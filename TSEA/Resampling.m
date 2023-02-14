function [sample1,denoise_struct,Global]=Resampling(Individual,N, Global)
          sampledec=repmat(Individual.decs,N,1);
          [sample, Global]=INDIVIDUAL(sampledec, Global); 
          
          sampleobj=sample.objs;
          denoise_struct.aver=sum(sampleobj)/N;
          denoise_struct.max=max(abs(sampleobj-repmat(denoise_struct.aver,N,1)));  
          denoise_struct.min=min(abs(sampleobj-repmat(denoise_struct.aver,N,1)));  
          denoise_struct.SD=sqrt(sum(sum((sampleobj-repmat(denoise_struct.aver,N,1)).^2)/(N-1))/3);
          
          denoise_struct.length=denoise_struct.max-denoise_struct.min;
          sample1= denoise_struct.aver;
end