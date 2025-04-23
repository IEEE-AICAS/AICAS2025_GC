import argparse
import pandas as pd
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn

from fpga_qwen import *

accelerator = QWEN_ACCELERATOR(qwen, tokenizer)

def infer(prompt, max_gen_step, tokenizer):
    # compose the prompt
    messages = [
        {"role": "system", "content": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant."},
        {"role": "user", "content": prompt}
    ]
    prompt = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True
    )
    # do generation
    input_ids = tokenizer.encode(prompt, add_special_tokens=True)
    result = tokenizer.decode(accelerator.generate(input_ids, max_gen_step), skip_special_tokens=True)
    
    return result


def evaluate_model(dataset):
    correct_predictions = 0
    total_predictions = len(dataset)
    print(f"total_predictions={total_predictions}")
    

    finish_cnt=0
    with Progress(
        TextColumn("[bold green]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
        TextColumn("{task.completed}/{task.total} tasks completed"),
    ) as progress:
        
        task = progress.add_task("[bold green]Evaluation ", total=total_predictions)

        for _, data in dataset.iterrows():
            sentence1 = data['sentence1']
            sentence2 = data['sentence2']
            label = data['label']

            # prompt
            prompt = f"Sentence 1: {sentence1} Sentence 2: {sentence2} Is the second sentence entailed by the first? (1 for yes, 0 for no) you can only output 1 or 0"
            
            out = infer(prompt, 1000, tokenizer)

            # Output only has 1 or 0
            model_prediction = int(out.strip())

            if model_prediction == label:
                correct_predictions += 1

            finish_cnt+=1
            progress.update(task, completed=finish_cnt,description="Evaluation ")

    accuracy = correct_predictions / total_predictions
    return accuracy


def load_data(file_path):
    return pd.read_csv(file_path, sep='\t')

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="A description of your program")
    parser.add_argument('--bench_path', type=str, required=True, help="The path of benchmark (dev.tsv).")
    args = parser.parse_args()

    # dev.tsv is benchmark
    file_path = args.bench_path
    wnli_data = load_data(file_path)

    # eva
    accuracy = evaluate_model(wnli_data)

    # Write to json
    data={
    "acc":accuracy,
    }

    with open("submit_json/acc.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

    print(f"Model Accuracy: {accuracy:.2f}")
