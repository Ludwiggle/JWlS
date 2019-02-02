# JWLS

A **J**upyter notebook for **W**o**L**fram**S**cript

### Features

Designed to provide a graphical REPL for WolframScript in absence of the Mathematica Front-End; very handy on cloud computing services.

JWLS is basically a slimmed down version of the [`bash_kernel`](https://github.com/takluyver/bash_kernel) where two pipes comunicate with the [WolframKernel](https://www.wolfram.com/cdf-player/) through the WolframScript interface. 

The outputs are printed both on the Jupyter notebook and on the terminal where JWLS is started; though error messages, symbols `Information` and progress indicators are printed only on terminal. 

A custom `Show` prints a clickable url that opens Jupyter file viewer to display vector graphics and HR images in separated browser tabs (tested on Firefox).

If you prefer to view low-res rasters within the notebook, check [iWolfram](https://github.com/mmatera/iwolfram) or this ["official"](https://github.com/WolframResearch/WolframLanguageForJupyter) release. These two implementations are way more complex and less rialable insofar they do not support all possible input syntax. The "official" one cannot be installed without a full Mathematica installation. 

### Usage

Run `jwls.sh`

The script will check `jupyter notebook list` and connect to the first notebook found. If Jupyter is not running, it will open a new one.
