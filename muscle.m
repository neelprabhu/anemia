% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Muscle: Consumes O2 and glucose, produces CO2 and H2O.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bMus: Blood parameters out of muscle.
%   fM  : Flow in/out.

function [bMus] = muscle(b,cOut)

respfactor = (cOut-5000)./5000 + 1;

bMus = respir(b,respfactor);

if b.i == 10
    bMus.baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20
    bMus.oxNeed = abs((b.concO2 - b.basemusO2) .* 1);
    if bMus.oxNeed > 100
        bMus.oxNeed = 100;
    end
end

end