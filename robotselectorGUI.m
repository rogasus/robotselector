%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ROBOT SELECTOR 
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots
%
% Tool is made with Robotic toolbox version 9.7

%%

function varargout = robotselectorGUI(varargin)
%ROBOTSELECTORGUI M-file for robotselectorGUI.fig
%      ROBOTSELECTORGUI, by itself, creates a new ROBOTSELECTORGUI or raises the existing
%      singleton*.
%
%      H = ROBOTSELECTORGUI returns the handle to a new ROBOTSELECTORGUI or the handle to
%      the existing singleton*.
%
%      ROBOTSELECTORGUI('Property','Value',...) creates a new ROBOTSELECTORGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to robotselectorGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ROBOTSELECTORGUI('CALLBACK') and ROBOTSELECTORGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ROBOTSELECTORGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help robotselectorGUI

% Last Modified by GUIDE v2.5 30-May-2016 15:54:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @robotselectorGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @robotselectorGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before robotselectorGUI is made visible.
function robotselectorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for robotselectorGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

clc

%open robotic toolbox
run('startup_rvc.m')

% set global variables
global successq
global goal0
global goal
global testrobot
global illegal
global angles
global C

succesq = [];
C = [];
angles = [0];
illegal = [0 0 1 0 0];
goal = [];

setprevrobot(hObject, eventdata, handles)
readenv(hObject, eventdata, handles);
updateplot(hObject, eventdata, handles)
% UIWAIT makes robotselectorGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = robotselectorGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in resultlistbox.
function resultlistbox_Callback(hObject, eventdata, handles)
% hObject    handle to resultlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns resultlistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from resultlistbox
robotnum = get(handles.resultlistbox,'value');
robot = get(handles.resultlistbox,'string');

global testrobot
global angles
global successq
global C

if strcmp(robot,'no suitable robots') == true;
    setprevrobot(hObject, eventdata, handles)
else
    pointer1 = successq(robotnum,1);
    joints = str2num(C{2}{pointer1});
    angles = [successq(robotnum,2)];
    for i = 1:(joints-1)
        angles = [angles successq(robotnum,2+i)];
    end
    [testrobot,pointer1] = createrobot(hObject, eventdata, handles,C,pointer1,joints);
end

updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function resultlistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startbut.
function startbut_Callback(hObject, eventdata, handles)
% hObject    handle to startbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global goal
global illegal
global testrobot
global C
global suitablelist
global successq

set(handles.resultlistbox,'value',1);

