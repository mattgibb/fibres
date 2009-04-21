function upload_mesh_files(data_folder,mesh_name)
%

% Shared disk so does not matter which supercomputer files are uploaded to
% e.g. redqueen, queeg etc.
hostname = 'mgibb@redqueen.oerc.ox.ac.uk';
mesh_folder = Config.remote_mesh_folder(mesh_name);

% create folder 'meshname' on supercomputer
disp(['Creating ''' mesh_name ''' folder on OSC server...'])
command = ['!ssh ' hostname ' mkdir ' mesh_folder];
disp(command)
eval(command)
disp(' ')

% upload mesh files to supercomputer
disp('Uploading mesh files to OSC server...')
% HACK: Don't need to upload everything with * glob
command = ['!scp -C ' data_folder '/image_renum.* '...
    hostname ':' mesh_folder];
disp(command)
eval(command)
disp(' ')