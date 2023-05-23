import numpy as np
from scipy.signal import find_peaks

compartement = {'Connectivity': 8, 'ImageSize': Data.spectroinfo.s, 'NumObjects': None, 'PixelIdxList': None}
RIF = 100
fft_mean = [np.zeros(Data.spectroinfo.s[1] * 10) for _ in range(max(clust))]
time = [np.zeros(Data.spectroinfo.s[1]) for _ in range(max(clust))]
peak = [None] * max(clust)
location = [None] * max(clust)

for folder in range(NB_folder):
    for file in range(NB_file):
        T = np.arange(min(np.where((all_index[:, 0] == folder) & (all_index[:, 1] == file))[0]),
                      max(np.where((all_index[:, 0] == folder) & (all_index[:, 1] == file))[0]) + 1)

        for i in range(max(clust)):
            obj = np.where(clust == i + 1)[0]
            obj = obj[np.any(obj[:, None] == T, axis=1)]
            if obj.size > 0:
                compartement['PixelIdxList'] = all_obj[obj]
                compartement['NumObjects'] = len(obj)
                center = regionprops(compartement, 'centroid')[0]['Centroid'][0]
                time[i] = np.zeros(Data.spectroinfo.s[1])
                time[i][round(center)] = 1
                fft_mean[i] += np.convolve(np.abs(np.fft.fft(time[i], Data.spectroinfo.s[1] * 10)), np.ones(RIF),
                                           mode='same')

        fft_mean_norm = [fft / np.linalg.norm(fft[:fft.size // 2][:fft.size // 10]) for fft in fft_mean]

        for i, fft in enumerate(fft_mean_norm):
            peaks, locations = find_peaks(fft, height=7 * 10 ** -3, distance=1000)
            freq_locations = Frequel[locations]
            mask = freq_locations >= 4 / Data.spectroinfo.s[1]
            peak[i] = peaks[mask]
            location[i] = locations[mask]

# Clear variables
compartement = None
RIF = None