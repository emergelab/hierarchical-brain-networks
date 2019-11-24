function new_ci=ci_restoresingleton(old_ci)

for jj=1:size(old_ci,2)
    
    tmp_ci=old_ci(:,jj);
    if jj>1
        ncom=unique(tmp_ci);
        for hh=1:numel(ncom)
            com=ncom(hh,1);
            nnodes=sum(tmp_ci==com);
            if nnodes==1
                tmp_ci(tmp_ci==com)=new_ci(tmp_ci==com,jj-1);
            end
        end
    end
    new_ci(:,jj)=tmp_ci;
end

end