function calculate_radial_and_longitudinal_components(obj)

positions = obj.node_positions;
direction = obj.vessel.direction;
base      = obj.vessel.base_coordinates;

% calculates position vectors relative to vessel base coordinates
positions(:,1) = positions(:,1) - base(1);
positions(:,2) = positions(:,2) - base(2);
positions(:,3) = positions(:,3) - base(3);

% dots positions with vessel direction
obj.longitudinal_components = (positions*direction')*direction;

% takes longitudinal component from total position
obj.radial_components = positions - obj.longitudinal_components;