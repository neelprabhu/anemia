% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Kidney: Consume O2 and glucose, alter ion concentrations, remove water.

function [bKid] = kidney(b,cOut)

respfactor = (cOut-5000)./5000 + 1;
bKid = respir(b,respfactor);

if b.i == 10
    bKid.baseO2 = b.concO2; % Set baseline O2 at steady state.
end

if b.i > 20 && b.response
    bKid.oxNeed = abs((b.concO2 - b.basekidO2) .* b.respfactor);
    if bKid.oxNeed > 100
        bKid.oxNeed = 100;
    end
end

% Controlling GFR on each cycle
bKid.GFR = 1.25 .* (100 - bKid.oxNeed); % mL/min 90 is lowest
if bKid.GFR < 90
    bKid.GFR = 90;
end

waterout  = b.concH2O .* bKid.GFR; % Calculations for water out.
totwater  = b.cOut .* .22 .* b.concH2O - waterout;
bKid.h2o  = totwater ./ (b.cOut .* .22);
totalions = b.ions .* b.cOut .* .22 .* .001; % mmol
ionsout   = totalions ./ (b.cOut .* .22 - waterout) .* 1000;
bKid.ions = ionsout;

end