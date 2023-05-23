clear Data.spectroinfo
global Data
disp('spectrogram extraction');
Data.spectroinfo.overlap=0.5;

Data.spectroinfo.NBpoint_fft = 1024;

[~,Data.spectroinfo.F,Data.spectroinfo.T,~]=...
    spectrogram(squeeze(Data.directory(1).rawdata(1,:).'),hamming(Data.spectroinfo.NBpoint_fft),...
    floor(Data.spectroinfo.NBpoint_fft*Data.spectroinfo.overlap)+1,...
    Data.spectroinfo.NBpoint_fft,Data.wavinfo.SampleRate,'yaxis');

[Data.spectroinfo.gridT,Data.spectroinfo.gridF]=meshgrid(Data.spectroinfo.T,Data.spectroinfo.F);

[dim1,dim2] = size(Data.spectroinfo.gridT);

for i=1:NB_folder
    Data.directory(i).spectro=zeros(NB_file,dim1,dim2);
    for j=1:NB_file
        [~,~,~,Data.directory(i).spectro(j,:,:)]=(...
            spectrogram(squeeze(Data.directory(i).rawdata(j,:).'),hamming(Data.spectroinfo.NBpoint_fft),...
            floor(Data.spectroinfo.NBpoint_fft*Data.spectroinfo.overlap)+1,...
            Data.spectroinfo.NBpoint_fft,Data.wavinfo.SampleRate,'yaxis'));
            Data.directory(i).spectro(find(Data.directory(i).spectro(j,:,:)<10^-20))=10^-20;
         Data.directory(i).spectro(j,:,:)=(abs(Data.directory(i).spectro(j,:,:)));
    end
end
    Data.spectroinfo.s = squeeze(fliplr(size(Data.directory(i).spectro(j,:,:))));
    Data.spectroinfo.s = fliplr(Data.spectroinfo.s(1:2));
clear dim1 dim2 i j
% %% display
% figure(1)
% subplot(2,2,1);
% hold on;
% mesh(Data.spectroinfo.gridT/60,Data.spectroinfo.gridF*10^-3,20*log10(squeeze(Data.directory(end).spectro(end,:,:))));
% xlabel('time (mins)');
% ylabel('frequency (kHz)');
% view(0,90)
% colorbar