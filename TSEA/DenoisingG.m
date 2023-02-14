function [original_data,denoise_struct]=DenoisingG(original_data,Archive,denoise_struct,Threshold,N)


          if isempty(denoise_struct)
             Individual=Slect_Converence(original_data,1);
             [sample,denoise_struct]=Resampling(Individual,N);
          end
          % construct the denoising models
          M=size(original_data.objs,2);
          original_dec=original_data.decs;
          original_obj=original_data.objs;
          if ~isempty(Archive)
              Archive_dec=[Archive.decs;original_dec];
              Archive_obj=[Archive.objs;original_obj];
          else 
              Archive_dec=original_dec;
              Archive_obj=original_obj;
          end
          center_num=ceil(sqrt(size(Archive_dec,1)));
          for i=1:M
              dmodel=Create_RBFN(Archive_dec,Archive_obj(:,i),center_num);
              Network{i}=dmodel;
          end
          for j=1:M
              denoised_obj(:,j)=predict_RBFN(original_dec,Network{j});
          end
          objmax=original_obj+repmat(denoise_struct.max,size(original_dec,1),1);
          objmin=original_obj-repmat(denoise_struct.max,size(original_dec,1),1);
          % estimate the performance of denoising models
          result=denoised_obj>objmin&denoised_obj<objmax;
          Judgement=sum(result,1)/size(original_dec,1);
          denoised_data=original_obj;
          for i=1:M
             if Judgement(i)>Threshold
                 denoised_data(:,i)=denoised_obj(:,i);                
             end
          end
         for i=1:size(original_data,2)
              original_data(1,i).obj=denoised_data(i,:);
         end
end