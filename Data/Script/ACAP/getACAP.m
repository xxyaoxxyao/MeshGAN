function getACAP( model_path )

    if (~exist([model_path,'\LOGRNEW.txt'],'file'))
        genfeature(model_path);
    end
    
    [ fmlogdr, fms ] = ACAP_func(model_path);
    
    m=matfile([model_path,'\ACAP_data.mat'],'writable',true);
    m.fmlogdr = fmlogdr;
    m.fms = fms;
    
    objlist=dir([model_path,'\*.obj']);
    [v,~,~,~,~,vv,~,~,~,~,~] = cotlp([model_path,objlist(1).name]);
    p_neighbour=zeros(size(v,1),100);
    maxnum=0;
    for i=1:size(vv,1)
        p_neighbour(i,1:size(vv{i,:},2))=vv{i,:};
        if size(vv{i,:},2)>maxnum
            maxnum=size(vv{i,:},2);
        end
    end
    p_neighbour(:,maxnum+1:end)=[];
    m.p_neighbour = p_neighbour;
    m.p_adj = neighbour2adj(p_neighbour);
    
    m.acap = cat(3, fmlogdr, fms);
    m.vertex = getVertex(model_path);

end

