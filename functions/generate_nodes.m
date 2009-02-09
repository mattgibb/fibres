function nodes = generate_nodes(lengths,spacings,base_coords)
% generates a prod(lengths)*3 matrix of rectangular node coordinates with a
% central cylinder of radius r, whose axis aligns with the z axis, removed.

% generates equally spaced vectors of coordinates
x = 0:spacings(1):lengths(1);
y = 0:spacings(2):lengths(2);
z = 0:spacings(3):lengths(3);

% generates 3D arrays
[X Y Z] = meshgrid(x,y,z);

% saves dimensions of meshes
nodes.mesh_size = size(X);

% reshapes arrays into vectors and translates nodes to vascular origin
X = reshape(X,[],1) - base_coords(1);
Y = reshape(Y,[],1) - base_coords(2);
Z = reshape(Z,[],1) - base_coords(3);

% concatenates results
nodes.positions = [X Y Z];