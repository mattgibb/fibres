classdef Vessel < handle
    % Blood vessel running through the tissue.
    % constructor:
    % v = Vessel(varargin);
    %
    % ARGUMENT                      DEFAULT
    % varargin{1}: radius,          1000
    % varargin{2}: polar_angles     [0 0]
    % varargin{3}: base_coordinates [5000 5000 1500]
    
    properties
        polar_angles = [0 0] % spherical polar coords around y-axis
        base_coordinates = [5000 5000 1500] % specify point on vessel axis
    end
    
    properties (SetObservable = true)
        radius = 1000
    end
    
    properties (Dependent = true)
        direction
    end
    
    events
        CalculateComponentsSheetsAndFibres
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
            phi   = obj.polar_angles(1);
            theta = obj.polar_angles(2);
            value = [cos(phi)*sin(theta) cos(theta) sin(phi)*sin(theta)];
        end
           
        function obj = set.direction(obj,vector)
           if ~all(size(vector) == [1 3]) % isn't a 1 by 3 vector
              error('direction must be a row vector of length 3')
           elseif ~any(vector) % vector is [0 0 0]
               error('direction must be non-zero')
           else
              vector = vector/norm(vector);
              x = vector(1);
              y = vector(2);
              z = vector(3);
              
              % assign theta and phi to polar_angles
              if x == 0
                  if z >= 0
                      phi = pi/2;
                  else
                      phi = 3*pi/2;
                  end
              else
                  phi = atan(x/z);
              end
              theta = acos(y);
              
              obj.polar_angles = [phi theta];
           end
        end
        
        function obj = set.polar_angles(obj,angles)
            if ~all(size(angles) == [1 2]) % isn't a 1 by 2 vector
                error('direction must be a row vector of length 2')
            else
                obj.polar_angles = angles;
                % Fire CalculateComponentsSheetsAndFibres event
                notify(obj,'CalculateComponentsSheetsAndFibres');
            end
        end

        function obj = set.base_coordinates(obj,coordinates)
            if ~all(size(coordinates) == [1 3]) % isn't a 1 by 3 vector
                error('base_coordinates must be a row vector of length 3')
            else
                obj.base_coordinates = coordinates;
                % Fire CalculateComponentsSheetsAndFibres event
                notify(obj,'CalculateComponentsSheetsAndFibres');
            end
        end

    end
end

