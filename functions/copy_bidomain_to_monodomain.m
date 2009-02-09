function copy_bidomain_to_monodomain(pathstr,bidomain_folder)
extension = {'elem','lon','pts','tris'};
for i = 1:length(extension)
    eval(['!cp ' pathstr   bidomain_folder '/image_renum_i.' extension{i} ...
             ' ' pathstr '/image_renum.' extension{i}]);
end