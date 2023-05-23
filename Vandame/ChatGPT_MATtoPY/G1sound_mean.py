import numpy as np
from scipy.fft import fft, ifft
from scipy.signal import tukey

sons_moy = [None] * len(sons)
fft_moy = [None] * len(sons)

f = 0
for i in range(len(sons)):
    f += 1
    dim = 0
    for j in range(len(sons[i])):
        if sons[i][j] is not None:
            dim = max(dim, sons[i][j].shape[0])

    for j in range(len(sons[i])):
        if sons[i][j] is not None:
            FFT = np.abs(fft(sons[i][j], dim))
            if sons[i][j].shape[0] == dim:
                phase = np.angle(fft(sons[i][j], dim))
            if fft_moy[i] is None:
                fft_moy[i] = FFT / np.linalg.norm(FFT)
            else:
                fft_moy[i] += FFT / np.linalg.norm(FFT)

    fft_moy[i] /= np.linalg.norm(fft_moy[i])
    sons_moy[i] = np.real(ifft(fft_moy[i] * np.exp(1j * phase)))

    sons_moy[i] *= tukey(len(sons_moy[i]), alpha=0.25)

    if location[i]:
        t = np.arange(Data.wavinfo.SampleRate * 15 + 1)
        t = np.mod(t, round(Data.wavinfo.SampleRate * max(Data.wavinfo.Duration) /
                            Data.spectroinfo.s[1] * 1 / Frequel[location[i][-1]])) == 0

        sons_moy[i] = np.convolve(t.astype(float), sons_moy[i])

# Clear variables
sons_moy = None
fft_moy = None
dim = None
FFT = None
location = None
phase = None
Frequel = None
Fminfiltre = None
Fmaxfiltre = None
t = None
bandmin = None
f = None
fft_moy = None
sons = None