classdef Centroids < Tissue
    % nodes at the centre of finite element tetrahedra
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        data_folder
    end
    
    methods
        function centroids = Centroids(vessel,centroid_positions,data_folder)
            centroids.vessel = vessel;
            centroids.node_positions = centroid_positions;
     
            centroids.calculate_radial_and_longitudinal_components
            centroids.determine_tissue(data_folder)
            centroids.calculate_potential_field
            centroids.calculate_grad_V
            centroids.min_V = min(centroids.V);
            centroids.max_V = max(centroids.V);
            centroids.min_y = max(centroid_positions(:,2));
            centroids.max_y = max(centroid_positions(:,2));
            centroids.calculate_alpha
            centroids.calculate_projected_vectors
            centroids.calculate_simple_fibre_directions
            centroids.calculate_fibre_directions
        end
    end
    
    methods (Static = true)
        centroids = calculate_element_centroids(data_folder)
    end
end