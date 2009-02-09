function centroids = determine_tissue_from_elem_file(centroids,pathstr)

% calculates r for generate_potential_field
centroids.r = sqrt(centroids.radial_vectors(:,1).^2 + ...
                   centroids.radial_vectors(:,2).^2 + ...
                   centroids.radial_vectors(:,3).^2);

% reads 
region = dlmread([pathstr '/image_renum.elem'],' ',1,5);

% saves result in centroids.is_tissue
centroids.is_tissue = (region == 2);