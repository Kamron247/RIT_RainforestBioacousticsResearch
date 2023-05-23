anglemin = 55; %�
NB_repetition_min = 2;
Big_shape = 100000; % just to test devellop
disp('selected shape');
global Data
% load('data.mat');
for i = 1: NB_folder
    for j = 1 : NB_file
        
        NB_cell = size(Data.directory(i).obj(j).PixelIdxList);
        Data.directory(i).obj(j).Source = cell(NB_cell(2),1);
        Data.directory(i).obj(j).Freq_source = cell(NB_cell(2),1);
        
        for k=1:length(Data.directory(i).obj(j).PixelIdxList)
            [y,x]=ind2sub(Data.spectroinfo.s,Data.directory(i).obj(j).PixelIdxList{k});
            yp = y - min(y)+1;
            xp = x - min(x)+1;
            contour_down = 2;
            contour_up = 2;
            contour_left = 2;
            contour_right = 2;
            if min(y) < 3
                contour_down=0;
            end
            if max(y) > Data.spectroinfo.s(1)-3
                contour_up=0;
            end
            if min(x) < 3
                contour_left = 0;
            end
            if max(x) > Data.spectroinfo.s(2)-3
                contour_right=0;
            end
            Data.directory(i).obj(j).Freq_source{k} = ...
                [min(y)-contour_down max(y)+contour_up];
            Data.directory(i).obj(j).Source{k} =...
                zeros(max(yp)+contour_down+contour_up, max(xp)+contour_left+contour_right);% zeros(Data.spectroinfo.s);
            for m = 1 : length(x)
                Data.directory(i).obj(j).Source{k}(yp(m)+contour_down,xp(m)+contour_left) = (Data.directory(i).pointer(j,y(m),x(m)));
            end
        end
        %         Data.directory(i).obj(j).correlation_map_shape = zeros(Data.spectroinfo.s(1),...
        %             Data.spectroinfo.s(2),...
        %             5);
        %         Data.directory(i).obj(j).correlation_map_angle = zeros(Data.spectroinfo.s(1),...
        %             Data.spectroinfo.s(2),...
        %             5);
        
        clear NB_cell x y m xp yp
    end
end
%%
for i = 1: NB_folder
    for j = 1 : NB_file
        %% delete incoherente object
        Big_object = cell(NB_folder*NB_file,1);
        t = 1;
        NB_objet = Data.directory(i).obj(j).NumObjects;
        for k = 1 : Data.directory(i).obj(j).NumObjects
            [NB_pixel_shape,~]=size(Data.directory(i).obj(j).PixelIdxList{k});
            if NB_pixel_shape>Big_shape
                disp('big object impossible to compute here : immediate validation')
                Big_object{t}=Data.directory(i).obj(j).PixelIdxList{k};
                Data.directory(i).obj(j).PixelIdxList{k}=[];
                Data.directory(i).obj(j).Source{k}=[];
                Data.directory(i).obj(j).Freq_source{k}  = [];
                NB_objet = NB_objet-1;
                t = t +1;
            end
        end
        
        Data.directory(i).obj(j).PixelIdxList = ...
            Data.directory(i).obj(j).PixelIdxList(~cellfun('isempty', Data.directory(i).obj(j).PixelIdxList));
        Data.directory(i).obj(j).Source = ...
            Data.directory(i).obj(j).Source(~cellfun('isempty', Data.directory(i).obj(j).Source));
        Data.directory(i).obj(j).Freq_source=...
            Data.directory(i).obj(j).Freq_source(~cellfun('isempty', Data.directory(i).obj(j).Freq_source));
        Data.directory(i).obj(j).NumObjects = NB_objet ;

    end
end
%%
for i = 1: NB_folder
    for j = 1 : NB_file
        locbyshape = zeros(Data.directory(i).obj(j).NumObjects,1);
        f = waitbar(0,['Folder : ' num2str(i) ' File : ' num2str(j)]);
        for k=1:Data.directory(i).obj(j).NumObjects
            waitbar(k/Data.directory(i).obj(j).NumObjects,f);
            %%%%%%%%%%%
            for g = 1 : NB_folder
                for u=1 : NB_file
                    
                    r1 = squeeze(Data.directory(g).pointer(u,...
                        Data.directory(i).obj(j).Freq_source{k}(1):Data.directory(i).obj(j).Freq_source{k}(2),:));
                    r2 = Data.directory(i).obj(j).Source{k};
                    
                    angle = acos(round(abs(normxcorr2(r2,r1)),5))*180/pi;
                    dim = size(r2);
                    angle = angle(dim(1):end,dim(2):end);
                    BW = imregionalmin(angle);
                    angle((find(not(BW))))=180;%useless direclty send BW
                    %disp(min(angle(:)));
                    locbyshape(k) = locbyshape(k) + length(find(angle<anglemin));
                    if locbyshape(k)>= NB_repetition_min
                        break;
                    end
                end
                if locbyshape(k)>= NB_repetition_min
                    break;
                end
            end
            %disp([num2str(k) '  ' num2str(locbyshape(k))]);
            %%%%%%%%%%%
        end
        disp(['num object initial: ' 'Folder : ' num2str(i) ' File : ' num2str(j) ' ' num2str(Data.directory(i).obj(j).NumObjects)])
        %% delete incoherente object
        Big_object = cell(NB_folder*NB_file,1);
        t = 1;
        NB_objet = Data.directory(i).obj(j).NumObjects;
        for k = 1 : Data.directory(i).obj(j).NumObjects
            [NB_pixel_shape,~]=size(Data.directory(i).obj(j).PixelIdxList{k});
            if ( locbyshape(k) <= NB_repetition_min)
                Data.directory(i).obj(j).PixelIdxList{k}=[];
                Data.directory(i).obj(j).Source{k}=[];
                Data.directory(i).obj(j).Freq_source{k}  = [];
                NB_objet = NB_objet-1;
            end
        end
        
        Data.directory(i).obj(j).PixelIdxList = ...
            Data.directory(i).obj(j).PixelIdxList(~cellfun('isempty', Data.directory(i).obj(j).PixelIdxList));
        Data.directory(i).obj(j).Source = ...
            Data.directory(i).obj(j).Source(~cellfun('isempty', Data.directory(i).obj(j).Source));
        Data.directory(i).obj(j).Freq_source=...
            Data.directory(i).obj(j).Freq_source(~cellfun('isempty', Data.directory(i).obj(j).Freq_source));
        Data.directory(i).obj(j).NumObjects = NB_objet ;
        disp(['num object final: ' 'Folder : ' num2str(i) ' File : ' num2str(j) ' ' num2str(NB_objet)])
        close(f)
    end
end
%%
clear r1 r2 k i j k l f m g angle dim ind idcorrmin BW Big_shape NB_objet;
clear ans color  t angle u x y pointer NB_pixel_shape locbyshape fig;
clear contour_down contour_left contour_right contour_down contour_up;