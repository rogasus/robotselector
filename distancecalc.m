function [S,mindist] = distancecalc(X,Y,Z,P)
%   Distance calculator between point and environment
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% This function calculates a distance between point and environment points
%
% Input: point matrix P, environment matrices X, Y and Z
% Output: shortest distance mindist, coordinates of closest points in
% matrix S
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots


S = [];
mindist = 99999999;

j1 = size(P);
j2 = size(X);

k = 1;

while k <= j2(2)
    i = 1;
    while i <= j1(1)
        x = P(i,1);
        y = P(i,2);
        z = P(i,3);
        dist = sqrt((x-X(k))^2+(y-Y(k))^2+(z-Z(k))^2);
        if dist < mindist
            mindist = dist;
            S = [x y z; X(k) Y(k) Z(k)];
        end
        i = i+1;
    end
    k = k+1;
end

end