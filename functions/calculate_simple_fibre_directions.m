function nodes = calculate_simple_fibre_directions(nodes)

% unpack data and finds mins and maxes
y_coords = nodes.positions(:,2);
min_y = min(y_coords);
max_y = max(y_coords);

% alpha == 0
nodes.fibre_directions_simple_zero = zeros(size(nodes.positions));
nodes.fibre_directions_simple_zero(:,1) = 1;

% alpha == 1 - 2 * normalised distance parameter
e = (y_coords - min_y ) / (max_y - min_y);
simple_alpha = pi*(1 - 2*e).^3/3;
nodes.fibre_directions_simple_alpha = zeros(size(nodes.positions));
nodes.fibre_directions_simple_alpha(:,[1 3]) = [cos(simple_alpha) sin(simple_alpha)];