if illegal(1) == 0 && illegal(2) == 0
    
    %start timer
    tic
    
    %disable GUI
    set(handles.notefield,'string','Please wait. This may take several minutes per robot.');
    set(handles.status,'BackgroundColor','red');
    set(handles.status,'string','processing...');
    set(handles.colmodel,'Enable','off');
    set(handles.loctable,'Enable','off');
    set(handles.goaltable,'Enable','off');
    set(handles.addbut,'Enable','off'); 
    set(handles.temp,'Enable','off');
    set(handles.noise,'Enable','off');
    set(handles.applic,'Enable','off');
    set(handles.payload,'Enable','off');
    set(handles.costres,'Enable','off');
    set(handles.colres,'Enable','off');
    set(handles.envaccur,'Enable','off');
    set(handles.multidir,'Enable','off');
    set(handles.itersus,'Enable','off');
    set(handles.searchlimit,'Enable','off');
    set(handles.marklimit,'Enable','off');
    set(handles.resultlistbox,'Enable','off');
    set(handles.clearbut,'Enable','off');
    set(handles.envfilebut,'Enable','off');
    set(handles.libfilebut,'Enable','off');
    
    updateplot(hObject, eventdata, handles)
    
    % get values from GUI
    app = get(handles.applic,'string');
    app = cellstr(app);
    appval = get(handles.applic,'value');
    selapp = app(appval);
    payload = str2double(get(handles.payload,'string'));
    
    noise = str2double(get(handles.noise,'string'));
    temp = str2double(get(handles.temp,'string'));
    
    costres = str2double(get(handles.costres,'string'));
    colres = str2double(get(handles.colres,'string'));
    modelaccur = str2double(get(handles.envaccur,'string'));
    marklimit = str2double(get(handles.marklimit,'string'));
    searchlimit = str2double(get(handles.searchlimit,'string'));
    num = str2double(get(handles.itersus,'string'));
    multidir = get(handles.multidir,'value')+1;
    
    libname = get(handles.libfile,'string');
    envname = get(handles.envfile,'string');
    
    % read robot library
    fid = fopen(libname);
    C = textscan(fid,'%s %s %s %s %s %s %s %s');
    fclose(fid);
    
    % set initial values
    f = 0;
    pointer1 = 0;
    successq = [];
    suitablelist = [];
    
    %for result statistics
    totlandmarks = 0;
    totaliter = 0;
    robotnum = 0;
    
    % create environment model
    [X,Y,Z] = generatepoints(envname,modelaccur);
    
    while f == 0 
        try
            robotname = C{1}{1+pointer1};
            joints = str2num(C{2}{1+pointer1});
            tasks = C{3}{1+pointer1};
            maxload = str2num(C{4}{1+pointer1});
            robotmintemp = str2num(C{5}{1+pointer1});
            robotmaxtemp = str2num(C{6}{1+pointer1});
            robotnoise = str2num(C{7}{1+pointer1});
            pointer1 = pointer1 + 1;
            robotnum = robotnum + 1;
            
            % test other requirements
            [tsk] = tskchar(selapp,tasks);
            
            illegal(3) = 1;
            
            if (isempty(tsk) == false && ...
                    payload <= maxload && ...
                    noise <= robotnoise && ...
                    temp <= robotmaxtemp && ...
                    robotmintemp <= temp)
                illegal(3) = 0;
            end
                        
            % set current robot dh table and limits
            robotpointer = pointer1;
            [testrobot,pointer1] = createrobot(hObject, eventdata, handles,C,pointer1,joints);
            
            if illegal(3) == 0
                
                % find inverse kinematic solution for all frames
                gframes = size(goal);
                framesuc = 0;
                
                disp(robotname)
                for ii = 1:gframes(1)
                    [ig,jg,kg,~] = goalframe(goal(ii,:));
                    [qbest,~,~,landmarks,~,suc,totaliter0] = invkine(testrobot,X,Y,Z,ig,jg,kg,colres,costres,searchlimit,marklimit,multidir,num);
                    totaliter = totaliter+totaliter0;
                    totlandmarks = totlandmarks+landmarks;
                    if suc == 1
                        %robot is suitable for current frame
                        framesuc = framesuc +1;
                    else
                        %move to next robot
                        break
                    end
                end
                if framesuc == gframes(1)
                    %robot is suitable
                    disp('--------------')
                    disp('ROBOT SUITABLE')
                    disp('--------------')
                    successq = [successq; robotpointer qbest];
                    suitablelist = strvcat(suitablelist,robotname);
                else
                    disp('------------------')
                    disp('ROBOT NOT SUITABLE')
                    disp('------------------')
                end 
            end
        catch
            %file ended or error occurs
            f = 1;
        end
    end
    
    %enable GUI
    set(handles.colmodel,'Enable','on');
    set(handles.loctable,'Enable','on');
    set(handles.goaltable,'Enable','on');
    set(handles.addbut,'Enable','on'); 
    set(handles.temp,'Enable','on');
    set(handles.noise,'Enable','on');
    set(handles.applic,'Enable','on');
    set(handles.payload,'Enable','on');
    set(handles.costres,'Enable','on');
    set(handles.colres,'Enable','on');
    set(handles.envaccur,'Enable','on');
    set(handles.multidir,'Enable','on');
    set(handles.itersus,'Enable','on');
    set(handles.searchlimit,'Enable','on');
    set(handles.marklimit,'Enable','on');
    set(handles.resultlistbox,'Enable','on');
    set(handles.clearbut,'Enable','on');
    set(handles.envfilebut,'Enable','on');
    set(handles.libfilebut,'Enable','on');
    set(handles.status,'BackgroundColor','green');
    set(handles.status,'string','ready');
    
    %update results
    if isempty(suitablelist) == true
        time = toc;
        set(handles.resultlistbox,'string','no suitable robots');
        disp('+------------------------+')
        disp('|NO SUITABLE ROBOTS FOUND|')
        disp('+------------------------+')
    else
        time = toc;
        disp('+---------------------+')
        disp('|SUITABLE ROBOTS FOUND|')
        disp('+---------------------+')
        %result statistics
        fprintf('total time elapsed: %6.1f\n', time)
        fprintf('average time of robot: %7.2f\n',time/robotnum)
        fprintf('average time of landmark: %7.2f\n',time/totlandmarks)
        fprintf('average time of iteration: %6.2f\n',time/totaliter)
        fprintf('number of robots: %d\n', robotnum)
        fprintf('number of landmarks: %d\n',totlandmarks)
        fprintf('number of iterations: %d\n',totaliter)
        fprintf('average iterations per robot: %7.2f\n',totaliter/robotnum)
        fprintf('average iterations per landmark: %7.2f\n',totaliter/totlandmarks)
        fprintf('average landmarks per robot: %7.2f\n',totlandmarks/robotnum)
        
        set(handles.resultlistbox,'string',suitablelist);
    end
    set(handles.notefield,'string',' ');
    set(handles.resultlistbox,'value',1);
    resultlistbox_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in libfilebut.
