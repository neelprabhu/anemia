function [bResp] = respir(b)

MW_glu = 180;
MW_o2 = 32;
MW_co2 = 44;
MW_h2o = 18;

ni_glu = b.glu/MW_glu; % moles/min
ni_h20 = b.h2o/MW_h2o;
ni_o2 = b.concO2/MW_o2;
ni_co2 = b.co2/MW_co2; % NOT A THING YET

 

% determine limiting factor between glucose and oxygen
R = min((ni_glu/1),(ni_o2/6)); 

nj_glu = ni_glu - 1*R;
nj_h2o = ni_h20 + 6*R;
nj_o2 = ni_o2 - 6*R;
nj_co2 = ni_co2 + 6*R;

b.glu = nj_glu/MW_glu;
b.o2 = nj_o2/MW_o2;
b.co2 = nj_co2/MW_co2;
b.h2o = nj_h2o/MW_h2o;
bResp = b;

end