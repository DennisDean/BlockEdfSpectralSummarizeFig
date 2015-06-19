function varargout = BlockEdfSpectralSummarizeFigAbout(varargin)
% BLOCKEDFSPECTRALSUMMARIZEFIGABOUT MATLAB code for BlockEdfSpectralSummarizeFigAbout.fig
%      BLOCKEDFSPECTRALSUMMARIZEFIGABOUT, by itself, creates a new BLOCKEDFSPECTRALSUMMARIZEFIGABOUT or raises the existing
%      singleton*.
%
%      H = BLOCKEDFSPECTRALSUMMARIZEFIGABOUT returns the handle to a new BLOCKEDFSPECTRALSUMMARIZEFIGABOUT or the handle to
%      the existing singleton*.
%
%      BLOCKEDFSPECTRALSUMMARIZEFIGABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLOCKEDFSPECTRALSUMMARIZEFIGABOUT.M with the given input arguments.
%
%      BLOCKEDFSPECTRALSUMMARIZEFIGABOUT('Property','Value',...) creates a new BLOCKEDFSPECTRALSUMMARIZEFIGABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BlockEdfSpectralSummarizeFigAbout_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BlockEdfSpectralSummarizeFigAbout_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BlockEdfSpectralSummarizeFigAbout

% Last Modified by GUIDE v2.5 05-Nov-2014 12:51:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BlockEdfSpectralSummarizeFigAbout_OpeningFcn, ...
                   'gui_OutputFcn',  @BlockEdfSpectralSummarizeFigAbout_OutputFcn, ...
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


% --- Executes just before BlockEdfSpectralSummarizeFigAbout is made visible.
function BlockEdfSpectralSummarizeFigAbout_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BlockEdfSpectralSummarizeFigAbout (see VARARGIN)

% Choose default command line output for BlockEdfSpectralSummarizeFigAbout
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BlockEdfSpectralSummarizeFigAbout wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BlockEdfSpectralSummarizeFigAbout_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close BlockEdfSpectralSummarizeFigAbout
