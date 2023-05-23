anglemin = 70;%67;
NB_localiser = cell(NB_folder*NB_file,max(all.clust));
summ = cell(max(all.clust),1);
indice = cell(max(all.clust),1);
anglemin = 55;
k = 0;
for g = 1: NB_folder
    for u = 1: NB_file
        k = k+1;
%         fig=figure('outerposition',[1 1 1216 810.6667]);
%         set(fig,'visible','on');
%         subp=subplot(3,1,1);
%         cla(subp);
%         hold on;
%         mesh(Data.spectroinfo.gridT/60,Data.spectroinfo.gridF*10^-3,20*log10(squeeze(Data.directory(g).spectro(u,:,:))));
%         set(subp,'Colormap',colormap('jet'));
%         title('Spectogram');
%         xlabel('time (mins)');
%         ylabel('frequency (kHz)');
%         xlim([0 Data.wavinfo.Duration/60]);
%         ylim([0 Data.wavinfo.SampleRate*10^-3/2]);
%         view(0,90)
%         colorbar
%         freezeColors;
%         hold off
%         
%         subp=subplot(3,1,2);
%         cla(subp);
%         hold on;
%         mesh(Data.spectroinfo.gridT/60,Data.spectroinfo.gridF*10^-3,squeeze(Data.directory(g).pointer(u,:,:)));
%         set(subp,'Colormap',colormap('jet'));
%         title('spectogram after threshold')
%         xlim([0 Data.wavinfo.Duration/60]);
%         ylim([0 Data.wavinfo.SampleRate*10^-3/2]);
%         xlabel('time (mins)');
%         ylabel('frequency (kHz)');
%         view(0,90)
%         freezeColors;
%         hold off
        for i = 1 : max(all.clust)
            try
            sourcetocompare{i} = sourcetocompare{i}/norm(sourcetocompare{i});
            summ{i} = find(sum(sourcetocompare{i},2)>0.01);
            r1 = squeeze(Data.directory(g).spectro(u,...
                min(summ{i}):max(summ{i}),:));
            r2 = sourcetocompare{i}(min(summ{i}):max(summ{i}),:);
            
            angle = acos(round(abs(normxcorr2(r2,r1)),5))*180/pi;
            dim = size(r2);
            angle = angle(dim(1):end,dim(2):end);
            BW = imregionalmin(angle);
            angle((find(not(BW))))=180;
            
            angle = angle<anglemin;
            angle = sum(angle,1);
            indice{i} = find(angle);
            NB_localiser{k,i}=length(indice{i});
            catch
                sourcetocompare{i} = [];
            end
%             angle =double(angle >=1);
%             detected = conv2(angle,rot90(sourcetocompare{i},2));
%             detected =double(detected > 0.01);% Warning ajust
%             if i == 1
%                 canvas = zeros((Data.spectroinfo.s));
%             end
%             canvas = canvas+detected(1:Data.spectroinfo.s(1),1:Data.spectroinfo.s(2))*(mod(i,4)+1);
%             
        end
        
%         subp=subplot(3,1,3);
%         cla(subp);
%         hold on;
%         mesh(Data.spectroinfo.gridT/60,Data.spectroinfo.gridF*10^-3,(canvas));
%         set(subp,'Colormap',colormap('jet'));
%         title('spectogram after threshold')
%         xlim([0 Data.wavinfo.Duration/60]);
%         ylim([0 Data.wavinfo.SampleRate*10^-3/2]);
%         xlabel('time (mins)');
%         ylabel('frequency (kHz)');
%         view(0,90)
    end
end
%%
clear BW canvas color fig g i indice k minn maxx dim detected subp summ u z r1 r2 ans anglemin AA A B BB angle
