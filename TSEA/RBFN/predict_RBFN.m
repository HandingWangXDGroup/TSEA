function output=predict_RBFN(Input,Network)
    [N,~] = size(Input);
    output = zeros(N,1);
    obj = Network.kernal(Input,Network.centers,Network.sigma);
    obj = [obj,ones(size(obj,1),1)];
    output = obj*Network.weight+output;
end