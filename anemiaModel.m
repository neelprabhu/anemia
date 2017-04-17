% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology

%% Initialize starting parameters of blood and heart
b      = struct;      % All information about blood goes in here
b.cOut = 5000;        % Cardiac output, healthy and diseased (mL/min)
b.p    = 1.06;        % Density of blood (g/mL)
b.hemo = .150;        % Hemoglobin mass fraction in blood (g/mL)
b.rbc  = b.hemo;      % Assume RBCs are entirely hemoglobin (~.95)
b.o2   = b.hemo*1.34; % Binding capacity healthy (mL o2 / mL blood)
b.h2o  = .51;         % Water fraction in blood (g H20 / mL blood)
b.glu  = .001;        % Mass fraction of glucose in blood (g/mL)
b.ions = [2.5 100 5.0 135]; % Ion concentrations, [Ca Cl K Na] (mmol/L)

%% Send blood to organs:

for i = 1:100
    
    % 1. Heart to Lungs, Lungs to Heart (Oxygenation Phase)
    bLung = lungs(b);
    
    % 2. Heart to Muscle & Kidney (Consumption, Filtration, Excretion)
    bMus  = muscle(bLung);
    bKid  = kidney(bLung);
    
    % 4. Muscle & Kidney to Bone (Generate RBCs, Hemoglobin)
    bBone = marrow(bKid);
    
    % 5. Bone to Small Intestine (Regain Nutrients, Plasma)
    bInt  = intestine(bBone);
    
    % 6. Recycle
    b     = bInt;
    
    % 7. Record values of previous iteration
end

%% Create relevant graphs from b struct
