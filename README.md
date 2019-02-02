# JWLS

A **J**upyter notebook for **W**o**L**fram**S**cript

### Features

Designed to provide a graphical REPL (with autocompletion) for WolframScript in absence of the Mathematica Front-End; very handy on cloud computing services.

JWLS is a slimmed down version of the [`bash_kernel`](https://github.com/takluyver/bash_kernel) where two pipes comunicate with the [WolframKernel](https://www.wolfram.com/cdf-player/) through the WolframScript interface. 

The `Out[..]` expressions are returned both on the Jupyter notebook and on the terminal where JWLS is started; though error messages, symbols `Information` and progress indicators are printed only on terminal.

`Show` prints a clickable url that opens the Jupyter file viewer on a new browser tab (tested on Firefox).

![](JWLSrec.gif)

### Usage

Run `jwls.sh`

The script will check `jupyter notebook list` and connect to the first notebook found. If Jupyter is not running, it will open a Jupyter session.


### Comparison to 
