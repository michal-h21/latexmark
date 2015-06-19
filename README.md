# Introduction

This package enabled direct typesetting of markdown documents or code fragments
directly with LuaLaTeX. [lunamark](http://jgm.github.io/lunamark/) package 
is used for conversion. You can mix markdown constructs with LaTeX commands,
so you can enjoy simplicity of markdown combined with power of LaTeX.

# Install

Clone this repository to `tex/latex` directory in your local `texmf tree`. 
You can find `texmf`location (it is `~/texmf` usually) with this command:

    kpsewhich -var-value TEXMFHOME

install:

    cd `kpsewhich -var-value TEXMFHOME`
    mkdir -p tex/latex
    cd tex/latex
    git clone git@github.com:michal-h21/latexmark.git

# Usage

    \usepackage[options]{latexmarkdn}

## Possible options

extensions
: enable [lunamark extensions](http://jgm.github.io/lunamark/lunamark.1.html).
template
: use [Cosmo](http://cosmo.luaforge.net/) template. Useful when external markdown files are included.
document
: process whole document body. 

## Commands

     \begin{latexmark}
     # section

     some `markdown` *code*. But \LaTeX \texttt{commands} work too.
     \end{latexmark}

`latexmark` environment is processed for markdown instructions.

     \markdownfile{filename}

include a markdown file `filename`.

# Tips


- Text converted from markdown to \LaTeX\ is printed to the terminal, so you may  inspect possible conversion problem here.
- For conversion to html, use [make4ht](https://github.com/michal-h21/make4ht):


    make4ht -l filename

  note that `tex4ht` is used for the conversion and `fontspec` package 
  is unsupported


