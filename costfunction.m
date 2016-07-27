
function [cost] = costfunction(robot,qi,ig,jg,kg)
%   Cost-function
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% This function calculates a cost value for robot end-effector to goal
% frame
%
% Input: Robot, robot position vector, goal frame vectors (ig jg kg)
%
% Output: value of cost-function
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots

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

robotee = robot.base;

%find robot end-effector location
for i = 1:joints
    link = eval(sprintf('rLink%d', i));
    robotee = robotee*link.A(qi(i));
end

%create robot frame
ir = robotee*[1 0 0 50; 0 1 0 0; 0 0 1 0; 0 0 0 1];
jr = robotee*[1 0 0 0; 0 1 0 50; 0 0 1 0; 0 0 0 1];
kr = robotee*[1 0 0 0; 0 1 0 0; 0 0 1 50; 0 0 0 1];

%calculate distances between axes of frames
disti = sqrt((ig(1)-ir(1,4))^2+(ig(2)-ir(2,4))^2+(ig(3)-ir(3,4))^2);
distj = sqrt((jg(1)-jr(1,4))^2+(jg(2)-jr(2,4))^2+(jg(3)-jr(3,4))^2);
distk = sqrt((kg(1)-kr(1,4))^2+(kg(2)-kr(2,4))^2+(kg(3)-kr(3,4))^2);
cost = sqrt((disti)^2+(distj)^2+(distk)^2);

