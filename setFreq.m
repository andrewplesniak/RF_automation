function [meas_RF_FREQ,meas_RF_LEV] = setFreq(dsg3000,i)
%Sets Frequency on the Function Generator
        fprintf(dsg3000, ':SYST:PRES:TYPE FAC' ); %Send request to query the frequency
        fprintf(dsg3000, ':SYST:PRES');
        fprintf(dsg3000, strcat(':FREQ', 32, num2str(i), 'MHz')); % send the frequency of the given iteration
        fprintf(dsg3000, ':LEV 10'); % set the level
        fprintf(dsg3000, ':OUTP ON'); % turn on output
        fprintf(dsg3000, ':FREQ?' );
        meas_RF_FREQ = fscanf(dsg3000); %Read the frequency data
        fprintf(dsg3000, ':LEV?' ); %Send request to query the amplitude
        meas_RF_LEV = fscanf(dsg3000); %Read the amplitude data
end

