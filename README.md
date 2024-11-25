
# Table of Contents

1.  [About the project](#orgca6e345)
2.  [Install setup](#org9832860)
3.  [Run BQN](#org439b1f5)
4.  [Demo](#orgc78c296)
5.  [Numpy serialization](#org74eee53)


<a id="orgca6e345"></a>

# About the project

This project aims to visualize data movement involved in communication collectives.
As a first step, it shows how an all-reduce algorithm might work in a 2D HyperX topology


<a id="org9832860"></a>

# Install setup

    #!/bin/bash
    git clone git@github.com:dzaima/CBQN.git
    cd CBQN/
    make clean
    make o3n CC=clang CXX=clang++ FFI=0


<a id="org439b1f5"></a>

# Run BQN

    <path_to_cbqn_binary> hyperx_raylib.bqn


<a id="orgc78c296"></a>

# Demo

![img](./media/output.gif "Watch demo of all-reduce in a 2D hyperX")


<a id="org74eee53"></a>

# Numpy serialization

-   BQN array to numpy serialization code was taken verbatim from <https://github.com/dlozeve/bqn-npy/tree/main>

