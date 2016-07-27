%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ROBOT BUILDER
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

function varargout = robotbuilderGUI(varargin)
% ROBOTBUILDERGUI MATLAB code for robotbuilderGUI.fig
%      ROBOTBUILDERGUI, by itself, creates a new ROBOTBUILDERGUI or raises the existing
%      singleton*.
%
%      H = ROBOTBUILDERGUI returns the handle to a new ROBOTBUILDERGUI or the handle to
%      the existing singleton*.
%
%      ROBOTBUILDERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTBUILDERGUI.M with the given input arguments.
%
%      ROBOTBUILDERGUI('Property','Value',...) creates a new ROBOTBUILDERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before robotbuilderGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to robotbuilderGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help robotbuilderGUI

% Last Modified by GUIDE v2.5 13-May-2016 13:47:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @robotbuilderGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @robotbuilderGUI_OutputFcn, ...
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


% --- Executes just before robotbuilderGUI is made visible.
function robotbuilderGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to robotbuilderGUI (see VARARGIN)

% Choose default command line output for robotbuilderGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes robotbuilderGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
run('startup_rvc.m')
global C
global angle
angle = [0 0 0 0 0 0];
C = 1:7;
updatelist(hObject, eventdata, handles)
robotlist_Callback(hObject, eventdata, handles)


% --- Outputs from this function are returned to the command line.
function varargout = robotbuilderGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function updatelist(hObject, eventdata, handles)

global C

set(handles.robotlist,'value',1);
set(handles.robotlist,'string',[]);

filename = get(handles.lib,'string');
fid = fopen(filename);
C = textscan(fid,'%s %s %s %s %s %s %s %s');
fclose(fid);

i = 0;
pointer1 = 0;

while i == 0;
    try
        robotname = C{1}{1+pointer1};
        joints = str2num(C{2}{1+pointer1});
        pointer1 = pointer1 + 1;
        
        tasklistold = get(handles.robotlist,'string');
        tasklistnew = strvcat(tasklistold, robotname);
        set(handles.robotlist,'string',tasklistnew);
        
        pointer1 = pointer1 + joints;

    catch
        i = 1;
    end
end

% --- Executes on button press in libbutton.
function libbutton_Callback(hObject, eventdata, handles)
% hObject    handle to libbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename pathname] = uigetfile({'*.txt'},'Select robot library file');
set(handles.lib,'string',filename);

updatelist(hObject, eventdata, handles)



% --- Executes on selection change in robotlist.
function robotlist_Callback(hObject, eventdata, handles)
% hObject    handle to robotlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns robotlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from robotlist

global C
global angle 
angle = [0 0 0 0 0 0];

set(handles.test1,'value',0);
set(handles.test2,'value',0);
set(handles.test3,'value',0);
set(handles.test4,'value',0);
set(handles.test5,'value',0);
set(handles.test6,'value',0);

robot = get(handles.robotlist,'string');
robot = cellstr(robot);
robotid = get(handles.robotlist,'value');

robotname = robot(robotid);
set(handles.robotname,'string',robotname);

i = 0;
pointer1 = 0;

