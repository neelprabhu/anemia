% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Lung: Remove CO2 from blood, add O2 via hemoglobin. No consumption.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bLung: Blood parameters out of lung.
%   fL   : Flow in/out.

function [bLung, fL] = lungs(b)
    Vdot = b.cOut;
    
    % Use ode45 to solve for diffusion of CO2 out of, O2 into blood (1st
    % order)

    % Apply four-step Adair model for binding of O2 onto hemoglobin?


    % Reintegrate for outflow back to heart.




end