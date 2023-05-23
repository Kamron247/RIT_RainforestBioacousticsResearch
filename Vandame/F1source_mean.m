Fmaxfiltre = 20000;
Fminfiltre = 500;
bandmin = 0.05;
center_spectro = round(Data.spectroinfo.s(2)*3);
order = 7;
val = 0;
for i = 1 : max(clust)
    val = max(sum(clust == i),val);
end


sons = cell(max(clust),val);
sourcetocompare = cell(max(clust),1);
clear val


 
for i=1 : max(clust)
    indice_source = find(clust == i);
    
    
    canvas = zeros(Data.spectroinfo.s(1),Data.spectroinfo.s(2)*6);
    
    
    
    [y,x] = ind2sub(Data.spectroinfo.s,all_obj{indice_source(1)});
    xc = x-(min(x))+1;
    
    min_T_x =round( Data.spectroinfo.T(min(x))*Data.wavinfo.SampleRate);
    max_T_x = round(Data.spectroinfo.T(max(x))*Data.wavinfo.SampleRate);
    T = min_T_x:max_T_x;
    
    sons{i,1}=zeros(Data.wavinfo.TotalSamples,1);
    sons{i,1}(1:Data.wavinfo.TotalSamples) = ...
        squeeze(Data.directory(all_index(indice_source(1),1)). ...
        rawdata(all_index(indice_source(1),2),:)).';
    
    if Data.spectroinfo.F(max(y)) < Fmaxfiltre && Data.spectroinfo.F(min(y))>Fminfiltre
        if abs(Data.spectroinfo.F(min(y))-Data.spectroinfo.F(max(y)))*2/Data.wavinfo.SampleRate > bandmin
        [b,a] = butter(order,...
            [Data.spectroinfo.F(min(y)) Data.spectroinfo.F(max(y))]...
            *2/Data.wavinfo.SampleRate,'bandpass');
        
        else
            mu = abs(Data.spectroinfo.F(min(y))+ Data.spectroinfo.F(max(y)))/Data.wavinfo.SampleRate;
         [b,a] = butter(order,...
            [mu-bandmin/2 mu+bandmin/2]...
            ,'bandpass');   
        end
    elseif  Data.spectroinfo.F(min(y))>Fminfiltre
        [b,a] = butter(order,...
            Data.spectroinfo.F(min(y))...
            *2/Data.wavinfo.SampleRate,'high');
    else
        [b,a] = butter(order,...
            Data.spectroinfo.F(max(y))...
            *2/Data.wavinfo.SampleRate,'low');
    end
    sons{i,1} = filter(b,a,sons{i,1});
    
    A = zeros(Data.wavinfo.TotalSamples,1);
    A(T) = sons{i,1}(T);
    sons{i,1} = A;
    
    sons{i,1} = sons{i,1}(min(find(sons{i,1}~=0)):max(find(sons{i,1}~=0)));
    
    disp(['frequence ' num2str([Data.spectroinfo.F(min(y)) Data.spectroinfo.F(max(y))])]);
    for k = 1 : length(xc)
        canvas(y(k),xc(k)+center_spectro) =1;
    end
    
    for j = 2:length(indice_source)
        
        [y,x] = ind2sub(Data.spectroinfo.s,all_obj{indice_source(j)});
        xc = x-(min(x))+1;
        
        min_T_x =round( Data.spectroinfo.T(min(x))*Data.wavinfo.SampleRate);
        max_T_x = round(Data.spectroinfo.T(max(x))*Data.wavinfo.SampleRate);
        T = min_T_x:max_T_x;
        
        sons{i,j}=zeros(Data.wavinfo.TotalSamples,1);
        sons{i,j}(1:Data.wavinfo.TotalSamples) = ...
            squeeze(Data.directory(all_index(indice_source(j),1)). ...
            rawdata(all_index(indice_source(j),2),:)).';
        
            if Data.spectroinfo.F(max(y)) < Fmaxfiltre && Data.spectroinfo.F(min(y))>Fminfiltre
        if abs(Data.spectroinfo.F(min(y))-Data.spectroinfo.F(max(y)))*2/Data.wavinfo.SampleRate > bandmin
        [b,a] = butter(order,...
            [Data.spectroinfo.F(min(y)) Data.spectroinfo.F(max(y))]...
            *2/Data.wavinfo.SampleRate,'bandpass');
        else
            mu = abs(Data.spectroinfo.F(min(y))+ Data.spectroinfo.F(max(y)))/Data.wavinfo.SampleRate;
         [b,a] = butter(order,...
            [mu-bandmin/2 mu+bandmin/2]...
            ,'bandpass');   
        end
    elseif  Data.spectroinfo.F(min(y))>Fminfiltre
        [b,a] = butter(order,...
            Data.spectroinfo.F(min(y))...
            *2/Data.wavinfo.SampleRate,'high');
    else
        [b,a] = butter(order,...
            Data.spectroinfo.F(max(y))...
            *2/Data.wavinfo.SampleRate,'low');
    end
         

        sons{i,j} = filter(b,a,sons{i,j});
        
        A = zeros(Data.wavinfo.TotalSamples,1);
        A(T) = sons{i,j}(T);
        sons{i,j} = A;
        
        sons{i,j} = sons{i,j}(min(find(sons{i,j}~=0)):max(find(sons{i,j}~=0)));
        
        
        
        
        source = ones(Data.spectroinfo.s(1),max(xc)+4)*10^-20;
        for k = 1 : length(xc)
            source(y(k),2+xc(k)) = 1;% squeeze(Data.directory(all_index(indice_source(j),1)). ...
            %spectro(all_index(indice_source(1),2),:,x(k)));
        end
        
        angle = acos(round(abs(normxcorr2(sum(source,1),sum(canvas,1))),5));
        [~,xpeak] = ind2sub(size(angle), find(angle==min(angle(:))));
        xoffSet = xpeak(1)-size(source,2);
        try
        canvas(:,xoffSet+1:xoffSet+max(xc)+4) = ...
            canvas(:,xoffSet+1:xoffSet+max(xc)+4)+...
            source(:,:);
        catch
            disp('impossible')
        end
        
    end
    summ = find(sum(canvas,1)~=0);
    minn = min(summ);
    maxx = max(summ);
    
   sourcetocompare{i}=canvas(:,minn:maxx); 
   sourcetocompare{i} = flipud(sourcetocompare{i});
end
%% clean the fucking Workspace
clear T xoffSet xpeak x y A a b angle  i j k max_T_x min_T_x center_spectro xc source canvas Big_object

all.all_index =all_index;
all.all_objet = all_obj;
all.clust = clust;
%%
clear clust all_obj all_index indice_source val order clear mu indice_source