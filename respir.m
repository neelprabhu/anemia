function [bResp] = respir(b)

% Molecular weights
MW_glu = 180;
MW_o2  = 32;
MW_co2 = 44;
MW_h2o = 18;

% b._ is in g/mL
ni_glu = b.concGlu/MW_glu; % moles/mL
ni_h20 = b.concH2O/MW_h2o; % moles/mL
ni_o2 = b.concO2/MW_o2;    % moles/mL
ni_co2 = b.concCO2/MW_co2; % moles/mL

% determine limiting factor between glucose and oxygen
R = min((ni_glu/1),(ni_o2/6)) * 0.8;

% Set outflow concentrations based on the respiration equation
nj_glu = ni_glu - 1*R;
nj_o2 = ni_o2 - 6*R;
nj_h2o = ni_h20 + 6*R;
nj_co2 = ni_co2 + 6*R;

% Getting outputs of function ready
b.glu = nj_glu.*MW_glu;
b.o2 = nj_o2.*MW_o2;
b.co2 = nj_co2.*MW_co2;
b.h2o = nj_h2o.*MW_h2o;
bResp = b;

end