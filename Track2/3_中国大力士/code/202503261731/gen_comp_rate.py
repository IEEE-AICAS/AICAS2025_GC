import os
import sys
import json

def main():
    file_path = input("Your models path:")

    if not os.path.exists(file_path):
        print(f"{file_path} does not exist")
        sys.exit(1)


    file_size = os.path.getsize(file_path)
    print(f"{file_size} bytes")

    data={
    "model_size_bytes":file_size,
    "rate":1-file_size/988097824,
    }

    with open("submit_json/comp_rate.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    main()
