#!/usr/bin/env python
import fire
from plotlib import *
import numpy as np

class PLT(object):
    def cudabench(self, tp='png'):
        upper = [21, 21, 19]
        filenames = ["cpu_nobatch.dat", "cuda_nobatch.dat", "cuda_batch.dat"]
        with DataPlt(filename="cudabench.%s"%tp) as dp:
            for up, fn in zip(upper, filenames):
                x = np.arange(4,up)
                y = np.loadtxt(fn)
                iscpu = fn[:3] == 'cpu'
                ls = '--' if iscpu else '-'
                nbatch = 1000 if up==19 else 1
                color = 'k' if nbatch == 1 else 'r'
                plt.plot(x,y/nbatch, color=color, ls=ls)
            plt.legend(["CPU", "GPU", "GPU-batched"])
            plt.xlabel("$N$")
            plt.ylabel(r"time")
            plt.yscale("log")
            plt.tight_layout()

fire.Fire(PLT)
