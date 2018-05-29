function varargout = split(this, varargin)
% Splits MrDataNd (or MrImage) along splitDims, sets filenames of created splitDataNd
% and optionally saves split images to file.
%
%   Y = MrDataNd()
%   [splitDataNd, selectionArray] = Y.split('splitDims', {'dimLabelSplit1, ..., dimLabelSplitN}, ...
%                           'doSave', false, 'fileName', newSplitFilename, ...
%                           'doRemoveDims', false)
%
% This is a method of class MrDataNd.
%
% IN
%   doRemoveDims    removes singleton dimensions from dimInfo after split
%                   (i.e. also the dimension information for dimensions
%                   along which split was performed)
%                   default: false
% OUT
%   splitDataNd cell(nElementsSplitDim1, ..., nElementsSplitDimN) of
%               MrDataNd, split along splitDims, i.e. containing one
%               element along these dimensions only
%   selectionArray
%               cell(nElementsSplitDim1, ..., nElementsSplitDimN) of
%               selections, defined as cells containing propertyName/value
%               pairs over split dimensions, e.g.
%               {'t', 5, 'dr', 3, 'echo', 4}
%
% EXAMPLE
%   split
%
%   See also MrDataNd MrDataNd.save
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2016-09-25
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: split.m 470 2018-05-03 12:00:34Z lkasper $

defaults.doSave = false;
defaults.fileName = this.get_filename();
defaults.splitDims = 'unset'; % changed below!
defaults.doRemoveDims = false; 

args = propval(varargin, defaults);
strip_fields(args);

% defaults splitDims are adapted depending on file extension to have
% e.g. default 4D nifti files.
[fp, fn, ext] = fileparts(fileName);
if isequal(splitDims, 'unset')
    switch ext
        case {'.nii', '.img'}
            splitDims = [5:this.dimInfo.nDims];
            
            if doSave
                % save dimInfo for later recovery of absolute indices (e.g.
                % which coil or echo time)
                warning('off', 'MATLAB:structOnObject');
                dimInfo = struct(this.dimInfo);
                warning('on', 'MATLAB:structOnObject');
                
                if ~exist(fp, 'dir')
                    mkdir(fp);
                end
                save(fullfile(fp, [fn '_dimInfo.mat']), 'dimInfo');
            end
            
        otherwise
            splitDims = [];
    end
end


% 1. create all selections,
% 2. loop over all selections
%       a) to select sub-image
%       b) to adapt name of subimage with selection suffix
%       c) to save (with extension-specific) single-file save

[dimInfoArray, sfxArray, selectionArray] = this.dimInfo.split(splitDims);


nSelections = numel(dimInfoArray);

if nargout
    splitDataNd = cell(size(dimInfoArray));
end

for iSelection = 1:nSelections
    tempDataNd = this.select(selectionArray{iSelection});
    tempDataNd.parameters.save.path = fp;
    tempDataNd.parameters.save.fileName = [fn sfxArray{iSelection} ext];
    
    if doRemoveDims
        tempDataNd.remove_dims([]);
    end
    
    if doSave
        tempDataNd.write_single_file();
    end
    
    if nargout
        splitDataNd{iSelection} = tempDataNd;
    end
    
end

if nargout
    varargout{1} = splitDataNd;
end

if nargin > 1
    varargout{2} = selectionArray;
end
