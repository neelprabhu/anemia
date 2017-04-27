% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Intestine: Consume nutrients, add water, ions, and glucose into blood.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bInt: Blood parameters out of intestine.
%   fI  : Flow in/out.

function [bInt,fI] = intestine(b)
%Assume consume 300g glucose in a day that is broken down evenly over time
b.glu = b.glu + 1.667 %mol/day
bInt = b

end