threshold = -144 ;%-80; %(normalize dB)
threshold = 10^(0.05*threshold);
global Data
NB_pixel_min = 50; % perfect = [1] %Warning
cmerge_threshold = 5;
infomin = 70;
canvas = 10*[200 1];
se = strel('disk',3);
% cmerge_threshold = 1.3;
disp('Find shape');
tab_NB_object = zeros(NB_folder,NB_file);
[dim1,dim2] = size(Data.spectroinfo.gridT);
%%
total = zeros(NB_folder,1);
for i = 1 : NB_folder
    Data.directory(i).pointer=zeros(NB_file,dim1,dim2);
    for j = 1 : NB_file
        %% display time frequency
        
        pointer =  (squeeze(Data.directory(i).spectro(j,:,:))) > threshold;
        pointer = imclose(pointer,se);
        Data.directory(i).pointer(j,:,:) = pointer;
        canvas = diag(canvas);
        
        %% isolation shape
        obj = bwconncomp(pointer);
        for zz = 1 : obj.NumObjects
             total(i) = total(i)+length(obj.PixelIdxList{zz});
        end
        center =regionprops(obj,'Centroid');
        center = cat(1,center.Centroid);
        center = fliplr(center)*canvas;
        link = linkage(center,'ward','euclidean');
        
        
        
        clust = cluster(link,'cutoff',cmerge_threshold,'criterion','distance');
        %clust = clusterdata(center,cmerge_threshold);
        nobj = cell(1,max(clust));
        obj.NumObjects = max(clust);
        
        for m = 1 : length(clust)
            nobj{clust(m)} = cat(1,nobj{clust(m)},obj.PixelIdxList{m});
        end
        
        obj.PixelIdxList = nobj;
        clear nobj locs pks link clusr center delta;
        %% delete little object
        NB_object = obj.NumObjects;
        for k = 1 : obj.NumObjects
            [NB_pixel_shape,~]=size(obj.PixelIdxList{k});
            if NB_pixel_shape<NB_pixel_min
                obj.PixelIdxList{k}=[];
                NB_object=NB_object-1;
            end
        end
        obj.NumObjects = NB_object;
        obj.PixelIdxList = obj.PixelIdxList(~cellfun('isempty', obj.PixelIdxList));
        
        Data.directory(i).obj(j).Connectivity=obj.Connectivity;
        Data.directory(i).obj(j).ImageSize=obj.ImageSize;
        Data.directory(i).obj(j).NumObjects=obj.NumObjects;
        Data.directory(i).obj(j).PixelIdxList=obj.PixelIdxList;
        tab_NB_object(i,j) = NB_object;
        
    end
end

disp(tab_NB_object);
disp(['sum : ',num2str(sum(tab_NB_object(:)))]);
save('total.mat','total');
%%
close all;
clear ans threshold canvas pointer canvas_min cmerge_threshold m clust 
clear center NB_pixel_shape i j k NB_pixel_min obj NB_object subp fig se 
clear dim1 dim2 fig