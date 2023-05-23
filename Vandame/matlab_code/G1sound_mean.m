sons_moy = cell(size(sons,1),1);
fft_moy = cell(size(sons,1),1);

        f = waitbar(0,'sound mean');
for i = 1:size(sons,1)
    waitbar(i/size(sons,1),f);

    dim = 0;
    for j = 1 : size(sons,2)
        if ~isempty(sons{i,j})
            dim=max(dim,size(sons{i,j},1));
        end
    end
    
    for j = 1 : size(sons,2)
        if ~isempty(sons{i,j})
            FFT = abs(fft(sons{i,j},dim));
            if size(sons{i,j},1) == dim
                phase = angle(fft(sons{i,j},dim));
            end
            if isempty(fft_moy{i})
                fft_moy{i}=FFT/norm(FFT);
            else
                fft_moy{i}=fft_moy{i}+FFT/norm(FFT);
            end
        end
    end
    fft_moy{i} = fft_moy{i}/norm(fft_moy{i});
    sons_moy{i} = real(ifft(fft_moy{i}.*exp(1i*phase)));
    
    sons_moy{i} = sons_moy{i}.*tukeywin((length(sons_moy{i})),0.25);
    %% repetition of the sound
    if ~isempty(location{i})
        t = 0:max(Data.wavinfo.SampleRate*15);
        t = double( mod(t,round(Data.wavinfo.SampleRate*...
            max(Data.wavinfo.Duration)/Data.spectroinfo.s(2)*1/(Frequel(location{i}(end))))) == 0 ).';

        sons_moy{i} = conv(t,sons_moy{i});
        
    end
    
end

close(f);
%%
clear ans dim FFT location i j k phase Frequel Fminfiltre Fmaxfiltre t bandmin f fft_moy 
clear sons