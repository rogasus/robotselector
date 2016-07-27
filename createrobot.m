function [testrobot,pointer1] = createrobot(hObject, eventdata, handles,C,pointer1,joints)
%   Robot creator
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% This function creates robot from given data
%
% Input: datamatrix, pointer value, robot joints 
% Output: robot, pointer value
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots

% set robot parameters
rLink1 = Link([str2num(C{1}{1+pointer1}) str2num(C{2}{1+pointer1}) ...
    str2num(C{3}{1+pointer1}) str2num(C{4}{1+pointer1}) str2num(C{5}{1+pointer1})]);
rLink1.qlim = [str2num(C{6}{1+pointer1}),str2num(C{7}{1+pointer1})];
pointer1 = pointer1 + 1;
if joints > 1;
    rLink2 = Link([str2num(C{1}{1+pointer1}) str2num(C{2}{1+pointer1}) ...
        str2num(C{3}{1+pointer1}) str2num(C{4}{1+pointer1}) str2num(C{5}{1+pointer1})]);
    rLink2.qlim = [str2num(C{6}{1+pointer1}),str2num(C{7}{1+pointer1})];
    pointer1 = pointer1 + 1;
    if joints > 2;
        rLink3 = Link([str2num(C{1}{1+pointer1}) str2num(C{2}{1+pointer1}) ...
            str2num(C{3}{1+pointer1}) str2num(C{4}{1+pointer1}) str2num(C{5}{1+pointer1})]);
        rLink3.qlim = [str2num(C{6}{1+pointer1}),str2num(C{7}{1+pointer1})];
        pointer1 = pointer1 + 1;
        if joints > 3;
            rLink4 = Link([str2num(C{1}{1+pointer1}) str2num(C{2}{1+pointer1}) ...
                str2num(C{3}{1+pointer1}) str2num(C{4}{1+pointer1}) str2num(C{5}{1+pointer1})]);
            rLink4.qlim = [str2num(C{6}{1+pointer1}),str2num(C{7}{1+pointer1})];
            pointer1 = pointer1 + 1;
            if joints > 4;
                rLink5 = Link([str2num(C{1}{1+pointer1}) str2num(C{2}{1+pointer1}) ...
                    str2num(C{3}{1+pointer1}) str2num(C{4}{1+pointer1}) str2num(C{5}{1+pointer1})]);
                rLink5.qlim = [str2num(C{6}{1+pointer1}),str2num(C{7}{1+pointer1})];
                pointer1 = pointer1 + 1;
                if joints > 5;
                    rLink6 = Link([str2num(C{1}{1+pointer1}) str2num(C{2}{1+pointer1}) ...
                        str2num(C{3}{1+pointer1}) str2num(C{4}{1+pointer1}) str2num(C{5}{1+pointer1})]);
                    rLink6.qlim = [str2num(C{6}{1+pointer1}),str2num(C{7}{1+pointer1})];
                    pointer1 = pointer1 + 1;
                end
            end
        end
    end
end

%create robot
if joints == 6;
    testrobot = SerialLink([rLink1 rLink2 rLink3 rLink4 rLink5 rLink6]);
elseif joints == 5;
    testrobot = SerialLink([rLink1 rLink2 rLink3 rLink4 rLink5]);
elseif joints == 4;
    testrobot = SerialLink([rLink1 rLink2 rLink3 rLink4]);
elseif joints == 3;
    testrobot = SerialLink([rLink1 rLink2 rLink3]);
elseif joints == 2;
    testrobot = SerialLink([rLink1 rLink2]);
elseif joints == 1;
    testrobot = SerialLink([rLink1]);
end

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

testrobot.base = transl([robotloca(1) robotloca(2) robotloca(3)]);
testrobot.base = testrobot.base*baserot;