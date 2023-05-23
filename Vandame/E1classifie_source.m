total_source_nb = 0;
rate_x_fusion = 0.01; % in (%)
incoherence_rate = 0.3;
disp('classifie_source');
anglemin = 65;
global Data
for i = 1: NB_folder
    for j = 1 : NB_file
        total_source_nb = total_source_nb+Data.directory(i).obj(j).NumObjects;
    end
end

k = 1;
dim1 = 0;
dim2 = 0;
for i = 1: NB_folder
    for j = 1 : NB_file
        for l = 1 : Data.directory(i).obj(j).NumObjects
            [d1, d2] = size(Data.directory(i).obj(j).Source{l});
            if d1> dim1
                dim1 = d1;
            end
            if d2>dim2
                dim2 = d2;
            end
            k = k+1;
        end
    end
end

all_source_array = zeros(total_source_nb,3+3);
all_source = cell(total_source_nb,1);
all_obj = cell(total_source_nb,1);
all_index = zeros(total_source_nb,3);

k = 1;
for i = 1: NB_folder
    for j = 1 : NB_file
        for l = 1 : Data.directory(i).obj(j).NumObjects
            [d1, d2] = size(Data.directory(i).obj(j).Source{l});
            all_source{k} = Data.directory(i).obj(j).Source{l};
            all_obj{k} = Data.directory(i).obj(j).PixelIdxList{l};
            all_source_array(k,end-2) = sum(Data.directory(i).obj(j).Freq_source{l}(:))/2;
            all_source_array(k,end-1:end)=[d1 d2];
            all_index(k,1) = i;
            all_index(k,2) = j;
            all_index(k,3) = l;
            all_source_array(k,1:3) = [i j l];
            
            k = k+1;
        end
    end
end


tree = linkage(all_source_array,'single',@distcorr);
clust = cluster(tree,'cutoff',anglemin,'criterion','distance');
clear all_source all_source_array total_source_nb;
%% delete cluster alone
for i = 1 : max(clust)
    A = find(clust == i);
    if length(A) < NB_repetition_min
        all_obj(A(:)) = [];
        all_index(A(:),:) = [];
        clust(A(:)) = [];
    end
end
all_obj = all_obj(~cellfun('isempty', all_obj));
[clust] = delete_incoherente_class(clust);
clear all_source_array all_source;
%% merge by time
mean_x = cell(max(clust),1);
for i = 1 : max(clust)
    A = find(clust(:) == i);
    mean_x{i} = zeros(length(A),1);
    for j = 1 : length(A)
        [~,x]=ind2sub(Data.spectroinfo.s,all_obj{A(j)});
        mean_x{i}(j) = mean(x);
    end
end

already_fusion = zeros(max(clust),1);
for i = 1 : max(clust)
    for j = 1 : max(clust)
        if(i ~= j)&& (already_fusion(j) == 0) && (already_fusion(i) == 0)
            dist = zeros(length(mean_x{j}),1);
            indice = zeros(length(mean_x{j}),1);
            A = find(clust(:)==i);
            B = find(clust(:)==j);
            for k = 1 : length(mean_x{j})
                
                AA = abs(mean_x{i}(:) -  mean_x{j}(k));
                for l = 1 : length(mean_x{i})
                    if min(all_index(A(l),1:2) == all_index(B(k),1:2)) == 0
                        AA(l) = nan;
                    end
                end
                [dist(k),indice(k)] =  min(AA);
                % we fusion J <WARNING>
            end
            if length(find(isnan(dist(:)))==1) < incoherence_rate*length(dist)
                if max(dist) < Data.spectroinfo.s(2)*rate_x_fusion
                    disp('fusion');
                    already_fusion(j) = 1;
                    A = find(clust(:)==i);
                    B = find(clust(:)==j);
                    for k = 1 : length(mean_x{j})
                        if min(all_index(A(indice(k)),1:2) == all_index(B(k),1:2)) ~= 0
                            all_obj{A(indice(k))} =  cat(1,all_obj{A(indice(k))},all_obj{B(k)});
                        end
                        all_obj{B(k)} = [];
                    end
                    all_index(B(:),1) = 0;
                    clust(B(:)) = 0;
                end
            end
        end
        
    end
end
all_obj = all_obj(~cellfun('isempty', all_obj));
clust(find(clust == 0)) = [];
all_index(find(all_index(:,1) == 0),:) = [];
[clust] = delete_incoherente_class(clust);
%%
%%
close all
disp(['NB_objet : ' num2str(length(clust))]);
disp(['NB_source : ' num2str(max(clust))]);
for i = 1 : NB_folder
    for j = 1 : NB_file
        A = zeros(Data.spectroinfo.s);
        close all
        Beginning = min(((find(all_index(:,1) == i & all_index(:,2) == j))));% because only one file
        NB_shape = max(((find(all_index(:,1) == i & all_index(:,2) == j))));% because only one file
        for k = Beginning : NB_shape
            A(all_obj{k}) = 10*clust(k)+10;
        end
        fig=figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        
        subplot(2,1,1);
        mesh(Data.spectroinfo.gridT/60,Data.spectroinfo.gridF*10^-3,20*log10(squeeze(Data.directory(i).spectro(j,:,:))));
        set(gca,'Colormap',colormap('jet'));
        title('Spectogram');
        xlabel('time (mins)');
        ylabel('frequency (kHz)');
        xlim([0 Data.wavinfo.Duration/60]);
        ylim([0 Data.wavinfo.SampleRate*10^-3/2]);
        view(0,90)
        colorbar
        freezeColors;
        hold off
        
        subplot(2,1,2)
        mesh(Data.spectroinfo.gridT/60,Data.spectroinfo.gridF*10^-3,A);
        set(gca,'Colormap',colormap('colorcube'));
        freezeColors
        colormap jet
        title('Classification by correlation and frequency distance')
        xlabel('time (mins)');
        ylabel('frequency (kHz)');
        view(0,90)
        xlim([0 Data.wavinfo.Duration/60]);
        ylim([0 Data.wavinfo.SampleRate*10^-3/2]);
        saveas(fig,['resultat/folder' num2str(i) 'record' num2str(j) '.bmp']);
        close(fig)
        clear fig
    end
end
%%
clear tree all_shape total_source_nb i j l k d2 d1 dim1 dim2 same_source all_cell_shape
clear  all_source_array all_source fig Beginning NB_shape Beginning mean_x x y dist ans A
clear AA already_fusion B indice rate_x_fusion NB_repetition_min incoherence_rate