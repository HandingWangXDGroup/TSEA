function y = Gaussian(Popdec,center,sigma)
    dis = pdist2(Popdec,center);
    y = exp(-(dis.^2)./(2*sigma.^2));
end