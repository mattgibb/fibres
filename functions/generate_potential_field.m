function nodes = generate_potential_field(nodes,radius)

% endo-to-epi direction
n = [0 1 0];

% unpacks data
r                     = nodes.r;
is_tissue             = nodes.is_tissue;
positions             = nodes.positions;
radial_vectors        = nodes.radial_vectors;
longditudinal_vectors = nodes.longditudinal_vectors;

% initialise V
nodes.V = zeros(size(r));

% in tissue
nodes.V(is_tissue) = positions(is_tissue,:)*n' ...
     - (radial_vectors(is_tissue,:)*n').*(radius./r(is_tissue)).^2;

% in vessel
nodes.V(~is_tissue) = longditudinal_vectors(~is_tissue,:)*n';