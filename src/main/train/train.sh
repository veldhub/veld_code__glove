#!/bin/bash

# this script is a slimmed down and adapted version of the original demo.sh script in the GloVe repo

in_corpus_file="/veld/input/${in_corpus_file}"
out_vocab_file="/veld/output/${out_vocab_file}"
out_cooccurrence_file="/veld/output/${out_cooccurrence_file}"
out_cooccurrence_shuf_file="${out_cooccurrence_shuf_file}"
out_vector_file="${out_vector_file}"

echo "in_corpus: ${in_corpus}"
echo "out_vocab_file: ${out_vocab_file}"
echo "out_cooccurrence_file: ${out_cooccurrence_file}"
echo "out_cooccurrence_shuf_file: ${out_cooccurrence_shuf_file}"
echo "out_vector_file: ${out_vector_file}"
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

echo
echo "$ /opt/glove/build/vocab_count -min-count $vocab_min_count -verbose $verbose < $in_corpus_file > $out_vocab_file"
/opt/glove/build/vocab_count -min-count $vocab_min_count -verbose $verbose < $in_corpus_file > $out_vocab_file

echo "$ /opt/glove/build/cooccur -memory $memory -vocab-file $out_vocab_file -verbose $verbose -window-size $window_size < $in_corpus_file > $out_cooccurrence_file"
/opt/glove/build/cooccur -memory $memory -vocab-file $out_vocab_file -verbose $verbose -window-size $window_size < $in_corpus_file > $out_cooccurrence_file

echo "$ /opt/glove/build/shuffle -memory $memory -verbose $verbose < $out_cooccurrence_file > $out_cooccurrence_shuf_file"
/opt/glove/build/shuffle -memory $memory -verbose $verbose < $out_cooccurrence_file > $out_cooccurrence_shuf_file

echo "$ /opt/glove/build/glove -save-file $out_vector_file -threads $num_threads -input-file $out_cooccurrence_shuf_file -x-max $x_max -iter $max_iter -vector-size $vector_size -binary $binary -vocab-file $out_vocab_file -verbose $verbose"
/opt/glove/build/glove -save-file $out_vector_file -threads $num_threads -input-file $out_cooccurrence_shuf_file -x-max $x_max -iter $max_iter -vector-size $vector_size -binary $binary -vocab-file $out_vocab_file -verbose $verbose

