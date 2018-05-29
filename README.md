# uniQC - Unified NeuroImaging Quality Control toolbox

## Overview

The challenge of unified and comprehensive quality control (QC) in (functional) MRI results from the vast amount of artefact sources combined with the complex processing pipelines applied to the data. Beyond standard image quality measures, MRI sequence development is often in need of flexible diagnostic tools to test diverse hypotheses on artefact origin, such as hardware fluctuations, k-space spikes, or subject movement. These tests are usually performed in a sequential order, where one outcome informs the next evaluation. This necessitates fast switching between mathematical image operations and interactive display of multi-dimensional data to assess image properties from a range of different perspectives. Additionally, for complex image analysis pipelines, as employed, e.g., in fMRI, direct access to the standard analysis packages is required to ultimately evaluate functional sensitivity of new sequence prototypes. Here, we present the uniQC toolbox that provides seamless combination of algebraic matrix operations, image processing, visualisation options and data provenance in an intuitive, object-oriented framework using MATLAB, and interfacing SPM for all fMRI-related pre-processsing and statistical analysis steps. Therein, processing of 4D image time series data is generalised to an arbitrary number of dimensions to handle data from multiple receiver coils, multi-echo or phase fMRI data in a unified framework along with classical statistical analysis and powerful visualisation options.

## Installation

Download the current version of [SPM](http://www.fil.ion.ucl.ac.uk/spm/software/) and add the code directory to you MATLAB path. Then clone or download the uniQC repository and **recursively** add this to your MATLAB path as well. Type `I = MrImage` to test your setup.

## Getting started

A thorough description of uniQC can be found [here](https://cloudstor.aarnet.edu.au/plus/s/59cJjfB9QI0Akxp).

The best starting point are the demo scripts contained in demo/[MrClassName]. Details to each demo are given below.

The example data can be found [here](https://cloudstor.aarnet.edu.au/plus/s/kmw6b1Ts4NrNqxp). Please put the data directory at the same level as the code, demo and test directory.

## Demos

### MrImage
`MrImage/demo_add_overlay.m`: Illustrates how to use plot with overlayImages and compares it to an implementation using native MATLAB code.

`MrImage/demo_constructor.m`: Illustrates how MrImage objects can be created from nifti files, folders and Philips par/rec files.

`MrImage/demo_coregister.m`: Illustrates how to coregister a structural to a functional image and the difference between changing (only) the geometry and reslicing the coregistered image.

`MrImage/demo_image_math_imcalc_fslmaths.m`: Illustrates how to estimate image properties and compare different images.

`MrImage/demo_multi_echo_realign.m`: Illustrates the syntax to extend SPM pre-processing options to n-dimensional data.

`MrImage/demo_plot_images.m`: Illustrates the versatile plot options; see also section Visualisation tools.

`MrImage/demo_roi_analysis.m`: Template for a fast analysis of regions-of-interest defined using tissue masks and manually drawn masks, which can be saved and, thereby, enhance the documentation of the performed analysis.

`MrImage/demo_spikes.m`: Illustrates the performance of different visualisation options such as mean and tSNR images and dynamic displays to identify k-space spikes.

`MrImage/demo_split_complex.m`: Illustrates how complex data are automatically split and combined to perform SPM pre-processing operations.

### MrSeries
`MrSeries/demo_fmri_qa.m`: Illustrates how to combine different visualisations and image operations to inspect an fMRI time series.

`MrSeries/demo_model_estimation_1st_level.m`: Illustrates how to specify a 1st level model using MrGlm and estimating its parameters using the classical restricted maximum Likelihood approach within SPM (Kiebel and Holmes, 2007). Note that it requires the output of MrSeries/demo_preprocessing.

`MrSeries/demo_model_estimation_1st_level_Bayesian.m`: Illustrates how to estimate the same model as in MrSeries/demo_model_estimation_1st_level using a Variational Bayesian framework (Penny et al., 2003). Note that it requires the output of MrSeries/demo_model_estimation_1st_level and MrSeries/demo_preprocessing.

`MrSeries/demo_preprocessing.m`: Example pre-processing script for fMRI data. Illustrates how MrSeries automatically updates data and populates appropriate properties such as mean, snr, sd images, tissue probability maps and masks.

`MrSeries/demo_snr_analysis_mrseries.m`: Example of a tSNR assessment in different ROIS illustrating the impact of different pre-processing steps on tSNR in grey matter.

### MrDimInfo
`MrDimInfo/demo_dim_info.m`: The MrDimInfo class implements data selection and access used in plots and computations. The demo covers the creation of dimInfo objects, retrieving parameters via get_dims and dimInfo.dimLabel, adding/setting dimensions, retrieving array indices and sampling points, selecting a subset of dimensions and creating dimInfos from files. Note that dimInfo does not know about the affineGeometry, i.e. all sampling points are with reference to the data matrix.

### MrAffineGeometry
`MrAffineGeometry/demo_affine_geometry.m`: Exemplifies creating of an MrAffineGeometry object using a nifti file, a Philips par/rec file, prop/val pairs or an affine transformation matrix.

### MrImageGeometry
`MrImageGeometry/demo_image_geometry.m`: Shows how an MrImageGeometry object can be created from file or via MrDimInfo and MrAffineGeometry objects.

### MrDataNd
`MrDataNd/demo_save.m`: Illustrates how data are split to allow compatibility with SPM read-in.

### MrCopyData
`MrCopyData/demo_copy_data.m`: Shows the functionality of MrCopyData for deep cloning and recursive operations.


