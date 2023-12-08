function overDone(const, expDes)
% ----------------------------------------------------------------------
% overDone
% ----------------------------------------------------------------------
% Goal of the function :
% Close screen, listen keyboard and save duration of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
fid = fopen(const.blockLog, 'a');
fprintf(fid, '\n');
fprintf(fid, 'Block%i', const.block);

% .mat file
save(const.design_fileMat,'expDes');
save(const.const_fileMat, 'const');

% timestamp_path = strrep(const.responses_fileMat,'responses', 'timestamps');
% save(timestamp_path,'trial_onsets');

%figure
%plot(responses(1:length(responses)/4))

ListenChar(1);
%WaitSecs(2.0);

ShowCursor;
Screen('CloseAll');
sca;
timeDur=toc/60;
fprintf(1,'\nTotal time : %2.0f min.\n\n',timeDur);

if ~const.expStop && const.staircasemode > 0 % later add the no-staircase condition to plot
    plottt(const,expDes)
end

if const.staircasemode == 0
    performance_PC = 100*(sum(expDes.response(:,2))/length(expDes.response(:,2)));
    disp(sprintf('PERCENT CORRECT: %s', num2str(performance_PC)))
    
    if performance_PC < 75
        disp('SUBJECT NEEDS TO DO ANOTHER PRACTICE BLOCK, OR CAN QUIT.')
    else
        disp('SUBJECT PASSES PERFORMANCE THRRESHOLD.')
    end
    
end


%PsychPortAudio('Stop', const.pahandle);
%PsychPortAudio('Close', const.pahandle); %added

clear mex;
clear fun;

end

