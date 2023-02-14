    %------------------------------- Reference --------------------------------
    % Zheng N, Wang H. A two-stage evolutionary algorithm for noisy bi-objective optimization[J]. 
    % Swarm and Evolutionary Computation, 2023: 101259.
    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 HandingWangXD Group. Permission is granted to copy and
    % use this code for research, noncommercial purposes, provided this
    % copyright notice is retained and the origin of the code is cited. The
    % code is provided "as is" and without any warranties, express or implied.
    %---------------------------- Parameter setting ---------------------------
    % Threshold = 0.8-----The threshold of model estimation
    % Global.N    = 100--------The size of population
    % Times = 5------The maximum frequency of model denoising
    % S = 3-------Resampling times
    % Objective relaxation: M-1
    % This code is written by Nan Zheng.
    % Email: Nanszheng@gmail.com
    
    clc; clear; warning off;
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));

%% Parameter Setting
    Global.problem = 'DTLZ1';
    Global.N = 100;
    Global.M = 2;
    Global.D = 30;
    Global.lower = zeros(1, Global.D);
    Global.upper = ones(1, Global.D);
    Global.evaluation = 50000;
    Global.evaluated = 0;
    Global.Var = 0.2;


    
    CAsize = Global.N;
    DAsize = Global.N/2;
    p = 1/Global.M;
    denoise_struct = struct([]);
    Threshold = 0.8;
    N = Global.N/10;
    theta = 0.2;          
    kappa = 0.05;         
    Proportion = 0.95;     
    count1 = 0;           
    count2 = 0;           
    successivecount = 0;  
    Times = 5;            
    S = 3;                
    
    %% Generate random population
    PopDec = unifrnd(repmat(Global.lower,Global.N,1),repmat(Global.upper,Global.N,1));
    [Population, Global] = INDIVIDUAL(PopDec, Global);
    Individual = Slect_Converence(Population, 1);
    [sample, denoise_struct,Global]=Resampling(Individual, N, Global);
    [CA, ~] = UpdateCA([], Population, CAsize);
    [DA, ~] = UpdateDA([],Population,DAsize,p);
    PopA = Population(NDSort(Population.objs,1)==1);
    Pop = Population(NDSort(Population.objs,1)==inf);
    tic;
    clc; fprintf('%s on %d-objective %d-variable (%6.2f%%), %.2fs passed...\n',Global.problem,Global.M,Global.D,Global.evaluated/Global.evaluation*100,toc);
    %% Optimization
    while Global.evaluated < Global.evaluation
            
        if (Global.evaluated < Proportion*Global.evaluation) || (count1>count2)
            Parent = MatingSelection(CA,DA,Global.N);
            [Offspring,Global] = GA(Parent,Global);
            NDOff = Offspring(NDSort(Offspring.objs,1)==1);
            DOff = Offspring(NDSort(Offspring.objs,1)==inf);
            lamreev = size(NDOff, 2);
            Offspring = [NDOff, DOff];
            
            [s, Offspring,Global] = NoiseEffectCal(Offspring, lamreev, theta, kappa,Global);
            All = [PopA, Offspring];
            NF = NDSort(All.objs, 1);
            PopA = All(NF==1);        
            Pop = [Pop, All(NF==inf)];
            if s < 0
                [CA,~] = UpdateCA(CA, Offspring, CAsize);
                [DA, ~] = UpdateDA(DA,[CA,Offspring],DAsize,p);
                count1 = count1 + 1;
                successivecount = 0;       
            else
                if Times -floor(Global.evaluated/10000) <= 0
                    T = 1;
                else
                    T = Times -floor(Global.evaluated/10000);
                end
                
                if successivecount < T
                    [NDEA, DEA, denoise_struct]=ModelDataSelect(PopA,Pop,denoise_struct,Global);
                    [CAOff, denoise_struct] = DenoisingG([CA,Offspring], [NDEA,DEA], denoise_struct, Threshold, N);
                    [CA, ~] = UpdateCA(CAOff, [], CAsize);
                    [DA, ~] = UpdateDA(DA,CAOff,DAsize,p);
                    count2 = count2 + 1;
                    successivecount = successivecount + 1;
                else
                    [SelPop,OriPop,denoise_struct] = DataSelect([CA,Offspring], denoise_struct);
                    [DePop, ADePop,Global]=AverageTimes(SelPop, S,Global);
                    CAOff = [DePop, ADePop, OriPop];
                    [CA, ~] = UpdateCA(CAOff, [], CAsize);
                    [DA, ~] = UpdateDA(DA,CAOff,DAsize,p);
                    count2 = count2 + 1;
                    successivecount = 0;

                end
            end
        else
            [PopA,Pop,Global]=Iteration(PopA,Pop,1,Global);
        end
        clc; fprintf('%s on %d-objective %d-variable (%6.2f%%), %.2fs passed...\n',Global.problem,Global.M,Global.D,Global.evaluated/Global.evaluation*100,toc);
    end
    OutPopulation = PopA;

    
    
    