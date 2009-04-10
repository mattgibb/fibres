classdef TissueBlock < Tissue
    % Used to models histological sample of myocardial wall
    % constructor:
    % tb = TissueBlock(vessel,varargin);
    %
    % ARGUMENT                      DEFAULT
    % varargin{1}: node_spacings    [100 100 100]
    % varargin{2}: lengths          [15000 15000 3000]
    properties
        node_spacings = [100 100 100]
        lengths = [15000 15000 3000]
        HLCalculateComponentsSheetsAndFibres
        HLRadius

    end
    
	properties(Dependent = true)
        mesh_size
    end
    
    methods
        function T = TissueBlock(vessel,varargin)
            T.vessel = vessel;
            if nargin >= 2
                T.node_spacings = varargin{1};
            end
            if nargin >= 3
                T.lengths = varargin{2};
            end
            T.calculate_tissue
            T.create_listeners
        end
        
        function calculate_tissue(T)
            T.calculate_node_positions
            T.calculate_components_sheets_and_fibres
        end
        
        function create_listeners(T)
            T.HLCalculateComponentsSheetsAndFibres = addlistener(...
                T.vessel,'CalculateComponentsSheetsAndFibres',...
                @(src,evnt)listenCalculateComponentsSheetsAndFibres(T,src,evnt));
            T.HLRadius = addlistener(T.vessel,'radius','PostSet',...
                @(src,evnt)listenRadius(T,src,evnt));
        end
                
        function set.node_spacings(obj,value)
            if ~all(size(value) == [1 3])
                error('node_spacings must be a row vector of length 3.')
            end
            obj.node_spacings = value;
            obj.calculate_tissue
        end
        
        function set.lengths(obj,value)
            if ~all(size(value) == [1 3])
                error('lengths must be a row vector of length 3.')
            end
            obj.lengths = value;
            obj.calculate_tissue
        end

        function size = get.mesh_size(obj)
            size = ceil(obj.lengths./obj.node_spacings + 1);
        end
        
        function listenCalculateComponentsSheetsAndFibres(T,src,evnt)
            T.calculate_components_sheets_and_fibres
        end
        
        function listenRadius(T,src,evnt)
            T.calculate_sheets_and_fibres
        end
    end
end

