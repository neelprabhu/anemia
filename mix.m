% BME 260 Spring 2017
% Modeling Blood Flow in Healthy and Anemic Physiology
% Mixing function to incorporate all blood components before sending back
% to heart.

function b = mix(bHeart, bMus, bKid, bBone, bInt, bElse)

bMixed = bHeart;
dist   = bMixed.dist;

bMixed.concO2  = bHeart.o2 .* dist(1) + bMus.o2 .* dist(2) + ...
          bKid.o2 .* dist(3) + bBone.o2 .* dist(4) + ...
          bInt.o2 .* dist(5) + bElse.o2 .* dist(6);
bMixed.concCO2 = bHeart.co2 .* dist(1) + bMus.co2 .* dist(2) + ...
          bKid.co2 .* dist(3) + bBone.co2 .* dist(4) + ...
          bInt.co2 .* dist(5) + bElse.co2 .* dist(6);
bMixed.concH2O = bHeart.h2o .* dist(1) + bMus.h2o .* dist(2) + ...
          bKid.h2o .* dist(3) + bBone.h2o .* dist(4) + ...
          bInt.h2o .* dist(5) + bElse.h2o .* dist(6);
bMixed.concGlu = bHeart.glu .* dist(1) + bMus.glu .* dist(2) + ...
          bKid.glu .* dist(3) + bBone.glu .* dist(4) + ...
          bInt.glu .* dist(5) + bElse.glu .* dist(6);
      
bMixed.oxNeed = avg(bHeart.oxNeed,bMus.oxNeed,bKid.oxNeed,bBone.oxNeed,bInt.oxNeed);      
      
b = bMixed;
b.hemo = bBone.hemo;
end