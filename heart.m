% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Heart: Consume O2 and glucose, establish flow rate through body.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bHeart: Blood parameters out of heart (post-metabolism).
%   fH    : Flow in/out.

function [bHeart,fH] = heart(b)

    % Max cardiac output will be 15 L/min, very severe anemia.
    oxNeed = b.oxNeed; % Number from 0 (SS) to 100 (severe anemia).
    b.cOut = (15000 - 5000)./100 .* oxNeed + 5000; % mL/min
    
    bHeart = b;
    fH     = b.dist(1) .* b.cOut;
end

% new function to calculate heart rate
% new change, adding some more functions