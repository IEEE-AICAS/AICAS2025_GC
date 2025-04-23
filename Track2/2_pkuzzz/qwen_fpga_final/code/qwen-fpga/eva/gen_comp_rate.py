import os
import sys
import json
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--file_path", type=str, help="Path to the model file")
    args = parser.parse_args()
    file_path = args.file_path

    if not os.path.exists(file_path):
        print(f"{file_path} does not exist")
        sys.exit(1)


    file_size = os.path.getsize(file_path)
    print(f"{file_size} bytes")

    data={
    "model_size_bytes":file_size,
    "rate":1-file_size/988097824,
    }

    os.makedirs("submit_json", exist_ok=True)
    with open("submit_json/comp_rate.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    main()
