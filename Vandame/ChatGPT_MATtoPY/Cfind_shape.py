import numpy as np
import matplotlib.pyplot as plt
from scipy.ndimage import label
from scipy.cluster.hierarchy import linkage, fcluster
from scipy.spatial.distance import pdist
from skimage.morphology import closing, disk

threshold = -144
threshold = 10 ** (0.05 * threshold)

NB_pixel_min = 50
cmerge_threshold = 5
infomin = 70
canvas = 10 * np.array([200, 1])
se = disk(3)

print('Find shape')

tab_NB_object = np.zeros((NB_folder, NB_file))
dim1, dim2 = Data.spectroinfo.gridT.shape

total = np.zeros(NB_folder)

for i in range(NB_folder):
    Data.directory[i].pointer = np.zeros((NB_file, dim1, dim2))
    for j in range(NB_file):
        pointer = Data.directory[i].spectro[j] > threshold
        pointer = closing(pointer, selem=se)
        Data.directory[i].pointer[j] = pointer.astype(int)
        canvas = np.diag(canvas)

        obj, num_objects = label(pointer)
        for zz in range(1, num_objects + 1):
            total[i] += np.sum(obj == zz)

        center = np.array([prop.centroid for prop in regionprops(obj)])
        center = np.fliplr(center) * canvas
        link = linkage(center, method='ward', metric='euclidean')

        clust = fcluster(link, cmerge_threshold, criterion='distance')
        nobj = [np.array([]) for _ in range(clust.max())]
        obj.NumObjects = clust.max()

        for m in range(len(clust)):
            nobj[clust[m] - 1] = np.concatenate((nobj[clust[m] - 1], obj[obj == m + 1]))

        obj.PixelIdxList = [n for n in nobj if len(n) > 0]
        obj.NumObjects = len(obj.PixelIdxList)
        Data.directory[i].obj[j].Connectivity = obj.Connectivity
        Data.directory[i].obj[j].ImageSize = obj.ImageSize
        Data.directory[i].obj[j].NumObjects = obj.NumObjects
        Data.directory[i].obj[j].PixelIdxList = obj.PixelIdxList
        tab_NB_object[i, j] = obj.NumObjects

print(tab_NB_object)
print('sum:', np.sum(tab_NB_object))

total = total.astype(int)
np.save('total.npy', total)
