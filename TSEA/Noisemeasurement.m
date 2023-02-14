function [s, ranks, rankDelta] = Noisemeasurement(arf1, arf2, lamreev, theta)

        if size(arf1,1) ~= size(arf2,1)
           error('arf1 and arf2 must be same in size 1'); 
        elseif size(arf1,2) ~= size(arf1,2)
            error('arf1 and arf2 must be same in size 2');
        elseif size(arf1,1) ~= 1
            error('arf1 and arf2 must be an 1x lamda array');
        end
        lam=size(arf1,2);
        %% calculate the rankDelta
        % calculate rank
        [~,idx] = sort([arf1,arf2]);
        [~,ranks] = sort(idx);
        ranks = reshape(ranks,lam,2)';
        
        rankDelta = ranks(1,:)-ranks(2,:)-sign(ranks(1,:)-ranks(2,:));
        
        % calculate rank change
        for i = 1:lamreev
            sumlim(i)=...
                prctile(abs((1:2*lam-1) - (ranks(1,i)-(ranks(1,i)>ranks(2,i)))),...
                        theta*50)+...
                prctile(abs((1:2*lam-1) - (ranks(2,i)-(ranks(2,i)>ranks(1,i)))),...
                        theta*50);
        end
        
        % calculate the intensity of the noise
        s = mean(2*abs(rankDelta(1:lamreev)) - sumlim);
        
end