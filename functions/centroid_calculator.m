%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Martin Bishop 
%
% 16th April 2008
% 
% Finds coordinates of centroids of elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
% Loads in data
%%%%%%%%%%%%%%%%
% Nodes
nodes = load('/Users/matthewgibb/Documents/DPhil/Martin/working_copy/code/data/cylinder/cylinder.node');

% Selects only myocardial nodes
nodes = nodes(:,2:4);

% Elements
elements = load('/Users/matthewgibb/Documents/DPhil/Martin/working_copy/code/data/cylinder.ele');

% Selects only myocardial elements
elements = elements(:,2:5);

% Creates a file where points will be stored
centroids = zeros(length(elements),1);

% Finds the values of the basis functions at the centroid
    s = 0.5;
    t = 0.5;
    u = 0.5;
    
    N1 = 1 - s - t - u;
    N2 = s;
    N3 = t;
    N4 = u;

for i = 1:length(elements)
    if i == 1000 || i == 10000 || i == 100000 || i == 1000000 || i == 3000000 ||i == 6000000
        i
    end
    % Picks-out coordinates of points of each tetrahedra
    x1 = nodes(elements(i,1),1);
    y1 = nodes(elements(i,1),2);
    z1 = nodes(elements(i,1),3);
    x2 = nodes(elements(i,2),1);
    y2 = nodes(elements(i,2),2);
    z2 = nodes(elements(i,2),3);
    x3 = nodes(elements(i,3),1);
    y3 = nodes(elements(i,3),2);
    z3 = nodes(elements(i,3),3);
    x4 = nodes(elements(i,4),1);
    y4 = nodes(elements(i,4),2);
    z4 = nodes(elements(i,4),3);
    
    
    
    x_c = 0.25*(x1 + x2 + x3 + x4);
    y_c = 0.25*(y1 + y2 + y3 + y4);
    z_c = 0.25*(z1 + z2 + z3 + z4);
   
    centroids(i,1) = x_c;
    centroids(i,2) = y_c;
    centroids(i,3) = z_c;
    
end

dlmwrite('/Users/matthewgibb/Documents/DPhil/Martin/working_copy/code/data/cylinder.vpts',centroids,' ');