import torch
from torch import nn, ls

class VAE(nn.Module):
    def __init__(self, dimx, dimz, n_sources,)