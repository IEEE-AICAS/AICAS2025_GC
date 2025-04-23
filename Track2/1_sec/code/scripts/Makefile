# Makefile

drop_cache:
	sync && echo 3 | sudo tee /proc/sys/vm/drop_caches

########## Generate unpacked embedding ###########
./unpack/PRUNED_EMBEDDING.bin:
	python gen_embedding.py

########## Generated tie cls ###########
./unpack/all_cls_w_tied.bin: ./unpack/PRUNED_EMBEDDING.bin
	python gen_tie_cls.py

########## unpack ###########
.PHONY: unpack
unpack: ./unpack/PRUNED_EMBEDDING.bin ./unpack/all_cls_w_tied.bin

########## Accuracy test ################
acc_eva: unpack
	python acc.py --bench_path final.tsv

########## Throughput test ###########
thpt_eva: unpack
	python throughput.py --bench_path prompt.txt

########## Compress ratio test ###########
comp_eva: unpack
	python gen_comp_rate.py

all: acc_eva thpt_eva comp_eva
