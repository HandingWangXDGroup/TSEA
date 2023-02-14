function Parent = MatingSelection(CA,DA,N)
% The mating selection of Two_Arch2

      [CA, ~] = UpdateCA([], CA, N/2);
      Parent = [CA, DA];
      Parent = Parent(randi(length(Parent),1,N));
end