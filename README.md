# BioHackathon2020
## Copenhagen Bioinformatics Hackathon 2020

## Overview

## Prerequisites
Python 3.7

## Installation
1. Install direnv:
    * run `brew install direnv (macOS)`
    * run `sudo apt-get install direnv (linux)`
2. Install venv (inspired by https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/):
    * run `sudo apt-get install python3-venv`
3. Setup of .bash_profile and .config/direnv (inspired by https://github.com/direnv/direnv/wiki/Python):
    * run `cat direnv_allow.txt >> ~/.bashrc; echo "export PATH=$PATH:local/bin" > "./.envrc"`
    * run `cat venv_allow.txt >> ~/.bashrc; echo "layout python-venv python3.7"  >> "./.envrc"`
    * run `cat direnvrc_config.txt > ~/.config/direnv/direnvrc`
    * run `source ~/.bashrc; direnv allow ./`
4. Install python packages:
    * run `pip install -r requirements.txt`

## Key files

## References
