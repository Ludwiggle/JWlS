# JWLS

A **J**upyter notebook for **W**olfram(**L**anguage)**S**cript.

The goal of **JWLS** is to *extend* the wolframscript cli with a HTML-based REPL interface.


### Features

* Autocompletion of WL Symbols
* WL syntax highlighting
* "!command" runs Bash commands
* Vector graphics outputs displayed by the Jupyter file viewer
* 3D and Dynamic displayed by `wolframplayer`
* It works also on older versions of CDFPlayer


### Installation

Assuming `miniconda` (Python 3.7) installed

1. Copy the kernel folder `JWLS_kernel` into your python installation folder e.g. `~/miniconda3/lib/python3.7/site-packages/ 
2. Run the installation script  `python install.py` (it's in the kernel folder)

3. Modify the path of `Names.wl.txt` in `kernel.py` because it requires the full path instead of `~` .
Check also if `JWLS.sh` points the actual `wolframscript` executable.

### Usage

Run `JWLS.sh` or copy it in the executables path e.g. ` cp JWLS.sh /usr/local/bin/JWLS` .

In order to use it on a cloud compute virtual machine, modify the `nbAddrF` function by adding `jupyter notebook --no-browser --port=7000` . Then `screen` a session run `JWLS` and detach it. Go back to your local machine and   `ssh -N -f -L  localhost:6001:localhost:7000  <IP>"`.
For AWS instances also add the pem. For Google Cloud follow their instructions. 

### Possible issues and Troubleshooting

On MacOs, if `sed` gives error substitute it with `gsed`; see this [discussion]
If your system is generally slow and `JWLS.sh` opens more than one jupyter-notebook server, you might want to increase the `Pause` timing in the `nbAddrF` function which is reponsible for that. 


### How it works

**JWLS** is a slimmed down version of the Jupyter [`bash_kernel`](https://github.com/takluyver/bash_kernel) 
that pipes input cells into a [wolframscript](https://www.wolfram.com/wolframscript/) `Dialog[]` 
through a temporary fifo, and it reads the corresponding outputs from
the default wolframscript log file. 

The `JWLS.sh` script reads your `jupyter notebook list` to save the address of the **first** notebook found; that is needed by `show`.  If Jupyter is not running, JWLS will start a new notebook. 

The custom `show` function returns the clickable URL of the exported graphical output. In this way, graphics is rendered by the Jupyter file viewer in a new browser tab, not within the notebook.
Any epression or graphics that is not an `Image` is exported as a pdf (quickest export time and very accurate), otherwise it exports a png. 
`show` exports 3D graphics or `Dynamic` stuff like `Manipulate` as notebooks to be open with the `wolframplayer` which gets installed with [Wolfram Engine](https://www.wolfram.com/engine/) and it can be found on`../WolframEngine/12.0/Executables/wolframplayer`. Be sure to have it in your `PATH`.

The `Out[..]` expressions are returned on both the Jupyter notebook and the terminal 
where JWLS is started.
On Wolfram Kernels prior to V12,  error messages, `Information` and progress indicators are printed on terminal only.
With the new Wolfram Engine (for developers) errors and `Information` are given back to the standard ouput but still, progress indicators or incremental ouputs like `Do[ Print@"hello"; Pause@1, 3 ]` returns only at the end of the execution; keep an eye on the terminal for those. 

