function calculate_simple_fibre_directions(obj)

% unpacks data and sets min_y and max_y if unset
y = obj.node_positions(:,2);
if isempty(obj.min_y) && isempty(obj.max_y)
    obj.min_y = min(y);
    obj.max_y = max(y);
end
min_y = obj.min_y;
max_y = obj.max_y;

% alpha == 0
obj.fibre_directions_simple_zero = zeros(size(obj.node_positions));
obj.fibre_directions_simple_zero(obj.is_tissue,1) = 1;

% alpha == 1 - 2 * normalised distance parameter
e = ( y(obj.is_tissue) - min_y ) / (max_y - min_y);
simple_alpha = pi*(1 - 2*e).^3/3;
obj.fibre_directions_simple_alpha = zeros(size(obj.node_positions));
obj.fibre_directions_simple_alpha(obj.is_tissue,[1 3]) = [cos(simple_alpha) sin(simple_alpha)];
