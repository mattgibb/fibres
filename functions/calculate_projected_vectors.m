function nodes = calculate_projected_vectors(nodes,radius,direction)

% initialises projected_vector to zero
nodes.projected_vectors = zeros(size(nodes.positions));

% unpacks data
is_tissue = nodes.is_tissue;
V         = nodes.V        (is_tissue  );
positions = nodes.positions(is_tissue,:);
alpha     = nodes.alpha    (is_tissue  ) + pi/2; % plus pi/2 as grad is perp to isolines


if direction(2) ~= 0 % the projected circle is not a line
    % calculate x-z position of vessel axis with same V
    intersection = [V*direction(1) V*direction(3)]/direction(2);
    
    % calculate x-z position of node relative to intersection
    plane_vector = positions(:,[1 3]) - intersection;
    
    if direction(2) ~= 1 % if direction is not the y unit vector
        % calculate alpha_dash, the projected angle of alpha on the y ==
        % constant plane
        % if theta is the angle of the vessel from the y-axis and phi is
        % the angle of the vessel in the x-z plane:
        
        % ( x_dash  y_dash) = ( cos(alpha)  sin(alpha) )*( cos(phi) -sin(phi) )*( 1/cos(theta)   0   )*( cos(phi)  sin(phi) )
        %                                                ( sin(phi)  cos(phi) ) (      0         1   ) (-sin(phi)  cos(phi) )
        
        % tan(alpha_dash) = y_dash/x_dash
        
        % calculate angles of direction in spherical polars
        theta = acos(direction(2));
        phi   = atan(direction(3)/direction(1)) + pi/2; % plus pi/2 as vectors are rotated 90 degrees before squashing
        
        % calculate matrix multiplication
        M = [cos(phi),-sin(phi);sin(phi),cos(phi)]*[1/cos(theta),0;0,1]*[cos(phi) sin(phi);-sin(phi) cos(phi)];
        
        % calculate projected vectors
        xy_dash = [cos(alpha) sin(alpha)]*M;
        
        % alpha_dash = arctan(y_dash/x_dash)
        alpha_dash = atan(xy_dash(:,2)./xy_dash(:,1));
        
        
        % calculate component of plane_vector that is parallel to direction
        parallel_length = (plane_vector*direction([1 3])') ./ ...
                          sum(direction([1 3]).^2);
        parallel = [direction(1)*parallel_length direction(3)*parallel_length];
        
        % calculate component of plane_vector that is perpendicular to direction
        perpendicular = plane_vector - parallel;
        
        % stretch plane_vector: divide parallel component by y-value of
        % direction
        plane_vector = parallel/direction(2) + perpendicular;
    else
        alpha_dash = alpha;
    end
    
    % rotates plane_vector clockwise by alpha
    alpha_x = sum(plane_vector.*[ cos(alpha_dash)  sin(alpha_dash)],2);
    alpha_y = sum(plane_vector.*[-sin(alpha_dash)  cos(alpha_dash)],2);
    
    % calculates grad V for conducting circle in these coords
    E_rotated(:,1) = 1 + ( radius^2*(alpha_x.^2 - alpha_y.^2) ) ./ ...
                     (alpha_x.^2 + alpha_y.^2).^2;
    E_rotated(:,2) = 2*radius^2*alpha_x.*alpha_y ./ ...
                     (alpha_x.^2 + alpha_y.^2).^2;
    
    % rotates result by alpha, back into original coords
    E(:,1) = sum(E_rotated.*[ cos(alpha_dash) -sin(alpha_dash)],2);
    E(:,2) = sum(E_rotated.*[ sin(alpha_dash)  cos(alpha_dash)],2);
    
    % rotates E anticlockwise by 90 degrees to point parallel to isopotentials
    isopotentials      = -E(:,2);
    isopotentials(:,2) =  E(:,1);
    
    if direction(2) ~= 1 % if direction is not the y unit vector
        % calculate component of E that is parallel to direction
        IPs_para_length = (isopotentials*direction([1 3])') ./ ...
                            sum(direction([1 3]).^2);
        IPs_para = [direction(1)*IPs_para_length direction(3)*IPs_para_length];
        
        % calculate component of plane_vector that is perpendicular to direction
        IPs_perp = isopotentials - IPs_para;
        
        % compress E: multiply parallel component by y-value of direction
        isopotentials = IPs_para*direction(2) + IPs_perp;
    end
    % rotate vectors clockwise by 90 degrees to point perpendicular to
    % isopotentials
    nodes.projected_vectors(is_tissue,1) =  isopotentials(:,2);
    nodes.projected_vectors(is_tissue,3) = -isopotentials(:,1);
    
else
    nodes.projected_vectors(is_tissue,[1 3]) = [cos(alpha) sin(alpha)];
end