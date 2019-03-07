function arduinoMove(arduino,relNextPosition,movecommand,acknowledge,done)
%This function completes the handshake for the move command to the arduino
%   and sends the number of inches to move

fprintf(arduino,movecommand); % send move command to arduino
while (arduino.BytesAvailable <= 0) %wait for the acknowledge from arduino
end
while (fscanf(arduino) ~= acknowledge) %wait for the acknowledge from arduino
end
fprintf(arduino, '%f', relNextPosition); % send number of inches to move to arduino
while (arduino.BytesAvailable <= 0) %wait for the acknowledge from arduino
end
while (fscanf(arduino) ~= done) %wait for the done command from arduino
end

end

