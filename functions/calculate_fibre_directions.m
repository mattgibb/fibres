function nodes = calculate_fibre_directions(nodes)

% unpack data
grad_V            = nodes.grad_V;
projected_vectors = nodes.projected_vectors;

% cross two vectors to give vector perpendicular to both vectors
fibre_directions = cross(grad_V,projected_vectors);

% normalise vector if it is not equal to zero
is_finite = fibre_directions(:,1) ~=0 & ...
            fibre_directions(:,2) ~=0 & ...
            fibre_directions(:,3) ~=0;

% calculate moduli of finite fibre directions
moduli = sqrt( fibre_directions(is_finite,1).^2 + ...
               fibre_directions(is_finite,2).^2 + ...
               fibre_directions(is_finite,3).^2 );

% concatenates moduli so that element-by-element division is possible
moduli = [moduli moduli moduli];

% normalises moduli
fibre_directions(is_finite,:) = fibre_directions(is_finite,:)./moduli;

% points with grad_V parallel to y-axis
grad_V_no_fibre = grad_V(~is_finite);

% TEMP assign [1 1 1] to zero fibre directions
% fibre_directions(~is_finite,:) = 1/sqrt(3);

% saves to nodes
nodes.fibre_directions = fibre_directions;