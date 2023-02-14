function [PopA,Pop,Global]=Iteration(PopA,Pop,k,Global)
         Fre=PopA.fres;
         [Loc_r,~]=find(Fre==min(min(Fre)));
         SelIndividual=PopA(Loc_r(1,1));
         [PopD,Pop]=SearchDominSolution(SelIndividual,Pop);
         dec=SelIndividual.dec;
         for i=1:k
            [SelIndividual(i),Global]=INDIVIDUAL(dec,Global);
         end
         PopA=Estimation([SelIndividual,PopA]);
         All=[PopA,PopD];
         NF=NDSort(All.objs,1);
         PopA=All(NF==1);
         Pop=[Pop,All(NF==inf)];
         
         
end