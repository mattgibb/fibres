function centroids = calculate_element_centroids(filename)
% Finds coordinates of centroids of elements

% loads node data
nodes = dlmread([filename '.pts'],'',1,0);

% loads element data and removes final 'region' column
elements = dlmread([filename '.elem'],'',1,1);
elements(:,5) = [];

% centroids(element node_number axis)
centroids = zeros([length(elements) 4 3]);
centroids(:) = nodes(elements+1,:);
centroids = squeeze(sum(centroids,2))/4;

% writes the number of centroids as the first line
dlmwrite([filename '.vpts'],size(centroids,1),...
         'delimiter','',...
         'precision','%-20.0f');

% writes the centroids
dlmwrite([filename '.vpts'],centroids,'-append','delimiter',' ')