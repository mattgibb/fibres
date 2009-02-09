function WriteMhaFile(filename, img_size, resolution, data_type)

[pathstr,name, ext]=fileparts(filename);

fid=fopen(filename, 'w');
if(fid<=0) 
    printf('Impossible to open file %s\n', filename);
end

ndims=prod(size(resolution));

if(ndims == 3)
    fprintf(fid, 'NDims = 3\n');

    fprintf(fid, 'DimSize = %d %d %d\n', img_size(1), img_size(2), img_size(3));

    if(strcmp(data_type, 'char') | strcmp(data_type, 'uint8'))
        fprintf(fid, 'ElementType = MET_UCHAR\n');
    elseif(strcmp(data_type, 'short'))
        fprintf(fid, 'ElementType = MET_SHORT\n');
    end

    fprintf(fid, 'ElementSpacing = %1.4f %1.4f %1.4f\n', resolution(1), resolution(2), resolution(3));

elseif(ndims==4)
    fprintf(fid, 'NDims = 4\n');

    fprintf(fid, 'DimSize = %d %d %d %d\n', img_size(1), img_size(2), img_size(3), img_size(4));

    if(strcmp(data_type, 'char'))
        fprintf(fid, 'ElementType = MET_UCHAR\n');
    elseif(strcmp(data_type, 'short'))
        fprintf(fid, 'ElementType = MET_SHORT\n');
    end

    fprintf(fid, 'ElementSpacing = %1.4f %1.4f %1.4f %1.4f\n', resolution(1), resolution(2), resolution(3), resolution(4));
       
end

fprintf(fid, 'ElementByteOrderMSB = False\n');

fprintf(fid, 'ElementDataFile = %s\n', strcat(name, '.raw'));

fclose(fid);