function libfilebut_Callback(hObject, eventdata, handles)
% hObject    handle to libfilebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.txt'},'Select robot library file');
if isequal(filename,0) == true
    filename = get(handles.libfile,'string'); 
end
set(handles.libfile,'string',filename);

% --- Executes on selection change in applic.
function applic_Callback(hObject, eventdata, handles)
% hObject    handle to applic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns applic contents as cell array
%        contents{get(hObject,'Value')} returns selected item from applic

% --- Executes during object creation, after setting all properties.
function applic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to applic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in goaltable.
function goaltable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to goaltable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global illegal
global V
global F

goaltable = get(handles.goaltable,'data');

P = [cell2mat(goaltable(1,1)) cell2mat(goaltable(2,1)) cell2mat(goaltable(3,1))];
[X,Y,Z] = generatepoints(get(handles.envfile,'string'),str2double(get(handles.envaccur,'string')));
[S,mindist] = distancecalc(X,Y,Z,P);

if mindist < str2double(get(handles.colres,'string'))+str2double(get(handles.envaccur,'string'))
    illegal(4) = 1;
    set(handles.addbut,'Enable','off');
else
    illegal(4) = 0;
    set(handles.addbut,'Enable','on');
end
updateplot(hObject, eventdata, handles)


% --- Executes on button press in addbut.
function addbut_Callback(hObject, eventdata, handles)
% hObject    handle to addbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global goal
global goal0

goal = [goal; goal0];
updateplot(hObject, eventdata, handles)



% --- Executes on button press in clearbut.
function clearbut_Callback(hObject, eventdata, handles)
% hObject    handle to clearbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global goal
goal = [];
updateplot(hObject, eventdata, handles)


function payload_Callback(hObject, eventdata, handles)
% hObject    handle to payload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of payload as text
%        str2double(get(hObject,'String')) returns contents of payload as a double


% --- Executes during object creation, after setting all properties.
function payload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to payload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in envfilebut.
function envfilebut_Callback(hObject, eventdata, handles)
% hObject    handle to envfilebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.obj'},'Select environment model file');
if isequal(filename,0) == true
    filename = get(handles.envfile,'string'); 
end
set(handles.envfile,'string',filename);
readenv(hObject, eventdata, handles);
updateplot(hObject, eventdata, handles)

function readenv(hObject, eventdata, handles)
global V
global F
[V,F] = read_vertices_and_faces_from_obj_file(get(handles.envfile,'string'));

% --- Executes when entered data in editable cell(s) in loctable.
function loctable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to loctable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
setprevrobot(hObject, eventdata, handles)
set(handles.resultlistbox,'value',1);
set(handles.resultlistbox,'string','no suitable robots');
updateplot(hObject, eventdata, handles)

