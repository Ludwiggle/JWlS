# JWlS

A **J**upyter notebook for **W**o**l**fram**S**cript

### Features

Designed to provide a graphical REPL (with autocompletion) for WolframScript in absence of the Mathematica Front-End; very handy on cloud computing services.

JWlS is a slimmed down version of the [`bash_kernel`](https://github.com/takluyver/bash_kernel) where two pipes comunicate with the [WolframKernel](https://www.wolfram.com/cdf-player/) through the WolframScript interface. 


The `Out[..]` expressions are returned on both the Jupyter notebook and the terminal where JWlS is started; though error messages, symbols `Information` and progress indicators are printed on terminal only.

`Show` prints a clickable URL that opens the Jupyter file viewer on a new browser tab (tested on Firefox).

![](JWlSrec.gif)

The underlying `bash_kernel` is still accessible by starting a cell with `!`

![](bashCell.gif)


### Usage

Run `JWlS.sh`

### How it works

The `JWlS.sh` script first reads `jupyter notebook list` and connect to the first available; if Jupyter is not running, JWlS will start a new notebook. The WolframKernel is then initiated in REPL mode waiting for commands sent by the `bashWL_kernel.py` through a fifo.
By default, wolframscript would append ouputs on a temporary log file; JWlS simply pipes the latest ouputs from that file back to Jupyter. 

