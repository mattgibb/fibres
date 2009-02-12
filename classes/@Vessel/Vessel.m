classdef Vessel < handle
    % Blood vessel running through the tissue.
    %   Detailed explanation goes here
    
    properties
        base_coordinates = [5000 5000 1500]
        radius = 1000
        polar_angles = [0 0] % spherical polar coords around y-axis
    end
    
    properties (Dependent = true)
        direction
    end
    
    methods
        function V = Vessel(varargin)
            if nargin > 0
                V.radius = varargin{1};
            end
            if nargin > 1
                V.polar_angles = varargin{2};
            end
            if nargin > 2
                V.base_coordinates = varargin{3};
            end
        end
        
        % returns normalised direction vector
        function value = get.direction(obj)
            theta = obj.polar_angles(1);
            phi   = obj.polar_angles(2);
            value = [cos(theta)*sin(phi) cos(phi) sin(theta)*sin(phi)];
        end
    end
    
end

