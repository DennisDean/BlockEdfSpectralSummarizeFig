function varargout = BlockEdfSpectralSummarizeFig(varargin)
% BLOCKEDFSPECTRALSUMMARIZEFIG MATLAB code for BlockEdfSpectralSummarizeFig.fig
%      BLOCKEDFSPECTRALSUMMARIZEFIG, by itself, creates a new BLOCKEDFSPECTRALSUMMARIZEFIG or raises the existing
%      singleton*.
%
%      H = BLOCKEDFSPECTRALSUMMARIZEFIG returns the handle to a new BLOCKEDFSPECTRALSUMMARIZEFIG or the handle to
%      the existing singleton*.
%
%      BLOCKEDFSPECTRALSUMMARIZEFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLOCKEDFSPECTRALSUMMARIZEFIG.M with the given input arguments.
%
%      BLOCKEDFSPECTRALSUMMARIZEFIG('Property','Value',...) creates a new BLOCKEDFSPECTRALSUMMARIZEFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BlockEdfSpectralSummarizeFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BlockEdfSpectralSummarizeFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BlockEdfSpectralSummarizeFig

% Last Modified by GUIDE v2.5 18-Mar-2015 11:48:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BlockEdfSpectralSummarizeFig_OpeningFcn, ...
                   'gui_OutputFcn',  @BlockEdfSpectralSummarizeFig_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BlockEdfSpectralSummarizeFig is made visible.
function BlockEdfSpectralSummarizeFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BlockEdfSpectralSummarizeFig (see VARARGIN)

% Choose default command line output for BlockEdfSpectralSummarizeFig
handles.output = hObject;

% Initialize text boxes
set(handles.e_spec_spec_sum_fn, 'String',' ');
set(handles.e_spectral_study_text_string, 'String',' ');
set(handles.e_covariates_covariate_files, 'String',' ');
set(handles.e_summarize_signal_labels, 'String','{ }');
set(handles.e_summariz_adjudication_spreadsheet, 'String',' ');
set(handles.e_summarize_subject_id_function, 'String','@(x)str2num(x(1:7))');

% Inactivate buttons untill analysis folders are set
set(handles.pb_spectral_load, 'enable','off');
set(handles.pb_summarize_load_adjudication_spreadsheet, 'enable','off');
set(handles.pb_summarize_identify_nans, 'enable','off');
set(handles.pb_summarize_plot_spectrograms, 'enable','off');
set(handles.pb_summarize_plot_total_power, 'enable','off');
set(handles.pb_summarize_plot_average_spectra, 'enable','off');
set(handles.pb_adjudication_ppt, 'enable','off');
set(handles.pb_summarize_band_plots, 'enable','off');
set(handles.pb_covariates_select_covariate_file, 'enable','off');
set(handles.pb_covaraites_merge, 'enable','off');

% Get Monitor Positions and set to first monitor
monitorPositionsStrCell = ConvertMonitorPosToFigPos;
set(handles.pm_summarize_monitor_id, ...
    'String', monitorPositionsStrCell);

% Operation variables
handles.spectral_summary_pn = cd;
handles.spectral_summary_fn = '';
handles.spectral_summary_is_selected = '';

handles.adjudication_spreadsheet_pn = cd;
handles.adjudication_spreadsheet_fn = '';
handles.adjudication_spreadsheet_is_selected = '';

handles.covariate_pn = cd;
handles.covaraite_fn = '';
handles.covaraite_fn_is_selected = '';

