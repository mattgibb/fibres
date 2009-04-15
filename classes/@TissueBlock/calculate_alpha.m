function calculate_alpha(obj)
% This function is the same as Tissue>calculate_alpha.m, except that min_V
% and max_V are always set to min(V) and max(V), respectively.

% unpacks V
is_tissue = obj.is_tissue;
V = obj.V;

% sets min and max potentials
obj.min_V = min(V);
obj.max_V = max(V);

% alpha == 1 - 2 * normalised distance parameter
e = (V(is_tissue)-obj.min_V)/(obj.max_V-obj.min_V);
obj.alpha = pi*(1-2*e).^3/3;