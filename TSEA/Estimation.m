function Population=Estimation(Population)
         PopDec=Population.decs;    
         Fres=Population.fres;
         Pop=Population;
         for i=1:size(PopDec,1)
             Select=ismember(PopDec,Pop(i).dec,'rows');
             objs=Pop(Select').objs;
             fres=Fres(Select);
             Population(i).obj=sum(objs.*repmat(fres,1,size(objs,2)),1)/(sum(fres,1));
             Population(i).fre=sum(fres,1);
         end
         [~,Choose,~]=unique(PopDec,'rows');
         Population=Population(Choose');
         
end