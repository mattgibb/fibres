function calculate_alpha(obj)

% unpacks V
is_tissue = obj.is_tissue;
V = obj.V;
if isempty(obj.min_V) && isempty(obj.max_V)
    obj.min_V = min(V(:));
    obj.max_V = max(V(:));
end

% alpha == 1 - 2 * normalised distance parameter
e = (V(is_tissue)-obj.min_V)/(obj.max_V-obj.min_V);
obj.alpha = pi*(1-2*e).^3/3;