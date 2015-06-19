classdef BlockSpectralSummarizeClass
    %BlockSpectralSummarizeClass Summarize and plot spectral summaries
    %   Load summarize data with additional varaibles to summarize by
    %   covariate.
    %
    %  Public Properties
    %
    %   Dependendent Properties
    %   -----------------------
    %
    %       Information extracted from file
    %       -------------------------------
    %       xlsNumRows
    %       xlsNumCols
    %       fileNames
    %       uniqueFileNames
    %       signalLabels
    %       uniqueSignalLabels
    %       numUniqueSignalLabels
    %       numEntriesPerSpectra
    %       nremLabel
    %       remLabel
    %       spectraDescription
    %       spectraUnits 
    %       freqLabels
    %       freqValues
    %       nremValues
    %       remValues
    %       numfiles
    %       numLeads 
    %       xlsLoadFlag
    %         
    %       Computed Variables
    %       ------------------
    %       numBandsOfInterest
    %       nremBands
    %       remBands
    %         
    %       Adjudication Variables
    %       ----------------------
    %       pptidFromFn
    %
    % Public Functions
    % ----------------
    %
    %   obj = BlockSpectralSummarizeClass(varargin)
    %   obj = LoadSpectralTrainFigSpectralSummary(obj,varargin)
    %   obj = CreateNremPanel(obj,varargin)
    %   obj = CreateNremSortPanel(obj,varargin)
    %   obj = CreateRemPanel(obj,varargin)
    %   obj = CreateRemSortPanel(obj,varargin)
    %   obj = PlotNremTotalPower(obj,varargin)
    %   obj = PlotRemTotalPower(obj,varargin)
    %   obj = PlotNremRemTotalPowerSort(obj,varargin)
    %   obj = PlotAverageSpectra(obj,varargin)
    %   obj = PlotBandPlots(obj,varargin)
    %   obj = IdentifyNans(obj,varargin)
    %   obj = MergeBandsWithCovariates (obj, varargin)
    %
    %
    % Private Funciton Protype
    % ------------------------
    %
    %   obj = loadAdjudicationFile(obj)
    %
    %
    % Private Function Protype
    % ------------------------
    %
    %   display_vector_int(data_vec)
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
    
    
    %---------------------------------------------------- Public Properties    
    properties (Access = public)
        % Input
        spectralSummaryFn  % SpectralTrainFig output
        
        % Optional input
        outputFolder = '';
        
        % Operation Flags
        LIST_NAN_SPECTRA = 1;
        
        % Adjudication Information (optional)
        % Only works for average spectra
        adjudication_spreadsheet_is_selected = 0;
        adjudication_spreadsheet_fn = ' ';
        adjudication_spreadsheet_pn = ' ';
        subjectIdF = [];  % abstract function for extracting id from EDF fn
        
        % Figure Values
        studyLabel = 'MESA';
        figPos = [-3839, -119, 1920, 1124];
        xtick = [1 11 21 31 41 51]
        xTickLabel = [' 0'; ' 5'; '10';'15'; '20'; '25'];
        xtickMin = [1 51]
        xTickLabelMin = [' 0'; '25'];
        MINIMUM_TITLE = 1;
        max_display_frequency = 25;
        
        % Bands of Interest
        bandsOfInterest = { ...
            { 'SlwOsc',            [ 0.25, 1.0]};...
            { 'Delta',              [ 1.0,  4.0]};...
            { 'Theta',              [ 4.0,  8.0]};...
            { 'Alpha',              [ 8.0, 12.0]};...
            { 'Sigma',              [12.0, 15.0]};...
            { 'Beta',               [15.0, 20.0]};...
        };
        bandsOfInterestLabels = { ...
             'SlwOsc'; ...
             'Delta';...
             'Theta';...
             'Alpha';...
             'Sigma';...
             'Beta';...
        };
        bandsOfInterestLatex = { ...
             '$1$';...
             '$\delta$';...
             '$\theta$';...
             '$\alpha$';...
             '$\sigma$';..... 
             '$\Beta$';...
        };
        bandColors = [...
            [ 198  217  241 ];...
            [ 220  230  242 ];...
            [ 242  220  219 ];...
            [ 235  241  222 ];...
            [ 230  224  236 ];...
            [ 219  238  244 ];...
            [ 253  234  218 ];...
            [ 230  224  236 ]...
        ]/255;   
        minBandFigValue = -1.5;
        maxVandFigValue = 3.5;
        
        % Data Filtering
        outlierStd = 3;
        bandAvgFn = 'bandAvg.xlsx';
        bandSubjectFn = 'bandSubject.xlsx';
    end
    %------------------------------------------------- Dependent Properties    
    properties (Dependent = true)
        % Information extracted from file
        xlsNumRows
        xlsNumCols
        fileNames
        uniqueFileNames
        signalLabels
        uniqueSignalLabels
        numUniqueSignalLabels
        numEntriesPerSpectra
        nremLabel
        remLabel
        spectraDescription
        spectraUnits 
        freqLabels
        freqValues
        nremValues
        remValues
        numfiles
        numLeads 
        xlsLoadFlag
        
        % Computed Variables
        numBandsOfInterest
        nremBands
        remBands
        
        % Adjudication Variables
        pptidFromFn
        
    end
    %--------------------------------------------------- Private Properties    
    properties (Access = protected)
        % Excel load components
        num
        txt
        raw
        fileNameCol = 2;
        signalLabelsCol = 3;
        
        % Operation flags
        xlsLoaded = 0;
        
        % Recorded information
        figs = [];
        
        % Currently annotation and band information assume the defaults 
        % Annotation Specification
        scoreKey = { ...
            { 'Awake' ,      0,  'W'}; ...
            { '1' ,          1,  '1'}; ...
            { '2' ,          2,  '2'}; ...
            { '3' ,          3,  '3'}; ...
            { '4' ,          4,  '4'}; ...
            { 'REM' ,        5,  'R'}; ...
            { 'X' ,          9,  'X'}; ...
            { 'X',          10,  'X'}; ...
        };
    
         maxAnalysisFrequency = 25;         % Maximum frequency to save
         
         % Adjudiction Variables
         pptidP
         commentsP
         adjudicationLabelsP
         adjudicationMatrixP
         numberOfAdjudicationSignalsP
         
         % Merging Bands with Covaraite variables
         bandsMatrixDefined = 0;
         outFnSuffix = 'WithSpectralBands.xls';
        
    end
    %------------------------------------------------------- Public Methods
    methods
        %------------------------------------------------------ Constructor
        function obj = BlockSpectralSummarizeClass(varargin)
            if nargin == 1
                obj.spectralSummaryFn = varargin{1};
            end
        end
        %------------------------------ LoadSpectralTrainFigSpectralSummary
        function obj = LoadSpectralTrainFigSpectralSummary(obj,varargin)
            try
                % Load Excel components
                [num txt raw] = xlsread(obj.spectralSummaryFn);

                % Save load information
                obj.num = num;
                obj.txt = txt;
                obj.raw = raw; 

                obj.xlsLoaded = 1;
            catch
                obj.xlsLoaded = 0;
            end
            
        end 
        %-------------------------------------------------- CreateNremPanel
        function obj = CreateNremPanel(obj,varargin)       
            % Initalize data selection parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Restructure figure
            nremValues = obj.nremValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            uniqueSignalLabels = obj.uniqueSignalLabels;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(nremValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadSpectraMatix = cell2mat(leadSpectra);
            
             
            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end  
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
                                   
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
            
            % Save Axis Information
            climMatrix = [];
            
            % Plot results for each lead
            for s = leadIndexes
                % Identify data to plot
                nremSpectra = leadSpectra{s};
                   
                % Identify Spectra to Remove
                numEntriesPerLead = size(nremSpectra, 1);
                nremIndex = [1:1:numEntriesPerLead]';
                if nargin >= 3
                    % Select data based on percentile of total power
                    nremTotalPow = sum(nremSpectra,2);

                    % Compute Percentiles
                    nremPctl = prctile(nremTotalPow, [startPctl endPctl]);

                    % Identify included indexes
                    nremIndex = find(and(nremTotalPow > nremPctl(1), ...
                        nremTotalPow < nremPctl(2)));  
                    nremIndexLength = length(nremIndex);
                end
                
                % Plot Data
                subplot(1, numLeadIndexes, subplotId);
                imagesc(log10(nremSpectra(nremIndex, :)));
                
                % Store image color limits
                clim = get(gca, 'CLIM');
                climMatrix = [climMatrix; clim];
                
                % Annotate plot
                titleStr = sprintf('%s - NREM - %s', obj.studyLabel, ...
                    uniqueSignalLabels{s}); 
                if obj.MINIMUM_TITLE
                    titleStr =  strcat('N-',uniqueSignalLabels{s});
                end   
                title(titleStr);
                ylabel('Subject ID');
                xlabel('Frequency(Hz)');
                
                % Set Axis labels
                xtick = obj.xtick;
                xTickLabel = obj.xTickLabel;
                if obj.MINIMUM_TITLE
                    xtick = obj.xtickMin;
                    xTickLabel = obj.xTickLabelMin;
                    xlabel('Hz');
                end   
                set(gca, 'xtick', xtick);
                set(gca, 'xTickLabel', xTickLabel);
                
                % Add colorbar
                colorbar
                                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            % Rescale image to same color limts
            clim = [min(climMatrix(:,1)) max(climMatrix(:,2))];
            
            subplotId = 1;
            for s = leadIndexes
                % Select subplot
                subplot(1, numLeadIndexes, subplotId);
                
                % change limits
                set(gca, 'clim', clim);
                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
                        
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %---------------------------------------------- CreateNremSortPanel
        function obj = CreateNremSortPanel(obj,varargin)       
            % Initalize data selection parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Restructure figure
            nremValues = obj.nremValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            uniqueSignalLabels = obj.uniqueSignalLabels;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(nremValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadSpectraMatix = cell2mat(leadSpectra);
            
             % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end              
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
                        
            % Save Axis Information
            climMatrix = [];
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
                      
            % Plot results for each lead
            for s = leadIndexes
                % Identify data to plot
                nremSpectra = leadSpectra{s};                
                
                % Identify Spectra to Remove
                numEntriesPerLead = size(nremSpectra, 1);
                nremIndex = [1:1:numEntriesPerLead]';
                if nargin >= 3
                    % Select data based on percentile of total power
                    nremTotalPow = sum(nremSpectra,2);

                    % Compute Percentiles
                    nremPctl = prctile(nremTotalPow, [startPctl endPctl]);

                    % Identify included indexes
                    nremIndex = find(and(nremTotalPow > nremPctl(1), ...
                        nremTotalPow < nremPctl(2)));  
                    nremIndexLength = length(nremIndex);
                end
      
                % Plot Data
                subplot(1, numLeadIndexes, subplotId);
                imagesc(sortrows(log10(nremSpectra(nremIndex, :))));
                
                % Store image color limits
                clim = get(gca, 'CLIM');
                climMatrix = [climMatrix; clim];
                
                % Annotate plot
                titleStr = sprintf('%s - NREM - Sort - %s', obj.studyLabel, ...
                    uniqueSignalLabels{s}); 
                if obj.MINIMUM_TITLE
                    titleStr =  strcat('NS-',uniqueSignalLabels{s});
                end                
                title(titleStr);
                ylabel('Subject ID');
                xlabel('Frequency(Hz)');
                
                % Set Axis labels
                xtick = obj.xtick;
                xTickLabel = obj.xTickLabel;
                if obj.MINIMUM_TITLE
                    xtick = obj.xtickMin;
                    xTickLabel = obj.xTickLabelMin;
                    xlabel('Hz');
                end   
                set(gca, 'xtick', xtick);
                set(gca, 'xTickLabel', xTickLabel);
                
                % Add colorbar
                colorbar;
                                                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            % Rescale image to same color limts
            clim = [min(climMatrix(:,1)) max(climMatrix(:,2))];
            
            subplotId = 1;
            for s = leadIndexes
                % Select subplot
                subplot(1, numLeadIndexes, subplotId);
                
                % change limits
                set(gca, 'clim', clim);
                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %--------------------------------------------------- CreateRemPanel
        function obj = CreateRemPanel(obj,varargin)       
            % Initalize data selection parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Restructure figure
            remValues = obj.remValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            uniqueSignalLabels = obj.uniqueSignalLabels;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(remValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadSpectraMatix = cell2mat(leadSpectra);
                      
            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end   
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
                        
            % Save Axis Information
            climMatrix = [];
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
                
            % Plot results for each lead
            for s = leadIndexes
                % Identify data to plot
                remSpectra = leadSpectra{s};

                % Identify Spectra to Remove
                numEntriesPerLead = size(remSpectra, 1);
                remIndex = [1:1:numEntriesPerLead]';
                if nargin >= 3
                    % Select data based on percentile of total power
                    remTotalPow = sum(remSpectra,2);

                    % Compute Percentiles
                    remPctl = prctile(remTotalPow, [startPctl endPctl]);

                    % Identify included indexes
                    remIndex = find(and(remTotalPow > remPctl(1), ...
                        remTotalPow < remPctl(2)));  
                    remIndexLength = length(remIndex);
                end
                  
                % Plot Data
                subplot(1, numLeadIndexes, subplotId);
                imagesc(log10(remSpectra(remIndex, :)));
                
                % Store image color limits
                clim = get(gca, 'CLIM');
                climMatrix = [climMatrix; clim];
                
                % Annotate plot
                titleStr = sprintf('%s - REM - %s', obj.studyLabel, ...
                    uniqueSignalLabels{s}); 
                if obj.MINIMUM_TITLE
                    titleStr =  strcat('R-',uniqueSignalLabels{s});
                end                
                title(titleStr);
                ylabel('Subject ID');
                xlabel('Frequency(Hz)');
                
                % Set Axis labels
                xtick = obj.xtick;
                xTickLabel = obj.xTickLabel;
                if obj.MINIMUM_TITLE
                    xtick = obj.xtickMin;
                    xTickLabel = obj.xTickLabelMin;
                    xlabel('Hz');
                end   
                set(gca, 'xtick', xtick);
                set(gca, 'xTickLabel', xTickLabel);
                
                % Add colorbar
                colorbar;
                                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            % Rescale image to same color limts
            clim = [min(climMatrix(:,1)) max(climMatrix(:,2))];
            
            subplotId = 1;
            for s = leadIndexes
                % Select subplot
                subplot(1, numLeadIndexes, subplotId);
                
                % change limits
                set(gca, 'clim', clim);
                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %----------------------------------------------- CreateRemSortPanel
        function obj = CreateRemSortPanel(obj,varargin)       
            % Initalize data selection parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Restructure figure
            remValues = obj.remValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            uniqueSignalLabels = obj.uniqueSignalLabels;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(remValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadSpectraMatix = cell2mat(leadSpectra);

            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end  
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
                        
            % Save Axis Information
            climMatrix = [];
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
            
            % Plot results for each lead
            for s = leadIndexes
                % Identify data to plot
                remSpectra = leadSpectra{s};   
                
                % Identify Spectra to Remove
                numEntriesPerLead = size(remSpectra, 1);
                remIndex = [1:1:numEntriesPerLead]';
                if nargin >= 3
                    % Select data based on percentile of total power
                    remTotalPow = sum(remSpectra,2);

                    % Compute Percentiles
                    remPctl = prctile(remTotalPow, [startPctl endPctl]);

                    % Identify included indexes
                    remIndex = find(and(remTotalPow > remPctl(1), ...
                        remTotalPow < remPctl(2)));  
                    remIndexLength = length(remIndex);
                end
                                  
                % Plot Data
                subplot(1, numLeadIndexes, subplotId);
                imagesc(sortrows(log10(remSpectra(remIndex, :))));
                
                % Store image color limits
                clim = get(gca, 'CLIM');
                climMatrix = [climMatrix; clim];
                
                % Annotate plot
                titleStr = sprintf('%s - REM -Sort - %s', obj.studyLabel, ...
                    uniqueSignalLabels{s});
                if obj.MINIMUM_TITLE
                    titleStr =  strcat('RS-',uniqueSignalLabels{s});
                end                
                title(titleStr);
                xlabel('Frequency(Hz)');
                
                % Set Axis labels
                xtick = obj.xtick;
                xTickLabel = obj.xTickLabel;
                if obj.MINIMUM_TITLE
                    xtick = obj.xtickMin;
                    xTickLabel = obj.xTickLabelMin;
                    xlabel('Hz');
                end   
                set(gca, 'xtick', xtick);
                set(gca, 'xTickLabel', xTickLabel);
                
                % Add colorbar
                colorbar;
                                 
                % Update Subplot Id
                subplotId = subplotId + 1;              
            end
            
            % Rescale image to same color limts
            clim = [min(climMatrix(:,1)) max(climMatrix(:,2))];
            
            subplotId = 1;
            for s = leadIndexes
                % Select subplot
                subplot(1, numLeadIndexes, subplotId);
                
                % change limits
                set(gca, 'clim', clim);
                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %----------------------------------------------- PlotNremTotalPower
        function obj = PlotNremTotalPower(obj,varargin)
            % Initalize data selection parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Restructure figure
            nremValues = obj.nremValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            numEntriesPerLead = size(nremValues,1)/numLeads;
            uniqueSignalLabels = obj.uniqueSignalLabels;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(nremValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadSpectraMatix = cell2mat(leadSpectra);
            
            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
            
            %Plot results for each lead
            for s = leadIndexes
                
                % Identify data to plot
                nremSpectra = leadSpectra{s};
                
                % Identify Spectra to Remove
                nremIndex = [1:1:numEntriesPerLead]';
                if nargin >= 3
                    % Select data based on percentile of total power
                    nremTotalPow = sum(nremSpectra,2);
                    
                    % Compute Percentiles
                    nremPctl = prctile(nremTotalPow, [startPctl endPctl]);
                    
                    % Identify included indexes
                    nremIndex = find(and(nremTotalPow > nremPctl(1), ...
                        nremTotalPow < nremPctl(2)));  
                    nremIndexLength = length(nremIndex);
                end
                
                % Plot Data
                subplot(1,numLeadIndexes,subplotId);
                
                plot(log10(sum(nremSpectra(nremIndex,:),2)), [1:nremIndexLength]);
                
                % Annotate plot
                titleStr = sprintf('%s - NREM - %s', obj.studyLabel, ...
                    uniqueSignalLabels{s}); 
                if obj.MINIMUM_TITLE
                    titleStr =  strcat('N-',uniqueSignalLabels{s});
                end                
                title(titleStr);
                xlabel('log10(Total Power)');
                ylabel('Subject ID');
                if obj.MINIMUM_TITLE
                    xlabel('log(P)');
                end
                
                % Set Axis labels
                set(gca, 'ydir', 'reverse');
                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
                        
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %------------------------------------------------- PlotRemTotalPower
        function obj = PlotRemTotalPower(obj,varargin)       
            % Initalize data selection parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Restructure figure
            remValues = obj.remValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            numEntriesPerLead = size(remValues,1)/numLeads;
            uniqueSignalLabels = obj.uniqueSignalLabels;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(remValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadSpectraMatix = cell2mat(leadSpectra);
            
            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end            
                   
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
            
            % Plot results for each lead
            for s = leadIndexes
                % Identify data to plot
                remSpectra = leadSpectra{s};
                
                % Identify Spectra to Remove
                remIndex = [1:1:numEntriesPerLead]';
                if nargin >= 3
                    % Select data based on percentile of total power
                    remTotalPow = sum(remSpectra,2);

                    % Compute Percentiles
                    remPctl = prctile(remTotalPow, [startPctl endPctl]);

                    % Identify included indexes
                    remIndex = find(and(remTotalPow > remPctl(1), ...
                        remTotalPow < remPctl(2)));  
                    remIndexLength = length(remIndex);
                end

                % Plot Data
                subplot(1, numLeadIndexes, subplotId);
                plot(log10(sum(remSpectra,2)), [1:numEntriesPerLead]);
                
                % Annotate plot
                titleStr = sprintf('%s - REM - %s', obj.studyLabel, ...
                    uniqueSignalLabels{s}); 
                if obj.MINIMUM_TITLE
                    titleStr =  strcat('R-',uniqueSignalLabels{s});
                end                
                title(titleStr);
                xlabel('log10(Total Power)');
                ylabel('Subject ID');
                if obj.MINIMUM_TITLE
                    xlabel('log(P)');
                end                  
                % Set Axis labels
                set(gca, 'ydir', 'reverse');
                
                % Update Subplot ID
                subplotId = 1;
            end
                        
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %--------------------------------------- PlotNremRemTotalPowerSort
        function obj = PlotNremRemTotalPowerSort(obj,varargin) 
            % Initalize data selection parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Restructure figure
            remValues = obj.remValues;
            nremValues = obj.nremValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            numEntriesPerLead = size(remValues,1)/numLeads;
            uniqueSignalLabels = obj.uniqueSignalLabels;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(remValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadNremSpectra = cellfun(@(x)cell2mat(nremValues(x,:)),leadCell, ...
                'UniformOutput', 0);            
            leadSpectraMatix = cell2mat(leadSpectra);
            
            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end             
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;            
            
            % Plot each lead
            for s = leadIndexes
                % Identify data to plot
                nremSpectra = leadNremSpectra{s};
                remSpectra = leadSpectra{s};
         
                % Identify Spectra to Remove
                nremIndex = [1:1:numEntriesPerLead]';
                remIndex = [1:1:numEntriesPerLead]';
                nremIndexLength = length(nremIndex);
                remIndexLength = length(remIndex);
                if nargin >= 3
                    % Select data based on percentile of total power
                    nremTotalPow = sum(nremSpectra,2);
                    remTotalPow = sum(remSpectra,2);

                    % Compute Percentiles
                    nremPctl = prctile(nremTotalPow, [startPctl endPctl]);
                    remPctl = prctile(remTotalPow, [startPctl endPctl]);

                    % Identify included indexes
                    nremIndex = find(and(nremTotalPow > nremPctl(1), ...
                        nremTotalPow < nremPctl(2)));  
                    nremIndexLength = length(nremIndex);
                    remIndex = find(and(remTotalPow > remPctl(1), ...
                        remTotalPow < remPctl(2)));  
                    remIndexLength = length(remIndex);
                end
                
                % Plot Data
                subplot(1, numLeadIndexes, subplotId);
                plot(log10(sort(sum(nremSpectra(nremIndex, :),2))), ...
                    [1:nremIndexLength],'k');hold on;
                plot(log10(sort(sum(remSpectra(remIndex, :),2))), ...
                    [1:remIndexLength],'b');hold on;
                
                % Annotate plot
                titleStr = sprintf('%s - Total Power - %s', obj.studyLabel, ...
                    uniqueSignalLabels{s}); 
                if obj.MINIMUM_TITLE
                    titleStr =  strcat('R-',uniqueSignalLabels{s});
                end
                title(titleStr);
                xlabel('log10(Total Power)');
                ylabel('Ordered ID');
                if obj.MINIMUM_TITLE
                    xlabel('log10(P)');
                end
                
                % Set Axis labels
                set(gca, 'ydir', 'reverse');
%                 xtick = obj.xtick;
%                 xTickLabel = obj.xTickLabel;
%                 set(gca, 'xtick', xtick);
%                 set(gca, 'xTickLabel', xTickLabel);
                
                % Create legend
                legend('NREM', 'REM');
                
                % Update subplot index
                subplotId = subplotId+1;
            end
                        
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %--------------------------------------------------- AverageSpectra
        function obj = PlotAverageSpectra(obj,varargin)  
            % Initalize parameters
            startPctl        = 0;
            endPctl          = 100;
            plotSignalLabels = {};
            
            % Optional adjudication variables
            subjectIdF                  = '';
            adjudication_spreadsheet_pn = '';
            adjudication_spreadsheet_fn = '';
            pptidFromFn = [];
            adjudicationMatrix = [];
            adjudication_spreadsheet_is_selected = ...
                obj.adjudication_spreadsheet_is_selected;
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Check if adjudication information is available
            adjudication_spreadsheet_is_selected = ...
                obj.adjudication_spreadsheet_is_selected;
            if adjudication_spreadsheet_is_selected ==1
                % Get adjudication values
                subjectIdF = obj.subjectIdF;
                adjudication_spreadsheet_pn = ...
                    obj.adjudication_spreadsheet_pn;
                adjudication_spreadsheet_fn = ...
                    obj.adjudication_spreadsheet_fn;  
                
                % Update object varaibles
                obj.subjectIdF = subjectIdF;
                obj.adjudication_spreadsheet_pn = ...
                    adjudication_spreadsheet_pn;
                obj.adjudication_spreadsheet_fn = ...
                    adjudication_spreadsheet_fn;
                 
                % Load Adjudcation File
                obj = obj.loadAdjudicationFile;
                
                % Identify data to exclude: Load Variables
                pptidFromFn = unique(obj.pptidFromFn, 'stable');
                adjudicationPptid = obj.pptidP;
                adjudicationMatrix = obj.adjudicationMatrixP;
                
                % Identify adjudication matrix to include
                getEntryIndexF = @(x)find(x == adjudicationPptid);
                adjudicationIndex = arrayfun(getEntryIndexF, pptidFromFn);
                adjudicationMatrix = adjudicationMatrix(adjudicationIndex,:);
            end
            
            % Restructure figure
            remValues = obj.remValues;
            nremValues = obj.nremValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            numEntriesPerLead = size(remValues,1)/numLeads;
            uniqueSignalLabels = obj.uniqueSignalLabels;
            freqValues = obj.freqValues;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(remValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadNremSpectra = cellfun(@(x)cell2mat(nremValues(x,:)),leadCell, ...
                'UniformOutput', 0);            
            leadSpectraMatix = cell2mat(leadSpectra);
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
            
            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
            
            % Loop Variables
            leadAxis = cell(numLeadIndexes,1);  
            adjudicationArray = ones(numEntriesPerLead, 1);
            for s = leadIndexes
                % Identify NAN indexes
                nremNanIndex = find(sum(isnan(leadNremSpectra{s}),2)>0);
                remNanIndex = find(sum(isnan(leadSpectra{s}),2)>0);
                
                % Write NAN information to console
                if obj.LIST_NAN_SPECTRA > 0
                    fprintf('\n\n%.0f. Lead = %s\n', s, uniqueSignalLabels{s}); 
                    fprintf('NREM NaN Indexes (n =%0.f): ', length(nremNanIndex));
                    obj.display_vector_int(nremNanIndex)
                    fprintf('\nREM NaN Indexes (n =%0.f): ', length(remNanIndex));
                    obj.display_vector_int(remNanIndex)
                end
                
                % Get Spectra Data
                nremSpectra = leadNremSpectra{s};
                remSpectra = leadSpectra{s};
                
                % Identify Spectra to Remove
                nremIndex = [1:1:numEntriesPerLead]';
                remIndex = [1:1:numEntriesPerLead]';
                
                % Exclude data based on user settings
                if adjudication_spreadsheet_is_selected ==1
                    % Remove by adjudication
                    adjudicationArray = ...
                        logical(adjudicationMatrix(:,s));
                    nremIndex = nremIndex(adjudicationArray);
                    remIndex = remIndex(adjudicationArray);
                elseif nargin >= 3
                    % Select data based on percentile of total power
                    nremTotalPow = sum(nremSpectra,2);
                    remTotalPow = sum(remSpectra,2);
                    
                    % Compute Percentiles
                    nremPctl = prctile(nremTotalPow, [startPctl endPctl]);
                    remPctl = prctile(remTotalPow, [startPctl endPctl]);
                    
                    % Identify included indexes
                    nremIndex = and(nremTotalPow > nremPctl(1), ...
                        nremTotalPow < nremPctl(2));
                    remIndex = and(remTotalPow > remPctl(1), ...
                        remTotalPow < remPctl(2));                    
                end
                
                % Compute Spectra
                nremSpectra = log10(nanmean(nremSpectra(nremIndex,:),1));
                remSpectra = log10(nanmean(remSpectra(remIndex,:),1));
                
                % Plot Data
                subplot(1,numLeadIndexes,subplotId);
                plot(freqValues, nremSpectra, 'k');hold on;
                plot(freqValues, remSpectra,'b');hold on;
                
                % Annotate plot
                titleStr = sprintf('%s - %s - %s', obj.studyLabel, ...
                    obj.spectraDescription, uniqueSignalLabels{s});
                if obj.MINIMUM_TITLE
                    titleStr =  uniqueSignalLabels{s};
                end
                title(titleStr);
                xlabel('Frequency (Hz)');
                ylabelStr = sprintf('%s (%s)', obj.spectraDescription, ...
                    obj.spectraUnits);
                ylabel(ylabelStr);
                if obj.MINIMUM_TITLE
                    xlabel('Hz');
                end
                
                % Set Axis Limits
                v = axis();
                v(1:2) = [0 obj.max_display_frequency];
                axis(v);
                % Add Legend
                legend('NREM', 'REM');
                
                % Save Axis Informaton
                leadAxis{subplotId} = axis;
                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            % Create common axis
            leadAxis = cell2mat(leadAxis);
            commonAxis = [leadAxis(1,1), leadAxis(1,2),...
                min(leadAxis(:,3)), max(leadAxis(:,4))];
            for s = 1:numLeadIndexes
                subplot(1, numLeadIndexes, s);
                axis(commonAxis);
            end
            
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %---------------------------------------------------- PlotBandPlots
        function obj = PlotBandPlots(obj,varargin)  
            % Initalize parameters
            startPctl = 0;
            endPctl = 100;
            plotSignalLabels = {};
            
            % Optional adjudication variables
            subjectIdF                  = '';
            adjudication_spreadsheet_pn = '';
            adjudication_spreadsheet_fn = '';
            pptidFromFn = [];
            adjudicationMatrix = [];
            adjudication_spreadsheet_is_selected = ...
                obj.adjudication_spreadsheet_is_selected;         
            
            % Process input            
            if nargin == 3
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2};
            elseif nargin == 4
                % Get Parameters
                startPctl = varargin{1}; 
                endPctl = varargin{2}; 
                plotSignalLabels = varargin{3};
            end
            
            % Check if adjudication information is available
            adjudication_spreadsheet_is_selected = ...
                obj.adjudication_spreadsheet_is_selected;
            if adjudication_spreadsheet_is_selected ==1
                % Get adjudication values
                subjectIdF = obj.subjectIdF;
                adjudication_spreadsheet_pn = ...
                    obj.adjudication_spreadsheet_pn;
                adjudication_spreadsheet_fn = ...
                    obj.adjudication_spreadsheet_fn;  
                
                % Update object varaibles
                obj.subjectIdF = subjectIdF;
                obj.adjudication_spreadsheet_pn = ...
                    adjudication_spreadsheet_pn;
                obj.adjudication_spreadsheet_fn = ...
                    adjudication_spreadsheet_fn;
                 
                % Load Adjudcation File
                if isempty(adjudicationMatrix)
                    obj = obj.loadAdjudicationFile;
                end
                
                % Identify data to exclude: Load Variables
                pptidFromFn = unique(obj.pptidFromFn, 'stable');
                adjudicationPptid = obj.pptidP;
                adjudicationMatrix = obj.adjudicationMatrixP;
                
                % Identify adjudication matrix to include
                getEntryIndexF = @(x)find(x == adjudicationPptid);
                adjudicationIndex = arrayfun(getEntryIndexF, pptidFromFn);
                adjudicationMatrix = adjudicationMatrix(adjudicationIndex,:);
            end            
            
            % Restructure figure
            remValues = obj.remValues;
            nremValues = obj.nremValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            numEntriesPerLead = size(remValues,1)/numLeads;
            uniqueSignalLabels = obj.uniqueSignalLabels;
            freqValues = obj.freqValues;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(remValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadNremSpectra = cellfun(@(x)cell2mat(nremValues(x,:)),leadCell, ...
                'UniformOutput', 0);            
            leadSpectraMatix = cell2mat(leadSpectra);
            
            % Get Band Information
            numBandsOfInterest = obj.numBandsOfInterest;
            bandLabels = obj.bandsOfInterestLabels;
            bandsOfInterest = obj.bandsOfInterest;
            bandRange = cell2mat(cellfun(@(x)x{2}, bandsOfInterest,...
                'UniformOutput', 0));
            
            % Create figure
            fid = figure();
            obj.figs = fid;
            if ~isempty(obj.figPos)
                set(fid, 'Position', obj.figPos);
            end
            
            % Determine which indexes to plot
            if isempty(plotSignalLabels)
                % Select all leads
                leadIndexes = 1:numLeads;
            else
                % Identify specific leads to plot
                leadIndexes = zeros(1,numLeads);
                for c = 1:length(plotSignalLabels)
                    tf = strcmp(plotSignalLabels{c}, ...
                        obj.uniqueSignalLabels);
                    if sum(tf) == 1
                        leadIndexes(find(tf)) = 1;
                    end
                end
                leadIndexes = find(leadIndexes);
            end
            
            % Create Subplots
            numLeadIndexes = length(leadIndexes);
            subplotId = 1;
            
            % Loop Variables
            leadAxis = cell(numBandsOfInterest, numLeadIndexes);  
            nremBandList = pptidFromFn;
            remBandList = [];
            nremBandTable = [];
            remBandTable = [];
            titleCell1 = {};
            titleCell2 = {};
            for s = leadIndexes
                % Identify NAN indexes
                nremNanIndex = find(sum(isnan(leadNremSpectra{s}),2)>0);
                remNanIndex = find(sum(isnan(leadSpectra{s}),2)>0);
                
                % Write NAN information to console
                if obj.LIST_NAN_SPECTRA > 0
                    fprintf('\n\n%.0f. Lead = %s\n', s, uniqueSignalLabels{s}); 
                    fprintf('NREM NaN Indexes (n =%0.f): ', length(nremNanIndex));
                    obj.display_vector_int(nremNanIndex)
                    fprintf('\nREM NaN Indexes (n =%0.f): ', length(remNanIndex));
                    obj.display_vector_int(remNanIndex)
                end
                
                % Get Spectra Data
                nremSpectra = leadNremSpectra{s};
                remSpectra = leadSpectra{s};
                
                % Identify Spectra to Remove
                nremIndex = [1:1:numEntriesPerLead]';
                remIndex = [1:1:numEntriesPerLead]';
                
                
                % Exclude data based on user settings
                if adjudication_spreadsheet_is_selected ==1
                    % Remove by adjudication
                    adjudicationArray = ...
                        logical(adjudicationMatrix(:,s));
                    nremIndex = nremIndex(adjudicationArray);
                    remIndex = remIndex(adjudicationArray);
                    
                elseif nargin >= 3
                    % Select data based on percentile of total power
                    nremTotalPow = sum(nremSpectra,2);
                    remTotalPow = sum(remSpectra,2);
                    
                    % Compute Percentiles
                    nremPctl = prctile(nremTotalPow, [startPctl endPctl]);
                    remPctl = prctile(remTotalPow, [startPctl endPctl]);
                    
                    % Identify included indexes
                    nremIndex = and(nremTotalPow > nremPctl(1), ...
                        nremTotalPow < nremPctl(2));
                    remIndex = and(remTotalPow > remPctl(1), ...
                        remTotalPow < remPctl(2));                    
                end
                
                % Compute Spectra
                nremSpectra = log10((nremSpectra(nremIndex,:)));
                remSpectra = log10((remSpectra(remIndex,:)));
                
                % Echo status to console
                fprintf('%s\n', uniqueSignalLabels{s})
                
                % Compute each band
                titleCell1 = [titleCell1(:)', {uniqueSignalLabels{s} ''}];
                titleCell2 = [titleCell2(:)', {'Mean' 'std'}];
                nextNremBandEntry = [];
                nextRemBandEntry = [];
                for b = 1:numBandsOfInterest
                    % Compute Bands
                    brange = bandRange(b,:);
                    freqValues = obj.freqValues;
                    bandIndex = find(and(freqValues>=brange(1), ...
                        freqValues<=brange(2)));
                    
                    % Identify outliers
                    nremBandData = nanmean(nremSpectra(:,bandIndex),2);
                    remBandData = nanmean(remSpectra(:,bandIndex),2);
                    outlierF = @(x)abs(x-nanmean(x))> nanstd(x)*obj.outlierStd;
                    nremOutlier = outlierF(nremBandData);
                    remOutlier = outlierF(remBandData);
                    numNremOutliers = sum(nremOutlier);
                    numRemOutliers = sum(remOutlier);
                    indexNremOutliers = find(nremOutlier == 1);
                    indexRemOutliers = find(remOutlier == 1);
                    
                    % Prepare variable for saving
                    nremBandData2 = nremBandData;
                    remBandData2 = remBandData;
                    nremBandData2(indexNremOutliers) = NaN;
                    remBandData2(indexRemOutliers) = NaN;
                    
                    % Echo status to console
                    fprintf('\t%s, Number of outliers > %.0f std: NREM = %.0f, REM = %.0f\n',...
                        bandLabels{b}, obj.outlierStd, ...
                        numNremOutliers, numRemOutliers);
                    
                    % Plot Data
                    p = (b-1)*numLeadIndexes+subplotId;
                    subplot(numBandsOfInterest,numLeadIndexes, p);
                    
                    % Record filtered band data
                    nremFilteredBand = ...
                        nanmean(nremSpectra(~nremOutlier,bandIndex),2);
                    remFilteredBand = ...
                        nanmean(remSpectra(~remOutlier,bandIndex),2);  
                    
                    nextNremBandEntry = [nextNremBandEntry; ...
                        [nanmean(nremFilteredBand), nanstd(nremFilteredBand)]];
                    nextRemBandEntry = [nextRemBandEntry; ...
                        [nanmean(remFilteredBand), nanstd(remFilteredBand)]];

                    
                    % Save data prior to printing
                    temp1 = ones(length(pptidFromFn),1)*NaN;
                    temp2 = ones(length(pptidFromFn),1)*NaN;
                    temp1(nremIndex) = nremBandData2;
                    temp2(remIndex) = remBandData2;
                    temp1(indexNremOutliers) = NaN;
                    temp2(indexRemOutliers) = NaN;
                    if size(temp1,1) < size(temp1,2) 
                        temp1 = temp1';
                    end
                    if size(temp2,1) < size(temp2,2) 
                        temp2 = temp2';
                    end
                    nremBandList = [nremBandList, temp1];
                    remBandList = [remBandList, temp2];
                    
                    % Create pretty histogram
                    if and(b == 1, s == 1)
                        t = nhist({...
                            nremFilteredBand(~isnan(nremFilteredBand)), ...
                            remFilteredBand(~isnan(remFilteredBand))}, ...
                            'legend', {'NREM','REM'});
                    else
                        t = nhist({...
                            nremFilteredBand(~isnan(nremFilteredBand)), ...
                            remFilteredBand(~isnan(remFilteredBand))}, ...
                            'legend', {'NREM','REM'});                    
                    end
                    
                    % Annotate plot
                    if b == 1 % Add title only to top plot
                        titleStr = sprintf('%s - %s - %s', obj.studyLabel, ...
                            obj.spectraDescription, uniqueSignalLabels{s});
                        if obj.MINIMUM_TITLE
                            titleStr =  uniqueSignalLabels{s};
                        end
                        title(titleStr);
                    end
                    
                    %xlabel('Frequency (Hz)');
                    brange = bandRange(b,:);
                    
                    if s == 1 % add y labels for most left plots
                        ylabelStr = sprintf('%s', bandLabels{b});
                        ylabel(ylabelStr);
                        if obj.MINIMUM_TITLE
                            %xlabel('Hz');
                        end
                    else
                        ylabel('');
                    end
                    
                    % Add Axis label
                    % set(gca, 'YTickLabel', {'R', 'N'});
                    
                    % Save Axis Inforamtion
                    leadAxis{b, subplotId} =  axis;
                    
                    % Set min/max bands
                    if and(~isempty(obj.minBandFigValue), ...
                            ~isempty(obj.maxVandFigValue))
                        v = axis();
                        v(1) =  obj.minBandFigValue;
                        v(2) =  obj.maxVandFigValue;
                        axis(v);
                    end
                end
                
                % Save band entry
                nremBandTable = [nremBandTable, nextNremBandEntry];
                remBandTable  = [remBandTable, nextRemBandEntry];
                
                % Update Subplot Id
                subplotId = subplotId + 1;
            end
            
            %% Create Subject Band Table
            outArray = [nremBandList remBandList];
            
            % Create ouput Labels
            label1 = {'pptid'};
            label2 = {};
            for s = 1:length(uniqueSignalLabels)
                for b = 1:length(bandLabels)
                    nextLabel = ...
                        sprintf('NREM_%s_%s',uniqueSignalLabels{s},...
                            bandLabels{b});
                    label1 = [label1(:)' {nextLabel}];
                    nextLabel = ...
                        sprintf('REM_%s_%s',uniqueSignalLabels{s},...
                            bandLabels{b});
                    label2 = [label2(:)' {nextLabel}];
                end
            end
            
            % Merge Output components
            label1      = [label1(:)' label2(:)'];
            if size(label1,1) > size(label1,2)
                label1 = label1';
            end
            pptidFromFn = unique(obj.pptidFromFn, 'stable');
            if size(label1,1) > size(outArray,1) 
                outArray    = num2cell([pptidFromFn, outArray]);
            end
            % label1 = [label1(:)'; outArray(:,:)];
            label3 = cell(size(outArray,1)+1,length(label1));
            label3(1,:)     = label1;
            label3(2:end,2:end) = num2cell(outArray);
            
            % Write file to disk
            bandSubjectFn = strcat(obj.outputFolder, obj.bandSubjectFn);
            xlswrite(bandSubjectFn, label3);
            
            %% Create Band Average Table
            % Save table to axis
            titleCell3     = cell(length(titleCell1),1);
            titleCell4     = cell(length(titleCell1),1);
            nremBandTable  = num2cell(nremBandTable);
            remBandTable   = num2cell(remBandTable);
            outAverageCell = ...
                [titleCell1(:,:);  ...
                 titleCell2(:,:); ...
                 titleCell3(:)';  ...
                 nremBandTable(:,:); ...
                 titleCell4(:)';      ...
                 remBandTable(:,:)];
            signalColumn = ...
                [ {' ';' ';'NREM'};
                  bandLabels(:);...
                  {'REM'};...
                  bandLabels(:)];
            outAverageCell = [signalColumn(:),  outAverageCell(:,:)];
            
            % Write file to disk
            bandBandFn = strcat(obj.outputFolder, obj.bandAvgFn);
            xlswrite(bandBandFn, outAverageCell);
            
            % Prepare figure for presetnation
            fixfig(fid, 0);
        end
        %----------------------------------------------------- IdentifyNans
        function obj = IdentifyNans(obj,varargin)       
            % Restructure figure
            remValues = obj.remValues;
            nremValues = obj.nremValues;
            numLeads = obj.numLeads;
            leadEntry = repmat([1:numLeads],[1 obj.numfiles])';
            numEntriesPerLead = size(remValues,1)/numLeads;
            uniqueSignalLabels = obj.uniqueSignalLabels;
            freqValues = obj.freqValues;
            
            % Create index cell and matrix for each lead
            leadCell = arrayfun(@(x)find(leadEntry == x), [1:numLeads], ...
                'UniformOutput', 0);
            leadSpectra = cellfun(@(x)cell2mat(remValues(x,:)),leadCell, ...
                'UniformOutput', 0);
            leadNremSpectra = cellfun(@(x)cell2mat(nremValues(x,:)),leadCell, ...
                'UniformOutput', 0);            
            leadSpectraMatix = cell2mat(leadSpectra);
            
            % Loop Variables
            leadAxis = cell(numLeads,1);
            
            % Plot each spectra
            for s = 1:numLeads
                % Identify NAN indexes
                nremNanIndex = find(sum(isnan(leadNremSpectra{s}),2)>0);
                remNanIndex = find(sum(isnan(leadSpectra{s}),2)>0);
                
                % Write NAN information to console
                fprintf('\n\n%.0f. Lead = %s\n', s, uniqueSignalLabels{s}); 
                fprintf('NREM NaN Indexes (n =%0.f): ', length(nremNanIndex));
                obj.display_vector_int(nremNanIndex)
                fprintf('\nREM NaN Indexes (n =%0.f): ', length(remNanIndex));
                obj.display_vector_int(remNanIndex)

            end
        end
        %----------------------------------------- MergeBandsWithCovariates
        function obj = MergeBandsWithCovariates (obj, varargin)
            % Initialize Variables
            covariate_fn = '';
            covariate_pn = '';
            outputFolder = obj.outputFolder;
            
            % Process input
            if nargin == 3
                covariate_fn = varargin{1};
                covariate_pn = varargin{2};
            end
            
            % Merge and write file 
            covaraiteFn = strcat(covariate_pn, covariate_fn);
            bandSubjectFn = strcat(obj.outputFolder, obj.bandSubjectFn);
            newCovariateFn = ...
                strcat(obj.outputFolder, covariate_fn(1:end-4),obj.outFnSuffix);

            % Create new name
            MergeExcelData({covaraiteFn, bandSubjectFn}, newCovariateFn);  
        end
    end
    %------------------------------------------------- Dependent Properties
    methods
        %------------------------------------------------------- xlsNumRows
        function value = get.xlsNumRows(obj)
            value = size(obj.num,1)-2;
        end
        %------------------------------------------------------- xlsNumCols
        function value = get.xlsNumCols(obj)
            value =  size(obj.num,2);
        end
        %-------------------------------------------------------- fileNames
        function value = get.fileNames(obj)
            value = obj.raw(3:end,obj.fileNameCol);
        end
        %-------------------------------------------------- uniqueFileNames
        function value = get.uniqueFileNames(obj)
            value = unique(obj.fileNames);
        end
        %----------------------------------------------------- signalLabels
        function value = get.signalLabels(obj)
            value = obj.raw(3:end,obj.signalLabelsCol);
        end
        %----------------------------------------------- uniqueSignalLabels
        function value = get.uniqueSignalLabels(obj)
            value = unique(obj.signalLabels);
        end
        %-------------------------------------------- numUniqueSignalLabels
        function value = get.numUniqueSignalLabels(obj)
            value = length(obj.uniqueSignalLabels);
        end
        %--------------------------------------------- numEntriesPerSpectra
        function value = get.numEntriesPerSpectra(obj)
            value = (obj.xlsNumCols-3)/2;
        end
        %-------------------------------------------------------- nremLabel
        function value = get.nremLabel(obj)
            value = obj.raw{1,4};
        end
        %--------------------------------------------------------- remLabel
        function value = get.remLabel(obj)
            value = obj.raw{1,4+obj.numEntriesPerSpectra};
        end
        %----------------------------------------------- spectraDescription
        function value = get.spectraDescription(obj)
            index = strfind(obj.nremLabel, '-');
            value = strtrim(obj.nremLabel(index(1)+1:index(2)-1));
        end
        %----------------------------------------------------- spectraUnits
        function value = get.spectraUnits(obj)
            index = strfind(obj.nremLabel, '-');
            value = strtrim(obj.nremLabel(index(end)+1:end));
        end
        %------------------------------------------------------- freqLabels
        function value = get.freqLabels(obj)
            value = obj.raw(2,4:3+obj.numEntriesPerSpectra);
        end
        %------------------------------------------------------- freqValues
        function value = get.freqValues(obj)
            value = cellfun(@(x)str2num(x(1:end-2)), obj.freqLabels);
        end
        %------------------------------------------------------- nremValues
        function value = get.nremValues(obj)
            value = obj.raw(3:end, 4:3+obj.numEntriesPerSpectra);
        end
        %-------------------------------------------------------- remValues
        function value = get.remValues(obj)
            value = obj.raw(3:end, 4+obj.numEntriesPerSpectra:end);
        end
        %--------------------------------------------------------- numfiles
        function value = get.numfiles(obj)
            value = length(obj.uniqueFileNames);
        end
        %--------------------------------------------------------- numLeads
        function value = get.numLeads(obj)
            value = length(obj.uniqueSignalLabels);
        end
        %------------------------------------------------------ xlsLoadFlag
        function value = get.xlsLoadFlag(obj)
            value = obj.xlsLoaded;
        end
        %----------------------------------------------- Computed Variables
        %----------------------------------------------- numBandsOfInterest
        function value = get.numBandsOfInterest(obj)
            value = length(obj.bandsOfInterest);
        end
        %-------------------------------------------------------- nremBands
        function value = get.nremBands(obj)
            % Band summary code copied from SpectralTrainFig
            value = 1;
        end
        %--------------------------------------------------------- remBands
        function value = get.remBands(obj)
            value = 1;
        end    
        %------------------------------------------- Adjudication Variables
        %------------------------------------------------------ pptidFromFn
        function value = get.pptidFromFn(obj)
            value = [];
            try
            if and(~isempty(obj.subjectIdF), ~isempty(obj.fileNames))
                % Apply id extractor to file name list
                value = cellfun(obj.subjectIdF, obj.fileNames, ...
                    'UniformOutput', 1);             
            end
            catch
                msg = 'Subject ids were not successfully extracted from file names';
                error(msg);
            end
        end
    end
    %------------------------------------------------- Dependent Properties
    methods(Access=protected)   
        %------------------------------------------- display_vector_int
        function obj = loadAdjudicationFile(obj)
            % Load adjudicatin file
            % Excel file column example (MESA): 
            %    pptid	EEG1_Adjud	EEG2_Adjud	EEG3_Adjud	Comments
            %
            
            % Get adjudication file information
            adjudication_spreadsheet_fn = obj.adjudication_spreadsheet_fn;
            adjudication_spreadsheet_pn = obj.adjudication_spreadsheet_pn;
            fn = ...
                strcat(adjudication_spreadsheet_pn, adjudication_spreadsheet_fn);
            
            % Load excel file
            [num txt raw] = xlsread(fn);
            
            % Define private adjudication variables
            obj.pptidP = cell2mat(raw(2:end,1));
            obj.commentsP = raw(2:end,end);
            obj.adjudicationLabelsP = raw(1,2:end-1);
            obj.adjudicationMatrixP = cell2mat(raw(2:end,2:end-1));
            obj.numberOfAdjudicationSignalsP = ...
                size(obj.adjudicationMatrixP,2);  
        end
    end
    %------------------------------------------------- Dependent Properties
    methods(Static)   
        %------------------------------------------- display_vector_int
        function display_vector_int(data_vec)
            %
            % display_vector_int
            %
            % Input:
            %   data_vec - array of integers
            %
            % Output:
            %   Tab delimited list at the console.
            %
            %

            if ~isempty(data_vec)
                % Write array to console
                fprintf('(\t%d',data_vec(1))
                for i = 2:length(data_vec)
                    fprintf(' \t%d',data_vec(i))
                end
                fprintf(')\n');
            else
                fprintf('( )\n');
            end
        end
    end   
end

