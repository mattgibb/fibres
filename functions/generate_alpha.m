function nodes = generate_alpha(nodes,min_V,max_V)

% unpacks V
V = nodes.V;

% % alpha == 0
% nodes.alpha = zeros(size(V));

% alpha == 1 - 2 * normalised distance parameter
e = (V-min_V)/(max_V-min_V);
nodes.alpha = pi*(1-2*e).^3/3;