function [voltage] = arduinoGetData(arduino, getdatacommand, acknowledge, done)
%data is read from the arduino (average of 5 readings done in arduino code)
       fprintf(arduino, getdatacommand); % send the get data command to arduino
        while (arduino.BytesAvailable <= 0) %wait for the acknowledge from arduino
        end
        while (fscanf(arduino) ~= acknowledge) %wait for the acknowledge from arduino
        end
        while (arduino.BytesAvailable <= 3) %wait for the data from arduino
        end
        voltage = fread(arduino,1,'float32'); % retrieves average voltage data from arduino
        while (arduino.BytesAvailable <= 0) %wait for the acknowledge from arduino
        end
        while (fscanf(arduino) ~= done) %wait for the done command from arduino
        end
end

