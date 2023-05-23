function [S,river,trail,sensor] = map_creation()
map = imread('map.bmp');

rivermap = map ==1;
obj = bwconncomp(rivermap);
river = [];
for i = 1:obj.NumObjects
    [y, x]= ind2sub(size(map),obj.PixelIdxList{i});
    river = cat(1,river,[y x]);
end

traimap = map ==2;
obj = bwconncomp(traimap);
trail = [];
for i = 1:obj.NumObjects
    [y, x]= ind2sub(size(map),obj.PixelIdxList{i});
    trail = cat(1,trail,[y x]);
end
sensorsmap  = map == 3;
obj = bwconncomp(sensorsmap);
sensor =regionprops(obj,'Centroid');
sensor = fliplr(cat(1,sensor.Centroid));
S = size(map);
%imshow(map,[]);

end

