classdef Config
    % Accessor class to all values assigned in config/*
    %   Detailed explanation goes here
        
    methods (Static)
        % returns the application root folder
        function app_root = root_folder
            app_root = fileparts(mfilename('fullpath'));
            % FRAGILE HACK: take off 'classes/@Config'
            app_root(end-14:end) = [];
        end
        
        function path = CARP_executable
            % runs config/program_folders.m
            program_folders;
            path = CARP_executable;
        end
        
        function update_path
            addpath(genpath(Config.root_folder));
        end
        
        function path = data_path(filename)
            program_folders; % runs config/program_folders.m
            path = [data_folder filename '/' filename]; 
        end
        
        function make_simulation_folder(filename)
            program_folders; % runs config/program_folders.m
            eval(['!mkdir ' data_folder filename])
        end
        
    end
    
end

