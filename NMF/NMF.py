import os
from utils import *
import tqdm
from sklearn.decomposition import NMF
## Load the data
PATH = "../data/m10_50202_50202/"
files = os.listdir("../data/m10_50202_50202/")
print(f'{len(files)} files present.')
spectro_shape = get_spectrogram(PATH + files[0], 48000).shape

vector_shape = spectro_shape[0] * spectro_shape[1]

V = np.zeros(shape=(len(files[:10]), vector_shape))

for i, file in tqdm.tqdm(enumerate(files[:10])):
    V[i] = get_spectrogram(PATH + file, 48000 ).reshape((1, vector_shape))
print(V.shape)
print("Initializing...")
model = NMF(n_components=6, init='random', random_state=0)
print("Fitting...")
W = model.fit_transform(V)
print("done")
print(W.shape)
print(model.components_.shape)

i = 1
for component in model.components_:
    plt.subplot(3, 2, i)
    i+=1
    plt.figure(figsize = (25,10))
    librosa.display.specshow(librosa.amplitude_to_db(component.reshape(spectro_shape),ref=np.max), sr = 46000, hop_length = 512, x_axis = "time", y_axis = 'linear')
    plt.colorbar(format="%+2.f")
plt.show()
