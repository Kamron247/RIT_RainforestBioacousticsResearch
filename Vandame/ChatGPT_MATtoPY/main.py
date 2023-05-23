import os
from datetime import date
from scipy.io import savemat

# Add path to 'function/' directory
path = os.path.join(os.getcwd(), 'function')
os.add_path(path)

# Load data
Aload_data()

# Time-frequency extraction
Btime_frequency_extraction()

# Find shape
Cfind_shape()

# Select shape
Dselected_shape()

# Save data before classification
savemat(f'beforeClassification_{date.today()}.mat', {'Data': Data}, format='7.3')

# Classify source
E1classifie_source()

# Save middle data
savemat(f'middle_{date.today()}.mat', {'Data': Data})

# Repetition sound
E2_repetition_sound()

# Source mean
F1source_mean()

# Sound mean
G1sound_mean()

# Save final data
savemat(f'final_{date.today()}.mat', {'Data': Data}, format='7.3')

# Play sound
I1play_sound()

# Identification
Hidentification()

# Localization
Jlocalisation()