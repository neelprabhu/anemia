% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Marrow: Basal production of RBCs/hemoglobin, small consumption.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bBone: Blood parameters out of bone marrow.
%   fB   : Flow in/out.

function [bBone,fB,b.hemo] = marrow(b,i)
if i<20
    b.hemo=0.150*exp((20-20)*i/100)
    else 
    b.hemo=0.12+0.15*exp((20-28.1)*i/100)
    end
    
end