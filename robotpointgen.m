function [P] = robotpointgen(robot,angles,accur)
%   Robot point generator
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% This function creates set of points from serial manipulator
% Input: robot, joint values, point interval
% Output: X, Y and Z coordinates in matrix P
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots
%
% tool tested with Robotic toolbox version 9.7

joints = robot.n;

if joints >= 1
    rLink1 = robot.links(1);
end
if joints >= 2
    rLink2 = robot.links(2);
end
if joints >= 3
    rLink3 = robot.links(3);
end
if joints >= 4
    rLink4 = robot.links(4);
end
if joints >= 5
    rLink5 = robot.links(5);
end
if joints >= 6
    rLink6 = robot.links(6);
end

mem = robot.base;
prev = [mem(1,4) mem(2,4) mem(3,4)];
P = [prev];

count = 0;
i = 1;

while i == 1;
    
    %find endpoint of current link
    if count == 0;
        mem = robot.base;
    elseif count == 1;
        mem = robot.base*rLink1.A(angles(1));
    elseif count == 2;
        mem = robot.base*rLink1.A(angles(1))*rLink2.A(angles(2));
    elseif count == 3;
        mem = robot.base*rLink1.A(angles(1))*rLink2.A(angles(2))*rLink3.A(angles(3));
    elseif count == 4;
        mem = robot.base*rLink1.A(angles(1))*rLink2.A(angles(2))*rLink3.A(angles(3))*rLink4.A(angles(4));
    elseif count == 5;
        mem = robot.base*rLink1.A(angles(1))*rLink2.A(angles(2))*rLink3.A(angles(3))*rLink4.A(angles(4))*rLink5.A(angles(5));
    else
        mem = robot.base*rLink1.A(angles(1))*rLink2.A(angles(2))*rLink3.A(angles(3))*rLink4.A(angles(4))*rLink5.A(angles(5))*rLink6.A(angles(6));
    end
    
    %end if last joint
    if count == joints;
        i = 2;
    end
    
    %set current point
    pointv = [mem(1,4) mem(2,4) mem(3,4)];
    
    %calculate distance
    dist = sqrt((pointv(1)-prev(1))^2+(pointv(2)-prev(2))^2+(pointv(3)-prev(3))^2);
    
    %measure distances along axes
    x = -prev(1)+pointv(1);
    y = -prev(2)+pointv(2);
    z = -prev(3)+pointv(3);
    
    n = dist/accur;
    c = 1;
    
    %create points for current link
    while c*accur < dist
        P = [P; prev(1)+c/n*x, prev(2)+c/n*y, prev(3)+c/n*z];
        c = c+1;
    end
    
    P = [P; pointv];
    prev = pointv;
    count = count + 1;
end
end