function HO=Output_Hidden(Popdec,Network)
    HO = Network.kernal(Popdec,Network.centers,Network.sigma);
    HO = [HO,ones(size(HO,1),1)];
end