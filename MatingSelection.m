function MatingPool = MatingSelection(Population,ArcPop1,ArcPop2,N,alpha,ratio)

  MatingPool = [];
   
if length(ArcPop1)<N 
    PopAll = [Population,ArcPop1,ArcPop2];
    [~,b]=unique(PopAll.objs,'rows');
    PopAll = PopAll(1,b);
    SelectedIndex= TournamentSelection(2,N,DensityCal(PopAll.decs));
    MatingPool= PopAll(SelectedIndex);
else
    Density1 =  DensityCal(Population.objs);
    Density2 =  DensityCal(ArcPop1.objs);
    Density3 =  DensityCal(ArcPop2.objs);
    index1 = randi(N,1,N);
    index2 = randi(N,1,N);
    index3 = randi(N,1,N);
    for i = 1:N 
        PopObj1 = Population.objs;
        PopObj2 = ArcPop1.objs; 
        PopObj3 = ArcPop2.objs;
       
        
       rand1 = rand;
       rand2 = rand;
        if rand1 < alpha
          if  PopObj1(index1(i),:)<PopObj1(index2(i),:)
            MatingPool = [MatingPool, Population(index1(i))];
          elseif  PopObj1(index1(i),:)>PopObj1(index2(i),:)
             MatingPool = [MatingPool, Population(index2(i))];
          elseif Density1(index1(i)) < Density1(index2(i))
             MatingPool = [MatingPool, Population(index1(i))];
          else
             MatingPool = [MatingPool, Population(index2(i))];
          end
        elseif rand2> ratio
             if  PopObj2(index1(i),:)<PopObj2(index2(i),:)
             MatingPool = [MatingPool, ArcPop1(index1(i))];
             elseif  PopObj2(index1(i),:)>PopObj2(index2(i),:)
             MatingPool = [MatingPool, ArcPop1(index2(i))];
             elseif Density2(index1(i)) < Density2(index2(i))
             MatingPool = [MatingPool, ArcPop1(index1(i))];
             else
             MatingPool = [MatingPool, ArcPop1(index2(i))];
             end
                   
        else
            if  PopObj3(index1(i),:)<PopObj3(index2(i),:)
               MatingPool = [MatingPool, ArcPop2(index2(i))];
             elseif  PopObj3(index1(i),:)>PopObj3(index2(i),:)
             MatingPool = [MatingPool, ArcPop2(index1(i))];
             elseif Density3(index1(i)) < Density3(index2(i))
             MatingPool = [MatingPool, ArcPop2(index1(i))];
             else
             MatingPool = [MatingPool, ArcPop2(index2(i))];
            end                      
        end
        
    end
end
end  
 


 function Density = DensityCal(PopObj)
     [N,~] = size(PopObj);  
    Zmin       = min(PopObj,[],1);
    PopObj = (PopObj-repmat(Zmin,N,1))./(repmat(max(PopObj),N,1)-repmat(Zmin,N,1)+1e-20);
    Distance = pdist2(PopObj,PopObj);
    Distance(logical(eye(length(Distance)))) = Inf;
    DistanceSort = sort(Distance,2);
    Density = 1./(1+DistanceSort(:,floor(sqrt(length(Distance)))+1));  
 end
