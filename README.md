Spine Toolbox two-models demo for EMP-E
=========================

Created by Erkka Rinne (erkka.rinne@vtt.fi) and Juha Kiviluoma (juha.kiviluoma@vtt.fi).

Requirements
------------

- Python 3.7
- [SpineToolbox 0.5](https://github.com/Spine-project/Spine-Toolbox/tree/release-0.5)
- [Julia 1.4 or later](https://julialang.org/downloads/)
- [GAMS version 24.1 or later](https://gams.com/download/)


Setting up
----------

1. Create a Python virtual environment using e.g. [conda](https://docs.conda.io/en/latest/miniconda.html)
    
    ```
    $ conda create -n spinetoolbox-0.5 python=3.7
    $ conda activate spinetoolbox-0.5
    ```

2. Browse to the dir where you downloaded Spine Toolbox v0.5 and install it:

    ```
    (spinetoolbox-0.5) $ pip install -r requirements.txt
    ```

3. Browse to dir *MyJuliaModel* in this project and initialize the Julia project

    ```
    MyJuliaModel (spinetoolbox-0.5) $ julia init.jl
    ```

4. Launch Spine Toolbox:

    > NOTE: Currently, Spine Toolbox has to be launched *from the Julia 
    > project directory*, in this case *MyJuliaModel/*.
    ```
    MyJuliaModel (spinetoolbox-0.5) $ spinetoolbox
    ```

5. In Spine Toolbox settings, select dir *MyJuliaModel* as the Julia project on **Tools** page.
