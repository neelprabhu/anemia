% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Lung: Remove CO2 from blood, add O2 via hemoglobin. No consumption.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bLung: Blood parameters out of lung.
%   fL   : Flow in/out.

function [bLung] = lungs(b)

    % All-or-none binding of O2 to hemoglobin using saturation curve model
    sat   = @(po2) 85./(0.89 + exp(-0.1037.*(po2-27.63))); % Hb saturation (%)
    
    % Calculate total oxygen content, including Hb and dissolved
    CaO2  = @(SaO2,Hb,PaO2) (SaO2.*Hb.*1.34)+(.003.*PaO2);  % Total O2 (mL/dL blood)
    
    % Baseline values
    Hb    = b.hemo.*100; % Hemoglobin in g/dL;
    MWHb  = 64458;       % Molecular weight hemoglobin (g/mol)
    PAO2  = 100; % Alveolar O2 pressure (mmHg), probably constant
    PaO2  = 95;  % Arterial O2 pressure (mmHg), function of fixed duration diffusion
    PvO2  = 40;  % Venous O2 pressure (mmHg), constant?
    PaCO2 = 40;  % Arterial CO2 pressure (mmHg), constant
    
    % Diffusion first order ODE
    tspan = [0 1000]; % ms
    O20    = PvO2;     % Initial O2 before oxygenation
    [t,y] = ode45(@(t,y) 2*t, tspan, O20);
    
    b.sat   = sat(PaO2); % Calculate and store Hb saturation
    b.o2    = CaO2(b.sat,Hb,PaO2) ./ 1000; % Calculate total oxygen content (mL/mL)
    b.paO2  = PaO2;      % Store information about arterial O2
    b.paCO2 = PaCO2;     % Store information about arterial CO2
    
    % Solve for concentration O2
    concO2hemo = b.hemo .* (1./MWHb) .* 4;
    concO2diss = PaO2 .* 0.003 ./ 100 .* PaO2 ./ (8.314e6)./ (310);
    b.concO2   = (concO2hemo + concO2diss) .* 32; % g O2/ml blood
    b.concCO2  = 1.012e-3; % g CO2/mL
    
    % Reintegrate for outflow back to heart.   
    fL    = b.cOut .* 1;
    bLung = b;
end