function Individual=Slect_Converence(Pop,Size)
        
         PopObj=Pop.objs;
         N=size(PopObj,1);
         PopObj=(PopObj-repmat(min(PopObj),N,1))...
             ./(repmat(max(PopObj),N,1)...
             -repmat(min(PopObj),N,1));   
         I=zeros(N);
         for i=1:N
             for j=1:N
                 
                 I(i,j)=max(PopObj(i,:)-PopObj(j,:));  
             end
         end
         C=max(abs(I)); 
         F=sum(-exp(-I./(0.05*repmat(C,N,1))))+1; 
         
         S=1:N;
         while size(S,2)>Size
            [~,location]=min(F(S));
            F=F+exp(-I(S(location),:)./(0.05*C(location)));
            S(location)=[];
         end
         Individual=Pop(S);

end