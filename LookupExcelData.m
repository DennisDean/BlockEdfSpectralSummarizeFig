function varargout = LookupExcelData( varargin )
%LookupExcelData Lookup values in second files and place in first.
%   Lookup values in second files and place in first
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
ECHO_TO_CONSOLE = 0;
T = table;
outFN = 'LookupOutput.xls';

% Process input
if nargin == 2
    % Process input and output
    T1_Fn = varargin{1};
    T2_Fn = varargin{2};
elseif nargin == 3
    % Process input and output
    T1_Fn = varargin{1};
    T2_Fn = varargin{2};
    outFN = varargin{3};
end

% Echo Status to variable
if ECHO_TO_CONSOLE == 1
    fprintf('Starting lookup\n');
end

% Load table
T = sortrows(readtable(T1_Fn));
T2 = sortrows(readtable(T2_Fn));

% Check if tables have the same enties
Tkey = T{1:end,1};
T2key = T2{1:end,1};

% Add rows to master
rowsToadd = setdiff(Tkey, T2key);
if ~isempty(rowsToadd)
    err('Check if master file contains all ids');
end

% Remove rows not needed 
idsToRemove = setxor(Tkey, T2key);
if ~isempty(idsToRemove)
    % Identify rows to remove
    flagRowF = @(x)sum(idsToRemove == x)>0;
    rowsToRemove = arrayfun(flagRowF, T2key);
    
    % Remove rows
    T2(rowsToRemove,:) = [];
end
    
% Merge Table
T = sortrows(join(T, T2));

% Write file 
if nargin == 3
    writetable(T, outFN);
end

% Process output
varargout = {};
if nargout == 1
    varargout = {T};
end


% Echo Status to variable
if ECHO_TO_CONSOLE == 1
    fprintf('Lookup completed\n');
end

end

