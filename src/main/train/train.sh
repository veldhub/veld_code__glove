#!/bin/bash

# this script is a slimmed down and adapted version of the original demo.sh script in the GloVe repo

in_corpus_path="/veld/input/${in_corpus_file}"
out_vocab_path="/veld/output/${out_vocab_file}"
out_cooccurrence_path="/veld/output/${out_cooccurrence_file}"
out_cooccurrence_shuf_path="/veld/output/${out_cooccurrence_shuf_file}"
out_vector_path="/veld/output/${out_vector_file}"

echo "in_corpus_path: ${in_corpus_path}"
echo "out_vocab_path: ${out_vocab_path}"
echo "out_cooccurrence_path: ${out_cooccurrence_path}"
echo "out_cooccurrence_shuf_path: ${out_cooccurrence_shuf_path}"
echo "out_vector_path: ${out_vector_path}"
echo "verbose: ${verbose}"
echo "memory: ${memory}"
echo "vocab_min_count: ${vocab_min_count}"
echo "vector_size: ${vector_size}"
echo "max_iter: ${max_iter}"
echo "window_size: ${window_size}"
echo "binary: ${binary}"
echo "num_threads: ${num_threads}"
echo "x_max: ${x_max}"

set -e

echo "begin training."
start_time=$(date +%s)

echo "$ /opt/glove/build/vocab_count -min-count $vocab_min_count -verbose $verbose < $in_corpus_path > $out_vocab_path"
/opt/glove/build/vocab_count -min-count $vocab_min_count -verbose $verbose < $in_corpus_path > $out_vocab_path

echo "$ /opt/glove/build/cooccur -memory $memory -vocab-file $out_vocab_path -verbose $verbose -window-size $window_size < $in_corpus_path > $out_cooccurrence_path"
/opt/glove/build/cooccur -memory $memory -vocab-file $out_vocab_path -verbose $verbose -window-size $window_size < $in_corpus_path > $out_cooccurrence_path

echo "$ /opt/glove/build/shuffle -memory $memory -verbose $verbose < $out_cooccurrence_path > $out_cooccurrence_shuf_path"
/opt/glove/build/shuffle -memory $memory -verbose $verbose < $out_cooccurrence_path > $out_cooccurrence_shuf_path

echo "$ /opt/glove/build/glove -save-file $out_vector_path -threads $num_threads -input-file $out_cooccurrence_shuf_path -x-max $x_max -iter $max_iter -vector-size $vector_size -binary $binary -vocab-file $out_vocab_path -verbose $verbose"
/opt/glove/build/glove -save-file $out_vector_path -threads $num_threads -input-file $out_cooccurrence_shuf_path -x-max $x_max -iter $max_iter -vector-size $vector_size -binary $binary -vocab-file $out_vocab_path -verbose $verbose

end_time=$(date +%s)
DURATION=$(echo "scale=2; $(( end_time - start_time )) / 60" | bc)

echo "done with training. Duration in minutes: ${DURATION}" 

export DURATION
python3 /veld/code/write_veld_data.py

