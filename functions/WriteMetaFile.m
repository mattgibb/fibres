%function WriteMetaFile(filename, img, resolution, data_type)
function WriteMetaFile(filename, img, resolution, data_type)

[pathstr,name, ext]=fileparts(filename);


fid=fopen(filename, 'w');
if(fid<=0) 
    printf('Impossible to open file %s\n', filename);
end

if(ndims(img) == 3)
    fprintf(fid, 'NDims = 3\n');

    fprintf(fid, 'DimSize = %d %d %d\n', size(img,1), size(img,2), size(img,3));

    if(strcmp(data_type, 'char') | strcmp(data_type, 'uint8'))
        fprintf(fid, 'ElementType = MET_UCHAR\n');
    elseif(strcmp(data_type, 'short'))
        fprintf(fid, 'ElementType = MET_SHORT\n');
    end

    fprintf(fid, 'ElementSpacing = %1.4f %1.4f %1.4f\n', resolution(1), resolution(2), resolution(3));

elseif(ndims(img)==4)
    fprintf(fid, 'NDims = 4\n');

    fprintf(fid, 'DimSize = %d %d %d %d\n', size(img,1), size(img,2), size(img,3), size(img,4));

    if(strcmp(data_type, 'char') | strcmp(data_type, 'uint8'))
        fprintf(fid, 'ElementType = MET_UCHAR\n');
    elseif(strcmp(data_type, 'short'))
        fprintf(fid, 'ElementType = MET_SHORT\n');
    end

    fprintf(fid, 'ElementSpacing = %1.4f %1.4f %1.4f %1.4f\n', resolution(1), resolution(2), resolution(3), resolution(4));
       

elseif(ndims(img)==2)
    fprintf(fid, 'NDims = 2\n');

    fprintf(fid, 'DimSize = %d %d \n', size(img,1), size(img,2));

    if(strcmp(data_type, 'char') | strcmp(data_type, 'uint8'))
        fprintf(fid, 'ElementType = MET_UCHAR\n');
    elseif(strcmp(data_type, 'short'))
        fprintf(fid, 'ElementType = MET_SHORT\n');
    end

    fprintf(fid, 'ElementSpacing = %1.4f %1.4f\n', resolution(1), resolution(2));
       
end

fprintf(fid, 'ElementByteOrderMSB = False\n');

fprintf(fid, 'ElementDataFile = %s\n', strcat(name, '.raw'));

fclose(fid);

fid=fopen(strcat(pathstr, '/', name, '.raw'), 'w');
if(fid<=0) 
    printf('Impossible to open file %s\n', img_filename);
end
fwrite(fid, img, data_type);
fclose(fid);