#!/bin/bash

#### CONSTANTS

BENCHMARKS="/home/csgrad/ahamed/bin/benchmarks"
BM_OUTPUT_DIR="/home/csgrad/ahamed/bin/sims"
EXTR_DIR="${BM_OUTPUT_DIR}/extracted"

#### FUNCTIONS 

find_and_append() {
  match=$(grep -r "$1" ${2} | tr -s ' ' | cut -f2 -d ' ')
  echo "$3 $match" >> "$4"
}

complement_and_append() {
  miss=$(grep -r "${1}" ${3} | tr -s ' ' | cut -f2 -d ' ')
  hit=$(python -c "print(1 - ${miss})")
  echo "${2} ${hit}" >> "$4"
}

find_and_append_hit_rates() {
  complement_and_append "system.l2.overall_miss_rate::total" "l2_cache_hit_rate" "${1}" "${2}"
  complement_and_append "system.cpu.dcache.overall_miss_rate::total" "l1_dcache_hit_rate" "${1}" "${2}"
  complement_and_append "system.cpu.icache.overall_miss_rate::total" "l1_icache_hit_rate" "${1}" "${2}"
}

calc_and_append_cpi() {
  l1_icache_miss=$(grep -r "system.cpu.icache.overall_misses::total" ${2} | tr -s ' ' | cut -f2 -d ' ')
  l1_dcache_miss=$(grep -r "system.cpu.dcache.overall_misses::total" ${2} | tr -s ' ' | cut -f2 -d ' ')
  l2_cache_miss=$(grep -r "system.l2.overall_misses::total" ${2} | tr -s ' ' | cut -f2 -d ' ')
  insts=$(grep -r "sim_insts" ${2} | tr -s ' ' | cut -f2 -d ' ')
  cpi=$(python -c "print(1 + ((${l1_icache_miss} + ${l1_dcache_miss})*6 + ${l2_cache_miss}*50)/${insts})")
  echo "$1: ${cpi}" >> "$3"
}

extract() {
  cd $BM_OUTPUT_DIR
  var="$1"
  for bench in $(cat $BENCHMARKS); do
    for s in $(find . -name "${var}*"); do
      sim=${s//.\//}
      stats="${sim}/stats_${bench}.txt" 
      file="$EXTR_DIR/${bench}_${var}_extr"

      echo "${sim}" >> $file
      find_and_append "system.l2.overall_miss_rate::total" ${stats} "l2_miss_rate" "$file"
      find_and_append "system.l2.overall_misses::total" ${stats} "l2_misses_num" "$file"
      find_and_append "system.cpu.dcache.overall_hits::total" ${stats} "l1_dcache_hits" "$file"
      find_and_append "system.cpu.dcache.overall_misses::total" ${stats} "l1_dcache_misses" "$file"
      find_and_append "system.cpu.dcache.overall_miss_rate::total" ${stats} "l1_dcache_miss_rate" "$file"
      find_and_append "system.cpu.icache.overall_hits::total " ${stats} "l1_icache_hits" "$file"
      find_and_append "system.cpu.icache.overall_miss_rate::total" ${stats} "l1_icache_miss_rate" "$file"
      find_and_append "system.cpu.icache.overall_misses::total" ${stats} "l1_icache_miss_num" "$file"
      find_and_append "sim_insts" "${stats}" "number_of_instructions" "$file"
      find_and_append_hit_rates "${stats}" "${file}"
      calc_and_append_cpi "cpi" "${stats}" "${file}"
      echo "" >> "$file"
    done
  done
}

collect() {
  cd $EXTR_DIR
  for bench in $(cat $BENCHMARKS); do
    file="${bench}_stats"
    mkdir ${file} 
    for f in $(find . -type f -name "${bench}*"); do
      mv $f $file 
    done
  done
}

##### MAIN 

mkdir "$EXTR_DIR"

extract "sim_blk_size"
extract "sim_l1d_assoc"
extract "sim_l1d_cache"
extract "sim_l1i_assoc" 
extract "sim_l1i_cache"
extract "sim_l2_cache"
extract "sim_l2_assoc" 

collect

