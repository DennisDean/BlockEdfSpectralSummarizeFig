function [spec_sum_fn spec_sum_pn spec_sum_file_is_selected] = ...
                     pb_select_spectral_summary_file(current_spec_sum_path)
%pb_select_spectral_summary_file Select spectral summary file
%   File created to facilitate building GUI's from command line routines
% Loads spectral summary file generated by SpectralTrainFig
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
% File created: November 5, 2012
% Last update:  November 5, 2012 
%    
% Copyright � [2014] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%
    
% Program Constant
DEBUG = 1;


% Select file to open. 
[spec_sum_fn, spec_sum_pn, filterindex] = uigetfile( ...
{  '*.xlsx','EDF Files (*.xlsx)'; ...
   '*.xls','EDF Files (*.xls)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Select EDF files', ...
   current_spec_sum_path,...
   'MultiSelect', 'off');

% Check output
if isequal(spec_sum_fn,0)
   spec_sum_file_is_selected = 0;
else
   spec_sum_file_is_selected = 1;
end

end
