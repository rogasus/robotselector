function [qbest,mindist,cost,count,S,success,totaliter] = invkine(robot1,X,Y,Z,ig,jg,kg,colres,costres,searchlimit,marklimit,multidir,num)

%   Inverse kinematic solver with collision avoidance
%
%   ROBOT SELECTION TOOLS
%   https://robotselection.wordpress.com/
%
%   Tampere University of Technology
%
%   ANTTI RUOKONEN
%   antti.ruokone2@gmail.com
%
% Input: robot, obstacle coordinate matrices (x,y,z), goal frame
% vectors(ig,jg,kg), collision distance, cost function limit, iteration
% limit, landmark limit, invkin direction, iteration sustainability factor
% Output: best solution angle vector, minimum distance to obstacles, cost
% function value, number of landmarks, minimum distance coordinates, robot
% suitability value, iteration number
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots

%start timer
%tic

%initialization
count = 0;
cost = 9999999;
landmark = [robot1.base(1,4) robot1.base(2,4) robot1.base(3,4)];
dir = -1;
totaliter = 0;
disp('processing... please wait')
while (cost > costres && count < marklimit)
    
    % EXPLORE
    [qi,landmark] = explore(robot1,landmark,X,Y,Z,colres);
    
    % SEARCH
    for i = 1:multidir
        
        [qi,~,cost1, mindist,iter] = search(robot1,qi,ig,jg,kg,X,Y,Z,colres,searchlimit,costres,dir,num);
      
        totaliter = iter + totaliter;
        
        %update closest solution
        if cost1 < cost
            cost = cost1;
            qbest = qi;
        end
        if multidir == 2 && cost1 > costres
            dir = dir*(-1);
        end
    end
    
    count = count +1;
    
    disp(sprintf('iteration %d out of %d',count,marklimit))
    disp(cost1)
end

[cost] = costfunction(robot1,qbest,ig,jg,kg);

%for results:
[P] = robotpointgen(robot1,qbest,50);
[S,mindist] = distancecalc(X,Y,Z,P);

%display results
if cost <= costres
    success = 1;
else
    success = 0;
end

%for measurement:
%time = toc;
% disp('total time elapsed')
% disp(time)
% disp('collision distance:')
% disp(mindist)
% disp('cost function:')
% disp(cost)
% disp('number of landmarks')
% disp(landmarks(1)-1)
% disp('total iterations')
% disp(totaliter)
% disp('average iterations per landmark')
% disp(totaliter/(landmarks(1)-1))
% disp('average time of landmark')
% disp(time/(landmarks(1)-1))
% disp('average time of iteration')
% disp(time/totaliter)