function [ output_args ] = testBlockSpectralSummarizeClass( input_args )
%testBlockSpectralSummarizeClass test BlockSpectralSummarizeClass
%   Create visual summaries and summaries by secondary information
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
% Boston, MA  02115
%
% File created: November 2, 2014
% Last updated: November 2, 2014 
%    
% Copyright © [2014] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
% 

% Test Flags
TEST_FLAG_1 = 1;  % Load test data

%-------------------------------------------------------------- TEST_FLAG_1
if TEST_FLAG_1 == 1
    % Write file message to console
    test_id = 1;
    test_msg = 'Load spectral results';
    fprintf('%.0f. %s\n', test_id, test_msg);
    
    % File Information
    spectralSummaryFn = 'MESA_full_run_SpectralSummary.xlsx';
    xlsLoaded
    % Create class, load file, create summary
    objBSS = BlockSpectralSummarizeClass(spectralSummaryFn);
    objBSS = objBSS.LoadSpectralTrainFigSpectralSummary;
    objBSS = objBSS.CreateNremPanel;
    objBSS = objBSS.CreateNremSortPanel;
    objBSS = objBSS.CreateRemPanel;
    objBSS = objBSS.CreateRemSortPanel;
    objBSS = objBSS.PlotNremTotalPower;
    objBSS = objBSS.PlotRemTotalPower;
    objBSS = objBSS.PlotRemTotalPowerSort;
    objBSS = objBSS.PlotAverageSpectra;  
end





end

