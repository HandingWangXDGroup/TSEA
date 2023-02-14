function [PopD,Pop]=SearchDominSolution(SelIndividual,Pop)
        N=size(Pop,2);
        for i=1:size(SelIndividual,2)
             PopObj=[SelIndividual(1,i).obj;Pop.objs];
             for j = 2 : N+1
                 k = any(PopObj(1,:)<PopObj(j,:)) - any(PopObj(1,:)>PopObj(j,:));
                 if k == 1
                    Dominate(i,j) = true;
                 else
                    Dominate(i,j) = false;
                 end
             end
        end
         PopD=Pop(Dominate(1,2:end));
         Pop=Pop(~Dominate(1,2:end));

end