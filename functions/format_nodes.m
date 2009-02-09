function list = format_nodes(X,Y,Z,is_tissue)
% reshapes X, Y and Z into column vectors
X = reshape(X,[],1);
Y = reshape(Y,[],1);
Z = reshape(Z,[],1);
is_tissue = reshape(is_tissue,[],1);

% <point #> <x> <y> <z> [attributes] [boundary marker]
node_number = 1:length(X);
boundary_marker = is_tissue;
nodes = [node_number' X Y Z boundary_marker];