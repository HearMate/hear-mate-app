import os
import soundfile as sf
import numpy as np
import argparse


def process_tone_files(assets_folder):
    """
    Process all audio files in the assets folder that start with 'tone'.
    Creates two versions of each file: one for left ear only and one for right ear only.
    """
    # Check if the assets folder exists
    if not os.path.exists(assets_folder):
        print(f"Error: Assets folder '{assets_folder}' not found.")
        return

    # Count processed files
    processed_count = 0

    # List all files in the assets folder
    for filename in os.listdir(assets_folder):
        file_path = os.path.join(assets_folder, filename)

        # Check if it's a file (not a directory) and starts with 'tone'
        if (
            os.path.isfile(file_path)
            and filename.lower().startswith("tone")
            and (
                filename.lower().endswith(".wav")
                or filename.lower().endswith(".mp3")
                or filename.lower().endswith(".ogg")
            )
        ):

            try:
                # Get the file name without extension
                base_name, extension = os.path.splitext(filename)

                # Skip if it's already a left/right processed file
                if base_name.endswith("_left") or base_name.endswith("_right"):
                    continue

                # Load the audio file
                print(f"Processing {filename}...")
                data, sample_rate = sf.read(file_path)

                # Create stereo version if it's mono
                if len(data.shape) == 1:
                    # It's a mono file
                    stereo_data_left = np.zeros((len(data), 2))
                    stereo_data_right = np.zeros((len(data), 2))

                    # Left ear version
                    stereo_data_left[:, 0] = data  # Copy original data to left channel

                    # Right ear version
                    stereo_data_right[:, 1] = (
                        data  # Copy original data to right channel
                    )

                else:
                    # It's already stereo
                    stereo_data_left = np.zeros(data.shape)
                    stereo_data_right = np.zeros(data.shape)

                    # Left ear version
                    stereo_data_left[:, 0] = data[:, 0]  # Keep left channel

                    # Right ear version
                    stereo_data_right[:, 1] = data[
                        :, data.shape[1] - 1
                    ]  # Keep right channel

                # Create output file names
                left_file = os.path.join(assets_folder, f"{base_name}_left{extension}")
                right_file = os.path.join(
                    assets_folder, f"{base_name}_right{extension}"
                )

                # Save the new files
                sf.write(left_file, stereo_data_left, sample_rate)
                sf.write(right_file, stereo_data_right, sample_rate)

                processed_count += 1
                print(f"Created: {left_file} and {right_file}")

            except Exception as e:
                print(f"Error processing {filename}: {str(e)}")

    if processed_count > 0:
        print(f"\nProcessed {processed_count} tone files.")
    else:
        print("\nNo tone files were found or processed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Process tone files for left/right ear playback"
    )
    parser.add_argument(
        "--folder", default="assets", help="Path to the assets folder (default: assets)"
    )
    args = parser.parse_args()

    process_tone_files(args.folder)
