function plot_isosurfaces(nodes,radius,direction)
    
    % unpacks data
    positions = nodes.positions;
    mesh_size = nodes.mesh_size;
    is_tissue = nodes.is_tissue;
    V         = nodes.V;
    
    % declare figure size
    figure_size = [360,500,600,500];
    
    % finds axis limits
    mins  = min(positions);
    maxes = max(positions);
    
    %  Create and then hide the GUI as it is being constructed.
    f = figure('Visible','off','Position',figure_size);
    
    %  Construct the components
    htop =          uipanel('Tag','top',...
                            'ResizeFcn',@resize_top);
        
    hbottom =       uipanel('Tag','bottom',...
                            'ResizeFcn',@resize_bottom);
    
    harrows = uibuttongroup('Title','Arrows',...
                            'Units','Pixels',...
                            'Position',[10 10 140 130],...
                            'Parent',hbottom,...
                            'SelectionChangeFcn',@plot_isosurface);
        
    hrender = uibuttongroup('Title','Draw',...
                            'Units','Pixels',...
                            'Position',[160 10 140 70],...
                            'Parent',hbottom,...
                            'SelectionChangeFcn',@plot_isosurface);
    
    hslider =     uicontrol('Style','slider',...
                            'Position',[10 160 290 20],...
                            'Callback',{@slider_Callback},...
                            'Max',max(V),...
                            'Min',min(V),...
                            'SliderStep',[0.01 0.1],...
                            'Parent',hbottom);
    
    haxes =            axes('Units','Normalized',...
                            'Position',[50 70 figure_size(3)-60 figure_size(4)-80],...
                            'YTick',[mins(2) maxes(2)],...
                            'YTickLabel',{'Endocardium','Epicardium'},...
                            'Parent',htop);

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
                            'String',['V = ' num2str(get(hslider,'Value'))],...
                            'Parent',hbottom);
                        

    
	% sets the selected radio button to 'none'
    set(harrows,'SelectedObject',hnone);
    
    % separates and reshapes coordinates
    X = reshape(positions(:,1),mesh_size);
    Y = reshape(positions(:,2),mesh_size);
    Z = reshape(positions(:,3),mesh_size);
    V = reshape(V,mesh_size);
    
    % Change units to normalized so components resize 
    % automatically.
%     set([f,hslider,haxes],'Units','normalized');

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
        set(hpatch,'FaceColor','blue','EdgeColor','none')
        camlight left; 
        set(gcf,'Renderer','zbuffer'); lighting phong
        %set(gcf,'Renderer','OpenGL'); lighting gouraud
        
        % plot grad_V at verteces of isosurface patch
        if get(hnormals,'Value')
            surface_nodes.positions = get(hpatch,'Vertices');
            surface_nodes = calculate_radial_and_longditudinal_components(surface_nodes,direction);
            surface_nodes = determine_tissue(surface_nodes,radius);
            surface_nodes = calculate_grad_V(surface_nodes,radius);
            hold on
            quiver3(surface_nodes.positions(:,1),surface_nodes.positions(:,2),surface_nodes.positions(:,3),...
                    surface_nodes.grad_V   (:,1),surface_nodes.grad_V   (:,2),surface_nodes.grad_V   (:,3),0);
        end
        
        % plot vessel boundary
        if get(hvessel,'Value')
            hpatch_vessel = patch(isosurface(X,Y,Z,...
                reshape(is_tissue,mesh_size),... % reshapes is_tissue for isosurface
                0.01));
            isonormals(X,Y,Z,V,hpatch_vessel)
            set(hpatch_vessel,'FaceColor','red',...
                              'EdgeColor','none',...
                              'FaceAlpha',0.7);
        end
    end

    function resize_top(source,eventdata)
        htop = findobj('Tag','top');
        fig = gcf;
        old_units = get(fig,'Units');
        set(fig,'Units','pixels');
        figpos = get(fig,'Position');
        set(htop,'Position',[0 190 figpos(3) figpos(4)-190]);
        set(fig,'Units',old_units);
    end

    function resize_bottom(source,eventdata)
        u = findobj('Tag','bottom');
        fig = gcbo;
        old_units = get(fig,'Units');
        set(fig,'Units','pixels');
        figpos = get(fig,'Position');
        set(u,'Position',[0 0 figpos(3), 190]);
        set(fig,'Units',old_units);
    end
end