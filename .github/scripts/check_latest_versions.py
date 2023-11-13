import sys
import os
import modules.version_manipulation as ndvm

def main(command_line_args):
    """
    Inputs: Single version or multiple versions
    """
    versions = [str(arg) for arg in command_line_args]
    # Create a temp output folder for the release that need update
    staging = os.path.join(os.environ.get('TMPDIR', '/tmp'), 'staging-new-releases')
    os.makedirs(staging, exist_ok=True)
    
    for version in versions:
        temp_value = ndvm.compare_version_with_remote(version)
        if temp_value == version:
            path, filename = ndvm.get_release_path_and_filename(version)
            release_path = os.path.join(staging, path)
            os.makedirs(release_path, exist_ok=True)
            file_release_path = os.path.join(release_path, filename)
            with open(file_release_path, "w") as file:
                print("Creating local copy of the release version update at: ", file_release_path)
                file.write(version)

if __name__ == "__main__":
    main(sys.argv[1:])
