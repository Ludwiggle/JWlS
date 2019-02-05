# JWLS

A **J**upyter notebook for **W**olfram**L**anguage**S**cript

Designed to provide a responsive HTML interface to a remote WolframScript interpreter with minimal overhead on the bash_kernel. 


### Install

### Run

Run `JWLS.sh`


### Features

JWLS is a slimmed down version of the [`bash_kernel`](https://github.com/takluyver/bash_kernel) 
that transfer Wolfram Language expressions to a [WolframKernel](https://www.wolfram.com/cdf-player/) 
through the WolframScript interface. 

Graphics is rendered by the Jupyter file viewer, not by notebook.
`Show` returns the URL of the graphical output.


The `Out[..]` expressions are returned on both the Jupyter notebook and the terminal where JWLS is started; though error messages, symbols `Information` and progress indicators are printed on terminal only.

![](JWLSrec.gif)

The underlying `bash_kernel` is still accessible by starting a cell with `!`

![](bashCell.gif)




### How it works

The `JWLS.sh` script reads your `jupyter notebook list` to save the address of the **first** notebook found; that is needed by `Show`.  If Jupyter is not running, JWLS will start a new notebook. 

The WolframKernel is then initiated in REPL mode waiting for commands sent by the `kernel.py` through a temporary fifo.
By default, wolframscript appends ouputs to a temporary log file; JWLS simply pipes the latest ouputs from that file back to Jupyter. 

