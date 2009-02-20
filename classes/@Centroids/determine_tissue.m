function determine_tissue(centroids,pathstr)

% calculates r for generate_potential_field
centroids.radii = sqrt(centroids.radial_components(:,1).^2 + ...
	centroids.radial_components(:,2).^2 + ...
	centroids.radial_components(:,3).^2);

% reads 
region = dlmread([pathstr '/image_renum.elem'],' ',1,5);

% saves result in centroids.is_tissue
centroids.is_tissue = (region == 2);