while i == 0;
    try
        robotname2 = C{1}{1+pointer1};
        joints = str2num(C{2}{1+pointer1});
        if (strcmp(robotname,robotname2) == true)
            i = 1;
            %robot found. Send parameters to GUI
            set(handles.jointnumb,'string',C{2}{1+pointer1});
            set(handles.payload,'string',C{4}{1+pointer1});
            set(handles.mintemp,'string',C{5}{1+pointer1});
            set(handles.maxtemp,'string',C{6}{1+pointer1});
            set(handles.noise,'string',C{7}{1+pointer1});
            
            set(handles.theta1,'string',C{1}{2+pointer1});
            set(handles.d1,'string',C{2}{2+pointer1});
            set(handles.a1,'string',C{3}{2+pointer1});
            set(handles.alpha1,'string',C{4}{2+pointer1});
            set(handles.sigma1,'value',str2num(C{5}{2+pointer1}));
            set(handles.test1,'Min',str2num(C{6}{2+pointer1}));
            set(handles.test1,'Max',str2num(C{7}{2+pointer1}));
            if str2num(C{5}{2+pointer1}) == 0
                set(handles.min1,'string',rad2deg(str2num(C{6}{2+pointer1})));
                set(handles.max1,'string',rad2deg(str2num(C{7}{2+pointer1})));
            else
                set(handles.min1,'string',str2num(C{6}{2+pointer1}));
                set(handles.max1,'string',str2num(C{7}{2+pointer1}));
            end
            if joints > 1;
                set(handles.theta2,'string',C{1}{3+pointer1});
                set(handles.d2,'string',C{2}{3+pointer1});
                set(handles.a2,'string',C{3}{3+pointer1});
                set(handles.alpha2,'string',C{4}{3+pointer1});
                set(handles.sigma2,'value',str2num(C{5}{3+pointer1}));
                set(handles.test2,'Min',str2num(C{6}{3+pointer1}));
                set(handles.test2,'Max',str2num(C{7}{3+pointer1}));
                if str2num(C{5}{3+pointer1}) == 0
                    set(handles.min2,'string',rad2deg(str2num(C{6}{3+pointer1})));
                    set(handles.max2,'string',rad2deg(str2num(C{7}{3+pointer1})));
                else
                    set(handles.min2,'string',str2num(C{6}{3+pointer1}));
                    set(handles.max2,'string',str2num(C{7}{3+pointer1}));
                end
                if joints > 2;
                    set(handles.theta3,'string',C{1}{4+pointer1});
                    set(handles.d3,'string',C{2}{4+pointer1});
                    set(handles.a3,'string',C{3}{4+pointer1});
                    set(handles.alpha3,'string',C{4}{4+pointer1});
                    set(handles.sigma3,'value',str2num(C{5}{4+pointer1}));
                    set(handles.test3,'Min',str2num(C{6}{4+pointer1}));
                    set(handles.test3,'Max',str2num(C{7}{4+pointer1}));
                    if str2num(C{5}{4+pointer1}) == 0
                        set(handles.min3,'string',rad2deg(str2num(C{6}{4+pointer1})));
                        set(handles.max3,'string',rad2deg(str2num(C{7}{4+pointer1})));
                    else
                        set(handles.min3,'string',str2num(C{6}{4+pointer1}));
                        set(handles.max3,'string',str2num(C{7}{4+pointer1}));
                    end
                    if joints > 3;
                        set(handles.theta4,'string',C{1}{5+pointer1});
                        set(handles.d4,'string',C{2}{5+pointer1});
                        set(handles.a4,'string',C{3}{5+pointer1});
                        set(handles.alpha4,'string',C{4}{5+pointer1});
                        set(handles.sigma4,'value',str2num(C{5}{5+pointer1}));
                        set(handles.test4,'Min',str2num(C{6}{5+pointer1}));
                        set(handles.test4,'Max',str2num(C{7}{5+pointer1}));
                        if str2num(C{5}{5+pointer1}) == 0
                            set(handles.min4,'string',rad2deg(str2num(C{6}{5+pointer1})));
                            set(handles.max4,'string',rad2deg(str2num(C{7}{5+pointer1})));
                        else
                            set(handles.min4,'string',str2num(C{6}{5+pointer1}));
                            set(handles.max4,'string',str2num(C{7}{5+pointer1}));
                        end
                        if joints > 4;
                            set(handles.theta5,'string',C{1}{6+pointer1});
                            set(handles.d5,'string',C{2}{6+pointer1});
                            set(handles.a5,'string',C{3}{6+pointer1});
                            set(handles.alpha5,'string',C{4}{6+pointer1});
                            set(handles.sigma5,'value',str2num(C{5}{6+pointer1}));
                            set(handles.test5,'Min',str2num(C{6}{6+pointer1}));
                            set(handles.test5,'Max',str2num(C{7}{6+pointer1}));
                            if str2num(C{5}{6+pointer1}) == 0
                                set(handles.min5,'string',rad2deg(str2num(C{6}{6+pointer1})));
                                set(handles.max5,'string',rad2deg(str2num(C{7}{6+pointer1})));
                            else
                                set(handles.min5,'string',str2num(C{6}{6+pointer1}));
                                set(handles.max5,'string',str2num(C{7}{6+pointer1}));
                            end
                            if joints > 5;
                                set(handles.theta6,'string',C{1}{7+pointer1});
                                set(handles.d6,'string',C{2}{7+pointer1});
                                set(handles.a6,'string',C{3}{7+pointer1});
                                set(handles.alpha6,'string',C{4}{7+pointer1});
                                set(handles.sigma6,'value',str2num(C{5}{7+pointer1}));
                                set(handles.test6,'Min',str2num(C{6}{7+pointer1}));
                                set(handles.test6,'Max',str2num(C{7}{7+pointer1}));
                                if str2num(C{5}{7+pointer1}) == 0
                                    set(handles.min6,'string',rad2deg(str2num(C{6}{7+pointer1})));
                                    set(handles.max6,'string',rad2deg(str2num(C{7}{7+pointer1})));
                                else
                                    set(handles.min6,'string',str2num(C{6}{7+pointer1}));
                                    set(handles.max6,'string',str2num(C{7}{7+pointer1}));
                                end
                            end
                        end
                    end
                end
            end
        else
            pointer1 = pointer1 + joints + 1;
        end
    catch
        i = 1;
    end
end

tasks = C{3}{1+pointer1};
set(handles.tasklist2,'string',[])

if isempty(strfind(tasks,'w')) == false
    tasklistold = get(handles.tasklist2,'string');
    tasklistnew = strvcat(tasklistold, 'welding');
    set(handles.tasklist2,'string',tasklistnew);    
end
if isempty(strfind(tasks,'a')) == false
    tasklistold = get(handles.tasklist2,'string');
    tasklistnew = strvcat(tasklistold, 'assembly');
    set(handles.tasklist2,'string',tasklistnew);    
end
if isempty(strfind(tasks,'g')) == false
    tasklistold = get(handles.tasklist2,'string');
    tasklistnew = strvcat(tasklistold, 'glueing');
    set(handles.tasklist2,'string',tasklistnew);     
end
if isempty(strfind(tasks,'t')) == false
    tasklistold = get(handles.tasklist2,'string');
    tasklistnew = strvcat(tasklistold, 'tending');
    set(handles.tasklist2,'string',tasklistnew);    
end
if isempty(strfind(tasks,'p')) == false
    tasklistold = get(handles.tasklist2,'string');
    tasklistnew = strvcat(tasklistold, 'painting');
    set(handles.tasklist2,'string',tasklistnew);    
