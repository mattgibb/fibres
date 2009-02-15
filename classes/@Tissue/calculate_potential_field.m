function calculate_potential_field(obj)

% endo-to-epi direction
n = [0 1 0];

% unpacks data
is_tissue               = obj.is_tissue;
radii                   = obj.radii;
R                       = radii(is_tissue)/obj.vessel.radius;
node_positions          = obj.node_positions;
radial_components       = obj.radial_components;
longitudinal_components = obj.longitudinal_components;

% initialise V
obj.V = zeros(size(radii));

% in tissue
obj.V(is_tissue) = node_positions(is_tissue,:)*n' ...
     - (radial_components(is_tissue,:)*n') ./ R.^2;

% in vessel
obj.V(~is_tissue) = longitudinal_components(~is_tissue,:)*n';