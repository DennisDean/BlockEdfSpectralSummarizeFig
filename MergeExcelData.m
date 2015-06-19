function varargout = MergeExcelData( varargin )
%MergeExcelData Merge column variables
%   Merge data from multiple excel files into a single output file.
%
%
%
% Version: 0.1.01
%
% ---------------------------------------------
% Dennis A. Dean, II, Ph.D
%
% Program for Sleep and Cardiovascular Medicine
% Brigam and Women's Hospital
% Harvard Medical School
% 221 Longwood Ave
% Boston, MA  02149
%
% File created: March 10, 2015
% Last updated: March 10, 2015 
%    
% Copyright © [2015] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%

% Create empty table for return
T = table;

% Process input
if nargin == 1
    % Process input and output
    fnCell = varargin{1};
elseif nargin == 2
    % Process input and output
    fnCell = varargin{1};
    combinedFn = varargin{2};
end

% Echo status to console
fprintf('Starting EXCEL file merge\n');

% Merge each data set sequentially
T = readtable(fnCell{1});
for s = 2:length(fnCell)
    % Echo status to console
    fprintf('\tMerging file: %s\n', fnCell{s});
    
    % Load table
    T2 = readtable(fnCell{s});
    
    % Check if tables have the same enties
    Tkey = T{1:end,1};
    T2key = T2{1:end,1};
    
    % Add rows to master
    rowsToadd = setxor(Tkey, T2key);
    if ~isempty(rowsToadd)
        TrowsToAdd = setdiff(rowsToadd, Tkey);
        if ~isempty(TrowsToAdd)
            % Create entry information
            TVariables = T.Properties.VariableNames;
            TAddCell   = cell(length(TrowsToAdd), length(TVariables));
            entries    = ones(length(TrowsToAdd), length(TVariables)-1)*NaN;
            
            % Add missing rows
            % Add missing rows
            Tlength    = length(Tkey);
            rows2add    = length(TrowsToAdd);
            entry = cell2table([num2cell(TrowsToAdd),num2cell(entries)]);
            entry.Properties.VariableNames = TVariables;

            % Union and Sort Rows    
            T = [T;entry];
            T = sortrows(T);
        end
        
        % Add rows to secondary key
        T2rowsToAdd = setdiff(rowsToadd, T2key);
        if ~isempty(T2rowsToAdd)
            % Create entry information
            T2Variables = T2.Properties.VariableNames;
            TAddCell    = cell(length(T2rowsToAdd), length(T2Variables));
            entries     = ones(length(T2rowsToAdd), length(T2Variables)-1)*NaN;
            
            % Add missing rows
            T2length    = length(T2key);
            rows2add    = length(T2rowsToAdd);
            T2(T2length+1:T2length+rows2add, 1:end) = ...
                [num2cell(T2rowsToAdd),num2cell(entries)];
            
            % Sort rows
            T2 = sortrows(T2);
        end        
    end
    
    % Ready to Merge
    T = sortrows(join(T,T2));
end

% Echo status to console
fprintf('EXCEL file merge completed\n');

% Write file 
if nargin == 2
    writetable(T, combinedFn);
end

% Process output
varargout = {};
if nargout == 1
    varargout = {T};
end

end

