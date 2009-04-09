classdef gratingStimulus < baseStimulus
   properties
		sf=0.01
		tf=0.01
		method='procedural'
		angle=0;
		phase=0;
		contrast=10;
		texid=[];
	end
	properties (SetAccess = private, GetAccess = private)
	end
   methods
		function obj = gratingStimulus(args)
			obj=obj@baseStimulus(args); %we call the superclass constructor first
			if ~strcmp(obj.family,'grating')
				error('Sorry, you are trying to call a gratingStimulus with a family other than grating');
			end
			if nargin>0 && isstruct(args)
				if isfield(args,'sf');obj.sf=args.sf;end
				if isfield(args,'tf');obj.tf=args.tf;end
				if isfield(args,'angle');obj.angle=args.angle;end
				if isfield(args,'phase');obj.phase=args.phase;end
				if isfield(args,'contrast');obj.contrast=args.contrast;end
			end

		end
		function makeTexture(obj)
			
		end
	end
	methods (Access = private)
			function construct(obj)
				
			end
	end
end