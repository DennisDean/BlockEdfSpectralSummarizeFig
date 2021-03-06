function [covaraite_fn covariate_pn covariate_fn_is_selected] = ...
                     pb_select_covaraite_file(current_covariate_path)
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
% File created: November 21, 2012
% Last update:  November 21, 2012 
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
[covaraite_fn, covariate_pn, filterindex] = uigetfile( ...
{  '*.xlsx','Covaraite File (*.xlsx)'; ...
   '*.xls','Covaraite File (*.xls)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Select Covariate file', ...
   current_covariate_path,...
   'MultiSelect', 'off');

% Check output
if isequal(covaraite_fn,0)
   covariate_fn_is_selected = 0;
else
   covariate_fn_is_selected = 1;
end

end

