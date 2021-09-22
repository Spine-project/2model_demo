Spine Toolbox two-models demo
=============================

Created by Erkka Rinne (erkka.rinne@vtt.fi) and Juha Kiviluoma (juha.kiviluoma@vtt.fi).

Requirements
------------

- Python 3.7
- [SpineToolbox](https://github.com/Spine-project/Spine-Toolbox/)
- [Julia 1.4 or later](https://julialang.org/downloads/)
- [GAMS version 24.1 or later](https://gams.com/download/)


Setting up
----------

1. Create a Python virtual environment using e.g. [conda](https://docs.conda.io/en/latest/miniconda.html)
    
    ```
    $ conda create -n spinetoolbox python=3.8
    $ conda activate spinetoolbox
    ```

2. Browse to the dir where you downloaded Spine Toolbox and install it:

    ```
    (spinetoolbox) $ pip install -r requirements.txt
    ```

3. Browse to dir *MyJuliaModel* in this project and initialize the Julia project

    ```
    MyJuliaModel (spinetoolbox) $ julia init.jl
    ```

4. Launch Spine Toolbox:

    > NOTE: Currently, Spine Toolbox has to be launched *from the Julia 
    > project directory*, in this case *MyJuliaModel/*.
    ```
    MyJuliaModel (spinetoolbox) $ spinetoolbox
    ```

5. In Spine Toolbox settings, select dir *MyJuliaModel* as the Julia project on **Tools** page.

6. In Spine Toolbox settings, select GAMS executable on **Tools** page. If you don't have GAMS, you can request a demo license or skip that part of the Toolbox workflow (https://www.gams.com/download/). GAMS version used for the demo is 24.1 (hopefully works with newer versions - it's very simple).
