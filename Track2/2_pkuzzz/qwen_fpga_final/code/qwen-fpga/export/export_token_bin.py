import json
import string
import struct
import argparse

VOCAB_SIZE_FINAL=151936

parser = argparse.ArgumentParser()
parser.add_argument("modelpath", type=str, help="the output filepath")
parser.add_argument("output", type=str, help="the output filepath")
args = parser.parse_args()

# Load tokenizer_config.json and vocab.json
with open(f"{args.modelpath}/tokenizer_config.json", "r", encoding="utf-8") as f:
    tokenizer_config = json.load(f)

with open(f"{args.modelpath}/vocab.json", "r", encoding="utf-8") as f:
    vocab = json.load(f)

# 获取额外的特殊标记
added_tokens_decoder = tokenizer_config.get("added_tokens_decoder", {})

# print(len(added_tokens_decoder))

# 提取词汇表中的词和标识符
words = {word: idx for word, idx in vocab.items()}

# 处理 added_tokens_decoder 中的特殊标记
special_tokens = {}
for idx, token_info in added_tokens_decoder.items():
    special_tokens[token_info["content"]] = int(idx)

# 合并词表和特殊标记
final_vocab = {**words, **special_tokens}

# 显示最终的词表
print(f"vocab len {len(final_vocab)}")
# for token, idx in final_vocab.items():
#     print(f"{token}: {idx}")


vocab_size_reverse=VOCAB_SIZE_FINAL-len(final_vocab)
# reverse_template=<|reserved_special_token_8|>

weight_begin=len(final_vocab)

for i in range(0,vocab_size_reverse):
    reverse_token_name=f"<|reserved_special_token_{i}|>"
    final_vocab[reverse_token_name]=weight_begin+i


# for token, idx in final_vocab.items():
#     print(f"{token}: {idx}")

assert len(final_vocab)==VOCAB_SIZE_FINAL

###################################################
#####################################################
tokens, scores = [], []
for token, idx in final_vocab.items():
    # print(f"{token}: {idx}")
    t = token.encode('utf-8')
    s = idx
    tokens.append(t)
    scores.append(s)

max_token_length = max(len(t) for t in tokens)

with open(f"{args.output}", "wb") as f:
    f.write(struct.pack("I", max_token_length))
    for bytes, score in zip(tokens, scores):
        f.write(struct.pack("fI", score, len(bytes)))
        f.write(bytes)