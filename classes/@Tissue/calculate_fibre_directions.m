function calculate_fibre_directions(obj)

% unpack data
grad_V            = obj.grad_V;
projected_vectors = obj.projected_vectors;

% cross two vectors to give vector perpendicular to both vectors
fibre_directions = cross(grad_V,projected_vectors);

% normalise vector if it is not equal to zero
zero_fibres = ~any(fibre_directions,2);

% calculate moduli of finite fibre directions
moduli = sqrt( fibre_directions(~zero_fibres,1).^2 + ...
               fibre_directions(~zero_fibres,2).^2 + ...
               fibre_directions(~zero_fibres,3).^2 );

% concatenates moduli so that element-by-element division is possible
moduli = [moduli moduli moduli];

% normalises moduli
fibre_directions(~zero_fibres,:) = fibre_directions(~zero_fibres,:)...
                                      ./moduli;

% Two reasons for zero fibre_direction:
% 1) node is in vessel i.e. grad_V is 0
% 2) grad_V is perpendicular to projected vectors i.e. parallel to y-axis

% 2) points with grad_V parallel to y-axis
y_grad_V = grad_V(:,1) == 0 & ...
           grad_V(:,2) ~= 0 & ...
           grad_V(:,3) == 0;
       
% rotate projected_vector 90 degrees in the x-z plane        
fibre_directions(y_grad_V,[1 3]) = projected_vectors(y_grad_V,[1 3]) * ...
                                   [0 -1;1 0];
                               

% saves to nodes
obj.fibre_directions = fibre_directions;