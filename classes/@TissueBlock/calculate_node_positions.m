function calculate_node_positions(obj)
% generates a prod(lengths)*3 matrix of rectangular node coordinates
node_spacings = obj.node_spacings;
lengths       = obj.lengths;

% generates equally spaced vectors of coordinates
x = 0:node_spacings(1):lengths(1);
y = 0:node_spacings(2):lengths(2);
z = 0:node_spacings(3):lengths(3);

% generates 3D arrays
[X Y Z] = meshgrid(x,y,z);

% concatenates results
obj.node_positions = [X(:) Y(:) Z(:)];
