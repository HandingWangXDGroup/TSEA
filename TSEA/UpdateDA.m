function [DA,Remain] = UpdateDA(DA,New,MaxSize,p)
% Update DA

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    %% Delete duplicate solution
    candidates = [New];
    Remainder = DeleteDuplicateSolution(candidates,2*MaxSize);
    

    %% Find the solutions
    
    SDA=Remainder;
    Choose=[];
    Select=[];
    if size(SDA,2) >= MaxSize
        while(size(Choose,2)+size(Select,2)<MaxSize)
              ND = NDSort(SDA.objs,1);
              Choose=[Choose,Select];
              Select=SDA(ND==1);
              SDA(ND==1)=[];
        end    
    else
        Choose = DA;
    end
    
    DA = Select;
    N  = length(DA);
    RemainSum=SDA;
    ChooseSum=Choose;
    %% Select the extreme solutions first
    Choose = false(1,N);
    [~,Extreme1] = min(DA.objs,[],1);
    [~,Extreme2] = max(DA.objs,[],1);
    Choose(Extreme1) = true;
    Choose(Extreme2) = true;
    
    %% Delete or add solutions to make a total of K solutions be chosen by truncation
    if sum(Choose) > MaxSize-size(ChooseSum,2)
        % Randomly delete several solutions
        Choosed = find(Choose);
        k = randperm(sum(Choose),sum(Choose)-MaxSize+size(ChooseSum,2));
        Choose(Choosed(k)) = false;
    elseif sum(Choose) < MaxSize-size(ChooseSum,2)
        % Add several solutions by truncation strategy
        Distance = inf(N);
        for i = 1 : N-1
            for j = i+1 : N
                Distance(i,j) = norm(DA(i).obj-DA(j).obj,p);
                Distance(j,i) = Distance(i,j);
            end
        end
        while sum(Choose) < MaxSize-size(ChooseSum,2)
            Remain = find(~Choose);
            [~,x]  = max(min(Distance(~Choose,Choose),[],2));
            Choose(Remain(x)) = true;
        end
    end
    Remain=DA;
    DA = [ChooseSum,DA(Choose)];
    Remain=Remain(~Choose);
    Remain=[RemainSum,Remain];
end