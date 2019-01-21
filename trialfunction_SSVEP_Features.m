function [trl,event,hdr] = trialfunction_SSVEP_Features(cfg)

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
passCounter=1;
for ii = 2:(length(sample)-1)
    trg1 = event(ii).value;
    trg2 = event(ii+1).value;
    event_vector(ii)=event(ii).value;
    if  (trg1==1)
                 
                 sprintf('trial %d as started',trial_counter)
        
                 
    end
    if ~strcmp('__',trg1) && ~strcmp('__',trg2)
        
        if trg1==2
            passCounter=1
             sprintf('trial %d as ended',trial_counter)
        end
        if  trg1==1 && passCounter==1 %(trg1==18|| trg1==19) && passCounter==1%&& (trg2==8) || (trg1==1) && (trg2==9) %(trg1 ==1) && (trg2==9) || (trg1 ==1) && (trg2==8)% || strcmp(trg1,'21') && strcmp(trg2,'31')  || str2num(trg1)== 21 && str2num(trg2)==31 || str2num(trg1)== 22 && str2num(trg2)==31
        passCounter=0;
            
            trlbegin = sample(ii)+.5*1024;
            trlend   = sample(ii)+69*1024;%+ posttrig;
            offset   = pretrig;
            newtrl   = [trlbegin trlend offset];
            
            trial_counter=trial_counter+1
            trl      = [trl; newtrl];
            
            
            
        else
            ii;
        end;
    end
    %
%         if trial_counter>=16
%             break;
%         end
% %     
end