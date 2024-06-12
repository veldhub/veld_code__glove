#!/bin/bash

# this script is a slimmed down and adapted version of the original demo.sh script in the GloVe repo

in_corpus_file="/veld/input/${in_corpus_file}"
out_vocab_file="/veld/output/${out_vocab_file}"
out_cooccurrence_file="/veld/output/${out_cooccurrence_file}"
out_cooccurrence_shuf_file="${out_cooccurrence_shuf_file}"
out_vector_file="${out_vector_file}"

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

