%LOADVSTEXT Loads Text data from VSX output.
%   Load VSX text file data
%
%   V0.1 Nov 2005 Initial release

function [meta] = loadvstext(file)

meta = [];

fid=fopen(file);
if fid==-1
	disp(['Load VS Text Error: Sorry, cannot open the text file: ' file '; please check the path.']);
	return
end
tline={''};
a=1;
while 1
    tline{a} = fgetl(fid);
    if ~ischar(tline{a}), break, end
    a=a+1;
end
fclose(fid);

meta.filename=file;

b=1; %used for the raw variable matrix
for i=1:size(tline,2)
    if ischar(tline{i})
		if regexpi(tline{i}, '^Indep Variables:');
			names=regexp(tline{i}, '^Indep Variables:(?<values>.+)','names');
			if ~isempty(names)
				meta.numvars=str2num(names.values);				
			end
		elseif regexpi(tline{i}, '^Var\d')
			names=regexp(tline{i},'^Var(?<num>\d)(?<type>[^:]*): (?<values>.+)$','names');
			if ~isempty(names)
				if isempty(names.type)
					meta.var{str2num(names.num)}.title=names.values;
				elseif regexpi(names.type,'Actual values')
					meta.var{str2num(names.num)}.values=str2num(names.values);
					meta.var{str2num(names.num)}.range=size(str2num(names.values),2);
				end
				
			end	
		elseif regexpi(tline{i}, '^Repeats:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)				
				meta.repeats=str2num(names.values);				
			end
		elseif regexpi(tline{i}, '^Cycles:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.cycles=str2num(names.values);				
			end
		elseif regexpi(tline{i}, '^Mod time:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.modtime=str2num(names.values);				
			end
		elseif regexpi(tline{i}, '^TF:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.tempfreq=str2num(names.values);	
			else
				meta.tempfreq==[];
			end
		elseif regexpi(tline{i}, '^Trial time:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.trialtime=str2num(names.values);				
			end
		elseif regexpi(tline{i}, '^Protocol:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.protocol=names.values;				
			end
		elseif regexpi(tline{i}, '^Protocol descrip:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.description=names.values;				
			end
		elseif regexpi(tline{i}, '^Filecomm:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.comments=names.values;
			else
				meta.comments=' ';
			end
		elseif regexpi(tline{i}, '^Date:')
			names=regexp(tline{i}, '^.+: (?<values>.+)','names');
			if ~isempty(names)
				meta.date=names.values;				
			else
				meta.date=' ';
			end
		elseif regexp(tline{i}, '^\s\s\s\s\s')
			names=regexp(tline{i}, '^(?<val1>[^:]+):(?<val2>.+)','names');
			if ~isempty(names)
				meta.matrix(b,:)=str2num([names.val1 names.val2]);				
				b=b+1;
			end
        end
    end
end