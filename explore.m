function [qi,landmark] = explore(robot1,landmark,X,Y,Z,colres)

%   EXPLORE
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% This function creates random starting positions as far from previous
% landmarks as possible. This function also checks joint limits and
% collisions
%
% Input: robot, previous landmarks, environment points (X,Y,Z), collision
% distance
% Output: new robot joint values, updated landmark matrix
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots

joints = robot1.n;

if joints >= 1
    rLink1 = robot1.links(1);
end
if joints >= 2
    rLink2 = robot1.links(2);
end
if joints >= 3
    rLink3 = robot1.links(3);
end
if joints >= 4
    rLink4 = robot1.links(4);
end
if joints >= 5
    rLink5 = robot1.links(5);
end
if joints >= 6
    rLink6 = robot1.links(6);
end

ii = 1;
q0 = [0];
markmaxdist = 0;

%create angle vector with right size
for l = 1:(joints-1)
    q0 = [q0 0];
end

%generate 10 potentioal landmarks
while ii <= 10
    %randomize joints to create an embryo
    for i = 1:joints
        link = eval(sprintf('rLink%d', i));
        rand1 = (link.qlim(2)-link.qlim(1))*rand(1);
        rand1 = rand1 + link.qlim(1);
        q0(i) = rand1;
        fordw = robot1.fkine(q0);
    end
    landmarks = size(landmark);
    markdist = 9999999;
    %collision detection
    [P] = robotpointgen(robot1,q0,50);
    [~,mindist] = distancecalc(X,Y,Z,P);
    if mindist > colres
        %measure distance to closest landmark
        for i = 1:landmarks(1)
            markdist0 = sqrt((fordw(1,4)-landmark(i,1))^2+ ...
                (fordw(2,4)-landmark(i,2))^2+(fordw(3,4)-landmark(i,3))^2);
            if markdist0 < markdist
                markdist = markdist0;
            end
        end
        %set embryo with longest distance to other landmarks as
        %new landmark
        if markdist > markmaxdist
            markmaxdist = markdist;
            landmark0 = [fordw(1,4) fordw(2,4) fordw(3,4)];
            qi = q0;
        end
        ii = ii+1;
    end
end
% hold on
% plot3(landmark0(1),landmark0(2),landmark0(3),'kx')
landmark = [landmark; landmark0];
