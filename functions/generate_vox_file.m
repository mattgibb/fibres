function generate_vox_file(tb,save_path,image)
%

% write first two lines of vox file
dlmwrite([save_path '.vox'],tb.mesh_size + [2 2 2],' ');
dlmwrite([save_path '.vox'],tb.node_spacings,'-append','delimiter',' ');

% write the image
dlmwrite([save_path '.vox'],image,'-append','delimiter',' ');