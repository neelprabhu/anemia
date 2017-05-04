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
    ox(i)       = bLung.concO2;
    oxheart(i)  = bHeart.o2;
    oxmus(i)    = bMus.o2;
    oxkid(i)    = bKid.o2;
    oxbone(i)   = bBone.o2;
    oxint(i)    = bInt.o2;
    oxelse(i)   = bElse.o2;
   
    
    totoxout(i) = bLung.concO2 .* cOut;
    co2in(i)    = b.concCO2;
    co2out(i)   = bLung.concCO2;
    co2mus(i)   = bMus.co2;
    glu(i)      = b.concGlu;
    gluint(i)   = bInt.glu;
    glumus(i)   = bMus.glu;
    glukid(i)   = bKid.glu;
    hemo(i)     = b.hemo;
    h2o(i)      = b.h2o;
    h2okid(i)   = bKid.h2o;
    h2oint(i)   = bInt.h2o;
    cl(i)       = b.ions(1);
    clkid(i)    = bKid.ions(1);
    pot(i)      = b.ions(2);
    na(i)       = b.ions(3);
end

%% Create relevant graphs from b struct

figure(1)
plot([1:100], totoxout, 'r-','LineWidth',1)
xlabel('Cycle (days)')
ylabel('Total O_{2} delivered to tissues per cycle (g)')
title('Total Oxygen Delivered with Cardiac Response')

figure(2)
hold on
plot([1:100], h2o,'k-','LineWidth',1)
plot([1:100], h2okid,'k--','LineWidth',1)
plot([1:100], h2oint,'k-.','LineWidth',1)
hold off
xlabel('Time (day cycles)')
ylabel('Plasma concentration (g/mL)')
title('Blood Plasma Concentration Levels')
legend('Plasma through lung', 'Plasma out of kidney', 'Plasma out of intestine','Location','SouthEast')

figure(3)
plot([1:100], hemo, 'r-','LineWidth',1)
xlabel('Cycle (days)')
ylabel('Hemoglobin concentration in systemic blood (g/mL)')
set(gca,'YLim',[.1175 .1525])
title('Hemoglobin Concentration')

figure(4)
plot([1:100], out, 'r-','LineWidth',1)
xlabel('Cycle (days)')
ylabel('Cardiac output (mL/min)')
set(gca,'YLim',[4900 6400])
title('Cardiac Output')

sat   = @(po2) 85./(0.89 + exp(-0.1037.*(po2-27.63)));
CaO2  = @(SaO2,Hb,PaO2) (SaO2.*Hb.*1.34)+(.003.*PaO2);

figure(5)
plot(1:100, sat(1:100),'k-')
xlabel('Partial pressure of oxygen (mmHg)')
ylabel('Hemoglobin saturation (%)')
title('Hemoglobin Saturation Curve')

figure(6)
plot(1:100, CaO2(sat(1:100),.150,1:100),'k-')
hold on
plot(1:100, CaO2(sat(1:100),.120,1:100),'k--')
xlabel('Partial pressure of oxygen (mmHg)')
ylabel('Total oxygen content (mL/dL)')
title('Total Oxygen Content')
legend('Healthy Hb = .150 g/mL','Anemic Hb = .120 g/mL','Location','SouthEast')

figure(7)
plot([1:100], glu,'k-','LineWidth',1)
hold on
plot([1:100], gluint,'k--','LineWidth',1)
plot([1:100], glumus,'k-.','LineWidth',1)
hold off
xlabel('Time (day cycles)')
ylabel('Glucose concentration (g/mL)')
title('Blood Glucose Levels')
legend('Glucose leaving lung','Glucose leaving intestine','Glucose leaving muscle','Location','SouthEast')

figure(8)
hold on
plot([1:100], co2out,'k-','LineWidth',1)
plot([1:100], co2mus,'k--','LineWidth',1)
hold off
set(gca,'YLim',[1e-3 1.625e-3])
xlabel('Time (day cycles)')
ylabel('Carbon dioxide concentration (g/mL)')
title('Blood Carbon Dioxide Concentration Levels')
legend('Carbon dioxide leaving lung', 'Carbon dioxide entering lung', 'Location','SouthEast')

figure(9)
plot([1:100], cl,'k-','LineWidth',1)
hold on
plot([1:100], clkid,'k--','LineWidth',1)
hold off
xlabel('Time (day cycles)')
ylabel('Chloride concentration (mM)')
title('Chloride Ion Levels')
legend('Chloride through lung','Chloride leaving kidney','Location','NorthEast')

heartdiff = (ox-oxheart).* cOut .* .04 * 720;
musdiff = (ox-oxmus).* cOut .* .15* 720;
kiddiff = (ox-oxkid).* cOut .* .22* 720;
bonediff = (ox-oxbone).* cOut .* .05* 720;
intdiff = (ox-oxint).* cOut .* .20* 720;

figure(10)
plot([1:100], heartdiff,'k-','LineWidth',1)
hold on
plot([1:100], musdiff,'k--','LineWidth',1)
plot([1:100], kiddiff,'k-.','LineWidth',1)
plot([1:100], bonediff,'k:','LineWidth',1)
plot([1:100], intdiff,'k.','LineWidth',1)
hold off
xlabel('Time (day cycles)')
ylabel('Total oxygen consumption per day (g)')
title('Total Oxygen Consumption in Major Organs')
legend('Heart','Muscle','Kidney','Bone Marrow','Intestine')