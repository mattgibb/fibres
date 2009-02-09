% file parameters
root_folder = '/Users/matthewgibb/Documents/DPhil/Martin/working_copy/code/';
filename = 'epicardial';
save_path = [root_folder 'data/' filename '/' filename];
pathstr = fileparts(save_path); % [pathstr, name, ext, versn] = fileparts(filename)
CARP_folder = [root_folder 'external_programs/CARP/'];


% make folder 'filename' in 'data'
eval(['!mkdir ' root_folder 'data/' filename])

% add functions folder to path
addpath([root_folder 'functions']);

% tissue parameters
lengths = [10000 10000 3000];
base_coords = [5000 5000 1500];
spacings = [200 200 200];
radius = 1000;
direction = [1 0 1];

% normalises direction vector
direction = direction/norm(direction);

% generate 3D coordinates of each node in a cuboid, with origin at base_coords
nodes = generate_nodes(lengths,spacings,base_coords);

% calculates node component vectors along and perpendicular to vessel
nodes = calculate_radial_and_longditudinal_components(nodes,direction);

% calculate r and determine which nodes are tissue nodes
nodes = determine_tissue(nodes,radius);

% plot3(nodes.positions(nodes.is_tissue,1),...
%       nodes.positions(nodes.is_tissue,2),...
%       nodes.positions(nodes.is_tissue,3),'.');
% axis equal

% generate potentials at nodes
nodes = generate_potential_field(nodes,radius);

% calculate fibre direction
nodes = calculate_grad_V(nodes,radius);
nodes = generate_alpha(nodes,min(nodes.V(:)),max(nodes.V(:))); % alpha == 0 || varies with cubic
nodes = calculate_projected_vectors(nodes,radius,direction);
nodes = calculate_fibre_directions(nodes);

% plot potential field isosurfaces
% plot_isosurfaces(nodes,radius,direction)

% Generate image files
image = zeros(nodes.mesh_size + [2 2 2]);
image(2:end-1,2:end-1,2:end-1) = reshape(nodes.is_tissue,nodes.mesh_size);
image = reshape(image,[],1);
generate_vox_file(nodes,spacings,save_path,image);


% GENERATE FILES REMOTELY

% move myimage.vox to Martin's machine i.e.
eval(['!scp ' save_path '.vox gibbm@clpc293.comlab.ox.ac.uk:/home/gibbm/image.vox'])

% generates image.flma
!ssh gibbm@clpc293.comlab.ox.ac.uk "/home/scratch/programmes/Tarantula2.0/bin/linux64/voxmesher_2 tara.conf 1"
% translates flma to pts, elem and lon
!ssh gibbm@clpc293.comlab.ox.ac.uk "/home/scratch/programmes/CardioEngLib/Examples/flma2carp/flma2carp image mat1 1000"
 % generates image_renum.pts and .elem
!ssh gibbm@clpc293.comlab.ox.ac.uk "/home/scratch/programmes/CardioEngLib/Examples/renumber_mesh/renumber_mesh image"

% copy image files to local folder
eval(['!scp gibbm@clpc293.comlab.ox.ac.uk:/home/gibbm/image_renum* ' pathstr '/'])

% convert .pts files from voxel units to micrometres
convert_pts_files([pathstr '/image_renum.pts'],spacings)

% generate .vpts file
centroids.positions = generate_element_centroids_tarantula_method(pathstr,base_coords);

% calculate fibre directions
centroids = calculate_radial_and_longditudinal_components(centroids,direction);
centroids = determine_tissue_from_elem_file(centroids,pathstr);
centroids = generate_potential_field(centroids,radius);
centroids = calculate_grad_V(centroids,radius);
centroids = generate_alpha(centroids,min(nodes.V(:)),max(nodes.V(:))); % alpha == 0 || varies with cubic
centroids = calculate_projected_vectors(centroids,radius,direction);
centroids = calculate_simple_fibre_directions(centroids);
centroids = calculate_fibre_directions(centroids);

% decides which set of vectors to use
method = 'potential';
% method = 'simple_zero';
% method = 'simple_alpha';

% generate .vec file
generate_lon_file(pathstr,centroids,method);

% set folders
bidomain_folder = '/bidomain';
monodomain_folder = '/monodomain';

% run CARP on generated files for bidomain
run_CARP(pathstr,CARP_folder,'parameters.par',bidomain_folder)

% copy files from bidomain run
copy_bidomain_to_monodomain(pathstr,bidomain_folder)

% run CARP on bidomain files for monodomain
run_CARP(pathstr,CARP_folder,'parameters_mono.par',monodomain_folder)

% generate lon file for simple_alpha
method = 'simple_alpha';
generate_lon_file(pathstr,centroids,method);

% reset folders
bidomain_folder = '/bidomain_simple_alpha';
monodomain_folder = '/monodomain_simple_alpha';

% run CARP on generated files for bidomain
run_CARP(pathstr,CARP_folder,'parameters.par',bidomain_folder)

% copy files from bidomain run
copy_bidomain_to_monodomain(pathstr,bidomain_folder)

% run CARP on bidomain files for monodomain
run_CARP(pathstr,CARP_folder,'parameters_mono.par',monodomain_folder)