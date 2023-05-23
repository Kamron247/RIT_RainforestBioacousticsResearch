import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import spectrogram

print('spectrogram extraction')

class SpectroInfo:
    def __init__(self):
        self.overlap = 0.5
        self.NBpoint_fft = 1024
        self.F = None
        self.T = None
        self.gridT = None
        self.gridF = None

class Data:
    spectroinfo = SpectroInfo()
    spectroinfo.overlap = 0.5
    spectroinfo.NBpoint_fft = 1024
    spectroinfo.F, spectroinfo.T, _, _ = spectrogram(
        np.squeeze(Data.directory[0].rawdata[0].T),
        window='hamming',
        nperseg=spectroinfo.NBpoint_fft,
        noverlap=int(np.floor(spectroinfo.NBpoint_fft * spectroinfo.overlap)) + 1,
        fs=Data.wavinfo.sample_rate,
        axis='y'
    )
    spectroinfo.gridT, spectroinfo.gridF = np.meshgrid(spectroinfo.T, spectroinfo.F)

    dim1, dim2 = Data.spectroinfo.gridT.shape

    for i in range(NB_folder):
        Data.directory[i].spectro = np.zeros((NB_file, dim1, dim2))
        for j in range(NB_file):
            _, _, _, Data.directory[i].spectro[j] = spectrogram(
                np.squeeze(Data.directory[i].rawdata[j].T),
                window='hamming',
                nperseg=spectroinfo.NBpoint_fft,
                noverlap=int(np.floor(spectroinfo.NBpoint_fft * spectroinfo.overlap)) + 1,
                fs=Data.wavinfo.sample_rate,
                axis='y'
            )
            Data.directory[i].spectro[j][Data.directory[i].spectro[j] < 10e-20] = 10e-20
            Data.directory[i].spectro[j] = np.abs(Data.directory[i].spectro[j])

    Data.spectroinfo.s = np.flipud(Data.directory[i].spectro[j].shape)
    Data.spectroinfo.s = np.flipud(Data.spectroinfo.s[:2])

dim1 = None
dim2 = None
i = None
j = None

# Display
# fig = plt.figure(1)
# ax = fig.add_subplot(2, 2, 1, projection='3d')
# ax.plot_surface(
#     Data.spectroinfo.gridT / 60,
#     Data.spectroinfo.gridF * 10 ** -3,
#     20 * np.log10(np.squeeze(Data.directory[-1].spectro[-1])),
#     cmap='viridis'
# )
# ax.set_xlabel('Time (mins)')
# ax.set_ylabel('Frequency (kHz)')
# ax.view_init(elev=90, azim=0)
# fig.colorbar(ax)

