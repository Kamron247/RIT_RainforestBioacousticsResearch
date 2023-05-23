import os
import numpy as np
from scipy.io import wavfile

print('load_data')

class Obj:
    def __init__(self):
        self.Connectivity = 0
        self.ImageSize = []
        self.NumObjects = []
        self.PixelIdxList = []
        self.Source = []
        self.correlation_map_shape = []
        self.correlation_map_angle = []

class S:
    def __init__(self, NB_file):
        self.rawdata = np.zeros((NB_file, Data.wavinfo[0].total_samples))
        self.obj = [Obj() for _ in range(NB_file)]
        self.filename = ['' for _ in range(NB_file)]

class Data:
    directory = []
    wavinfo = []

mfiles = os.listdir('/dirs/home/phd/pmv8736/data/06022019 Dusk Dawn')
mfiles = os.listdir('D:\stage\manipulation\data\06022019 Dusk Dawn\\')
mdirflag = [os.path.isdir(m) for m in mfiles]
subfolder = [mfiles[i] for i, flag in enumerate(mdirflag) if flag]

files = os.listdir(os.path.join(subfolder[0], subfolder[0]))
NB_folder = len(subfolder) - 2
NB_file = len(files) - 3

NB_folder = 14
NB_file = 10

Data.wavinfo = wavfile.read(os.path.join(files[2].folder, files[2].name))
s = S(NB_file)

Data.directory = [S(NB_file) for _ in range(NB_folder)]

for i in range(NB_folder):
    files = os.listdir(os.path.join(subfolder[i], subfolder[i]))
    for j in range(NB_file):
        Data.directory[i].name = files[j + 2].name
        Data.directory[i].folder = files[j].folder
        Data.directory[i].folder = Data.directory[i].folder[Data.directory[i].folder.index('#') + 1:]
        Data.directory[i].filename[j] = os.path.join(files[j].folder, files[j + 2].name)
        Data.directory[i].rawdata[j] = wavfile.read(Data.directory[i].filename[j])[1]

mfiles.clear()
mdirflag.clear()
subfolder.clear()
files.clear()
obj = None
s = None
