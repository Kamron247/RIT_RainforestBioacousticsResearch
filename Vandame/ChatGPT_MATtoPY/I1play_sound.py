import sounddevice as sd
from scipy.io import wavfile

for i in range(len(sons_moy)):
    wavfile.write(f"resultat/source{i+1}.wav", Data.wavinfo.SampleRate, sons_moy[i] / np.max(sons_moy[i]) * 0.5)
    # To play the sound (uncomment the following lines):
    # sd.play(sons_moy[i][:min(len(sons_moy[i]), 44100*3)] * 1000, Data.wavinfo.SampleRate / 2)
    # sd.wait()
    # sd.stop()
    # print(i+1)
