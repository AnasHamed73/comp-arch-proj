#!/bin/bash

##### CONSTANTS

SIM_OUTPUT_DIR="/home/csgrad/ahamed/bin/sims"
GEM_HOME="/util/gem5"
BM_HOME="$GEM_HOME/benchmark"

# list of benchmarks to be used
BENCHMARKS="/home/csgrad/ahamed/bin/benchmarks"

OUTPUT_DIR="${SIM_OUTPUT_DIR}/sim_${VAR_PARAM_NAME}_${VAR_PARAM_VAL}"

L1D_SIZE="$1"   
L1I_SIZE="$2"   
L2_SIZE="$3"    
L1D_ASSOC="$4"  
L1I_ASSOC="$5"  
L2_ASSOC="$6"   
CACHE_BLOCK_SIZE="$7"

# name of the parameter that is being varied
VAR_PARAM_NAME="$8"

# value of the parameter that is being varied
VAR_PARAM_VAL="$9"

MAX_INSTRUCTIONS=100000000

##### FUNCTIONS

exec_single_sim() {
  time build/X86/gem5.opt -d "$2" configs/example/se.py -I "$MAX_INSTRUCTIONS" -c "$1" -o "$4" --caches --l2cache --l1d_size="$L1D_SIZE"  --l1i_size="$L1I_SIZE"  --l2_size="$L2_SIZE" --l1d_assoc="$L1D_ASSOC" --l1i_assoc="$L1I_ASSOC" --l2_assoc="$L2_ASSOC" --cacheline_size="$CACHE_BLOCK_SIZE" &> "$3" 
}
 
exec_bench() {
  cd "$GEM_HOME"
  exec_single_sim $BM_HOME/"$1"/src/benchmark "$2" "${2}/${1}.log" "$3"
  mv "${2}"/stats.txt "${2}"/stats_"${1}".txt
  mv "${2}"/config.ini "${2}"/config_"${1}".ini
}

##### MAIN

mkdir "$OUTPUT_DIR"

exec_bench "401.bzip2" "$OUTPUT_DIR" "${BM_HOME}/401.bzip2/data/input.program"
exec_bench "429.mcf" "$OUTPUT_DIR" "${BM_HOME}/429.mcf/data/inp.in"
exec_bench "458.sjeng" "$OUTPUT_DIR" "${BM_HOME}/458.sjeng/data/test.txt"
exec_bench "470.lbm" "$OUTPUT_DIR" " 20 reference.dat 0 1 ${BM_HOME}/470.lbm/data/100_100_130_cf_a.of "
exec_bench "456.hmmer" "$OUTPUT_DIR" " --fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 ${BM_HOME}/456.hmmer/data/bombesin.hmm.new "

