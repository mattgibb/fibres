function convert_pts_files(pts_file_path,spacings)
% convert .pts file from voxel units to millimetres

% read contents from second line
coords = dlmread(pts_file_path,' ',1,0);

% multiply by mm/voxel in each dimension
for i = 1:3
    coords(:,i) = coords(:,i)*spacings(i);
end

coords = coords/1000;

% write new data to file
dlmwrite(pts_file_path,size(coords,1),'precision','%.0f');
dlmwrite(pts_file_path,coords,'-append','delimiter',' ','precision','%8f');