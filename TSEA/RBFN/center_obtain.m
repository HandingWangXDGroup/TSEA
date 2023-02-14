function centers=center_obtain(Popdec,center_num)
    [~,centers]=kmeans(Popdec,center_num);
end