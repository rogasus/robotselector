function [q0,S, cost, mindist,iter] = search(robot1,angles,ig,jg,kg,X,Y,Z,colres,iterlimit,costres,ikdir,num)
%   SEARCH
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% This function finds inverse kinematic solution avoiding obstacles
%
% Input: robot, joint values, goal frame in vectors (ig jg kg),
% obstacle points (X Y Z), collision distance, iteration limit, cost
% function limit, inverse kinematic direction, iteration sustainability
% factor
%
% Output: Robot joint value vector, coordinates of closest collision
% points, cost function, minimum distance to environment, number of
% iterations
%
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots
%
% tool tested with Robotic toolbox version 9.7

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

q0 = angles;
dir = -1;
k = 1;
prevcost = 999999;

while k <= iterlimit
    
    % set joint iteration direction
    if ikdir == 1
        i = robot1.n;
    else
        i = 1; 
    end
        
    qi=q0;
    
    % for each joint
    while (i ~= 0 && i ~= (robot1.n+1))
        
        qs = qi(i);
        limits = [0 0];
        ii = 0;
        link = eval(sprintf('rLink%d', i));
        qv = qi;
        sigma = link.sigma;
        
        prismlenght = sqrt((link.qlim(2)-link.qlim(1))^2);
        
        if prismlenght < costres
            prismlenght = costres;
        end
        
        % find joint limits
        rot = 10;
        while ii < 2
            
            if sigma == 0
                qij = qi(i)+deg2rad(rot)*dir;
            else
                qij = qi(i)+rot*dir*(prismlenght/costres);
            end
            
            % test collision
            qv(i) = qij;
            [P] = robotpointgen(robot1,qv,50);
            [S,mindist] = distancecalc(X,Y,Z,P);
            collision = 0;
            if mindist < colres
                collision = 1;
            end

            %limit found
            if or(or(qij < link.qlim(1), qij > link.qlim(2)),collision == 1)
                
                % collision! set limit here
                if collision == 1
                    rot = 0;
                end
                
                % try with smaller movement
                if rot > 1
                    rot = 1;

                % set limit and change direction
                else
                    ii = ii+1;
                    limits(ii) = qi(i);
                    dir = dir*(-1);
                    rot = 10;
                    if ii == 1
                        qi(i) = qs;
                    end
                end
            else
                % place free
                qi(i) = qij;
            end
        end

        
        % find and move to cost function local minimum
        qij = qi(i);
        rot = 10;
        cost0=999999;
        prismlenght = sqrt((limits(2)-limits(1))^2);
        prev = 1;
        fr = 1;
        co = 0;
        
        if prismlenght < costres
            prismlenght = costres;
        end
        
        while qij > limits(1)
            
            % update joint movement
            if sigma == 0
                qij = qij+deg2rad(rot)*dir;
            else
                qij = qij+rot*dir*(prismlenght/(2*costres));
            end

            qv(i) = qij;
            
            % calculate cost function
            [cost] = costfunction(robot1,qv,ig,jg,kg);
            
            % local minimum near, return back and slow down
            if prev == 1 && cost > cost0 && co == 0
                if sigma == 0
                    qij = qij-deg2rad(rot)*dir;
                    if fr == 0;
                        qij = qij-deg2rad(rot)*dir;
                        co = co+10;
                    end
                else
                    qij = qij-rot*dir*(prismlenght/(2*costres));
                    if fr == 0;
                        qij = qij-rot*dir*(prismlenght/(2*costres));
                        co = co+10;
                    end
                end
                rot = 1;
                co = co+10;
            end          
             
            fr = 0;
            
            if cost <= cost0
                %set this position as closest one
                cost0 = cost;
                qi(i) = qij;
                prev = 1;
            else
                %no local minimum near, speed up
                if prev == 0 
                    if co == 0;
                        rot = 10;
                    else 
                        co = co-1;
                    end
                end
                prev = 0;
            end
        end
        
        if ikdir == 1
            i = i-1;
        else
            i = i+1;
        end
    end
    
    % calculate cost function
    [cost] = costfunction(robot1,qi,ig,jg,kg);
        
    % end search
    % position found or iterations does not improve results enough
    if or(or(q0 == qi,cost<costres),prevcost-cost <= costres/num)
        iter = k;
        k = iterlimit+1;
        [P] = robotpointgen(robot1,qi,50);
        [S,mindist] = distancecalc(X,Y,Z,P);
    end
    
    % iteration limit exceeded
    if k == iterlimit
        iter = k;
        [P] = robotpointgen(robot1,qi,50);
        [S,mindist] = distancecalc(X,Y,Z,P);    
    end
    
    k = k+1;
    prevcost = cost;
    q0 = qi;
end
