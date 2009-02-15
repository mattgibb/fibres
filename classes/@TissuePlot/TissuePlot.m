classdef TissuePlot < handle                 % EvalFcn is a subclass of handle
   properties                        
      FofXY
   end
   properties (SetObservable = true)
      Lm = [-2*pi 2*pi];
   end % properties SetObservable = true

   properties (Dependent = true)        % Do not store the Data property 
      Data
   end % properties Dependent = true
   
   events
      UpdateGraph % only if FofXY changes
   end

   methods
      function obj = fcneval(fcn_handle,limits)  % Constructor returns object
         obj.FofXY = fcn_handle;                 % Assign property values
         obj.Lm = limits;
      end % fcneval

   function fofxy = set.FofXY(obj,func)
      obj.FofXY = func;
      notify(obj,'UpdateGraph');       % Fire UpdateGraph event
   end % set.FofXY 
         
      function lm = set.Lm(obj,lim)     % Lm property set function
         if  ~(lim(1) < lim(2))
            error('Limits must be monotonically increasing')
         else
               obj.Lm = lim;
         end
      end % set.Lm

      function data = get.Data(obj)        % get function calculates Data
         [x,y] = fcneval.grid(obj.Lm);     % Use class name to call static method
         matrix = obj.FofXY(x,y);
         data.X = x;
         data.Y = y;
         data.Matrix = matrix;            % Return value of property
      end % get.Data
        
   end % methods

   methods (Static = true)            % Define static method 
     function [x,y] = grid(lim)        
        inc = (lim(2)-lim(1))/20;
        [x,y] = meshgrid(lim(1):inc:lim(2));
     end % grid
     
   end % methods Static = true
   
end % fcneval class