global testrobot
global illegal

P = [testrobot.base(1,4) testrobot.base(2,4) testrobot.base(3,4)];
[X,Y,Z] = generatepoints(get(handles.envfile,'string'),str2double(get(handles.envaccur,'string')));
[~,mindist] = distancecalc(X,Y,Z,P);

if mindist < str2double(get(handles.colres,'string'))
    illegal(1) = 1;
else
    illegal(1) = 0;
end

if illegal(1) == 0 && illegal(2) == 0;
    set(handles.status,'BackgroundColor','green');
    set(handles.status,'string','ready');
elseif illegal(1) == 1;
    set(handles.status,'BackgroundColor','yellow');
    set(handles.status,'string','illegal robot position');
elseif illegal(2) == 1;
    set(handles.status,'BackgroundColor','yellow');
    set(handles.status,'string','no goal frames created');
end

function temp_Callback(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temp as text
%        str2double(get(hObject,'String')) returns contents of temp as a double


% --- Executes during object creation, after setting all properties.
function temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise as text
%        str2double(get(hObject,'String')) returns contents of noise as a double


% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function costres_Callback(hObject, eventdata, handles)
% hObject    handle to costres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of costres as text
%        str2double(get(hObject,'String')) returns contents of costres as a double


% --- Executes during object creation, after setting all properties.
function costres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to costres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function envaccur_Callback(hObject, eventdata, handles)
% hObject    handle to envaccur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of envaccur as text
%        str2double(get(hObject,'String')) returns contents of envaccur as a double
if get(handles.colmodel,'value') == 1;
    updateplot(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function envaccur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to envaccur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colres_Callback(hObject, eventdata, handles)
% hObject    handle to colres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colres as text
%        str2double(get(hObject,'String')) returns contents of colres as a double


% --- Executes during object creation, after setting all properties.
function colres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function marklimit_Callback(hObject, eventdata, handles)
% hObject    handle to marklimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of marklimit as text
%        str2double(get(hObject,'String')) returns contents of marklimit as a double


% --- Executes during object creation, after setting all properties.
function marklimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to marklimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function searchlimit_Callback(hObject, eventdata, handles)
% hObject    handle to searchlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchlimit as text
%        str2double(get(hObject,'String')) returns contents of searchlimit as a double


% --- Executes during object creation, after setting all properties.
function searchlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itersus_Callback(hObject, eventdata, handles)
% hObject    handle to itersus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itersus as text
%        str2double(get(hObject,'String')) returns contents of itersus as a double


% --- Executes during object creation, after setting all properties.
function itersus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itersus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in multidir.
function multidir_Callback(hObject, eventdata, handles)
% hObject    handle to multidir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multidir

function updateplot(hObject, eventdata, handles)

set(handles.status,'BackgroundColor','red');
set(handles.status,'string','processing...');

% draw environment
global V
global F

trisurf(F,V(:,1),V(:,2),V(:,3),'FaceColor',[0.26,0.33,1.0 ]);
light('Position',[-1.0,-1.0,100.0],'Style','infinite');
lighting phong;
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal;
hold on

% draw goal frames
goaltable = get(handles.goaltable,'data');

global goal0

goal0 = [cell2mat(goaltable(1,1)) cell2mat(goaltable(2,1)) cell2mat(goaltable(3,1)) ...
    deg2rad(cell2mat(goaltable(3,2))) deg2rad(cell2mat(goaltable(2,2))) deg2rad(cell2mat(goaltable(1,2)))];

[ig,jg,kg,kgarrow] = goalframe(goal0);

global illegal

if illegal(4) == 0
    plot3([ig(1) goal0(1)],[ig(2) goal0(2)],[ig(3) goal0(3)],'r')
    plot3([jg(1) goal0(1)],[jg(2) goal0(2)],[jg(3) goal0(3)],'g')
    plot3([kg(1) goal0(1)],[kg(2) goal0(2)],[kg(3) goal0(3)],'b')
    mArrow3([goal0(1) goal0(2) goal0(3)],kgarrow,'color','b','stemWidth',5);
else
    plot3([ig(1) goal0(1)],[ig(2) goal0(2)],[ig(3) goal0(3)],'r')
    plot3([jg(1) goal0(1)],[jg(2) goal0(2)],[jg(3) goal0(3)],'r')
    plot3([kg(1) goal0(1)],[kg(2) goal0(2)],[kg(3) goal0(3)],'r')
    mArrow3([goal0(1) goal0(2) goal0(3)],kgarrow,'color','r','stemWidth',5);
end

global goal

if isempty(goal) == false
   illegal(2) = 0;
   i = size(goal);
   for ii = 1:i(1)
       [ig,jg,kg,kgarrow] = goalframe(goal(ii,:));
       plot3([ig(1) goal(ii,1)],[ig(2) goal(ii,2)],[ig(3) goal(ii,3)],'r')
       plot3([jg(1) goal(ii,1)],[jg(2) goal(ii,2)],[jg(3) goal(ii,3)],'g')
       plot3([kg(1) goal(ii,1)],[kg(2) goal(ii,2)],[kg(3) goal(ii,3)],'b')
       mArrow3([goal(ii,1) goal(ii,2) goal(ii,3)],kgarrow,'color','b','stemWidth',5);
   end
else
    illegal(2) = 1;
end

% draw robot
robotloc = get(handles.loctable,'data');

robotloca = [cell2mat(robotloc(1,1)) cell2mat(robotloc(2,1)) cell2mat(robotloc(3,1)) ...
    deg2rad(cell2mat(robotloc(1,2))) deg2rad(cell2mat(robotloc(2,2))) deg2rad(cell2mat(robotloc(3,2)))];

gamma = robotloca(4);
beta = robotloca(5);
alpha = robotloca(6);

baserot = [cos(alpha)*cos(beta)...
    cos(alpha)*sin(beta)*sin(gamma)-sin(alpha)*cos(gamma) ...
    cos(alpha)*sin(beta)*cos(gamma)+sin(alpha)*sin(gamma) 0;...
    sin(alpha)*cos(beta)...
    sin(alpha)*sin(beta)*sin(gamma)+cos(alpha)*cos(gamma)...
    sin(alpha)*sin(beta)*cos(gamma)-cos(alpha)*sin(gamma) 0;
    -sin(beta) ...
    cos(beta)*sin(gamma) ...
    cos(beta)*cos(gamma) 0; 0 0 0 1];

global testrobot
global angles

testrobot.base = transl([robotloca(1) robotloca(2) robotloca(3)]);
testrobot.base = testrobot.base*baserot;
testrobot.plot([angles])

%collision model
if get(handles.colmodel,'value') == 1;
    [P] = robotpointgen(testrobot,angles,50);
    [X,Y,Z] = generatepoints(get(handles.envfile,'string'),str2double(get(handles.envaccur,'string')));
    [S,~] = distancecalc(X,Y,Z,P);
    plot3([S(1,1) S(2,1)],[S(1,2) S(2,2)],[S(1,3) S(2,3)],'--')
    plot3(P(:,1),P(:,2),P(:,3),'rx')
    plot3(X,Y,Z,'r.')
end

hold off

if illegal(1) == 0 && illegal(2) == 0;
    set(handles.status,'BackgroundColor','green');
    set(handles.status,'string','ready');
elseif illegal(1) == 1;
    set(handles.status,'BackgroundColor','yellow');
    set(handles.status,'string','illegal robot position');
elseif illegal(2) == 1;
    set(handles.status,'BackgroundColor','yellow');
    set(handles.status,'string','no goal frames created');
end

function setprevrobot(hObject, eventdata, handles)
global testrobot
global angles
angles = [0];
rLink1 = Link([0 500 0 0 0]);
testrobot = SerialLink([rLink1]);


% --- Executes on button press in colmodel.
function colmodel_Callback(hObject, eventdata, handles)
% hObject    handle to colmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colmodel
updateplot(hObject, eventdata, handles)