handles.xlsLoadFlag = 0;
handles.objBSS = [];
handles.pptPath = strcat(cd,'\');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BlockEdfSpectralSummarizeFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BlockEdfSpectralSummarizeFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% redo but in pixel
% Set starting position in characters. Had problems with pixels
left_border = .8;
header = 2.0;
set(0,'Units','character') ;
screen_size = get(0,'ScreenSize');
set(handles.figure1,'Units','character');
dlg_size    = get(handles.figure1, 'Position');
pos1 = [ left_border , screen_size(4)-dlg_size(4)-1*header,...
    dlg_size(3) , dlg_size(4)];
set(handles.figure1,'Units','character');
set(handles.figure1,'Position',pos1);

% --- Executes on button press in pb_fig_about.
function pb_fig_about_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

BlockEdfSpectralSummarizeFigAbout

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_fig_quit.
function pb_fig_quit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close BlockEdfSpectralSummarizeFig


function e_spec_spec_sum_fn_Callback(hObject, eventdata, handles)
% hObject    handle to e_spec_spec_sum_fn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_spec_spec_sum_fn as text
%        str2double(get(hObject,'String')) returns contents of e_spec_spec_sum_fn as a double


% --- Executes during object creation, after setting all properties.
function e_spec_spec_sum_fn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_spec_spec_sum_fn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_spectral_select_summary_file.
function pb_spectral_select_summary_file_Callback(hObject, eventdata, handles)
% hObject    handle to pb_spectral_select_summary_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Default to current EDF path
spectral_summary_pn = handles.spectral_summary_pn;
[ spectral_summary_fn spectral_summary_pn spectral_summary_is_selected ] = ...
    pb_select_spectral_summary_file(spectral_summary_pn);

% check if user selected a file
if spectral_summary_is_selected == 1
    % write file name to dialog box
    set(handles.e_spec_spec_sum_fn, 'String', spectral_summary_fn);
    guidata(hObject, handles);
    
    % Turn on buttons
    set(handles.pb_spectral_load, 'enable','on');
    set(handles.pb_summarize_load_adjudication_spreadsheet, 'enable','off');
    set(handles.pb_summarize_identify_nans, 'enable','off');
    set(handles.pb_summarize_plot_spectrograms, 'enable','off');
    set(handles.pb_summarize_plot_total_power, 'enable','off');
    set(handles.pb_summarize_plot_average_spectra, 'enable','off');
    set(handles.pb_adjudication_ppt, 'enable','off');
    set(handles.pb_summarize_band_plots, 'enable','off');
    set(handles.pb_covariates_select_covariate_file, 'enable','off');
    set(handles.pb_covaraites_merge, 'enable','off');

    % Save file information to globals
    handles.spectral_summary_fn = spectral_summary_fn;
    handles.spectral_summary_pn = spectral_summary_pn;
    handles.spectral_summary_is_selected = spectral_summary_is_selected;
    guidata(hObject, handles);
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_spectral_load.
function pb_spectral_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_spectral_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get path and file information
if handles.spectral_summary_is_selected ==1
    % Get spectral file information
    spectral_summary_pn = handles.spectral_summary_pn;
    spectral_summary_fn = handles.spectral_summary_fn;  
    
    % Create a class and load file
    spectralSummaryFn = strcat(spectral_summary_pn, spectral_summary_fn);
    objBSS = BlockSpectralSummarizeClass(spectralSummaryFn);
    objBSS = objBSS.LoadSpectralTrainFigSpectralSummary;
    
    % Check that file was loaded
    if objBSS.xlsLoadFlag == 1
        % Save Load Information
        handles.xlsLoadFlag = 1;
        handles.objBSS = objBSS;
        
        % Set Buttons
        set(handles.pb_spectral_load, 'enable','on');
        set(handles.pb_summarize_load_adjudication_spreadsheet, 'enable','on'); 
        set(handles.pb_summarize_identify_nans, 'enable','on');
        set(handles.pb_summarize_plot_spectrograms, 'enable','on');
        set(handles.pb_summarize_plot_total_power, 'enable','on');
        set(handles.pb_summarize_plot_average_spectra, 'enable','on');
        set(handles.pb_summarize_band_plots, 'enable','on');
        set(handles.pb_adjudication_ppt, 'enable','on');
        set(handles.pb_covariates_select_covariate_file, 'enable','on');
        set(handles.pb_covaraites_merge, 'enable','off');     
        
        % Update handles structure
        guidata(hObject, handles);
    end
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_summarize_identify_nans.
function pb_summarize_identify_nans_Callback(hObject, eventdata, handles)
% hObject    handle to pb_summarize_identify_nans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get monitor position
displayPositionVal = get(handles.pm_summarize_monitor_id,'value');
displayPositionStr = get(handles.pm_summarize_monitor_id,'String');
displayPosition = eval(displayPositionStr{displayPositionVal,:});

% Get class and excute summary
objBSS = handles.objBSS;
objBSS.figPos = displayPosition;
objBSS = objBSS.IdentifyNans;
handles.objBSS = objBSS;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pb_summarize_plot_spectrograms.
function pb_summarize_plot_spectrograms_Callback(hObject, eventdata, handles)
% hObject    handle to pb_summarize_plot_spectrograms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get study label
studyLabel = get(handles.e_spectral_study_text_string, 'String');

% Get monitor position
displayPositionVal = get(handles.pm_summarize_monitor_id,'value');
displayPositionStr = get(handles.pm_summarize_monitor_id,'String');
displayPosition = eval(displayPositionStr{displayPositionVal,:});

% Get signal labels
signalLabels = eval(get(handles.e_summarize_signal_labels,'String'));

% Start and End Percentile to Plot
startPctlStr = get(handles.pm_summarize_start_pctl, 'String');
startPctlVal = get(handles.pm_summarize_start_pctl, 'Value');
startPctl = str2num(startPctlStr{startPctlVal,:});
endPctlStr = get(handles.pm_summarize_end_pctl, 'String');
endPctlVal = get(handles.pm_summarize_end_pctl, 'Value');
endPctl = str2num(endPctlStr{endPctlVal,:});

% Get class and excute summary
objBSS = handles.objBSS;
objBSS.LIST_NAN_SPECTRA = 0;
objBSS.figPos = displayPosition;
objBSS.studyLabel = studyLabel;
objBSS = objBSS.CreateNremPanel(startPctl, endPctl, signalLabels);
objBSS = objBSS.CreateNremSortPanel(startPctl, endPctl, signalLabels);
objBSS = objBSS.CreateRemPanel(startPctl, endPctl, signalLabels);
objBSS = objBSS.CreateRemSortPanel(startPctl, endPctl, signalLabels);
handles.objBSS = objBSS;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pb_summarize_plot_total_power.
function pb_summarize_plot_total_power_Callback(hObject, eventdata, handles)
% hObject    handle to pb_summarize_plot_total_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get study label
studyLabel = get(handles.e_spectral_study_text_string, 'String');

% Get monitor position
displayPositionVal = get(handles.pm_summarize_monitor_id,'value');
displayPositionStr = get(handles.pm_summarize_monitor_id,'String');
displayPosition = eval(displayPositionStr{displayPositionVal,:});

% Get signal labels
signalLabels = eval(get(handles.e_summarize_signal_labels,'String'));

% Start and End Percentile to Plot
startPctlStr = get(handles.pm_summarize_start_pctl, 'String');
startPctlVal = get(handles.pm_summarize_start_pctl, 'Value');
startPctl = str2num(startPctlStr{startPctlVal,:});
endPctlStr = get(handles.pm_summarize_end_pctl, 'String');
endPctlVal = get(handles.pm_summarize_end_pctl, 'Value');
endPctl = str2num(endPctlStr{endPctlVal,:});

% Get class and excute summary
objBSS = handles.objBSS;
objBSS.LIST_NAN_SPECTRA = 0;
objBSS.figPos = displayPosition;
objBSS.studyLabel = studyLabel;
objBSS = objBSS.PlotNremTotalPower(startPctl, endPctl, signalLabels);
objBSS = objBSS.PlotRemTotalPower(startPctl, endPctl, signalLabels);
objBSS = objBSS.PlotNremRemTotalPowerSort(startPctl, endPctl, signalLabels);
handles.objBSS = objBSS;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pb_summarize_plot_average_spectra.
function pb_summarize_plot_average_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to pb_summarize_plot_average_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get study label
studyLabel = get(handles.e_spectral_study_text_string, 'String');

% Get monitor position
displayPositionVal = get(handles.pm_summarize_monitor_id,'value');
displayPositionStr = get(handles.pm_summarize_monitor_id,'String');
displayPosition = eval(displayPositionStr{displayPositionVal,:});

% Get signal labels
signalLabels = eval(get(handles.e_summarize_signal_labels,'String'));

% Start and End Percentile to Plot
startPctlStr = get(handles.pm_summarize_start_pctl, 'String');
startPctlVal = get(handles.pm_summarize_start_pctl, 'Value');
startPctl = str2num(startPctlStr{startPctlVal,:});
endPctlStr = get(handles.pm_summarize_end_pctl, 'String');
endPctlVal = get(handles.pm_summarize_end_pctl, 'Value');
endPctl = str2num(endPctlStr{endPctlVal,:});

% Check if ADjudication spreadsheet is available.
adjudication_spreadsheet_is_selected = ...
    handles.adjudication_spreadsheet_is_selected;
if adjudication_spreadsheet_is_selected == 1
   % set adjudication variables
   subjectIdF = ...
       eval(get(handles.e_summarize_subject_id_function, 'String')); 
   adjudication_spreadsheet_fn = handles.adjudication_spreadsheet_fn;
   adjudication_spreadsheet_pn = handles.adjudication_spreadsheet_pn; 
end
   

% Get class and excute summary
objBSS = handles.objBSS;

% Parameters
objBSS.LIST_NAN_SPECTRA = 0;
objBSS.figPos = displayPosition;
objBSS.studyLabel = studyLabel;

% Set optional adjudication parameters
if adjudication_spreadsheet_is_selected == 1
    objBSS.adjudication_spreadsheet_is_selected = ...
        adjudication_spreadsheet_is_selected;
    objBSS.subjectIdF = subjectIdF;
    objBSS.adjudication_spreadsheet_fn = adjudication_spreadsheet_fn;
    objBSS.adjudication_spreadsheet_pn = adjudication_spreadsheet_pn;
end

objBSS = objBSS.PlotAverageSpectra(startPctl, endPctl, signalLabels);
handles.objBSS = objBSS;

% Update handles structure
guidata(hObject, handles);

function e_covariates_covariate_files_Callback(hObject, eventdata, handles)
% hObject    handle to e_covariates_covariate_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_covariates_covariate_files as text
%        str2double(get(hObject,'String')) returns contents of e_covariates_covariate_files as a double


% --- Executes during object creation, after setting all properties.
function e_covariates_covariate_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_covariates_covariate_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_covariates_select_covariate_file.
function pb_covariates_select_covariate_file_Callback(hObject, eventdata, handles)
% hObject    handle to pb_covariates_select_covariate_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Default to current EDF path
covariate_pn = handles.covariate_pn;
[ covaraite_fn covariate_pn covaraite_fn_is_selected ] = ...
    pb_select_covaraite_file(covariate_pn);

% check if user selected a file
if covaraite_fn_is_selected == 1
    % write file name to dialog box
    set(handles.e_covariates_covariate_files, 'String', covaraite_fn);
    guidata(hObject, handles);
    
    % Turn on buttons
    set(handles.pb_covaraites_merge, 'enable','on');
    
    % Save file information to globals
    handles.covaraite_fn = covaraite_fn;
    handles.covariate_pn = covariate_pn;
    handles.covaraite_fn_is_selected = covaraite_fn_is_selected;
    guidata(hObject, handles);
end


% --- Executes on button press in pb_covaraites_merge.
function pb_covaraites_merge_Callback(hObject, eventdata, handles)
% hObject    handle to pb_covaraites_merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check that file exists
covaraite_fn_is_selected = handles.covaraite_fn_is_selected;
if covaraite_fn_is_selected == 1
	% Get covariate files
    covaraite_fn = handles.covaraite_fn;
    covariate_pn = handles.covariate_pn;
    
    % Get spectral summary class
    objBSS = handles.objBSS;
    
    % Set optional parameters
    objBSS.outputFolder = handles.pptPath;
    
    % Merge Band Information
    objBSS = objBSS.MergeBandsWithCovariates(covaraite_fn, covariate_pn); 
end

% --- Executes on selection change in pm_summarize_monitor_id.
function pm_summarize_monitor_id_Callback(hObject, eventdata, handles)
% hObject    handle to pm_summarize_monitor_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_summarize_monitor_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_summarize_monitor_id

% --- Executes during object creation, after setting all properties.
function pm_summarize_monitor_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_summarize_monitor_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_close_all.
function pb_close_all_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


hands     = get (0,'Children');   % locate fall open figure handles
hands     = sort(hands);          % sort figure handles
numfigs   = size(hands,1);        % number of open figures
indexes   = find(hands-round(hands)==0);

close(hands(indexes));

% Set flags
handles.subject_is_displayed = 0;
handles.fig_id = 0;
fig_set_info = [];

% Update global handles
guidata(hObject, handles);

function e_spectral_study_text_string_Callback(hObject, eventdata, handles)
% hObject    handle to e_spectral_study_text_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_spectral_study_text_string as text
%        str2double(get(hObject,'String')) returns contents of e_spectral_study_text_string as a double


% --- Executes during object creation, after setting all properties.
function e_spectral_study_text_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_spectral_study_text_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_fig_folder.
function pb_fig_folder_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open folder dialog box
start_path = handles.pptPath;
dialog_title = 'PPT Save Directory';
folder_name = uigetdir(start_path, dialog_title);

% Check return values
if isstr(folder_name)
   % user selected a folder
   handles.pptPath = strcat(folder_name,'\');
   
   % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in pb_fig_ppt.
function pb_fig_ppt_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_ppt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get open figures
hands     = get (0,'Children');   % locate fall open figure handles
hands     = sort(hands);          % sort figure handles
numfigs   = size(hands,1);        % number of open figures
indexes   = find(hands-round(hands)==0);

% Initialize varaibles
fig_ids = hands(indexes);
studyLabel = get(handles.e_spectral_study_text_string, 'String');
titleStr = sprintf('PPT Summary - %s',studyLabel);
saveName = strcat(handles.spectral_summary_fn,'.ppt');

% Generate file name

savePath = handles.pptPath;
saveName = strcat(savePath,saveName);


% Create power point
pptFn = saveName;
ppt=saveppt2(pptFn,'init');
saveppt2('ppt',ppt,'f', 0, 'title', titleStr);
for f = 1:length(fig_ids)
    saveppt2('ppt',ppt,'f', fig_ids(f));
end
saveppt2(pptFn, 'ppt',ppt,'close');


% --- Executes on selection change in pm_summarize_start_pctl.
function pm_summarize_start_pctl_Callback(hObject, eventdata, handles)
% hObject    handle to pm_summarize_start_pctl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_summarize_start_pctl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_summarize_start_pctl


% --- Executes during object creation, after setting all properties.
function pm_summarize_start_pctl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_summarize_start_pctl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_summarize_end_pctl.
function pm_summarize_end_pctl_Callback(hObject, eventdata, handles)
% hObject    handle to pm_summarize_end_pctl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_summarize_end_pctl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_summarize_end_pctl


% --- Executes during object creation, after setting all properties.
function pm_summarize_end_pctl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_summarize_end_pctl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_adjudication_ppt.
function pb_adjudication_ppt_Callback(hObject, eventdata, handles)
% hObject    handle to pb_adjudication_ppt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function e_summarize_signal_labels_Callback(hObject, eventdata, handles)
% hObject    handle to e_summarize_signal_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_summarize_signal_labels as text
%        str2double(get(hObject,'String')) returns contents of e_summarize_signal_labels as a double


% --- Executes during object creation, after setting all properties.
function e_summarize_signal_labels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_summarize_signal_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_summarize_band_plots.
function pb_summarize_band_plots_Callback(hObject, eventdata, handles)
% hObject    handle to pb_summarize_band_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get study label
studyLabel = get(handles.e_spectral_study_text_string, 'String');

% Get monitor position
displayPositionVal = get(handles.pm_summarize_monitor_id,'value');
displayPositionStr = get(handles.pm_summarize_monitor_id,'String');
displayPosition = eval(displayPositionStr{displayPositionVal,:});

% Get signal labels
signalLabels = eval(get(handles.e_summarize_signal_labels,'String'));

% Start and End Percentile to Plot
startPctlStr = get(handles.pm_summarize_start_pctl, 'String');
startPctlVal = get(handles.pm_summarize_start_pctl, 'Value');
startPctl = str2num(startPctlStr{startPctlVal,:});
endPctlStr = get(handles.pm_summarize_end_pctl, 'String');
endPctlVal = get(handles.pm_summarize_end_pctl, 'Value');
endPctl = str2num(endPctlStr{endPctlVal,:});

% Check if ADjudication spreadsheet is available.
adjudication_spreadsheet_is_selected = ...
    handles.adjudication_spreadsheet_is_selected;
if adjudication_spreadsheet_is_selected == 1
   % set adjudication variables
   subjectIdF = ...
       eval(get(handles.e_summarize_subject_id_function, 'String')); 
   adjudication_spreadsheet_fn = handles.adjudication_spreadsheet_fn;
   adjudication_spreadsheet_pn = handles.adjudication_spreadsheet_pn; 
end

% Instantiate class
objBSS = handles.objBSS;

% Set object parameters
objBSS.LIST_NAN_SPECTRA = 0;
objBSS.figPos = displayPosition;
objBSS.studyLabel = studyLabel;

% Create file names
spectral_summary_fn = handles.spectral_summary_fn;
objBSS.bandAvgFn = strcat(spectral_summary_fn(1:end-4), 'bandAvg.xlsx');
objBSS.bandSubjectFn = ...
    strcat(spectral_summary_fn(1:end-4), 'SubjectBands.xlsx');
objBSS.outputFolder = handles.pptPath;

% Set optional adjudication parameters
if adjudication_spreadsheet_is_selected == 1
    objBSS.adjudication_spreadsheet_is_selected = ...
        adjudication_spreadsheet_is_selected;
    objBSS.subjectIdF = subjectIdF;
    objBSS.adjudication_spreadsheet_fn = adjudication_spreadsheet_fn;
    objBSS.adjudication_spreadsheet_pn = adjudication_spreadsheet_pn;
end

% Set subject id handle
subjectIdF = eval(get(handles.e_summarize_subject_id_function, 'String'));
objBSS.subjectIdF = subjectIdF;

% Create Band plots
objBSS = objBSS.PlotBandPlots(startPctl, endPctl, signalLabels);
handles.objBSS = objBSS;

% Update handles structure
guidata(hObject, handles);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_summariz_adjudication_spreadsheet_Callback(hObject, eventdata, handles)
% hObject    handle to e_summariz_adjudication_spreadsheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_summariz_adjudication_spreadsheet as text
%        str2double(get(hObject,'String')) returns contents of e_summariz_adjudication_spreadsheet as a double


% --- Executes during object creation, after setting all properties.
function e_summariz_adjudication_spreadsheet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_summariz_adjudication_spreadsheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_summarize_load_adjudication_spreadsheet.
function pb_summarize_load_adjudication_spreadsheet_Callback(hObject, eventdata, handles)
% hObject    handle to pb_summarize_load_adjudication_spreadsheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Default to current EDF path
adjudication_spreadsheet_pn = handles.spectral_summary_pn;
[ adjudication_spreadsheet_fn adjudication_spreadsheet_pn adjudication_spreadsheet_is_selected ] = ...
    pb_select_spectral_summary_file(adjudication_spreadsheet_pn);

% check if user selected a file
if adjudication_spreadsheet_is_selected == 1
    % write file name to dialog box
    set(handles.e_summariz_adjudication_spreadsheet, 'String', adjudication_spreadsheet_fn);
    
    % Update Adjudication variables
    handles.adjudication_spreadsheet_is_selected = ...
        adjudication_spreadsheet_is_selected;
    handles.adjudication_spreadsheet_fn = adjudication_spreadsheet_fn;
    handles.adjudication_spreadsheet_pn =adjudication_spreadsheet_pn;
    
    % Update handles
    guidata(hObject, handles);
    
    % adjudication_spreadsheet_is_selected is used as a modified to
    % exisiting functionality.
    %
    % BlockEdfSpectralSummarize configured to load adjudication spreadsheet.
    % Subject Id function will be passed in to generated subject ids from 
    % EDF file names.
    
end

function e_summarize_subject_id_function_Callback(hObject, eventdata, handles)
% hObject    handle to e_summarize_subject_id_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_summarize_subject_id_function as text
%        str2double(get(hObject,'String')) returns contents of e_summarize_subject_id_function as a double


% --- Executes during object creation, after setting all properties.
function e_summarize_subject_id_function_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_summarize_subject_id_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
