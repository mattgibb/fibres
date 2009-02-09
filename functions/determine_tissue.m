function nodes = determine_tissue(nodes,radius)

% calculates length of radial vectors
nodes.r = sqrt(nodes.radial_vectors(:,1).^2 + ...
               nodes.radial_vectors(:,2).^2 + ...
               nodes.radial_vectors(:,3).^2);

% determines which nodes are tissue nodes     
nodes.is_tissue = nodes.r>radius;