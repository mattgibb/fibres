classdef Centroids < Tissue
    % nodes at the centre of finite element tetrahedra
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        data_folder
    end
    
    methods
        function centroids = Centroids(vessel,centroid_positions,min_V,max_V,min_y,max_y,data_folder)
            % set properties
            centroids.vessel = vessel;
            centroids.node_positions = centroid_positions;
            centroids.min_V = min_V;
            centroids.max_V = max_V;
            centroids.min_y = min_y;
            centroids.max_y = max_y;
            
            % perform calculations
            centroids.calculate_radial_and_longitudinal_components
            centroids.determine_tissue(data_folder)
            centroids.calculate_potential_field
            centroids.calculate_grad_V
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