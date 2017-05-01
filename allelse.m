% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology

function [bElse] = allelse(b)

bElse = respir(b);

if b.i == 10
    baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20
    bElse.oxNeed = (b.concO2 - baseO2) .* c;
    if bElse.oxNeed > 100
        bElse.oxNeed = 100;
    end
end

end
