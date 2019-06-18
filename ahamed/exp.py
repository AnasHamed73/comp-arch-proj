from subprocess import Popen
from time import sleep

l1d_vals = ("16kB", "32kB", "64kB", "128kB", "256kB")   
l1i_vals = ("16kB", "32kB", "64kB", "128kB", "256kB") 
l2_vals = ("256kB", "512kB", "1MB", "2MB", "4MB") 
l1d_assoc_vals = ("1", "2", "4", "8", "16") 
l1i_assoc_vals = ("1", "2", "4", "8", "16")        
l2_assoc_vals = ("1", "2", "4", "8", "16")        
cache_blk_vals  = ("16", "32", "64", "256", "128")

all_vals = (l1d_vals, l1i_vals, l2_vals, l1d_assoc_vals, l1i_assoc_vals, l2_assoc_vals, cache_blk_vals)
list_ids = {0: "l1d_cache", 1: "l1i_cache", 2: "l2_cache", 3: "l1d_assoc", 4: "l1i_assoc", 5: "l2_assoc", 6: "blk_size"} 

indices = []
for i in range(len(all_vals)):
  indices.append(len(all_vals[i]) - 1)

for i in range(len(all_vals)):
  for j in range(len(all_vals[i])):
    Process=Popen('./exec_sim.sh %s %s %s %s %s %s %s %s %s' % (all_vals[0][indices[0]], all_vals[1][indices[1]],all_vals[2][indices[2]],all_vals[3][indices[3]], all_vals[4][indices[4]], all_vals[5][indices[5]], all_vals[6][indices[6]], list_ids[i], all_vals[i][indices[i]]), shell=True)
    Process.wait()
    indices[i] = indices[i] - 1
  indices[i] = len(all_vals[i]) - 1
