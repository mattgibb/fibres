% Add Config.root_folder and all subdirectories to path if not in path
% Only needs running once per Matlab session
% CHANGE TO CLASSES FOLDER AND EXECUTE:
Config.update_path

% set vessel and tissue
v = Vessel;
tb = TissueBlock(v);
setter = TissueSetter(tb);

% Creates folder to save and load the simulation in data_folder if needed
filename = 'epicardial';
data_path = Config.data_path(filename);
Config.make_simulation_folder(filename)
data_folder = fileparts(data_path); % [pathstr, name, ext, versn] = fileparts(filename)

% Generate image files
image = zeros(tb.mesh_size + [2 2 2]);
image(2:end-1,2:end-1,2:end-1) = reshape(tb.is_tissue,tb.mesh_size);
image = image(:);
generate_vox_file(tb,data_path,image);

% GENERATE FILES REMOTELY

% move myimage.vox to Martin's machine i.e.
eval(['!scp ' data_path '.vox gibbm@clpc293.comlab.ox.ac.uk:/home/gibbm/image.vox'])

% generates image.flma
!ssh gibbm@clpc293.comlab.ox.ac.uk "/home/scratch/programmes/Tarantula2.0/bin/linux64/voxmesher_2 tara.conf 1"
% translates flma to pts, elem and lon
!ssh gibbm@clpc293.comlab.ox.ac.uk "/home/scratch/programmes/CardioEngLib/Examples/flma2carp/flma2carp image mat1 1000"
 % generates image_renum.pts and .elem
!ssh gibbm@clpc293.comlab.ox.ac.uk "/home/scratch/programmes/CardioEngLib/Examples/renumber_mesh/renumber_mesh image"

% copy image files to local folder
eval(['!scp gibbm@clpc293.comlab.ox.ac.uk:/home/gibbm/image_renum* ' data_folder '/'])

% convert .pts files from voxel units to micrometres
convert_pts_files([data_folder '/image_renum.pts'],tb.node_spacings)

% generate .vpts file
centroid_positions = Centroids.calculate_element_centroids(data_folder);

% make tissue object of centroids
centroids = Centroids(v,centroid_positions,tb.min_V,tb.max_V,tb.min_y,tb.max_y,data_folder);

% decides which set of vectors to use
method = 'potential';
% method = 'simple_zero';
% method = 'simple_alpha';

% generate .vec file
generate_lon_file(data_folder,centroids,method);

% set folders
bidomain_folder = '/bidomain';
monodomain_folder = '/monodomain';

% run CARP on generated files for bidomain
run_CARP(data_folder,'parameters.par',bidomain_folder)

% copy files from bidomain run
copy_bidomain_to_monodomain(data_folder,bidomain_folder)

% run CARP on bidomain files for monodomain
run_CARP(data_folder,'parameters_mono.par',monodomain_folder)

% generate lon file for simple_alpha
method = 'simple_alpha';
generate_lon_file(data_folder,centroids,method);

% reset folders
bidomain_folder = '/bidomain_simple_alpha';
monodomain_folder = '/monodomain_simple_alpha';

% run CARP on generated files for bidomain
run_CARP(data_folder,'parameters.par',bidomain_folder)

% copy files from bidomain run
copy_bidomain_to_monodomain(data_folder,bidomain_folder)

% run CARP on bidomain files for monodomain
run_CARP(data_folder,'parameters_mono.par',monodomain_folder)