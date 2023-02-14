function [s, Pop,Global]=NoiseEffectCal(Pop, lamreev, theta, kappa,Global)
            Popdecs = Pop.decs;
            [NewPop,Global] = INDIVIDUAL(Popdecs(1:lamreev,:),Global);
            Popobjs = Pop.objs;
            NewPopobjs = [NewPop.objs;Popobjs(lamreev+1:end,:)];
            PopFitness = CalFitness(Popobjs,kappa);
            NewPopFitness = CalFitness(NewPopobjs,kappa);
            [s, ~, ~] = Noisemeasurement(PopFitness, NewPopFitness, lamreev, theta);
            for i = 1:lamreev
                Pop(i).obj = mean([Popobjs(i,:);NewPop(i).obj]);
                Pop(i).fre = 2; 
            end
             


end