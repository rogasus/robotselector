function [X,Y,Z] = generatepoints(filename,accur)

%   Environment point generator
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% This function creates set of points from obj file
% Input: filename of model, model accuracy (interval of points in mm)
% Output: X, Y and Z coordinate matrices of points
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots

% get faces and vertices
[V,F] = read_vertices_and_faces_from_obj_file(filename);

% set initial values
j = size(F);
i = j(1,1);

X = [];
Y = [];
Z = [];

while i > 0
    a = F(i, 1);
    b = F(i, 2);
    c = F(i, 3);
    
    %triangle vertices
    point1 = [V(a,1), V(a,2), V(a,3)];
    point2 = [V(b,1), V(b,2), V(b,3)];
    point3 = [V(c,1), V(c,2), V(c,3)];   
    
    %measure edge lenghts
    lenght1 = sqrt((point2(1)-point1(1))^2+(point2(2)-point1(2))^2+(point2(3)-point1(3))^2);
    lenght2 = sqrt((point3(1)-point1(1))^2+(point3(2)-point1(2))^2+(point3(3)-point1(3))^2);
    lenght3 = sqrt((point3(1)-point2(1))^2+(point3(2)-point2(2))^2+(point3(3)-point2(3))^2);
    
    %set pointa opposite to longest edge
    if lenght1 >= lenght2 && lenght1 >= lenght3
        pointa = point3;
        pointb = point2;
        pointc = point1;
        lenghtab = lenght3;
        lenghtac = lenght2;
    elseif lenght2 >= lenght1 && lenght2 >= lenght3
        pointa = point2;
        pointb = point1;
        pointc = point3;
        lenghtab = lenght1;
        lenghtac = lenght3;
    elseif lenght3 >= lenght1 && lenght3 >= lenght2
        pointa = point1;
        pointb = point2;
        pointc = point3;
        lenghtab = lenght1;
        lenghtac = lenght2;
    end
    
    %set vectors
    vector1 = [pointb(1)-pointa(1), pointb(2)-pointa(2), pointb(3)-pointa(3)];
    vector2 = [pointc(1)-pointa(1), pointc(2)-pointa(2), pointc(3)-pointa(3)];  
    
    %set point intervals
    n = lenghtab/accur;
    m = lenghtac/accur;
    
    c1 = 0;
    
    %create points
    while c1*accur < lenghtab
        c2 = 0;
        while c2/m+c1/n < 1
            X = [X pointa(1)+vector1(1)*(c1/n)+vector2(1)*(c2/m)];
            Y = [Y pointa(2)+vector1(2)*(c1/n)+vector2(2)*(c2/m)];
            Z = [Z pointa(3)+vector1(3)*(c1/n)+vector2(3)*(c2/m)];
            c2 = c2 +1;
        end
        c1 = c1+1;
    end
    
    i = i-1;
end

