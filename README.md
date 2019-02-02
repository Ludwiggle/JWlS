# JuWLS

A **Ju**pyter notebook for **W**o**L**fram**S**cript

### Features

Designed to provide a graphical REPL (with autocompletion) for WolframScript in absence of the Mathematica Front-End; very handy on cloud computing services.

JuWLS is a slimmed down version of the [`bash_kernel`](https://github.com/takluyver/bash_kernel) where two pipes comunicate with the [WolframKernel](https://www.wolfram.com/cdf-player/) through the WolframScript interface. 


The `Out[..]` expressions are returned on both the Jupyter notebook and the terminal where JuWLS is started; though error messages, symbols `Information` and progress indicators are printed only on terminal.

`Show` prints a clickable url that opens the Jupyter file viewer on a new browser tab (tested on Firefox).

![](JuWLSrec.gif)

The underlying `bash_kernel` is still accessible by starting a cell with `!`

![](bashCell.gif)


### Usage

Run `JuWLS.sh`

### How it works

The script will check `jupyter notebook list` and connect to the first in the list; if Jupyter is not running, JuWLS will start a new one. The WolframKernel is then initiated in REPL mode waiting for commands sent by the `bashWL_kernel.py` through a fifo.
By default, wolframscript appends ouputs on a temporary log file; JuWLS simply pipes the latest ouputs to Jupyter. 

