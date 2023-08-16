#!/bin/bash

for s in 1000000
do
	echo "Running extended pretraining with $s steps"
	python -m mlm --model_name_or_path cardiffnlp/twitter-xlm-roberta-base --use_special_tokens True --train_file data/dso_unlabelled_sample_$s.csv --max_seq_length 128 --output_dir outputs/xlmt_$s --overwrite_output_dir True --do_train --save_total_limit 2 --gradient_accumulation_steps 1 --num_train_epochs 1 --data_seed 123 --seed 123 --line_by_line True --per_device_train_batch_size 8 
	
	echo "Saving model to s3"
	rm -R -- outputs/xlmt_$s/*/
	python -m save_to_s3 --model_name xlmt_$s --model_folder outputs/xlmt_$s
	
	echo "Removing local model files"
	rm -rf outputs/xlmt_$s
done
