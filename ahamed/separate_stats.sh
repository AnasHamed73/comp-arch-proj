#!/bin/bash

##### CONSTANTS

BENCHMARKS="/home/csgrad/ahamed/bin/benchmarks"
EXTR_DIR="/home/csgrad/ahamed/bin/sims/extracted"

##### FUNCTIONS

separate() { 
  sim_file="${EXTR_DIR}/${2}_stats/${2}_sim_${1}_extr" 
  tags=(l1_dcache_miss_rate l1_dcache_hit_rate l1_icache_miss_rate l1_icache_hit_rate l2_miss_rate l2_cache_hit_rate cpi)
  for tag in ${tags[*]}; do
    output_file="${EXTR_DIR}/${1}/${tag}_${2}"
    matches=$(grep "${tag}" "$sim_file")
    echo "$sim_file ------ $matches" >> $output_file
  done
}

##### MAIN

cd "$EXTR_DIR"

params=(blk_size l1d_cache l1i_cache l2_cache l1d_assoc l1i_assoc l2_assoc)

for param in ${params[*]}; do
  [ -d $param ] || mkdir $param 
  for bench in $(cat $BENCHMARKS); do
    separate "$param" "${bench}"
  done
done

