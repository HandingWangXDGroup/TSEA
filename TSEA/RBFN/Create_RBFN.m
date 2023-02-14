function Network = Create_RBFN(Popdec,Popobj,center_num)
         Network.kernal=@Gaussian;          
         Network.centers=center_obtain(Popdec,center_num);
         Network.sigma = max(pdist(Network.centers))*2;
         Output = Output_Hidden(Popdec,Network);
         Network.weight=inv(Output'*Output)*Output'*Popobj;
         
         
         
end