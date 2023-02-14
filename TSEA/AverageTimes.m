%% Averaging-based denoising
function [Depopulation,Store,Global]=AverageTimes(Population,N,Global)
         Re=Population.flags;
         Sel=Population((~Re)');
         if sum(Re)==0
             Store=[];
         else
             Store=Population((Re==1)');
         end
         [~,C]=unique(Sel.decs,'rows');
         Sel=Sel(C');
         for i=1:size(Sel,2)
             sampledec=repmat(Sel(i).dec,N,1);
             [sample,Global]=INDIVIDUAL(sampledec,Global);
             sampleobj=sample.objs;
             Depopulation(i)=Sel(i);
             Depopulation(i).obj=sum([sampleobj;Sel(i).obj*Sel(i).fre],1)/(N+Sel(i).fre);
             Depopulation(i).oriobj = Depopulation(i).obj;
             Depopulation(i).flag=1;
             Depopulation(i).fre =Depopulation(i).fre+N;
         end
         
end