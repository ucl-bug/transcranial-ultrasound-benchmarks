# Benchmark problems for transcranial ultrasound simulation: Intercomparison library

[![License: LGPL v3](https://camo.githubusercontent.com/a68e3691793655c52b2d207c94ea538cfcdf9a4cf081c27b6e55ea0e4b27b936/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4c6963656e73652d4c47504c25323076332d626c75652e737667)](https://www.gnu.org/licenses/lgpl-3.0) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6020543.svg)](https://doi.org/10.5281/zenodo.6020543) [![arXiv](https://img.shields.io/badge/arXiv-2202.04552-b31b1b.svg)](https://arxiv.org/abs/2202.04552)

## Author

This library is written by Bradley Treeby, University College London. Contact: [b.treeby@ucl.ac.uk](mailto:b.treeby@ucl.ac.uk)

## Overview

This repository provides the MATLAB functions and scripts used for comparing model results for the benchmarks outlined [here](https://arxiv.org/abs/2202.04552).

## Quick start guide

1. Download the intercomparison data files from [Zenodo](https://doi.org/10.5281/zenodo.6020543) and unzip.
2. Clone or download this code repository.
3. Open MATLAB, and navigate to the code repository folder.
4. Run `processAll` to generate the paper figures and supplementary materials (this may take some time, particularly to run `computeAllMetrics`).
5. Run `compareTwo` to compare two models for a specified benchmark and source. For example, to compare `KWAVE` and `STRIDE` for benchmark 7 for the bowl source, run:

```matlab
metrics = compareTwo('KWAVE', 'STRIDE', 7, 1, 'C:\DATA', true);
```

## Using the skull models

This repository also hosts the `.stl` files for the skull models used for benchmarks 7 to 9, along with the affine transforms to position the transducer in the coordinate system of the `.stl` file. To rasterize the `.stl` files to a regular Cartesian mesh with a paricular grid resolution, use `rasterizeSkullMeshes`. This function requires the [iso2mesh toolbox](http://iso2mesh.sourceforge.net/cgi-bin/index.cgi). Note, for higher-resolution grids, this function requires significant computer memory. Pre-computed meshes are available in the `SKULL-MAPS` folder in the data repository stored in Zenodo (see above). Note, the rasterized meshes already incorporate the affine transforms to move the skull relative to the transducer. 

## Adding new model results

To add new model results:
1. Decide on a name for the model, e.g., `NEWMODEL` and add this to the list `intercomparison/getModelNames`.
1. Create a `NEWMODEL` folder in the downloaded results (see above). Add the model results to this folder following the naming convention, e.g., `PH1-BM1-SC1-NEWMODEL.mat`.
1. To compare results for one benchmark, call `compareTwo` as outlined above. 
1. To re-generate the intercomparison results with the new model, run `processAll`.

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.





