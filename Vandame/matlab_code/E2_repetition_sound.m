compartement = struct(...
    'Connectivity', 8, ...
    'ImageSize', Data.spectroinfo.s, ...
    'NumObjects', [], ...
    'PixelIdxList', [] );
RIF = 100;
fft_mean = cell(max(clust),1);
time  =cell(max(clust),1);
for i = 1: max(clust)
    fft_mean{i}=zeros(Data.spectroinfo.s(2)*10,1);
end

for folder = 1 : NB_folder
    for file = 1 : NB_file
        beginning =  min(find(all_index(:,1) == folder & all_index(:,2) == file));
        endd =  max(find(all_index(:,1) == folder & all_index(:,2) == file));
        
        
        T =  beginning:endd;
        for i = 1 : max(clust)
            obj = find(clust == i);
            obj = obj(logical(sum(obj == T,2)));
            if ~isempty(obj)
                compartement.PixelIdxList = all_obj(obj);
                compartement.NumObjects = length(obj(:));
                center = regionprops(compartement,'centroid');
                center = cat(1,center.Centroid);
                center = center(:,1);
                time{i} = zeros(Data.spectroinfo.s(2),1);
                time{i}(round(center)) = 1;
                fft_mean{i}=fft_mean{i}+conv(abs(fft(time{i},Data.spectroinfo.s(2)*10)),ones(RIF,1),'same');
            end
        end
        
    end
end
peak = cell(max(clust),1);
location = cell(max(clust),1);
Frequel = 0:1/(Data.spectroinfo.s(2)*10):1/2.';
Frequel = Frequel(1:floor(end/10));
 warning ('off','signal:findpeaks:largeMinPeakHeight');

for i = 1:max(clust)
    fft_mean{i}=fft_mean{i}/norm(fft_mean{i});
    fft_mean{i}=fft_mean{i}(1:floor(end/2));
    fft_mean{i} = fft_mean{i}(1:floor(end/10));
    
    [peak{i},location{i}]=findpeaks(fft_mean{i},1,...
        'MinPeakHeight',7*10^-3,...
        'MinPeakDistance',1000);

    peak{i}(Frequel(location{i})<4/Data.spectroinfo.s(2)) = [];
    location{i}(Frequel(location{i})<4/Data.spectroinfo.s(2)) = [];


end
%%
clear center compartement beginning endd f fft_mean i j k peak RIF t tab1 time tabgp T obj folder file