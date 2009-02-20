function generate_lon_file(data_folder,centroids,method)

is_tissue = centroids.is_tissue;

% initialises directions
directions = zeros(length(is_tissue),3);

% decides whether to use potential, simple_zero or simple_alpha
switch method
    case 'potential'
        directions(is_tissue,:) = centroids.fibre_directions(is_tissue,:);
    case 'simple_zero'
        directions(is_tissue,:) = centroids.fibre_directions_simple_zero(is_tissue,:);
    case 'simple_alpha'
        directions(is_tissue,:) = centroids.fibre_directions_simple_alpha(is_tissue,:);
end

% writes data to .lon file for CARP
dlmwrite([data_folder '/image_renum.lon'],directions,...
         'delimiter',' ',...
         'precision',10);

% makes .vec file for viewing in Meshalyzer
eval(['!cp ' data_folder '/image_renum.lon ' data_folder '/image_renum.vec']);