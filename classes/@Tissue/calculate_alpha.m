function calculate_alpha(obj)

% unpacks V
is_tissue = obj.is_tissue;
V = obj.V;
min_V = min(V(:));
max_V = max(V(:));

% alpha == 1 - 2 * normalised distance parameter
e = (V(is_tissue)-min_V)/(max_V-min_V);
obj.alpha = pi*(1-2*e).^3/3;