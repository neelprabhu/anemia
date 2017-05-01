% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Consume O2 and glucose, alter ion concentrations, remove water.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bKid: Blood parameters out of kidney
%   fK  : Flow in/out.

function [bKid] = kidney(b)

bKid = respir(b);

if b.i == 10
    bKid.baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20
    bKid.oxNeed = (b.concO2 - b.basekidO2) .* 1;
    if bKid.oxNeed > 100
        bKid.oxNeed = 100;
    end
end

end