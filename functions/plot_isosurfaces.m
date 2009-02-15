function plot_isosurfaces(tissue)
    
    % unpacks data
    radius    = tissue.vessel.radius;
    direction = tissue.vessel.direction;
    positions = tissue.node_positions;
    mesh_size = tissue.mesh_size;
    is_tissue = tissue.is_tissue;
    V         = tissue.V;
    
    % declare figure size
    figure_size = [360,500,600,700];
    
    % finds axis limits
    mins  = min(positions);
    maxes = max(positions);
    
    %  Create and then hide the GUI as it is being constructed.
    f = figure('Visible','off','Position',figure_size);
    
    %  Construct the components    
    harrows = uibuttongroup('Title','Arrows',...
                            'Units','Pixels',...
                            'Position',[10 10 140 130],...
                            'SelectionChangeFcn',@plot_isosurface);
    
    hrender = uibuttongroup('Title','Draw',...
                            'Units','Pixels',...
                            'Position',[160 10 140 70],...
                            'SelectionChangeFcn',@plot_isosurface);
    
    hslider =     uicontrol('Style','slider',...
                            'Position',[10 160 290 20],...
                            'Callback',{@slider_Callback},...
                            'Max',max(V),...
                            'Min',min(V),...
                            'SliderStep',[0.01 0.1]);
    
    haxes =            axes('Units','Pixels',...
                            'Position',[50 180 figure_size(3)-100 figure_size(4)-210],...
                            'YTick',[mins(2) maxes(2)],...
                            'YTickLabel',{'Endocardium','Epicardium'},...
                            'ZTick',[mins(3) maxes(3)],...
                            'ZTickLabel',[-1500 1500],...
                            'FontSize',50);

	hnormals =    uicontrol('Style','radiobutton',...
                            'Parent',harrows,...
                            'Position',[10 100 120 20],...
                            'String','grad V');
                        
	hprojected =  uicontrol('Style','radiobutton',...
                            'Parent',harrows,...
                            'Position',[10 70 120 20],...
                            'String','projected vector');
                        
	hfibre =      uicontrol('Style','radiobutton',...
                            'Parent',harrows,...
                            'Position',[10 40 120 20],...
                            'String','fibre direction');

	hnone =       uicontrol('Style','radiobutton',...
                            'Parent',harrows,...
                            'Position',[10 10 120 20],...
                            'String','none');
    
	hvessel =     uicontrol('Style','checkbox',...
                            'Parent',hrender,...
                            'Position',[10 40 120 20],...
                            'Callback',{@plot_isosurface},...
                            'String','vessel');
                        
	hisosurface = uicontrol('Style','checkbox',...
                            'Parent',hrender,...
                            'Position',[10 10 120 20],...
                            'Callback',@plot_isosurface,...
                            'String','sheet');

	hV =          uicontrol('Style','text',...
                            'Position',[410 10 80 20],...
                            'String',['V = ' num2str(get(hslider,'Value'))]);
    
	harrowsize =  uicontrol('Style','edit',...
                            'Position',[300 160 50 30],...
                            'Callback',{@plot_isosurface},...
                            'String','1');
                        

    
	% sets the selected radio button to 'none'
    set(harrows,'SelectedObject',hnone);
    
    % separates and reshapes coordinates
    X = reshape(positions(:,1),mesh_size);
    Y = reshape(positions(:,2),mesh_size);
    Z = reshape(positions(:,3),mesh_size);
    V = reshape(V,mesh_size);
    
    % Change units to normalized so components resize 
    % automatically.
    set([f,haxes],'Units','normalized');

    % Assign the GUI a name to appear in the window title.
    set(f,'Name','Myocardial Sheet Surfaces')
    
    % plot graph
    plot_isosurface
    view([-65,20])
    axis equal
    axis([mins(1) maxes(1) mins(2) maxes(2) mins(3) maxes(3) 0 1])
    rotate3d(haxes)
    
    % Make the GUI visible.
    set(f,'Visible','on');
   
    function slider_Callback(source,eventdata)
        set(hV,'String',['V = ' num2str(get(hslider,'Value'))])
        plot_isosurface
    end

    function plot_isosurface(source,eventdata)
        % plot isosurface
        delete(get(haxes,'Children'))
        hpatch = patch(isosurface(X,Y,Z,V,get(hslider,'Value')));
        isonormals(X,Y,Z,V,hpatch)
        set(hpatch,'FaceColor','blue',...
                   'EdgeColor','none',...
                   'AlphaDataMapping','none')
        if ~get(hisosurface,'Value')
            set(hpatch,'FaceAlpha',0.1) % makes the isosurface transparent
        end
        camlight right;
        % set(gcf,'Renderer','zbuffer'); lighting phong
        set(gcf,'Renderer','OpenGL'); lighting gouraud
        
        % build surface_nodes
        surface_nodes.positions = get(hpatch,'Vertices');
        surface_nodes = calculate_radial_and_longditudinal_components(surface_nodes,direction);
        surface_nodes = determine_tissue(surface_nodes,radius);
        surface_nodes = generate_potential_field(surface_nodes,radius);
        surface_nodes = calculate_grad_V(surface_nodes,radius);
        surface_nodes = generate_alpha(surface_nodes,min(nodes.V(:)),max(nodes.V(:)));
        surface_nodes = calculate_projected_vectors(surface_nodes,radius,direction);
        surface_nodes = calculate_fibre_directions(surface_nodes);
                
        hold on
        
        % plot grad_V at verteces of isosurface patch
        switch 1
            case get(hnormals,'Value')
                quiver_plot(surface_nodes.positions,surface_nodes.grad_V)
            case get(hprojected,'Value')
                quiver_plot(surface_nodes.positions,surface_nodes.projected_vectors)
            case get(hfibre,'Value')
                quiver_plot(surface_nodes.positions,surface_nodes.fibre_directions)
        end
        
        % plot vessel boundary
        if get(hvessel,'Value')
            hpatch_vessel = patch(isosurface(X,Y,Z,...
                reshape(is_tissue,mesh_size),... % reshapes is_tissue for isosurface
                0.01));
            isonormals(X,Y,Z,V,hpatch_vessel)
            set(hpatch_vessel,'FaceColor','red',...
                              'EdgeColor','none',...
                              'FaceAlpha',0.5);
        end
    end

    function quiver_plot(positions,vectors)
        quiver3(positions(:,1),positions(:,2),positions(:,3),...
                vectors  (:,1),vectors  (:,2),vectors  (:,3),...
                str2num(get(harrowsize,'String')),...
                'Color',[0.7 0 0]);
    end
end