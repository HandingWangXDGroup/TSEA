function [ND_solution,D_solution,denoise_struct]=ModelDataSelect(ND_solution,D_solution,denoise_struct,Global)
        if size(ND_solution,2) > 20*Global.N
            D_solution=[];
            return;
        else
            Nobj=ND_solution.objs;
            Dobj=D_solution.objs;
            if isempty(denoise_struct.length)
                ideal_point=repmat(min(Nobj,[],1),size(D_solution,2),1);
                nadir_point=repmat(max(Nobj,[],1),size(D_solution,2),1);
                denoise_struct.length=nadir_point(1,:)-ideal_point(1,:);
            else 
                length=max(Nobj,[],1)-min(Nobj,[],1);
                length=[length;denoise_struct.length];
                denoise_struct.length=min(length,[],1);
                ideal_point=repmat(min(Nobj,[],1),size(D_solution,2),1);
                nadir_point=repmat(min(Nobj,[],1)+denoise_struct.length,size(D_solution,2),1);
            end
            
            result=Dobj>=ideal_point&Dobj<=nadir_point;

            result=sum(result,2);
            D_solution=D_solution((result~=0)');
            if size([ND_solution,D_solution],2)>20*Global.N
                while size(ND_solution,2)<20*Global.N 
                    ND = NDSort(D_solution.objs,1);
                    ND_solution=[ND_solution,D_solution(ND==1)];
                    D_solution(ND==1)=[];
                end
                D_solution=[];
            end
        end


end