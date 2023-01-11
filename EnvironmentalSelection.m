function [Feasible,Infeasible1, Infeasible2] = EnvironmentalSelection(Population,N)
      
   
      [~,b]=unique(Population.objs,'rows');
      Population = Population(1,b);
      
      [FrontNo,~] = NDSort([Population.objs,sum(max(0,Population.cons),2)],inf);

      FeasibleIndex = sum(max(0,Population.cons),2)==0;    
      Feasible = Population(FeasibleIndex);
      FeasibleFrontNo = FrontNo(FeasibleIndex);
      Feasible = FeasibleUpdate(Feasible,FeasibleFrontNo,N); 
% 
      if length(Feasible)<N 
         N1 = N-length(Feasible);
         InfeasibleIndex = sum(max(0,Population.cons),2)~=0;
         Infeasible = Population(InfeasibleIndex); 
         [~,Index]=sort(sum(max(0,Infeasible.cons),2));
         Feasible=[Feasible,Infeasible(Index(1:N1))];
      end
      
         InfeasibleIndex = sum(max(0,Population.cons),2)~=0;
         Infeasible = Population(InfeasibleIndex);
         InfeasibleFrontNo = FrontNo(InfeasibleIndex);
         Temp = InfeasibleFrontNo==1;
         Infeasible =Infeasible(Temp);
         Infeasible1 = Infeasible1Update(Infeasible, N );
         Infeasible2 = Infeasible2Update(Infeasible,N);
end

function Population = FeasibleUpdate(Population,FrontNo,N)

if length(Population)>N
  
   
    FrontNoSort = sort(FrontNo);
    MaxFNo = FrontNoSort(N);
    
 
    Next = FrontNo < MaxFNo;
    Population1 = Population(Next);
    
   
    Last = FrontNo == MaxFNo;
    Population2 = Population(Last);
    if sum(Last)~= N-sum(Next)
    Population2 = Truncation(Population2,Population,N-sum(Next));
    end

    Population = [Population1,Population2]; 
end
end

function Population = Infeasible1Update(Population,N)

if length(Population) > N
    
    

    [FrontNo,MaxFNo] = NDSort(Population.objs,N);

    Next = FrontNo < MaxFNo;
    Population1 = Population(Next);  
    Last = FrontNo==MaxFNo;
    Population2 = Population(Last);
   
    if sum(Last)~= N-sum(Next)
    Population2 = Truncation(Population2,Population,N-sum(Next));
    end
    %% Population for next generation
    Population = [Population1,Population2];
end   
end


function Population = Infeasible2Update(Population,N)

if length(Population) > N
 
     % reverse the objective values
    [FrontNo,MaxFNo] = NDSort(-Population.objs,N);
 
    Next = FrontNo < MaxFNo;
    Population1 = Population(Next);  
    Last = FrontNo==MaxFNo;
    Population2 = Population(Last);
   
    if sum(Last)~= N-sum(Next)
    Population2 = Truncation(Population2,Population,N-sum(Next));
    end
    %% Population for next generation
    Population = [Population1,Population2];
end   
end




function Population = Truncation(Population,PopAll,N)
% Select part of the solutions by truncation

    %% Truncation
    Zmin       = min(PopAll.objs,[],1);
    PopObjTemp = Population.objs;
    PopObj = (PopObjTemp -repmat(Zmin,length(Population),1))./(repmat(max(PopAll.objs),length(Population),1)-repmat(Zmin,length(Population),1));

    
    Distance = pdist2(PopObj,PopObj);
    Distance(logical(eye(length(Distance)))) = inf;
    Del = false(1,size(PopObj,1));
    while sum(Del) < size(PopObj,1)-N
        Remain   = find(~Del);
        Temp     = sort(Distance(Remain,Remain),2);
        [~,Rank] = sortrows(Temp);
        Del(Remain(Rank(1))) = true;
    end
    
      Population = Population(Del==0);
end
