clear;
close all;
clc;
%% load data

pathData        = get_path('examples');

fileFunctional      = fullfile(pathData, 'nifti', 'rest', 'fmri_short.nii');
fileFunctionalMean  = fullfile(pathData, 'nifti', 'rest', 'meanfmri.nii');
fileStructural      = fullfile(pathData, 'nifti', 'rest', 'struct.nii');

Y = MrImageSpm4D(fileFunctionalMean);
Z = MrImageSpm4D(fileStructural);
%% and plot (voxel space)
Y.plot;
Z.plot;

%% spm check registration
Y.plot('plotType', 'spmi', 'overlayImages', Z);

% Coregister, but only update geometry
ZOrig = Z.copyobj;
ZOrig.parameters.save.fileName = 'structOrig.nii';
affineCoregistrationGeometry = Z.coregister_to(Y, 'geometry');


% looks the same as before (voxel-space plot)
Z.plot(); 

% but looks different in checkreg... (respects world space)
Y.plot('plotType', 'spmi', 'overlayImages', {Z, ZOrig});

%% Coregister with reslicing of data
ZReslice = MrImageSpm4D(fileStructural);
affineCoregistrationGeometry = ZReslice.coregister_to(Y, 'data');

ZReslice.plot();