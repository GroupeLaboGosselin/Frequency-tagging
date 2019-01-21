function [trl,event,hdr] = InterResponseSSVEP_trialfunction(cfg)


% read the header information and the events from the data
hdr     = ft_read_header(cfg.dataFile);         %For continuously recorded data, nSamplesPre=0 and nTrials=1.
event   = ft_read_event(cfg.dataFile);
% search for "trigger" events


% value=[];
% for ii=1:(length(event))
%     value =[value (str2num(event(ii).value))];
% end

sample = [event(strcmp('trigger', {event.type})).sample]';


% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.pre  * hdr.Fs);
%posttrig =  round(cfg.trialdef.post * hdr.Fs);

% look for the combination of a trigger "1" followed by a trigger "2"
% for each trigger except the last one
trl = [];
trial_counter=0;
for ii = 2:(length(sample)-1)
    trg1 = event(ii).value;
    trg2 = event(ii+1).value;
    event_vector(ii)=event(ii).value;
    if ~strcmp('__',trg1) && ~strcmp('__',trg2)
        if (trg1 ==9) && (trg2==19)  %|| (trg1 ==8) && (trg2==18) %strcmp(trg1,'21') && strcmp(trg2,'31')  || str2num(trg1)== 21 && str2num(trg2)==31 || str2num(trg1)== 22 && str2num(trg2)==31
            
            trlbegin = sample(ii)-0.5*1024;
            trlend   = sample(ii)+4*1024;%+ posttrig;
%             trlbegin = sample(ii);
%             trlend   = sample(ii)+4*1024;%+ posttrig;

            offset   = pretrig;
            newtrl   = [trlbegin trlend offset];
            trl      = [trl; newtrl];
            
            trial_counter=trial_counter+1;
            
            
        else
            ii;
        end;
    end
end
end
%