function remainder = DeleteDuplicateSolution(candidates,N)
        remainder = [];
        [CA, remain] = UpdateCA([], candidates, N);
        remainder = remain;
        [CA, remain] = UpdateCA([], CA, N/2);
        remainder =[remainder, remain];
end