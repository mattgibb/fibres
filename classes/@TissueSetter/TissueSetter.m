classdef TissueSetter < handle % EvalFcn is a subclass of handle
% List of things to change with tissue_listener
% Axes limits - based on min/max(vessel.node_positions)

    properties
        tissue_block
        V_isosurface
        hfigure
        haxes
        X
        Y
        Z
        V
        mins
        maxes
    end
    
    properties(Access = private)
        % handles
        hcontrol_panel
        harrows
        hnormals
        hprojected
        hfibre
        hnone
        hrender
        hvessel
        hisosurface
        harrowsize
        hslider
        hV
        hlight
    end

    methods
        function setter = TissueSetter(tissue_block)            
            % sets some object variables
            setter.tissue_block = tissue_block;
            setter.set_coordinates_ranges_and_potential
            mins = setter.mins;
            maxes = setter.maxes;
            
            % sets figure size
            figure_size = [360,500,600,700];
            
            setter.hfigure = figure('Position',figure_size,...
                'Visible','off','Renderer','OpenGL',...
                'MenuBar','none','Toolbar','none');
            
            setter.haxes = axes('Units','Pixels',...
                'Position',[50 180 figure_size(3)-100 figure_size(4)-210],...
                'YTick',[mins(2) maxes(2)],...
                'YTickLabel',{'Endocardium','Epicardium'},...
                'ZTick',[mins(3) maxes(3)],...'ZTickLabel',[-1500 1500],...
                'FontSize',50);
                
            % sets up axes
            view([-65,20])
            axis equal
            axis([mins(1) maxes(1) mins(2) maxes(2) mins(3) maxes(3) 0 1])
            rotate3d(setter.haxes)
            hold(setter.haxes,'on')
            
            % Change units to normalized so components resize 
            % automatically.
            set([setter.hfigure,setter.haxes],'Units','normalized');
            
            % Assign the GUI a name to appear in the window title.
            set(setter.hfigure,'Name','Myocardial Sheet Surfaces')
            
            % open side panel with viewing controls
            setter.open_control_panel
            
            % Assign the control panel a name
            set(setter.hcontrol_panel,'Name','Control Panel')
            
            % makes figure visible
            set(setter.hfigure,'Visible','on')
            
        end

        function set_coordinates_ranges_and_potential(setter)
            tb = setter.tissue_block;
            setter.mins  = min(tb.node_positions);
            setter.maxes = max(tb.node_positions);
            setter.X = reshape(tb.node_positions(:,1),tb.mesh_size);
            setter.Y = reshape(tb.node_positions(:,2),tb.mesh_size);
            setter.Z = reshape(tb.node_positions(:,3),tb.mesh_size);
            setter.V = reshape(tb.V,                  tb.mesh_size);
        end
        
        function quiver_plot(setter,positions,vectors)
            quiver3(positions(:,1),positions(:,2),positions(:,3),...
                vectors(:,1),vectors(:,2),vectors(:,3),...
                str2double(get(setter.harrowsize,'String')),...
                'Color',[0.7 0 0],...
                'Parent',setter.haxes);
        end
        
        function delete(obj)
            handles = [obj.hfigure,obj.hcontrol_panel];
            close(handles(ishandle(handles)))
        end
        
	end % methods
end % classdef