% This file lists names and optionally paths of all required external
% programs.

% If some or all programs are kept in the same folder, folder strings can
% be refactored with programs_dir. Alternatively, if all the programs are
% in the shell path, the full path can be omitted and just their file names
% can be given
programs_dir = '/Users/matthewgibb/Documents/DPhil/programs/';

% list of programs
CARP_executable = [programs_dir 'CARP/carp.mac'];

% folder to load and save data.
% Note: [Config.root_folder 'data/'] is listed in root .gitignore file
data_folder = [Config.root_folder 'data/'];