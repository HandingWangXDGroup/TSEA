function PopObj = fitness (PopDec,problem)


    switch problem.problem
        case 'DTLZ1'
            g              = 100*(problem.D-problem.M+1+sum((PopDec(:,problem.M:end)-0.5).^2-cos(20.*pi.*(PopDec(:,problem.M:end)-0.5)),2));
            PopObj = 0.5*repmat(1+g,1,problem.M).*fliplr(cumprod([ones(size(PopDec,1),1),PopDec(:,1:problem.M-1)],2)).*[ones(size(PopDec,1),1),1-PopDec(:,problem.M-1:-1:1)]...
                 +mvnrnd(zeros(1,problem.M),problem.Var^2*diag(ones(1,problem.M)),size(PopDec,1));
        case 'DTLZ2'
            g      = sum((PopDec(:,problem.M:end)-0.5).^2,2);
            PopObj = repmat(1+g,1,problem.M).*fliplr(cumprod([ones(size(g,1),1),cos(PopDec(:,1:problem.M-1)*pi/2)],2)).*[ones(size(g,1),1),sin(PopDec(:,problem.M-1:-1:1)*pi/2)]...
                +mvnrnd (zeros(1,problem.M),problem.Var^2*diag(ones(1,problem.M)),size(PopDec,1));
    end


end