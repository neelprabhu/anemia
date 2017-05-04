% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology

%% Initialize starting parameters of blood and heart
b      = struct;       % All information about blood goes in here
b.cOut = 5000;         % Cardiac output, baseline (mL/min)
b.p    = 1.06;         % Density of blood (g/mL)
b.T    = 37;           % Temperature of blood (C)
b.hemo = .150;         % Hemoglobin mass fraction in blood (g/mL)
b.rbc  = b.hemo;       % Assume RBCs are entirely hemoglobin (~.95)
b.response = 1;        % Cardiac output response
b.respfactor = 262e3;  % Adjust for physiological change in cardiac output

b.concH2O  = .51;               % Water fraction in blood (g H20 / mL blood)
b.concGlu  = .001;              % Mass fraction of glucose in blood (g/mL)
b.ions = [100 5.0 135];         % Ion concentrations, [Cl K Na] (mmol/L)
b.dist = [.04 .15 .22 .05 .20 .34]; % CO Distribution (Heart, Muscle, Kidney, Bone, Intestine, else)
b.oxNeed = 0;

%% Send blood to organs:

for i = 1:100 % Each cycle should be x min, values during cycle change once.
    
    b.i = i;
    % 1. Heart to lungs, lungs to heart (oxygenation phase)
    bLung   = lungs(b);
    
    % 2. Metabolic consumption by heart, change cardiac output
    bHeart  = heart(bLung);
    cOut    = bHeart.cOut;
    
    % 3. Heart to muscle & kidney (consumption, filtration, excretion)
    bMus  = muscle(bLung,cOut);
    bKid  = kidney(bLung,cOut);
    
    % 4. Muscle & kidney to bone (generate RBCs, hemoglobin)
    bBone = marrow(bLung,cOut);
    
    % 5. Bone to small intestine (regain nutrients, plasma)
    bInt  = intestine(bLung,cOut);
    
    % 6. Other stuff
    bElse = allelse(bLung,cOut);
    
    % 7. Mixing function bInt, bBone, bKid, bMus, bHeart.
    b = mix(bHeart, bMus, bKid, bBone, bInt, bElse);
    
    % 8. Record values of previous iteration (minute)
    out(i)      = cOut;
    oxin(i)     = b.concO2;
    oxout(i)    = bLung.concO2;
    totoxout(i) = bLung.concO2 .* cOut;
    co2in(i)    = b.concCO2;
    co2out(i)   = bLung.concCO2;
    glu(i)      = b.concGlu;
    hemo(i)     = b.hemo;
    h2o(i)      = b.h2o;
end

%% Create relevant graphs from b struct
figure(1)
plot([1:100], totoxout, 'r-','LineWidth',1)
xlabel('Cycle (days)')
ylabel('Total O_{2} delivered to tissues per cycle (g)')
title('Total Oxygen Delivered with Cardiac Response')

figure(2)
plot([1:100], hemo, 'r-','LineWidth',1)
xlabel('Cycle (days)')
ylabel('Hemoglobin concentration in systemic blood (g/mL)')
set(gca,'YLim',[.1175 .1525])
title('Hemoglobin Concentration')

figure(3)
plot([1:100], out, 'r-','LineWidth',1)
xlabel('Cycle (days)')
ylabel('Cardiac output (mL/min)')
set(gca,'YLim',[4900 6400])
title('Cardiac Output')

figure(4)
plot([1:100], oxin, 'ko')
figure(5)
plot([1:100], oxout, 'ko')
figure(6)
plot([1:100], glu,'ko')
figure(7)
plot([1:100], out,'ko')
figure(8)
plot([1:100], co2in,'ko')
figure(9)
plot([1:100], co2out,'ko')