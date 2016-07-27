function [tsk] = tskchar(selapp,tasks)
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
% This function finds task application id character from robot application
% string
%
% Input: selected application, robot taskstring
%
% Output: empty string or int corresponding task character location
%
%
% This tool is part of Master of Science thesis work
% Environment- and task-driven tool for selecting industrial robots
%
% tool tested with Robotic toolbox version 9.7

if (strcmp((selapp),'welding') == true)
    wtask = 'w';
elseif (strcmp(selapp,'assembly') == true)
    wtask = 'a';
elseif (strcmp(selapp,'painting') == true)
    wtask = 'p';
elseif (strcmp(selapp,'packing') == true)
    wtask = 'k';
elseif (strcmp(selapp,'tending') == true)
    wtask = 't';
elseif (strcmp(selapp,'glueing') == true)
    wtask = 'g';
elseif (strcmp(selapp,'any') == true)
    wtask = '1';
else
    wtask = '0';
end
tsk = strfind(tasks,wtask);