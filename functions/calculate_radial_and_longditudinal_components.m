function nodes = calculate_radial_and_longditudinal_components(nodes,direction)

nodes.longditudinal_vectors = (nodes.positions*direction')*direction;
nodes.radial_vectors = nodes.positions - nodes.longditudinal_vectors;