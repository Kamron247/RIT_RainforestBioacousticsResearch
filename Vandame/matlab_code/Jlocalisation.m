[S,river,trail,sensor] = map_creation();

microtofichier = [6 15 8 9 2 14 4 11 10 1 3 5 12 13 7];
[~, fichiertomicro] = sort(microtofichier);
vartofichier = zeros(length(Data.directory),1);
for i = 1 : length(Data.directory)
    vartofichier(i)=str2num(Data.directory(i).folder);
    
    all.all_index(find(all.all_index(:,1) == i),1)= -10000+vartofichier(i);
end

all.all_index(:,1) = all.all_index(:,1) + 10000;

total = zeros(NB_folder,1);
f = figure;
tabgp = uitabgroup(f);

for src = 1: max(all.clust)
    obj = find(all.clust == src);
    canvas = zeros(S);
    NB_source_localiser = all.all_index(obj,1);
    for k = 1: NB_folder%size(sensor,1)
        NB_detection = length(find(NB_source_localiser == k));
        for h = 1 : NB_file
            if NB_localiser{NB_file*(k-1)+h,src} ~= []
                NB_detection = NB_detection+ NB_localiser{NB_file*(k-1)+h,src};
            end
        end
        total(k) = total(k)+NB_detection;
        %disp(NB_detection);
        for i = 1:S(1)
            for j = 1:S(2)
                canvas(i,j) =canvas(i,j)+ NB_detection/...
                    (100*(norm([(i-sensor(fichiertomicro(k),1)) (j-sensor(fichiertomicro(k),2))]./S)))^2;
            end
        end
    end
    
    
    tab1 = uitab(tabgp,'Title',['source ' num2str(src)]);
    Axe=axes('Parent',tab1);
    
    [A,B]=meshgrid(1:482,1:700);
    contour(A,B,log10(canvas),40);
    view(0,-90);
    %imagesc(log(canvas),[-5 5]);
    %view(0,90);
    hold on
    plot(river(:,2),river(:,1),'.');
    plot(trail(:,2),trail(:,1),'.')
    for k = 1: size(sensor,1)
        text(sensor(fichiertomicro(k),2),sensor(fichiertomicro(k),1),num2str(k),'FontSize',20);
    end
    legend('equiprobability to hear this source','river','trail');
    %legend('probability to hear this source','river','trail');
    %legend('river','trail');
    title('Map of the microphone','FontSize',20);
    h=get(gca);
    h.XAxis.Visible = 'off';
    h.YAxis.Visible = 'off';
    hold off
end
savefig(f,'resultat/map_source.fig')
%%
f=figure();
canvas = zeros(S);
for k = 1: NB_folder%size(sensor,1)
    
    for i = 1:S(1)
        for j = 1:S(2)
            canvas(i,j) =canvas(i,j)+ total(k)/max(total) /...
                (100*(norm([(i-sensor(fichiertomicro(k),1)) (j-sensor(fichiertomicro(k),2))]./S)))^2;
        end
    end
end



[A,B]=meshgrid(1:size(canvas,2),1:size(canvas,1));
contour(A,B,log10(canvas),40);
view(0,-90);
%imagesc(log(canvas),[-3 0]);
hold on
plot(river(:,2),river(:,1),'.')
plot(trail(:,2),trail(:,1),'.')
for k = 1: size(sensor,1)
        text(sensor(fichiertomicro(k),2),sensor(fichiertomicro(k),1),num2str(k),'FontSize',20);
end


savefig(f,'resultat/total_NB_source.fig')
hold off
save('total.mat','total')
%%
%clear canvas f i j k obj S river tabl tabgp src tab1 trail sensor inv_ordre_micro ordre_micro NB_detection
%clear A B microtofichier fichiertomicro vartofichier