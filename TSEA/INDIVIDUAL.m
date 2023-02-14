classdef INDIVIDUAL < handle

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties
        dec;        % 个体的决策变量值
        obj;        % 个体使用的目标变量值
        nobj;       % 个体的不带噪声目标变量值
        oriobj;     % 个体原始或者经过平均的目标变量值
        flag=0;     % 降噪方式选择，0未进行噪声处理；1降噪处理
        time;       % 生命周期
        fre;        % 已经评估的次数
    end
    methods
        %% 建立
        function [obj, Global] = INDIVIDUAL(Decs, Global)
        %INDIVIDUAL - Constructor of INDIVIDUAL class.
        %
        %   H = INDIVIDUAL(Dec) creates an array of individuals (i.e., a
        %   population), where Dec is the matrix of decision variables of
        %   the population. The objective values and constraint violations
        %   are automatically calculated by the test problem functions.
        %   After creating the individuals, the number of evaluations will
        %   be increased by length(H).
        %
        %   H = INDIVIDUAL(Dec,AddProper) creates the population with
        %   additional properties stored in AddProper, such as the velocity
        %   in particle swarm optimization.
        %
        %   Example:
        %       H = INDIVIDUAL(rand(100,3))
        %       H = INDIVIDUAL(rand(100,10),randn(100,3))
        
            if nargin > 0
                % Create new objects
                obj(1,size(Decs,1)) = INDIVIDUAL;
                % Set the infeasible decision variables to boundary values
                if ~isempty(Global.lower) && ~isempty(Global.upper)
                    Lower = repmat(Global.lower,length(obj),1);
                    Upper = repmat(Global.upper,length(obj),1);
                    Decs  = max(min(Decs,Upper),Lower);
                end
                % Calculte the objective values and constraint violations
                Objs = fitness (Decs,Global);
                OriObjs = fitness (Decs,Global);
                % Assign the decision variables, objective values,
                % constraint violations, and additional properties
                for i = 1 : length(obj)
                    obj(i).dec = Decs(i,:);
                    obj(i).obj = Objs(i,:);
                    obj(i).oriobj = OriObjs(i,:);
                    obj(i).fre = 1;
                end
                % Increase the number of evaluated individuals
                Global.evaluated = Global.evaluated + length(obj);
            end
        end
        %% Get the matrix of decision variables of the population
        function value = decs(obj)
        %decs - Get the matrix of decision variables of the population.
        %
        %   A = obj.decs returns the matrix of decision variables of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.dec);
        end
        %% Get the matrix of with noise on objective values of the population
        function value = objs(obj)
        %objs - Get the matrix of objective values of the population.
        %
        %   A = obj.objs returns the matrix of objective values of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.obj);
        end

       %% Get the matrix without noise on objective values of the population
        function value = oriobjs(obj)
        %objs - Get the matrix of objective values of the population.
        %
        %   A = obj.objs returns the matrix of objective values of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.oriobj);
        end
       %% Get the matrix of flag of the population
        function value = flags(obj)
        %objs - Get the matrix of objective values of the population.
        %
        %   A = obj.objs returns the matrix of objective values of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.flag);
        end
       %% Get the matrix of flag of the population
        function value = times(obj)
        %objs - Get the matrix of objective values of the population.
        %
        %   A = obj.objs returns the matrix of objective values of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.time);
        end        
               %% Get the matrix of Frequency of the population
        function value = fres(obj)
        %objs - Get the matrix of objective values of the population.
        %
        %   A = obj.objs returns the matrix of objective values of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.fre);
        end      

    end
end