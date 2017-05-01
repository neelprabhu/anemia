% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology

function [bElse] = allelse(b,cOut)

respfactor = (cOut-5000)./5000;
bElse = respir(b,respfactor);

if b.i == 10
    bElse.baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20
    bElse.oxNeed = abs((b.concO2 - b.baseelseO2) .* 1);
    if bElse.oxNeed > 100
        bElse.oxNeed = 100;
    end
end

end
