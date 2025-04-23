import os
import sys
import json

def main():
    # get all .bin files in bin directory
    bin_files = [f for f in os.listdir("bin") if f.endswith(".bin")]
    # calculate total size of all .bin files
    file_size = sum([os.path.getsize(f"bin/{f}") for f in bin_files])

    data={
        "model_size_bytes":file_size,
        "rate":1-file_size/988097824,
    }

    with open("submit_json/comp_rate.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    main()
