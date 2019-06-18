import matplotlib.gridspec as gridspec
import matplotlib.pyplot as plt

EXTR_DIR = "/home/kikuchio/Documents/courses/computer-architecture/assignment-2/bin/sims/extracted"
BENCHMARKS_FILE = "/home/kikuchio/Documents/courses/computer-architecture/assignment-2/bin/benchmarks"

def graph(metrics, var, cases, x_axis, bm_legend, fig_name):
  colors = ["r", "g", "b", "y", "c"]
  color_ind = 0
  metric_ind = 0
  rows =  (len(metrics) / 3)
  if (len(metrics) % 3) != 0:
      rows += 1
  gs = gridspec.GridSpec(rows, 3)
  plt.figure()
  
  for metric in metrics:
    ax = plt.subplot(gs[metric_ind / 3, metric_ind % 3])
    plt.xlabel(x_axis)
    plt.ylabel(metric)
    for b in bm_legend:
      record = EXTR_DIR + "/" + var + "/" + metric + "_" + b.rstrip() 
      f = open(record, "r")
      vals = [] 
      for line in f:
        vals.append(float(line))
      vals.reverse()
      if var is "blk_size":
          temp = vals[-2]
          vals[-2] = vals[-1]
          vals[-1] = temp
      plt.plot(cases, vals, colors[color_ind])
      plt.xticks(cases, cases)
      plt.legend(bm_legend)
      color_ind = (color_ind + 1) % len(colors)
      
    metric_ind = metric_ind + 1
   
  plt.savefig(fig_name)
  plt.show()

##### MAIN

bm_legend = []
benchmarks = open(BENCHMARKS_FILE, "r")
for b in benchmarks:
  bm_legend.append(b.rstrip())

metrics = ["cpi", "l1_dcache_hit_rate", "l1_dcache_miss_rate", "l1_icache_hit_rate", "l1_icache_miss_rate", "l2_cache_hit_rate", "l2_miss_rate"]
 
# l1 data cache size 
var = "l1d_cache"
cases = [16, 32, 64, 128, 256] 
x_axis = "Size (KB)"
graph(metrics, var, cases, x_axis, bm_legend,"l1d_size.png")

# l1 instruction cache size 
var = "l1i_cache"
cases = [16, 32, 64, 128, 256] 
x_axis = "Size (KB)"
graph(metrics, var, cases, x_axis, bm_legend,"l1i_size.png")

# l2 cache size
var = "l2_cache"
cases = [256, 512, 1024, 2048, 4096] 
x_axis = "Size (KB)"
graph(metrics, var, cases, x_axis, bm_legend,"l2_size.png")

# l1 data cache associativity
var = "l1d_assoc"
cases = [1, 2, 4, 8, 16] 
x_axis = "Associativity"
graph(metrics, var, cases, x_axis, bm_legend,"l1d_assoc.png")


# l1 instruction cache associativity
var = "l1i_assoc"
cases = [1, 2, 4, 8, 16] 
x_axis = "Associativity"
graph(metrics, var, cases, x_axis, bm_legend,"l1i_assoc.png")

# l2 cache associativity
var = "l2_assoc"
cases = [1, 2, 4, 8, 16] 
x_axis = "Associativity"
graph(metrics, var, cases, x_axis, bm_legend,"l2_assoc.png")

# Cache block size
var = "blk_size"
cases = [16, 32, 64, 128, 256] 
x_axis = "Block Size (B)"
graph(metrics, var, cases, x_axis, bm_legend,"blk_size.png")

