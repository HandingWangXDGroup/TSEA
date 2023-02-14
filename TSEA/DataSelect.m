%% The data selection of averaging-based denoising
function [SelPop,Pop, denoise_struct] = DataSelect(Population, denoise_struct)
        
        for j = 1 : size(Population, 2)
            Population(1,j).obj = Population(1,j).oriobj;
        end
        Npop = Population(NDSort(Population.objs,1)==1);
        Pop = Population(NDSort(Population.objs,1)==inf);
        Nobj = Npop.objs;
        Dobj = Pop.objs;
        length = max(Nobj, [], 1)-min(Nobj, [], 1);
        length = [length; denoise_struct.length];
        denoise_struct.length = min(length, [], 1);
        ideal_point = repmat(min(Nobj,[], 1), size(Pop, 2), 1);
        nadir_point = repmat(min(Nobj, [], 1)+denoise_struct.length, size(Pop, 2), 1);
        result = Dobj >= ideal_point & Dobj <= nadir_point;
        result = sum(result,2);
        SelPop = Pop((result==size(Dobj,2))');
        Pop = Pop((result~=size(Dobj,2))');
        SelPop = [Npop, SelPop]; 

end