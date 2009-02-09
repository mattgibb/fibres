function generate_vox_file(nodes,spacings,save_path,image)
%

% write first two lines of vox file
dlmwrite([save_path '.vox'],nodes.mesh_size + [2 2 2],     ' ');
dlmwrite([save_path '.vox'],spacings,'-append','delimiter',' ');

% write the image
dlmwrite([save_path '.vox'],image,   '-append','delimiter',' ');