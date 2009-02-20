classdef Tissue < handle
    % A cuboid section of ventricular myocardial wall.
    % WARNING: This object can go stale i.e. out of sync with its vessel.
    % The subclass TissueBlock has listener methods
    
    properties
        vessel
    end
    
    properties(SetAccess = protected)
        node_positions
        radii
        V
        grad_V
        projected_vectors
        fibre_directions
        fibre_directions_simple_alpha
        fibre_directions_simple_zero
        min_V
        max_V
        min_y
        max_y
        is_tissue
    end
    
    properties(Access = protected)
        radial_components
        longitudinal_components
        alpha
    end
    
    methods
        function T = Tissue(varargin) % (vessel,node_positions,min_V,max_V,min_y,max_y)
            if nargin > 0
                T.vessel = varargin{1};
                T.node_positions = varargin{2};
                T.min_V = varargin{3};
                T.max_V = varargin{4};
                T.min_y = varargin{5};
                T.max_y = varargin{6};
                T.calculate_components_sheets_and_fibres
            end
        end
        
        function calculate_components_sheets_and_fibres(T)
            T.calculate_radial_and_longitudinal_components
            T.calculate_sheets_and_fibres
        end
        
        function calculate_sheets_and_fibres(T)
            T.determine_tissue
            T.calculate_potential_field
            T.calculate_grad_V
            T.calculate_alpha
            T.calculate_projected_vectors
            T.calculate_simple_fibre_directions
            T.calculate_fibre_directions
        end
        
    end
end