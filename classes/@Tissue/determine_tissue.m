function determine_tissue(obj)

% calculates length of radial vectors
obj.radii = sqrt(obj.radial_components(:,1).^2 + ...
                 obj.radial_components(:,2).^2 + ...
                 obj.radial_components(:,3).^2);

% determines which nodes are tissue nodes     
obj.is_tissue = obj.radii>obj.vessel.radius;