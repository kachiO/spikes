function plotraster(cell1, cell2, cell3, drawline, burst, tmax)
% plotraster(cell1, cell2, cell3)
%
%Plotraster allows the raw spike times of a run for each trial to be
%plotted for up to 3 cells / variable conditions.
%
% Input is a single variable raw structure from LSD2; in spikes this is given by data.raw{y, x, z}

seed=10;
cols=[0 0 0;0.6 0 0;0 0 0.5];
width=0.03; %time width of the Spike drawn in seconds
yticks=1;
ncells = 3;

if ~exist('cell3','var') || isempty(cell3) || ~isstruct(cell3)
	ncells=2;
end

if ~exist('cell2','var') || isempty(cell2) || ~isstruct(cell2)
	ncells = 1;
end

if ~exist('cell1','var') || isempty(cell1) || ~isstruct(cell1)
	ncells = 0;
end

if ~exist('drawline','var') || isempty(drawline)
	drawline=2;
end

if ~exist('burst','var') || isempty(burst)
	burst=1;
end

if ~exist('tmax','var') || isempty(tmax)
	tmax=0;
end

switch ncells
	case 3
		cell{1}=cell1;
		cell{2}=cell2;
		cell{3}=cell3;
		height=seed/6; %for scaling rasters
		gap=(seed-(height*3))/4;
		if drawline>0
			drawline=2;
		end
	case 2
		cell{1}=cell1;
		cell{2}=cell2;
		height=seed/4; %for scaling rasters
		gap=(seed-(height*2))/3;
		if drawline>0
			drawline=2;
		end
	case 1
		cell{1}=cell1;
		height=seed/3; %for scaling rasters
		gap=(seed-(height))/2;
	otherwise
		errordlg('Problem plotting Raster, insufficient input parameters');
		error('Problem plotting Raster, insufficient input parameters');
end

if cell1.numtrials > 25
	drawline=0;
	yticks=0;
end

for j=1:length(cell)
	run=cell{j};
	time=run.maxtime/10000;
	if tmax == 0
		tmax = time;
	end
	
	if  ~isfield(run,'btrial') %double check for burst structure
		burst = 0;
	end

	for i=1:run.numtrials
		if isfield(run,'tDelta');
			len = run.tDelta(i);
			if isfield(run,'startOffset');
				slen = abs(run.startOffset);
			else
				slen = 0;
			end
		end
		x=vertcat(run.trial(i).mod{:})';		
		x=x/10000;	%convert into seconds
		%xx=[x(:,:);x(:,:)+width;x(:,:)+width;x(:,:)]; %this constructs a set of patch co-ordinates for each spike time
		xx=[x(:,:);x(:,:)]; %this is to use lines instead of patches
		count(i,j)=length(x);
		
		if burst==1
			b=vertcat(run.btrial(i).mod{:})';
			b=b/10000;
			bb=[b(:,:);b(:,:)];
		end
		
		trialoffset=(i-1)*seed;
		switch j
			case 1
				startpos=gap;
				endpos=gap+height;
			case 2
				startpos=(gap*2)+height;
				endpos=(gap*2)+(height*2);
			case 3
				startpos=(gap*3)+(height*2);
				endpos=(gap*3)+(height*3);
		end
		%[xt,yy]=meshgrid([1:length(x)],[startpos+trialoffset; startpos+trialoffset; endpos+trialoffset; endpos+trialoffset]); %gets y coordinates to match x for patch
		%[xt,yy]=meshgrid([1:length(x)],[startpos+trialoffset; endpos+trialoffset]); %generates y coordinates for lines
		yy=repmat([startpos+trialoffset; endpos+trialoffset],1,length(x));
		if burst==1 yb=repmat((startpos+trialoffset)-0.15,1,length(b)); end
		%yb=repmat([startpos+trialoffset; endpos+trialoffset],1,length(b));
		
		%patch(xx,yy,cols(j,:),'EdgeColor','none');
		if exist('len','var')
			st=startpos+trialoffset;
			et=endpos+trialoffset;
			patch([slen len+slen len+slen slen],[st st et et],[0.8 0.8 0.5],'EdgeColor','none');
		end
		set(gca, 'NextPlot', 'add');
		if burst==1; plot(b,yb,'r^','MarkerSize',4); end
		line(xx,yy,'Color',cols(j,:),'LineWidth',0.025);
		if drawline==2 && j==1
			line([0 time],[trialoffset+seed trialoffset+seed],'Color',[.8 .8 .8]);
			text(tmax-(tmax/15),trialoffset+(seed/2),num2str(length(x)));
		elseif drawline==1 && j==1
			line([0 time], [trialoffset+(seed/2) trialoffset+(seed/2)],'Color',[.8 .8 .8]);
			text(tmax-(tmax/15),trialoffset+(seed/2),num2str(length(x)));
		end
		set(gca, 'NextPlot', 'replace');
	end
end

if yticks==1
	yticks=seed/2:seed:(run.numtrials*10)-seed/2;
	set(gca,'YTick',yticks);
	set(gca,'YTickLabel',num2str([1:run.numtrials]'));
else
	set(gca,'YTick',[]);
	set(gca,'YTickLabel','');
end

if exist('tmax','var')
	axis([-0.01 tmax 0 run.numtrials*seed]);
else
	axis([-0.01 time 0 run.numtrials*seed]);
end
xlabel('Time (s)');
ylabel('Trials')
box on;
tickdir('out');
set(gca,'Layer','top');