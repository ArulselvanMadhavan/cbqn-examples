
# Table of Contents

1.  [Install setup](#org34f7a5d)
2.  [Run BQN](#orgb5c2808)
3.  [Demo](#orgbe66c10)
4.  [Numpy serialization](#org51ed815)


<a id="org34f7a5d"></a>

# Install setup

    #!/bin/bash
    git clone git@github.com:dzaima/CBQN.git
    cd CBQN/
    make clean
    make o3n CC=clang CXX=clang++ FFI=0


<a id="orgb5c2808"></a>

# Run BQN

    <path_to_cbqn_binary> hyperx_raylib.bqn


<a id="orgbe66c10"></a>

# Demo

[![Watch the video](![img](https://raw.githubusercontent.com/ArulselvanMadhavan/cclviz/main/media/all_reduce_thumbnail.png))](<https://raw.githubusercontent.com/ArulselvanMadhavan/cclviz/main/media/all_reduce_viz_4x5.mov>)


<a id="org51ed815"></a>

# Numpy serialization

-   BQN array to numpy serialization code was taken verbatim from <https://github.com/dlozeve/bqn-npy/tree/main>

