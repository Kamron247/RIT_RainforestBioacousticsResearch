import librosa
import numpy as  np
import matplotlib.pyplot as plt 

def get_spectrogram(path, target_sample_rate, hop_length=None, n_fft=2048):
    """Converts a wav file to a spectrogram and returns it

    Args:
        path (_type_): _description_
        target_sample_rate (_type_): This is the sample rate you want it to be turned into
            if native sample rate > target_sample_rate, resampling will occur.
    """
    
    audio, sr = librosa.load(path, sr=target_sample_rate)
    #stft_audio = np.fft.rfft(audio, n=n_fft)
    stft_audio = librosa.stft(audio, hop_length=hop_length, n_fft=n_fft, window='hann')
    
    y = np.abs(stft_audio)**2
    
    return y

def plot_spectrogram(y, sr, hop_length=512):
    plt.figure(figsize = (25,10))
    #plt.imshow(y)
    librosa.display.specshow(y,sr = sr, hop_length = hop_length, x_axis = "time", y_axis = 'linear')
    plt.colorbar(format="%+2.f")
    plt.show()
    
def ACI(spectrogram, delta_f=16, delta_t=16):
    # librosa stft bins frequencies into bins according to n_fft.
    # It would be infeasible to check every since frequency, so I will bin the bins
    # for the complexity index.
    ACI_total = 0
    ACI_over_time = []
    for j in range(0, int(len(spectrogram[0])/ delta_t) - 1):
        t = j * delta_t
        ACI_t = 0
        for q in range(0, int(len(spectrogram) / delta_f) - 1):
            # for each frequency bin
            start = q * delta_f
            end = (q+1) * delta_f
            
            # find the intensity along the frequency axis within that bin
            D = sum([abs(spectrogram[k][t] - spectrogram[k+1][t]) for k in range(start, end-1)])
            I = sum([spectrogram[k][t] for k in range(start, end)])
            
            
            ACI_t += D/I
        ACI_over_time.append(ACI_t)
        ACI_total += ACI_t
    return ACI_total, ACI_over_time
        

    
if __name__ == "__main__":
    spectro = get_spectrogram("../data/m10_50202_50202/20230520_050302.WAV", 48000)
    t, aci = ACI(spectro)
    
    plt.plot(range(0, len(aci)), aci)
    plt.show()
    print(spectro.shape)