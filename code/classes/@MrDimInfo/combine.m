function [dimInfoCombined, indSamplingPointCombined] = combine(this, ...
    dimInfoArray, combineDims)
% Combines an array of dimInfos along a combination dimension or with
% pre-created selections
%
%   Y = MrDimInfo()
%   [dimInfoCombined, indSamplingPointCombined] = ...
%                     Y.combine(dimInfoArray, combineDims)
%       OR
%   dimInfoCombined = Y.combine(dimInfoArray, selectionIndexArrayCell)
%       OR
%   dimInfoCombined = Y.combine(dimInfoArray, selectionIndexRangeCell)
%       OR
%   dimInfoCombined = Y.combine(dimInfoArray, dimInfoCombineDims)
%
% This is a method of class MrDimInfo.
%
% NOTE: This method will work for two cases:
%           1)  Each dimInfo in the array has singleton-dimensions, which
%               match the labels in combineDims. Then, the dimInfo is
%               combined along these dimensions
%           2)  The combineDims do not exist as labels. In this case, use
%               the dimLabel/Range syntax of selectionIndexRangeCell below
%               The dimInfo is combined along these new dimensions with the
%               same
%
% IN
%   combineDims     cell(1,nDims) of dimLabels for the dimensions along
%                   which the dimInfos shall be combined. Those dimensions
%                   will have to be singleton (one entry only) in each
%                   dimInfo to allow the combination
%
%       OR
%   selectionIndexArrayCell     cell(nValuesDim1,...,nValuesDim1) of
%                               dimLabel / dimValue pairs as used in
%                               MrDimInfo.split (selectionArray)
%                               e.g.,
%                               {'coils', 1, 'echo', 1}, ..., {'coils', 1, 'echo', 3}
%                               ...
%                               {'coils', 8, 'echo', 1}, ..., {'coils', 8, 'echo', 3}
%
%       OR
%   selectionIndexRangeCell     cell(1,2*dimLabels) of dimLabel /
%                               dimValueRange pairs,
%                               e.g., {'coils', 1:8, 'echo', 1:3}
%
% OUT
%   dimInfoCombined
%
% EXAMPLE
%   combine(dimInfoArray, {'coils', 1:8, 'echo', 1:3});
%
%   See also MrDimInfo MrDimInfo.split
%
% Author:   Lars Kasper
% Created:  2018-05-04
% Copyright (C) 2018 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the TAPAS UniQC Toolbox, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: combine.m 489 2018-05-22 17:39:19Z lkasper $

%% 1) dimInfoCombined = Y.combine(dimInfoArray, combineDims)
%TODO: all cell elements are strings... || (iscell(combineDims) && all(cellfun(isstr)... etc.;

doCombineSingletonDims = nargin < 3; 
if doCombineSingletonDims
    indSplitDims = this.get_singleton_dimensions();
    combineDims = this.dimLabels(indSplitDims);
else
    % for 1-dim case, make cell
    if ~iscell(combineDims) && isstr(combineDims)
        combineDims = {combineDims};
    end
end

%% loop over all split dimInfo and retrieve values from all split dimensions
indSplitDims = this.get_dim_index(combineDims);
nDimsSplit = numel(indSplitDims);
nSplits = numel(dimInfoArray);

splitDimSamplingPoints = cell(nSplits,nDimsSplit);
for iSplit = 1:nSplits
    
    %% Check consistency of dimInfo properties for all non-combined dimensions
    % i.g. matching dimLabels, units, samplingWidths, samplingPoints and units whether they match...
    % check sampling widths
    indCommonDims = setdiff(1:this.nDims, indSplitDims);
    if ~isequal(this.get_dims(indCommonDims), ...
            dimInfoArray{iSplit}.get_dims(indCommonDims))
        disp('!!! Differing dimInfo properties:');
        disp(dimInfoArray{iSplit}.get_dims(indCommonDims).diffobj(...
            this.get_dims(indCommonDims)));
        error('unequal common dimensions in dimInfo %d for combination', iSplit);
    end
    
    
    for iDimSplit = 1:nDimsSplit
       
        %% Check consistency of dimInfo properties for combined dimensions
        % i.g. matching dimLabels, units, samplingWidths
        currentDim = combineDims{iDimSplit};
        
        % check if dimension with correct label exists
        if isempty(dimInfoArray{iSplit}.get_dim_index(currentDim))
            error('dimension of name ''%s'' not found in dimInfoArray{%d}', ...
                currentDim, iSplit);
        end
        
        diffDimInfo = dimInfoArray{iSplit}.get_dims(currentDim).diffobj(...
            this.get_dims(currentDim));
        
        % diff obj returns non-empty values for differing properties
        hasDifferingDimInfoProperties = ...
            ~isempty(diffDimInfo.dimLabels) || ...
            ~isempty(diffDimInfo.units) || ...
            ~isempty(diffDimInfo.samplingWidths);
        
        if hasDifferingDimInfoProperties
            disp('!!! Differing dimInfo properties:');
            disp(diffDimInfo); %to see differences)
            error('dimInfoArray{%d} does not match the common dimInfo-template for combination in dim ''%s''', ...
                iSplit, currentDim);
        end
        
        %% finally, combine dimInfo
        splitDimSamplingPoints{iSplit, iDimSplit} = ...
            dimInfoArray{iSplit}.samplingPoints{indSplitDims(iDimSplit)};
        
        
    end
end


%% Check unique entries for each dimension and sort values
combinedSplitDimSamplingPoints = cell(nDimsSplit,1);
indSamplingPointCombined = NaN(nSplits,nDimsSplit);
for iDimSplit = 1:nDimsSplit
    combinedSplitDimSamplingPoints{iDimSplit} = reshape(sort(unique(...
        cell2mat(splitDimSamplingPoints(:, iDimSplit)))), 1, []);
    for iSplit = 1:nSplits
        [~,indSamplingPointCombined(iSplit,iDimSplit)] = ...
            find(splitDimSamplingPoints{iSplit, iDimSplit} ...
            == combinedSplitDimSamplingPoints{iDimSplit});
    end
end

%% create new
dimInfoCombined = this.copyobj();
dimInfoCombined.samplingPoints(indSplitDims) = combinedSplitDimSamplingPoints;