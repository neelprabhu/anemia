% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Intestine: Consume nutrients, add water, ions, and glucose into blood.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bInt: Blood parameters out of intestine.
%   fI  : Flow in/out.

function [bInt] = intestine(b)

bInt = respir(b);

if b.i == 10
    baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20
    bInt.oxNeed = (b.concO2 - baseO2) .* 1; % Compute oxygen need
    if bInt.oxNeed > 100
        bInt.oxNeed = 100; % Max oxygen need is 100
    end
end

%Assume consume 300g glucose in a day that is broken down evenly over time

b.glu = b.glu + 1.667; %mol/day
end