end
if isempty(strfind(tasks,'k')) == false
    tasklistold = get(handles.tasklist2,'string');
    tasklistnew = strvcat(tasklistold, 'packing');
    set(handles.tasklist2,'string',tasklistnew);    
end

updatejoints(hObject, eventdata, handles)
updateplot(hObject, eventdata, handles)

function updatejoints(hObject, eventdata, handles)

joints = str2num(get(handles.jointnumb,'string'));

if joints < 6;
    set(handles.theta6,'Enable','off');
    set(handles.d6,'Enable','off');
    set(handles.a6,'Enable','off');
    set(handles.alpha6,'Enable','off');
    set(handles.min6,'Enable','off');
    set(handles.max6,'Enable','off');
    set(handles.sigma6,'Enable','off');
else
    set(handles.theta6,'Enable','on');
    set(handles.d6,'Enable','on');
    set(handles.a6,'Enable','on');
    set(handles.alpha6,'Enable','on');
    set(handles.min6,'Enable','on');
    set(handles.max6,'Enable','on');
    set(handles.sigma6,'Enable','on');
end
if joints < 5;
    set(handles.theta5,'Enable','off');
    set(handles.d5,'Enable','off');
    set(handles.a5,'Enable','off');
    set(handles.alpha5,'Enable','off');
    set(handles.min5,'Enable','off');
    set(handles.max5,'Enable','off');
    set(handles.sigma5,'Enable','off');
else
    set(handles.theta5,'Enable','on');
    set(handles.d5,'Enable','on');
    set(handles.a5,'Enable','on');
    set(handles.alpha5,'Enable','on');
    set(handles.min5,'Enable','on');
    set(handles.max5,'Enable','on');
    set(handles.sigma5,'Enable','on');
end
if joints < 4;
    set(handles.theta4,'Enable','off');
    set(handles.d4,'Enable','off');
    set(handles.a4,'Enable','off');
    set(handles.alpha4,'Enable','off');
    set(handles.min4,'Enable','off');
    set(handles.max4,'Enable','off');
    set(handles.sigma4,'Enable','off');
else
    set(handles.theta4,'Enable','on');
    set(handles.d4,'Enable','on');
    set(handles.a4,'Enable','on');
    set(handles.alpha4,'Enable','on');
    set(handles.min4,'Enable','on');
    set(handles.max4,'Enable','on');
    set(handles.sigma4,'Enable','on');
end
if joints < 3;
    set(handles.theta3,'Enable','off');
    set(handles.d3,'Enable','off');
    set(handles.a3,'Enable','off');
    set(handles.alpha3,'Enable','off');
    set(handles.min3,'Enable','off');
    set(handles.max3,'Enable','off');
    set(handles.sigma3,'Enable','off');
else
    set(handles.theta3,'Enable','on');
    set(handles.d3,'Enable','on');
    set(handles.a3,'Enable','on');
    set(handles.alpha3,'Enable','on');
    set(handles.min3,'Enable','on');
    set(handles.max3,'Enable','on');
    set(handles.sigma3,'Enable','on');
end
if joints < 2;
    set(handles.theta2,'Enable','off');
    set(handles.d2,'Enable','off');
    set(handles.a2,'Enable','off');
    set(handles.alpha2,'Enable','off');
    set(handles.min2,'Enable','off');
    set(handles.max2,'Enable','off');
    set(handles.sigma2,'Enable','off');
else
    set(handles.theta2,'Enable','on');
    set(handles.d2,'Enable','on');
    set(handles.a2,'Enable','on');
    set(handles.alpha2,'Enable','on');
    set(handles.min2,'Enable','on');
    set(handles.max2,'Enable','on');
    set(handles.sigma2,'Enable','on');
end

function updateplot(hObject, eventdata, handles)

global angle

plot3(0,0,0,'.')

axis tight

joints = str2num(get(handles.jointnumb,'string'));

rLink1 = Link([str2num(get(handles.theta1,'string'))...
    str2num(get(handles.d1,'string'))...
    str2num(get(handles.a1,'string'))...
    str2num(get(handles.alpha1,'string'))...
    get(handles.sigma1,'value')]);
rLink2 = Link([str2num(get(handles.theta2,'string'))...
    str2num(get(handles.d2,'string'))...
    str2num(get(handles.a2,'string'))...
    str2num(get(handles.alpha2,'string'))...
    get(handles.sigma2,'value')]);
rLink3 = Link([str2num(get(handles.theta3,'string'))...
    str2num(get(handles.d3,'string'))...
    str2num(get(handles.a3,'string'))...
    str2num(get(handles.alpha3,'string'))...
    get(handles.sigma3,'value')]);
rLink4 = Link([str2num(get(handles.theta4,'string'))...
    str2num(get(handles.d4,'string'))...
    str2num(get(handles.a4,'string'))...
    str2num(get(handles.alpha4,'string'))...
    get(handles.sigma4,'value')]);
rLink5 = Link([str2num(get(handles.theta5,'string'))...
    str2num(get(handles.d5,'string'))...
    str2num(get(handles.a5,'string'))...
    str2num(get(handles.alpha5,'string'))...
    get(handles.sigma5,'value')]);
rLink6 = Link([str2num(get(handles.theta6,'string'))...
    str2num(get(handles.d6,'string'))...
    str2num(get(handles.a6,'string'))...
    str2num(get(handles.alpha6,'string'))...
    get(handles.sigma6,'value')]);

testrobot1.base = transl(0,0,0);

