% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology

%% Initialize starting parameters of blood and heart
b      = struct;       % All information about blood goes in here
b.cOut = 5000;         % Cardiac output, baseline (mL/min)
b.p    = 1.06;         % Density of blood (g/mL)
b.T    = 37;           % Temperature of blood (C)
b.hemo = .150;         % Hemoglobin mass fraction in blood (g/mL)
b.rbc  = b.hemo;       % Assume RBCs are entirely hemoglobin (~.95)
b.concCO2 = 29e-6.*44; % Concentration venous CO2 (g/mL)

b.h2o  = .51;                   % Water fraction in blood (g H20 / mL blood)
b.glu  = .001;                  % Mass fraction of glucose in blood (g/mL)
b.ions = [2.5 100 5.0 135];     % Ion concentrations, [Ca Cl K Na] (mmol/L)
b.dist = [.04 .15 .22 .05 .20]; % CO Distribution (Heart, Muscle, Kidney, Bone, Intestine)
b.oxNeed = 0;

%% Send blood to organs:

for i = 1:100 % Each cycle should be 1 min, 5 L through system?
    
    b.i = i;
    % 1. Heart to lungs, lungs to heart (oxygenation phase)
    bLung = lungs(b);
    
    % 2. Metabolic consumption by heart
    bHeart = heart(bLung);
    
    % 3. Heart to muscle & kidney (consumption, filtration, excretion)
    bMus  = muscle(bLung);
    bKid  = kidney(bLung);
    
    % 4. Muscle & kidney to bone (generate RBCs, hemoglobin)
    bBone = marrow(bLung);
    
    % 5. Bone to small intestine (regain nutrients, plasma)
    bInt  = intestine(bLung);
    
    % 6. Recycle
    b     = bInt;
    
    % 7. Mixing function bInt, bBone, bKid, bMus, bHeart.
    
    % 7. Record values of previous iteration (minute)
    
end

%% Create relevant graphs from b struct
figure(1)