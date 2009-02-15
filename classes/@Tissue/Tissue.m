classdef Tissue < handle
    % A cuboid section of ventricular myocardial wall.
    % Detailed explanation goes here
    
    properties
        vessel
        node_spacings = [200 200 200]
        lengths = [10000 10000 3000]
        HLCalculateComponentsSheetsAndFibres
        HLRadius
    end
    
    properties(SetAccess = protected)
        node_positions
        radii % use this instead of is_tissue to plot vessel boundary!
        V
        grad_V
        projected_vectors
        fibre_directions
    end
    
    properties(Access = protected)
        radial_components
        longitudinal_components
        alpha
        is_tissue
    end
    
    properties(Dependent = true)
        mesh_size
    end
    
    methods
        function T = Tissue(vessel,varargin)
            T.vessel = vessel;
            if nargin > 1
                T.node_spacings = varargin{1};
            end
            if nargin > 2
                T.lengths = varargin{2};
            end
            T.calculate_tissue
            T.create_listeners
        end
        
        function obj = set.node_spacings(obj,value)
            if ~all(size(value) == [1 3])
                error('node_spacings must be a row vector of length 3.')
            end
            obj.node_spacings = value;
            obj.calculate_tissue
        end
        
        function obj = set.lengths(obj,value)
            if ~all(size(value == [1 3]))
                error('lengths must be a row vector of length 3.')
            end
            obj.lengths = value;
            obj.calculate_tissue
        end
        
        function size = get.mesh_size(obj)
            size = ceil(obj.lengths./obj.node_spacings + 1);
        end
        
        function calculate_tissue(T)
            T.calculate_node_positions
            T.calculate_components_sheets_and_fibres
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
            T.calculate_fibre_directions
        end
        
        function create_listeners(T)
            T.HLCalculateComponentsSheetsAndFibres = addlistener(...
                T.vessel,'CalculateComponentsSheetsAndFibres',...
                @(src,evnt)listenCalculateComponentsSheetsAndFibres(T,src,evnt));
            T.HLRadius = addlistener(T.vessel,'radius','PostSet',...
                @(src,evnt)listenRadius(T,src,evnt));
        end
        
        function listenCalculateComponentsSheetsAndFibres(T,src,evnt)
            T.calculate_components_sheets_and_fibres
        end
        
        function listenRadius(T,src,evnt)
            T.calculate_sheets_and_fibres
        end
    end
end