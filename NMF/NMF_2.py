import os
from utils import *
import tqdm
import scipy.io.wavfile as wav
from sklearn.decomposition import NMF
## Load the data
PATH = "../data/m10/20230520_153702.WAV"
files = os.listdir("../data/m10_50202_50202/")
print(f'{len(files)} files present.')

V = get_spectrogram("20230520_051702.WAV", 48000)



print("Initializing...")
model = NMF(n_components=3, init='random', random_state=0)
print("Fitting...")
W = model.fit_transform(V)
print(W.shape)
print(model.components_.shape)

#plt.imshow(y)
p = plt.subplot(3, 2, 1)
p.set_title("Original")
librosa.display.specshow(V,sr = 48000, hop_length = 512, x_axis = "time", y_axis = 'linear')

for i in range(len(model.components_)):
    p = plt.subplot(3, 2, i+2)
    
    p.set_title("Component " + str(i))
    C = np.outer(W[:,i], model.components_[i,:])

    waveform = librosa.griffinlim(C, hop_length=512, n_fft=2048)
        # Convert the waveform to the appropriate data type (int16)
    scaled_waveform = (waveform * 32767).astype(np.int16)
        
        # Save the waveform as a WAV file
    wav.write("out" + str(i) + ".wav", 48000, scaled_waveform)
    librosa.display.specshow(C,sr = 48000, hop_length = 512, x_axis = "time", y_axis = 'linear')
    print(i)

  
plt.show()