if joints == 6
    testrobot1 = SerialLink([rLink1 rLink2 rLink3 rLink4 rLink5 rLink6]);
    testrobot1.plot([angle(1) angle(2) angle(3) angle(4) angle(5) angle(6)])
elseif joints == 5
    testrobot1 = SerialLink([rLink1 rLink2 rLink3 rLink4 rLink5]);
    testrobot1.plot([angle(1) angle(2) angle(3) angle(4) angle(5)])
elseif joints == 4
    testrobot1 = SerialLink([rLink1 rLink2 rLink3 rLink4]);
    testrobot1.plot([angle(1) angle(2) angle(3) angle(4)])
elseif joints == 3
    testrobot1 = SerialLink([rLink1 rLink2 rLink3]);
    testrobot1.plot([angle(1) angle(2) angle(3)])
elseif joints == 2
    testrobot1 = SerialLink([rLink1 rLink2]);
    testrobot1.plot([angle(1) angle(2)])
else
    testrobot1 = SerialLink([rLink1]);
    testrobot1.plot([angle(1)])
end


% --- Executes during object creation, after setting all properties.
function robotlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robotlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta1_Callback(hObject, eventdata, handles)
% hObject    handle to theta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta1 as text
%        str2double(get(hObject,'String')) returns contents of theta1 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function theta1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d1_Callback(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d1 as text
%        str2double(get(hObject,'String')) returns contents of d1 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function d1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a1_Callback(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a1 as text
%        str2double(get(hObject,'String')) returns contents of a1 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha1_Callback(hObject, eventdata, handles)
% hObject    handle to alpha1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha1 as text
%        str2double(get(hObject,'String')) returns contents of alpha1 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function alpha1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sigma1.
function sigma1_Callback(hObject, eventdata, handles)
% hObject    handle to sigma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sigma1
updateplot(hObject, eventdata, handles)


function min1_Callback(hObject, eventdata, handles)
% hObject    handle to min1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min1 as text
%        str2double(get(hObject,'String')) returns contents of min1 as a double
if get(handles.sigma1,'value') == 0
    set(handles.test1,'Min',deg2rad(str2num(get(handles.min1,'string'))));
else
    set(handles.test1,'Min',str2num(get(handles.min1,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function min1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max1_Callback(hObject, eventdata, handles)
% hObject    handle to max1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max1 as text
%        str2double(get(hObject,'String')) returns contents of max1 as a double
if get(handles.sigma1,'value') == 0
    set(handles.test1,'Max',deg2rad(str2num(get(handles.max1,'string'))));
else
    set(handles.test1,'Max',str2num(get(handles.max1,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function max1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function test1_Callback(hObject, eventdata, handles)
% hObject    handle to test1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global angle
angle = [get(handles.test1,'value') get(handles.test2,'value') get(handles.test3,'value')...
    get(handles.test4,'value') get(handles.test5,'value') get(handles.test6,'value')];
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function test1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function theta2_Callback(hObject, eventdata, handles)
% hObject    handle to theta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta2 as text
%        str2double(get(hObject,'String')) returns contents of theta2 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function theta2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d2_Callback(hObject, eventdata, handles)
% hObject    handle to d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d2 as text
%        str2double(get(hObject,'String')) returns contents of d2 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function d2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a2_Callback(hObject, eventdata, handles)
% hObject    handle to a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a2 as text
%        str2double(get(hObject,'String')) returns contents of a2 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function a2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha2_Callback(hObject, eventdata, handles)
% hObject    handle to alpha2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha2 as text
%        str2double(get(hObject,'String')) returns contents of alpha2 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function alpha2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sigma2.
function sigma2_Callback(hObject, eventdata, handles)
% hObject    handle to sigma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sigma2
updateplot(hObject, eventdata, handles)


function min2_Callback(hObject, eventdata, handles)
% hObject    handle to min2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min2 as text
%        str2double(get(hObject,'String')) returns contents of min2 as a double
if get(handles.sigma2,'value') == 0
    set(handles.test2,'Min',deg2rad(str2num(get(handles.min2,'string'))));
else
    set(handles.test2,'Min',str2num(get(handles.min2,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function min2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max2_Callback(hObject, eventdata, handles)
% hObject    handle to max2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max2 as text
%        str2double(get(hObject,'String')) returns contents of max2 as a double
if get(handles.sigma2,'value') == 0
    set(handles.test2,'Max',deg2rad(str2num(get(handles.max2,'string'))));
else
    set(handles.test2,'Max',str2num(get(handles.max2,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function max2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function test2_Callback(hObject, eventdata, handles)
% hObject    handle to test2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global angle
angle = [get(handles.test1,'value') get(handles.test2,'value') get(handles.test3,'value')...
    get(handles.test4,'value') get(handles.test5,'value') get(handles.test6,'value')];
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function test2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function theta3_Callback(hObject, eventdata, handles)
% hObject    handle to theta3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta3 as text
%        str2double(get(hObject,'String')) returns contents of theta3 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function theta3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d3_Callback(hObject, eventdata, handles)
% hObject    handle to d3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d3 as text
%        str2double(get(hObject,'String')) returns contents of d3 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function d3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a3_Callback(hObject, eventdata, handles)
% hObject    handle to a3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a3 as text
%        str2double(get(hObject,'String')) returns contents of a3 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function a3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha3_Callback(hObject, eventdata, handles)
% hObject    handle to alpha3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha3 as text
%        str2double(get(hObject,'String')) returns contents of alpha3 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function alpha3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sigma3.
function sigma3_Callback(hObject, eventdata, handles)
% hObject    handle to sigma3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sigma3
updateplot(hObject, eventdata, handles)


function min3_Callback(hObject, eventdata, handles)
% hObject    handle to min3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min3 as text
%        str2double(get(hObject,'String')) returns contents of min3 as a double
if get(handles.sigma3,'value') == 0
    set(handles.test3,'Min',deg2rad(str2num(get(handles.min3,'string'))));
else
    set(handles.test3,'Min',str2num(get(handles.min3,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function min3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max3_Callback(hObject, eventdata, handles)
% hObject    handle to max3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max3 as text
%        str2double(get(hObject,'String')) returns contents of max3 as a double
if get(handles.sigma3,'value') == 0
    set(handles.test3,'Max',deg2rad(str2num(get(handles.max3,'string'))));
else
    set(handles.test3,'Max',str2num(get(handles.max3,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function max3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function test3_Callback(hObject, eventdata, handles)
% hObject    handle to test3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global angle
angle = [get(handles.test1,'value') get(handles.test2,'value') get(handles.test3,'value')...
    get(handles.test4,'value') get(handles.test5,'value') get(handles.test6,'value')];
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function test3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function theta4_Callback(hObject, eventdata, handles)
% hObject    handle to theta4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta4 as text
%        str2double(get(hObject,'String')) returns contents of theta4 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function theta4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d4_Callback(hObject, eventdata, handles)
% hObject    handle to d4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d4 as text
%        str2double(get(hObject,'String')) returns contents of d4 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function d4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a4_Callback(hObject, eventdata, handles)
% hObject    handle to a4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a4 as text
%        str2double(get(hObject,'String')) returns contents of a4 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function a4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha4_Callback(hObject, eventdata, handles)
% hObject    handle to alpha4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha4 as text
%        str2double(get(hObject,'String')) returns contents of alpha4 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function alpha4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sigma4.
function sigma4_Callback(hObject, eventdata, handles)
% hObject    handle to sigma4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sigma4
updateplot(hObject, eventdata, handles)


function min4_Callback(hObject, eventdata, handles)
% hObject    handle to min4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min4 as text
%        str2double(get(hObject,'String')) returns contents of min4 as a double
if get(handles.sigma4,'value') == 0
    set(handles.test4,'Min',deg2rad(str2num(get(handles.min4,'string'))));
else
    set(handles.test4,'Min',str2num(get(handles.min4,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function min4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max4_Callback(hObject, eventdata, handles)
% hObject    handle to max4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max4 as text
%        str2double(get(hObject,'String')) returns contents of max4 as a double
if get(handles.sigma4,'value') == 0
    set(handles.test4,'Max',deg2rad(str2num(get(handles.max4,'string'))));
else
    set(handles.test4,'Max',str2num(get(handles.max4,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function max4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function test4_Callback(hObject, eventdata, handles)
% hObject    handle to test4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global angle
angle = [get(handles.test1,'value') get(handles.test2,'value') get(handles.test3,'value')...
    get(handles.test4,'value') get(handles.test5,'value') get(handles.test6,'value')];
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function test4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function theta5_Callback(hObject, eventdata, handles)
% hObject    handle to theta5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta5 as text
%        str2double(get(hObject,'String')) returns contents of theta5 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function theta5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d5_Callback(hObject, eventdata, handles)
% hObject    handle to d5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d5 as text
%        str2double(get(hObject,'String')) returns contents of d5 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function d5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a5_Callback(hObject, eventdata, handles)
% hObject    handle to a5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a5 as text
%        str2double(get(hObject,'String')) returns contents of a5 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function a5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha5_Callback(hObject, eventdata, handles)
% hObject    handle to alpha5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha5 as text
%        str2double(get(hObject,'String')) returns contents of alpha5 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function alpha5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sigma5.
function sigma5_Callback(hObject, eventdata, handles)
% hObject    handle to sigma5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sigma5
updateplot(hObject, eventdata, handles)


function min5_Callback(hObject, eventdata, handles)
% hObject    handle to min5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min5 as text
%        str2double(get(hObject,'String')) returns contents of min5 as a double
if get(handles.sigma5,'value') == 0
    set(handles.test5,'Min',deg2rad(str2num(get(handles.min5,'string'))));
else
    set(handles.test5,'Min',str2num(get(handles.min5,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function min5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max5_Callback(hObject, eventdata, handles)
% hObject    handle to max5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max5 as text
%        str2double(get(hObject,'String')) returns contents of max5 as a double
if get(handles.sigma5,'value') == 0
    set(handles.test5,'Max',deg2rad(str2num(get(handles.max5,'string'))));
else
    set(handles.test5,'Max',str2num(get(handles.max5,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function max5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function test5_Callback(hObject, eventdata, handles)
% hObject    handle to test5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global angle
angle = [get(handles.test1,'value') get(handles.test2,'value') get(handles.test3,'value')...
    get(handles.test4,'value') get(handles.test5,'value') get(handles.test6,'value')];
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function test5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function theta6_Callback(hObject, eventdata, handles)
% hObject    handle to theta6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta6 as text
%        str2double(get(hObject,'String')) returns contents of theta6 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function theta6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d6_Callback(hObject, eventdata, handles)
% hObject    handle to d6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d6 as text
%        str2double(get(hObject,'String')) returns contents of d6 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function d6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a6_Callback(hObject, eventdata, handles)
% hObject    handle to a6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a6 as text
%        str2double(get(hObject,'String')) returns contents of a6 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function a6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha6_Callback(hObject, eventdata, handles)
% hObject    handle to alpha6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha6 as text
%        str2double(get(hObject,'String')) returns contents of alpha6 as a double
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function alpha6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sigma6.
function sigma6_Callback(hObject, eventdata, handles)
% hObject    handle to sigma6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sigma6
updateplot(hObject, eventdata, handles)


function min6_Callback(hObject, eventdata, handles)
% hObject    handle to min6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min6 as text
%        str2double(get(hObject,'String')) returns contents of min6 as a double
if get(handles.sigma5,'value') == 0
    set(handles.test6,'Min',deg2rad(str2num(get(handles.min6,'string'))));
else
    set(handles.test6,'Min',str2num(get(handles.min6,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function min6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max6_Callback(hObject, eventdata, handles)
% hObject    handle to max6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max6 as text
%        str2double(get(hObject,'String')) returns contents of max6 as a double
if get(handles.sigma5,'value') == 0
    set(handles.test6,'Max',deg2rad(str2num(get(handles.max6,'string'))));
else
    set(handles.test6,'Min',str2num(get(handles.min6,'string')));
end
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function max6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function test6_Callback(hObject, eventdata, handles)
% hObject    handle to test6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global angle
angle = [get(handles.test1,'value') get(handles.test2,'value') get(handles.test3,'value')...
    get(handles.test4,'value') get(handles.test5,'value') get(handles.test6,'value')];
updateplot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function test6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function robotname_Callback(hObject, eventdata, handles)
% hObject    handle to robotname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robotname as text
%        str2double(get(hObject,'String')) returns contents of robotname as a double

roboname = get(handles.robotname,'string');
roboname = regexprep(roboname,'[^\w'']','');
set(handles.robotname,'string',roboname);


% --- Executes during object creation, after setting all properties.
function robotname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robotname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mintemp_Callback(hObject, eventdata, handles)
% hObject    handle to mintemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mintemp as text
%        str2double(get(hObject,'String')) returns contents of mintemp as a double


% --- Executes during object creation, after setting all properties.
function mintemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mintemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxtemp_Callback(hObject, eventdata, handles)
% hObject    handle to maxtemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxtemp as text
%        str2double(get(hObject,'String')) returns contents of maxtemp as a double


% --- Executes during object creation, after setting all properties.
function maxtemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxtemp (see GCBO)
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


% --- Executes on button press in addrobot.
function addrobot_Callback(hObject, eventdata, handles)
% hObject    handle to addrobot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% tasklistold = get(handles.robotlist,'string');
% tasklistnew = strvcat(tasklistold, 'newrobot');
% set(handles.robotlist,'string',tasklistnew);

filename = get(handles.lib,'string');
fid = fopen(filename,'at');

fprintf(fid, '\n'); 
C = 'noname 6 1 10 5 40 70';
fprintf(fid, '%s\n', C); 
C = '0 10 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s', C); 

fclose(fid);

updatelist(hObject, eventdata, handles)

% --- Executes on button press in saverobot.
function saverobot_Callback(hObject, eventdata, handles)
% hObject    handle to saverobot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = get(handles.lib,'string');
fid = fopen(filename,'at');
joints = str2num(get(handles.jointnumb,'string'));

str = '1';

try
    str2 = strjoin(get(handles.tasklist2,'string'));
catch
    str2 = cellstr(get(handles.tasklist2,'string'));
end


if isempty(strfind(str2,'welding')) == false
    str = strcat(str,'w');
end
if isempty(strfind(str2,'glueing')) == false
    str = strcat(str,'g');
end
if isempty(strfind(str2,'assembly')) == false
    str = strcat(str,'a');
end
if isempty(strfind(str2,'painting')) == false
    str = strcat(str,'p');
end
if isempty(strfind(str2,'packing')) == false
    str = strcat(str,'k');
end
if isempty(strfind(str2,'tending')) == false
    str = strcat(str,'t');
end

fprintf(fid, '\n');

roboname = get(handles.robotname,'string');
roboname = regexprep(roboname,'[^\w'']','');

C = strcat(roboname,{' '},get(handles.jointnumb,'string'),{' '},...
    str,{' '},get(handles.payload,'string'),{' '},...
    get(handles.mintemp,'string'),{' '},get(handles.maxtemp,'string'),{' '},...
    get(handles.noise,'string'));
fprintf(fid, '%s\n', C{1});

if get(handles.sigma1,'value') == 0
    C = strcat(get(handles.theta1,'string'),{' '},get(handles.d1,'string'),{' '},...
        get(handles.a1,'string'),{' '},get(handles.alpha1,'string'),{' '},...
        num2str(get(handles.sigma1,'value')),{' '},...
        num2str(deg2rad(str2num(get(handles.min1,'string')))),{' '},...
        num2str(deg2rad(str2num(get(handles.max1,'string')))));
else
    C = strcat(get(handles.theta1,'string'),{' '},get(handles.d1,'string'),{' '},...
        get(handles.a1,'string'),{' '},get(handles.alpha1,'string'),{' '},...
        num2str(get(handles.sigma1,'value')),{' '},...
        get(handles.min1,'string'),{' '},...
        get(handles.max1,'string'));
end
fprintf(fid, '%s\n', C{1});

if joints > 1;
    if get(handles.sigma2,'value') == 0
    C = strcat(get(handles.theta2,'string'),{' '},get(handles.d2,'string'),{' '},...
        get(handles.a2,'string'),{' '},get(handles.alpha2,'string'),{' '},...
        num2str(get(handles.sigma2,'value')),{' '},...
        num2str(deg2rad(str2num(get(handles.min2,'string')))),{' '},...
        num2str(deg2rad(str2num(get(handles.max2,'string')))));
    else
        C = strcat(get(handles.theta2,'string'),{' '},get(handles.d2,'string'),{' '},...
            get(handles.a2,'string'),{' '},get(handles.alpha2,'string'),{' '},...
            num2str(get(handles.sigma2,'value')),{' '},...
            get(handles.min2,'string'),{' '},...
            get(handles.max2,'string'));
    end
    if joints == 2
        fprintf(fid, '%s', C{1});
    else
        fprintf(fid, '%s\n', C{1});
    end
end

if joints > 2;
    if get(handles.sigma3,'value') == 0
        C = strcat(get(handles.theta3,'string'),{' '},get(handles.d3,'string'),{' '},...
            get(handles.a3,'string'),{' '},get(handles.alpha3,'string'),{' '},...
            num2str(get(handles.sigma3,'value')),{' '},...
            num2str(deg2rad(str2num(get(handles.min3,'string')))),{' '},...
            num2str(deg2rad(str2num(get(handles.max3,'string')))));
    else
        C = strcat(get(handles.theta3,'string'),{' '},get(handles.d3,'string'),{' '},...
            get(handles.a3,'string'),{' '},get(handles.alpha3,'string'),{' '},...
            num2str(get(handles.sigma3,'value')),{' '},...
            get(handles.min3,'string'),{' '},...
            get(handles.max3,'string'));
    end
    if joints == 3
        fprintf(fid, '%s', C{1});
    else
        fprintf(fid, '%s\n', C{1});
    end
end

if joints > 3;
    if get(handles.sigma4,'value') == 0
        C = strcat(get(handles.theta4,'string'),{' '},get(handles.d4,'string'),{' '},...
            get(handles.a4,'string'),{' '},get(handles.alpha4,'string'),{' '},...
            num2str(get(handles.sigma4,'value')),{' '},...
            num2str(deg2rad(str2num(get(handles.min4,'string')))),{' '},...
            num2str(deg2rad(str2num(get(handles.max4,'string')))));
    else
        C = strcat(get(handles.theta4,'string'),{' '},get(handles.d4,'string'),{' '},...
            get(handles.a4,'string'),{' '},get(handles.alpha4,'string'),{' '},...
            num2str(get(handles.sigma4,'value')),{' '},...
            get(handles.min4,'string'),{' '},...
            get(handles.max4,'string'));
    end
    if joints == 4
        fprintf(fid, '%s', C{1});
    else
        fprintf(fid, '%s\n', C{1});
    end
end

if joints > 4;
    if get(handles.sigma5,'value') == 0
        C = strcat(get(handles.theta5,'string'),{' '},get(handles.d5,'string'),{' '},...
            get(handles.a5,'string'),{' '},get(handles.alpha5,'string'),{' '},...
            num2str(get(handles.sigma5,'value')),{' '},...
            num2str(deg2rad(str2num(get(handles.min5,'string')))),{' '},...
            num2str(deg2rad(str2num(get(handles.max5,'string')))));
    else
        C = strcat(get(handles.theta5,'string'),{' '},get(handles.d5,'string'),{' '},...
            get(handles.a5,'string'),{' '},get(handles.alpha5,'string'),{' '},...
            num2str(get(handles.sigma5,'value')),{' '},...
            get(handles.min5,'string'),{' '},...
            get(handles.max5,'string'));
    end
    if joints == 5
        fprintf(fid, '%s', C{1});
    else
        fprintf(fid, '%s\n', C{1});
    end
end

if joints > 5;
    if get(handles.sigma6,'value') == 0
        C = strcat(get(handles.theta6,'string'),{' '},get(handles.d6,'string'),{' '},...
            get(handles.a6,'string'),{' '},get(handles.alpha6,'string'),{' '},...
            num2str(get(handles.sigma6,'value')),{' '},...
            num2str(deg2rad(str2num(get(handles.min6,'string')))),{' '},...
            num2str(deg2rad(str2num(get(handles.max6,'string')))));
    else
        C = strcat(get(handles.theta6,'string'),{' '},get(handles.d6,'string'),{' '},...
            get(handles.a6,'string'),{' '},get(handles.alpha6,'string'),{' '},...
            num2str(get(handles.sigma6,'value')),{' '},...
            get(handles.min6,'string'),{' '},...
            get(handles.max6,'string'));
    end
    fprintf(fid, '%s', C{1});
end

fclose(fid);

delete(hObject, eventdata, handles)
robotlist_Callback(hObject, eventdata, handles)


% --- Executes on button press in newlib.
function newlib_Callback(hObject, eventdata, handles)
% hObject    handle to newlib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uiputfile({'*.txt'},'Create new library');

fid = fopen(filename,'at');

%fprintf(fid, '\n'); 
C = 'noname 6 1 10 5 40 70';
fprintf(fid, '%s\n', C); 
C = '0 10 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s\n', C);
C = '0 0 0 0 0 0 0';
fprintf(fid, '%s', C); 

fclose(fid);

set(handles.lib,'string',filename);

updatelist(hObject, eventdata, handles)
robotlist_Callback(hObject, eventdata, handles)


% --- Executes on button press in deleterobot.
function deleterobot_Callback(hObject, eventdata, handles)
% hObject    handle to deleterobot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Are you sure?', ...
    'Delete robot', ...
    'Yes','No','No');
switch choice
    case 'Yes'
        delete(hObject, eventdata, handles)
    case 'No'
end



function delete(hObject, eventdata, handles)

filename = get(handles.lib,'string');
fid = fopen(filename);
robot = get(handles.robotlist,'string');
robot = cellstr(robot);
robotid = get(handles.robotlist,'value');
robotname = robot(robotid);

C = textscan(fid,'%s %s %s %s %s %s %s %s');
fclose(fid);

fin = fopen(filename);
fout = fopen('temp.txt', 'wt');
tline = fgetl(fin);

j = 0;
i = 0;
pointer1 = 0;

while i == 0;
    try
        %find next robot name and joint number
        robotname2 = C{1}{1+pointer1};
        joints = str2num(C{2}{1+pointer1});
        
        %check if robot names match
        if (strcmp(robotname,robotname2) == true)
            
            %robot found. Delete robot
            disp('Deleted:')
            count = 0;
            while ischar(tline) && count <= joints
                disp(tline)
                tline = fgetl(fin);
                count = count + 1;
            end
            
            %save rest of the file
            while ischar(tline)
                if pointer1 == 0 && j == 0
                    fprintf(fout, '%s', tline);
                else
                    if ischar(tline)
                        fprintf(fout, '\n');
                        fprintf(fout, '%s', tline);
                    end
                end
                if ischar(tline)
                    tline = fgetl(fin);
                end
                j = 1;
            end
            
            %prevent listbox disappear bug
            if length(robot)<1;
                return;
            end;
            robot(robotid)=[];
            val=robotid-1;
            if val<1;
                val=1;
            end
            set(handles.robotlist,'String',robot,'Value',val);
            i = 2;
        else
            
            %robot not found yet
            k = 0;
            %skip current robot
            while k <= joints;
                if pointer1 == 0 && j == 0
                    if ischar(tline)
                        fprintf(fout, '%s', tline);
                    end
                else
                    if ischar(tline)
                        fprintf(fout, '\n');
                        fprintf(fout, '%s', tline);
                    end
                end
                if ischar(tline)
                    tline = fgetl(fin);
                end
                j = 1;
                k = k + 1;
            end
            pointer1 = pointer1 + joints+ 1;
        end
    catch
        i = 1;
    end
end

fclose(fin);
fclose(fout);

fout = fopen(filename, 'wt');
fin = fopen('temp.txt');

tline = fgetl(fin);

j = 0;

%copy temp to original file
while ischar(tline)
    if j == 0
        if ischar(tline)
            fprintf(fout, '%s', tline);
        end
    else
        if ischar(tline)
            fprintf(fout, '\n');
            fprintf(fout, '%s', tline);
        end
    end
    if ischar(tline)
        tline = fgetl(fin);
    end
    j = 1;
end

fclose(fin);
fclose(fout);

updatelist(hObject, eventdata, handles)

function jointnumb_Callback(hObject, eventdata, handles)
% hObject    handle to jointnumb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jointnumb as text
%        str2double(get(hObject,'String')) returns contents of jointnumb as a double
updatejoints(hObject, eventdata, handles)
updateplot(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function jointnumb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jointnumb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tasklist1.
function tasklist1_Callback(hObject, eventdata, handles)
% hObject    handle to tasklist1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tasklist1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tasklist1


% --- Executes during object creation, after setting all properties.
function tasklist1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tasklist1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tasklist2.
function tasklist2_Callback(hObject, eventdata, handles)
% hObject    handle to tasklist2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tasklist2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tasklist2


% --- Executes during object creation, after setting all properties.
function tasklist2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tasklist2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addtask.
function addtask_Callback(hObject, eventdata, handles)
% hObject    handle to addtask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
task = get(handles.tasklist1,'string');
task = cellstr(task);
taskid = get(handles.tasklist1,'value');

seltask = task(taskid);
seltask = [get(handles.tasklist2,'string'); seltask];

set(handles.tasklist2,'string',seltask);



% --- Executes on button press in removetask.
function removetask_Callback(hObject, eventdata, handles)
% hObject    handle to removetask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tasklist2,'value',1);
set(handles.tasklist2,'string',[]);


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


% --- Executes on button press in savelib.
function savelib_Callback(hObject, eventdata, handles)
% hObject    handle to savelib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uiputfile({'*.txt'},'Save as robot library');
filenamein = get(handles.lib,'string');

fout = fopen(filename, 'wt');
fin = fopen(filenamein);

tline = fgetl(fin)
j = 0;

while ischar(tline)
    if j == 0
        if ischar(tline)
            fprintf(fout, '%s', tline);
        end
    else
        if ischar(tline)
            fprintf(fout, '\n');
            fprintf(fout, '%s', tline);
        end
    end
    if ischar(tline)
        tline = fgetl(fin);
    end
    j = 1;
end

fclose(fin);
fclose(fout);

set(handles.lib,'string',filename);

updatelist(hObject, eventdata, handles)
robotlist_Callback(hObject, eventdata, handles)
