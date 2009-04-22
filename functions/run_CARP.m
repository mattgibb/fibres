function run_CARP(supercomputer,mesh_name,simulation_name)
hostname = ['mgibb@' supercomputer '.oerc.ox.ac.uk'];
root_folder = Config.root_folder;
mesh_folder = Config.remote_mesh_folder(mesh_name);
simulation_folder = Config.remote_simulation_folder(simulation_name);

% Delete previous version of simulation
disp(['Deleting any previous version of ' simulation_name ' on OSC server...'])
command = ['!ssh ' hostname ' rm -rf ' simulation_folder];
disp(command)
eval(command)
disp(' ')

% Make a simulations folder in CARP/fibres/simulations
disp(['Making simulation folder on OSC server...'])
command = ['!ssh ' hostname ' mkdir ' simulation_folder];
disp(command)
eval(command)
disp(' ')

% copy parameters.par to the remote server to ensure that it is up-to-date
% with local copy
disp(['Copying parameters.par to OSC server...'])
command = ['!scp ' root_folder 'config/parameters.par ' ...
    hostname ':' simulation_folder];
disp(command)
eval(command)
disp(' ')

% generate run_CARP.pbs and copy it to the remote server
disp(['Generating run_CARP.pbs and copying it to OSC server...'])
command = ['!' root_folder 'functions/process_template.rb ' ...
    root_folder 'config/run_CARP.pbs.erb ' ... template
    simulation_name ' ' simulation_folder ' ' mesh_folder ... % pbs name, simID and mesh folder
    ' | ssh ' hostname ... % pipe standard output to ssh
    ' "cat > ' simulation_folder 'run_CARP.pbs"']; % redirect standard input to run_CARP.pbs
disp(command)
eval(command)
disp(' ')

% execute run_CARP.pbs to submit job, from so that outputs are
% dumped there.
disp('Submitting job...')
command = ['!ssh ' hostname ...
    ' "cd ' simulation_folder ' && ' ... 
    'chmod 755 run_CARP.pbs && '...
    'qsub run_CARP.pbs"'];
disp(command)
eval(command)
