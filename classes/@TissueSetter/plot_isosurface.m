function plot_isosurface(setter,source,eventdata)
    % extracts variables
    X = setter.X;
    Y = setter.Y;
    Z = setter.Z;
    V = setter.V;
    haxes = setter.haxes;
    hslider = setter.hslider;
    hisosurface = setter.hisosurface;
    hnormals = setter.hnormals;
    hprojected = setter.hprojected;
    hfibre = setter.hfibre;
    hvessel = setter.hvessel;
    radii = setter.tissue_block.radii;
    radius = setter.tissue_block.vessel.radius;
    mesh_size = setter.tissue_block.mesh_size;
    
    % plot isosurface
    delete(get(haxes,'Children'))
    hpatch = patch(isosurface(X,Y,Z,V,get(hslider,'Value')),...
        'Parent',haxes,...
        'FaceLighting','phong',...
        'EdgeLighting','phong');
    isonormals(X,Y,Z,V,hpatch)
    set(hpatch,'FaceColor','blue',...
        'EdgeColor','none',...
        'AlphaDataMapping','none')
    if ~get(hisosurface,'Value')
        set(hpatch,'FaceAlpha',0.1) % makes the isosurface transparent
    end
    
    % potentially move this to constructor as it appears to make no
    % difference when source is at infinity...?
    setter.hlight = light('Position',[0 -2 1],'Parent',haxes);
        
    % build tissue
    surface = Tissue(setter.tissue_block.vessel,...
        get(hpatch,'Vertices'),min(V(:)),max(V(:)),...
        setter.tissue_block.min_y,setter.tissue_block.max_y);
    
    % plot grad_V at verteces of isosurface patch
    switch 1
        case get(hnormals,'Value')
            setter.quiver_plot(surface.node_positions,surface.grad_V)
        case get(hprojected,'Value')
            setter.quiver_plot(surface.node_positions,surface.projected_vectors)
        case get(hfibre,'Value')
            setter.quiver_plot(surface.node_positions,surface.fibre_directions)
    end
    
    % plot vessel boundary
    if get(hvessel,'Value')
        hpatch_vessel = patch(isosurface(X,Y,Z,...
            reshape(radii,mesh_size),... % reshapes is_tissue for isosurface
            radius),...
            'Parent',haxes,...
            'FaceColor','red',...
            'EdgeColor','none',...
            'FaceAlpha',0.5,...
            'FaceLighting','phong',...
            'EdgeLighting','phong');
        isonormals(X,Y,Z,V,hpatch_vessel)
    end
    
end