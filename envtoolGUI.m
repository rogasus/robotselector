%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ENVIRONMENT BUILDER
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

function varargout = envtoolGUI(varargin)
% ENVTOOLGUI MATLAB code for envtoolGUI.fig
%      ENVTOOLGUI, by itself, creates a new ENVTOOLGUI or raises the existing
%      singleton*.
%
%      H = ENVTOOLGUI returns the handle to a new ENVTOOLGUI or the handle to
%      the existing singleton*.
%
%      ENVTOOLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENVTOOLGUI.M with the given input arguments.
%
%      ENVTOOLGUI('Property','Value',...) creates a new ENVTOOLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before envtoolGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to envtoolGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help envtoolGUI

% Last Modified by GUIDE v2.5 03-Mar-2016 18:59:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @envtoolGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @envtoolGUI_OutputFcn, ...
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


% --- Executes just before envtoolGUI is made visible.
function envtoolGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to envtoolGUI (see VARARGIN)

% Choose default command line output for envtoolGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes envtoolGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
plot3(0,0,0)
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal
global V
global F
global i
global preview
global shape
shape = 12:1;
V = 3:1;
F = 3:1;
i = 0;

% --- Outputs from this function are returned to the command line.
function varargout = envtoolGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_Callback(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1 as text
%        str2double(get(hObject,'String')) returns contents of y1 as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z1_Callback(hObject, eventdata, handles)
% hObject    handle to z1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z1 as text
%        str2double(get(hObject,'String')) returns contents of z1 as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function z1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2 as text
%        str2double(get(hObject,'String')) returns contents of y2 as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z2_Callback(hObject, eventdata, handles)
% hObject    handle to z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z2 as text
%        str2double(get(hObject,'String')) returns contents of z2 as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function z2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addshape.
function addshape_Callback(hObject, eventdata, handles)
% hObject    handle to addshape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global V
global F
global i
global preview
global shape

% get values 
xa = str2num(get(handles.x1,'string'));
xb = str2num(get(handles.x2,'string'));
ya = str2num(get(handles.y1,'string'));
yb = str2num(get(handles.y2,'string'));
za = str2num(get(handles.z1,'string'));
zb = str2num(get(handles.z2,'string'));

% calculate and save midpoint
midpoint = [(xa+xb)/2 (ya+yb)/2 (za+zb)/2];

% get rotation values
alpha = deg2rad(str2num(get(handles.alphar,'string')));
beta = deg2rad(str2num(get(handles.betar,'string')));
gamma = deg2rad(str2num(get(handles.gammar,'string')));

% select corners of the rectangle
xco = [xa xa xb xb xa xa xb xb];
yco = [ya ya ya ya yb yb yb yb];
zco = [za zb zb za za zb zb za];

% create variable for rotated coordinates
rotalpha = 1:3;
j = 1;

while j < 9;
    % move to origin to rotate object along itself, not origin
    xco(j) = xco(j)-midpoint(1);
    yco(j) = yco(j)-midpoint(2);
    zco(j) = zco(j)-midpoint(3);
    
    % rotate
    rotalpha = [cos(alpha)*cos(beta)...
        cos(alpha)*sin(beta)*sin(gamma)-sin(alpha)*cos(gamma) ... 
        cos(alpha)*sin(beta)*cos(gamma)+sin(alpha)*sin(gamma);...
        sin(alpha)*cos(beta)...
        sin(alpha)*sin(beta)*sin(gamma)+cos(alpha)*cos(gamma)...
        sin(alpha)*sin(beta)*cos(gamma)-cos(alpha)*sin(gamma);
        -sin(beta) ...
        cos(beta)*sin(gamma) ...
        cos(beta)*cos(gamma)]...
        *[xco(j); yco(j); zco(j)];
    
    % move back to original location
    xco(j) = rotalpha(1,1)+midpoint(1);
    yco(j) = rotalpha(2,1)+midpoint(2);
    zco(j) = rotalpha(3,1)+midpoint(3);
    
    % next point
    j=j+1;
end

% create rectangle matrices
X=[xco(1) xco(1) xco(1) xco(1) xco(5) xco(7) xco(7) xco(7) xco(1) xco(1) xco(7) xco(7); ...
    xco(2) xco(5) xco(5) xco(4) xco(7) xco(8) xco(8) xco(3) xco(2) xco(4) xco(2) xco(2); ...
    xco(6) xco(6) xco(8) xco(8) xco(6) xco(5) xco(4) xco(4) xco(3) xco(3) xco(6) xco(3)];
Y=[yco(1) yco(1) yco(1) yco(1) yco(5) yco(7) yco(7) yco(7) yco(1) yco(1) yco(7) yco(7); ...
    yco(2) yco(5) yco(5) yco(4) yco(7) yco(8) yco(8) yco(3) yco(2) yco(4) yco(2) yco(2); ...
    yco(6) yco(6) yco(8) yco(8) yco(6) yco(5) yco(4) yco(4) yco(3) yco(3) yco(6) yco(3)];
Z=[zco(1) zco(1) zco(1) zco(1) zco(5) zco(7) zco(7) zco(7) zco(1) zco(1) zco(7) zco(7); ...
    zco(2) zco(5) zco(5) zco(4) zco(7) zco(8) zco(8) zco(3) zco(2) zco(4) zco(2) zco(2); ...
    zco(6) zco(6) zco(8) zco(8) zco(6) zco(5) zco(4) zco(4) zco(3) zco(3) zco(6) zco(3)];

% create and update verticle matrix
V0 = [xco(1) yco(1) zco(1);
     xco(2) yco(2) zco(2);
     xco(3) yco(3) zco(3);
     xco(4) yco(4) zco(4);
     xco(5) yco(5) zco(5);     
     xco(6) yco(6) zco(6);
     xco(7) yco(7) zco(7);
     xco(8) yco(8) zco(8)];
 
 V = [V;V0];
 
 % create and update face matrix
 F0 = [5+i*8 6+i*8 1+i*8;
     2+i*8 6+i*8 1+i*8;
     2+i*8 3+i*8 1+i*8;
     4+i*8 3+i*8 1+i*8;
     6+i*8 7+i*8 2+i*8;
     3+i*8 7+i*8 2+i*8;
     6+i*8 7+i*8 5+i*8;
     8+i*8 7+i*8 5+i*8;
     8+i*8 7+i*8 4+i*8;
     3+i*8 7+i*8 4+i*8;
     4+i*8 1+i*8 8+i*8;
     5+i*8 1+i*8 8+i*8];
 
 F = [F;F0];

 % remove preview rectangle
 delete(preview)
 
 % increase amount of shapes
i = i+1;

C=['b'];
hold on

% draw new shape
shape = [shape fill3(X,Y,Z,C)];


% --- Executes on button press in clearall.
function clearall_Callback(hObject, eventdata, handles)
% hObject    handle to clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold off
plot3(0,0,0)
clear all
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal
global i
i = 0;
global F
F = 3:1;
global V
V = 3:1;


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F
global V

vert = fliplr(V);
vert = rot90(vert);
face = fliplr(F);
face = rot90(face);

[filename pathname] = uiputfile({'*.obj'},'Save format as');
filename = fopen(filename,'w');
fprintf(filename, 'v %4d %4d %4d\r\n', vert);
fprintf(filename, 'f %4d %4d %4d\r\n', face);
fclose(filename);



function alphar_Callback(hObject, eventdata, handles)
% hObject    handle to alphar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphar as text
%        str2double(get(hObject,'String')) returns contents of alphar as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function alphar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betar_Callback(hObject, eventdata, handles)
% hObject    handle to betar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betar as text
%        str2double(get(hObject,'String')) returns contents of betar as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function betar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammar_Callback(hObject, eventdata, handles)
% hObject    handle to gammar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammar as text
%        str2double(get(hObject,'String')) returns contents of gammar as a double
updateprew(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function gammar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updateprew(hObject, eventdata, handles)
global preview

delete(preview)

xa = str2num(get(handles.x1,'string'));
xb = str2num(get(handles.x2,'string'));
ya = str2num(get(handles.y1,'string'));
yb = str2num(get(handles.y2,'string'));
za = str2num(get(handles.z1,'string'));
zb = str2num(get(handles.z2,'string'));

midpoint = [(xa+xb)/2 (ya+yb)/2 (za+zb)/2];

alpha = deg2rad(str2num(get(handles.alphar,'string')));
beta = deg2rad(str2num(get(handles.betar,'string')));
gamma = deg2rad(str2num(get(handles.gammar,'string')));

xco = [xa xa xb xb xa xa xb xb];
yco = [ya ya ya ya yb yb yb yb];
zco = [za zb zb za za zb zb za];

rotalpha = 1:3;
j = 1;

while j < 9;
    xco(j) = xco(j)-midpoint(1);
    yco(j) = yco(j)-midpoint(2);
    zco(j) = zco(j)-midpoint(3);
    rotalpha = [cos(alpha)*cos(beta)...
        cos(alpha)*sin(beta)*sin(gamma)-sin(alpha)*cos(gamma) ... 
        cos(alpha)*sin(beta)*cos(gamma)+sin(alpha)*sin(gamma);...
        sin(alpha)*cos(beta)...
        sin(alpha)*sin(beta)*sin(gamma)+cos(alpha)*cos(gamma)...
        sin(alpha)*sin(beta)*cos(gamma)-cos(alpha)*sin(gamma);
        -sin(beta) ...
        cos(beta)*sin(gamma) ...
        cos(beta)*cos(gamma)]...
        *[xco(j); yco(j); zco(j)];
    xco(j) = rotalpha(1,1)+midpoint(1);
    yco(j) = rotalpha(2,1)+midpoint(2);
    zco(j) = rotalpha(3,1)+midpoint(3);
    j=j+1;
end

%Kuutio
X=[xco(1) xco(1) xco(1) xco(1) xco(5) xco(7) xco(7) xco(7) xco(1) xco(1) xco(7) xco(7); ...
    xco(2) xco(5) xco(5) xco(4) xco(7) xco(8) xco(8) xco(3) xco(2) xco(4) xco(2) xco(2); ...
    xco(6) xco(6) xco(8) xco(8) xco(6) xco(5) xco(4) xco(4) xco(3) xco(3) xco(6) xco(3)];
Y=[yco(1) yco(1) yco(1) yco(1) yco(5) yco(7) yco(7) yco(7) yco(1) yco(1) yco(7) yco(7); ...
    yco(2) yco(5) yco(5) yco(4) yco(7) yco(8) yco(8) yco(3) yco(2) yco(4) yco(2) yco(2); ...
    yco(6) yco(6) yco(8) yco(8) yco(6) yco(5) yco(4) yco(4) yco(3) yco(3) yco(6) yco(3)];
Z=[zco(1) zco(1) zco(1) zco(1) zco(5) zco(7) zco(7) zco(7) zco(1) zco(1) zco(7) zco(7); ...
    zco(2) zco(5) zco(5) zco(4) zco(7) zco(8) zco(8) zco(3) zco(2) zco(4) zco(2) zco(2); ...
    zco(6) zco(6) zco(8) zco(8) zco(6) zco(5) zco(4) zco(4) zco(3) zco(3) zco(6) zco(3)];

C=['r'];
hold on
preview = fill3(X,Y,Z,C);
set(preview,'facealpha',.3);


% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i
global F
global V
global shape

if i > 0;

delete(shape(:,i));
shape(:,i) = [];

j = 0;

while j<12;
F(i*12-j,:) = [];
    if j < 8;
    V(i*8-j,:) = [];
    end
    j=j+1;
end

i = i-1;
updateprew(hObject, eventdata, handles)
end
