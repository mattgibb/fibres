function generate_vox_file(tb,save_path,image)
% swaps from [y x z] (generated by meshgrid) to [x y z]
mesh_size = tb.mesh_size([2 1 3]);
node_spacings = tb.node_spacings([2 1 3]);
image = permute(image,[2 1 3]);

% makes an image column vector
image = image(:);

% write first two lines of vox file
dlmwrite([save_path '.vox'],mesh_size + [2 2 2],' ');
dlmwrite([save_path '.vox'],node_spacings,'-append','delimiter',' ');

% write the image
dlmwrite([save_path '.vox'],image,'-append','delimiter',' ');