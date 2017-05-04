% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Marrow: Basal production of RBCs/hemoglobin, small consumption.

function [bBone] = marrow(b,cOut)

respfactor = (cOut-5000)./5000 + 1;
bBone = respir(b,respfactor);

if b.i == 10
    bBone.baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20 && b.response % Compute oxygen need
    bBone.oxNeed = abs((b.concO2 - b.baseboneO2) .* b.respfactor);
    if bBone.oxNeed > 100
        bBone.oxNeed = 100; % Maximum oxygen need is 100.
    end
end

k = bBone.i; % Counter
% Modeling aplastic anemia.
if k<20
    bBone.hemo = 0.150*exp((20-20)*k/100);
else
    bBone.hemo = 0.12+0.15*exp((20-28.1)*k/100);
end
end