function comaff = RMT_com(TS, n)

nroi=size(TS,2);
dtpoints=size(TS,1);

C=corrcoef(TS);
C=(C+C')/2;  

ca_sim=get_communities(FinRMTc(C,dtpoints),n);
ca_sim_all=ca_sim;

while true
    
    ca_sim_cur = zeros(nroi,1);
    
    for ii=unique(ca_sim_all(:,end))'
        indx=ca_sim_all(:,end)==ii;
        ca_sim_cur(indx) = get_communities(FinRMTc(C(indx,indx),dtpoints),n) + max(ca_sim_cur(:));
    end
    
    if numel(unique(ca_sim_cur)) == nroi || numel(unique(ca_sim_cur)) == numel(unique(ca_sim_all(:,end))) 
        break;
    else
        ca_sim_all = [ca_sim_all, (ca_sim_cur + max(ca_sim_all(:)))];
    end
end

comaff=ca_sim_all;

end

function ca_sim = get_communities(M, n)

ca_ensemble=zeros(size(M,1),n);
for i=1:n
    ca_ensemble(:,i)=iterated_genlouvain(M,[],0,1,'moverandw');
end
ca_sim=consensus_similarity(ca_ensemble);
end
