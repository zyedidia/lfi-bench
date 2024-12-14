#!/bin/bash

sudo cset shield -c 5 -k on
sudo cset shield -e sudo -- -u "$USER" env "PATH=$PATH" bash
sudo cset shield -c 5 -k off
