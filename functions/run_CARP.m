function run_CARP(supercomputer,data_folder,domain_folder,filename)
hostname = ['mgibb@' supercomputer '.oerc.ox.ac.uk'];

% create folder 'filename' on supercomputer
disp(['Creating ''' filename ''' folder on ' supercomputer '...'])
command = ['!ssh ' hostname ' mkdir '...
    'CARP/fibres/data/' filename];
disp(command)
eval(command)
disp(' ')

% upload mesh files to supercomputer
disp(['Uploading mesh files to ' supercomputer '...'])
% HACK: Don't need to upload everything with * glob
command = ['!scp -C ' data_folder '/image_renum.* '...
    hostname ':~/CARP/fibres/data/' filename '/'];
disp(command)
eval(command)
disp(' ')

% copy parameters.par and parameters_mono.par to the remote server
% to ensure that they are up-to-date with local copy
disp(['Copying CARP parameter files to ' supercomputer '...'])
command = ['!scp ' Config.root_folder 'config/parameters* ' ...
    hostname ':~/CARP/fibres/config/'];
disp(command);
eval(command);
disp(' ')

% generate run_CARP.pbs and copy it to the remote server
disp(['Generating run_CARP.pbs and copying it to ' supercomputer '...'])
command = ['!' Config.root_folder 'functions/process_template.rb ' ...
    Config.root_folder 'config/run_CARP.pbs.erb ' ... template
    filename ' ' domain_folder ... % pbs name and simID folder
    ' | ssh ' hostname ... % pipe standard output to ssh
    ' "cat > CARP/fibres/config/run_CARP.pbs"']; % redirect standard input to run_CARP.pbs
disp(command);
eval(command);
disp(' ')

% execute run_CARP.pbs to submit job
disp('Submitting job...')
command = ['!ssh ' hostname ...
    ' "cd CARP/fibres/config && ' ...
    'chmod 755 run_CARP.pbs && '...
    'qsub run_CARP.pbs"'];
disp(command)
eval(command)