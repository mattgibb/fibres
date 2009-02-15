function calculate_grad_V(obj)

% removes nodes not in the tissue
is_tissue         = obj.is_tissue;
radial_components = obj.radial_components(is_tissue,:);
radii             = obj.radii(is_tissue);
radius            = obj.vessel.radius;

% initialises terms in grad_V equation
constant      = zeros(size(radial_components));
constant(:,2) = 1;

dry_dy      = zeros(size(radial_components));
dry_dy(:,2) = (radius^2./radii.^3) .* radial_components(:,2);

ry = ( (radius^2*radial_components(:,2)./radii.^4)*[1 1 1] ).*radial_components;

% full equation
obj.grad_V = zeros(length(is_tissue),3);
obj.grad_V(is_tissue,:) = constant - dry_dy + ry;