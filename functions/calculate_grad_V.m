function nodes = calculate_grad_V(nodes,radius)

% removes nodes not in the tissue
is_tissue      = nodes.is_tissue;
radial_vectors = nodes.radial_vectors(is_tissue,:);
r              = nodes.r             (is_tissue  );

% initialises terms in grad_V equation
constant      = zeros(size(radial_vectors));
constant(:,2) = 1;

dry_dy        = zeros(size(radial_vectors));
dry_dy  (:,2) = (radius^2./r.^3) .* radial_vectors(:,2);

ry = ( (radius^2*radial_vectors(:,2)./r.^4)*[1 1 1] ).*radial_vectors;

% full equation
nodes.grad_V = zeros(length(is_tissue),3);
nodes.grad_V(is_tissue,:) = constant - dry_dy + ry;