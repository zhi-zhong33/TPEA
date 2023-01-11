classdef TPEA < ALGORITHM
% <multi> <real> <constrained>
% TPEA

 methods
    function main(Algorithm,Problem)
    %% Generate random population
    Population = Problem.Initialization();
    ArcPop1 = []; 
    ArcPop2 = [];
  
    %% Optimization
    while Algorithm.NotTerminated(Population)
	         ratio = 1./( 1+ exp(-20*(Problem.FE./Problem.maxFE-0.5)) );
             Parents = MatingSelection(Population,ArcPop1,ArcPop2,Problem.N,0.5,ratio);             
             Offspring  = OperatorGA(Problem,Parents);  
             [Population,ArcPop1,ArcPop2] = EnvironmentalSelection([Population,ArcPop1,ArcPop2,Offspring],Problem.N);                 
    end
    end
 end
end