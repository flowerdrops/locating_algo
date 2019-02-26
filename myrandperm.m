function x=myrandperm(Np,n,ii)
    a=randperm(Np);
    x=a([1:n]);
    while sum(x==ii)
        a=randperm(Np);
        x=a([1:n]);
    end  
end