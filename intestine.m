% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Intestine: Consume nutrients, add water, ions, and glucose into blood.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bInt: Blood parameters out of intestine.
%   fI  : Flow in/out.

function [bInt,fI] = intestine(b)

bInt = b;
b.gluc = 300;
end