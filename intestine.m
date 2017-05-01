% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Intestine: Consume nutrients, add water, ions, and glucose into blood.
% INPUTS:
%   b: Master struct with blood parameters out of heart.
% OUTPUTS:
%   bInt: Blood parameters out of intestine.
%   fI  : Flow in/out.

function [bInt] = intestine(b,cOut)

respfactor = (cOut-5000)./5000 + 1;
bInt = respir(b,respfactor);

if b.i == 10
    bInt.baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20
    bInt.oxNeed = abs((b.concO2 - b.baseintO2) .* 1); % Compute oxygen need
    if bInt.oxNeed > 100
        bInt.oxNeed = 100; % Max oxygen need is 100
    end
end

bInt.glu = 0.003214;

end
