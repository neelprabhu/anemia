% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Consume O2 and glucose, alter ion concentrations, remove water.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bKid: Blood parameters out of kidney
%   fK  : Flow in/out.

function [bKid,fK] = kidney(b)

bKid = respir(b);

end