import numpy as np
import scipy.io.wavfile as wav
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

sample_rate = 44100  # 44.1kHz sample rate, common for audio
duration = 2  # duration of each tone in seconds
frequencies = [125, 250, 500, 1000, 2000, 4000, 8000]  # frequencies for the tones


def check_if_flutter_project():
    # Check for the presence of important Flutter project files/folders
    if os.path.exists("pubspec.yaml") and os.path.exists("lib"):
        return True
    return False


def create_assets_folder():
    current_directory = os.getcwd()

    if check_if_flutter_project():
        # Define the path for the 'assets' folder inside the current directory
        assets_path = os.path.join(current_directory, "assets")

        # Check if the folder exists, and if not, create it
        if not os.path.exists(assets_path):
            os.makedirs(assets_path)
        logger.info(f"Assets folder created at: {assets_path}")
    else:
        logger.error(
            "Error: Not a Flutter project. Please run this script in a Flutter project directory."
        )


create_assets_folder()


# Function to generate sine wave for a given frequency
def generate_tone(frequency, duration, sample_rate):
    t = np.linspace(
        0, duration, int(sample_rate * duration), endpoint=False
    )  # time array
    wave = np.sin(2 * np.pi * frequency * t)  # sine wave formula
    return np.int16(wave * 32767)  # Convert to 16-bit PCM format


# Generate and save the tones as WAV files
for freq in frequencies:
    tone = generate_tone(freq, duration, sample_rate)
    file_name = f"assets/tone_{freq}Hz.wav"
    wav.write(file_name, sample_rate, tone)
    logger.info(f"Generated {file_name}")
