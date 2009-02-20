function centroids = calculate_element_centroids(data_folder)
% Finds coordinates of centroids of elements

% constructs filename
filename = [data_folder '/image_renum'];

% loads node data
nodes = dlmread([filename '.pts'],'',1,0);

% loads element data and removes final 'region' column
elements = dlmread([filename '.elem'],'',1,1);
elements(:,5) = [];

% Initialises centroids variable
centroids = zeros(length(elements),3);

for i = 1:length(elements)
    if i == 1000 || i == 10000 || i == 100000 || i == 1000000 || i == 3000000 ||i == 6000000
        i
    end
    % Picks-out coordinates of points of each tetrahedra
    x1 = nodes(elements(i,1)+1,1);
    y1 = nodes(elements(i,1)+1,2);
    z1 = nodes(elements(i,1)+1,3);
    x2 = nodes(elements(i,2)+1,1);
    y2 = nodes(elements(i,2)+1,2);
    z2 = nodes(elements(i,2)+1,3);
    x3 = nodes(elements(i,3)+1,1);
    y3 = nodes(elements(i,3)+1,2);
    z3 = nodes(elements(i,3)+1,3);
    x4 = nodes(elements(i,4)+1,1);
    y4 = nodes(elements(i,4)+1,2);
    z4 = nodes(elements(i,4)+1,3);
    
    % calculates coordinates for each tetrahedron centroid
    centroids(i,1) = 0.25*(x1 + x2 + x3 + x4);
    centroids(i,2) = 0.25*(y1 + y2 + y3 + y4);
    centroids(i,3) = 0.25*(z1 + z2 + z3 + z4);
    
end

% writes the number of centroids as the first line
dlmwrite([filename '.vpts'],size(centroids,1),...
         'delimiter','',...
         'precision','%-20.0f');

% writes the centroids
dlmwrite([filename '.vpts'],centroids,'-append','delimiter',' ')