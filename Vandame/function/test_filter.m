%order = 7;
[z,p,k] = butter(order,[mu-bandmin/2 mu+bandmin/2],'bandpass');
[b,a] =  butter(order,[mu-bandmin/2 mu+bandmin/2],'bandpass');
sos = zp2sos(z,p,k);
fvtool(sos,'Analysis','freq')


impz(b,a,10000)

%%
% spectrogram(sons{i},rectwin(Data.spectroinfo.NBpoint_fft),...
% floor(Data.spectroinfo.NBpoint_fft*Data.spectroinfo.overlap)+1,...
% Data.spectroinfo.NBpoint0_fft,Data.wavinfo.SampleRate,'yaxis');