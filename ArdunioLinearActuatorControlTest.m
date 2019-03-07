%Andrew Plesniak
%10/4/2018
%test code that controls the linear actuator through an arduino
clear
clc


%intial values and setup
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
arduino = serial('COM3');
arduino.Terminator = {'CR/LF',''};
fopen(arduino);
pause(3);
movecommand = 'M';
getdatacommand = 'C';
acknowledge = 'A';
done = 'D';
position = [-4 -2 0 2 4]; % must have zero in center of array and be in ascending order form left to right
numPositions = size(position,2);
currentPositionIndex = floor(numPositions/2) + 1;
currentPosition = position(currentPositionIndex); %should intially be zero
numTrials = input('How many trials sets would you like to run?: ');


%move to minimum position
relNextPosition = position(1)-position(currentPositionIndex);
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
currentPositionIndex=1;
direction = 1; 

for z = 1 : numPositions*numTrials
    clc
    fprintf('Trial Set Number = %d\n', floor(z/numPositions)+1) 
    fprintf('     Currently Gathering Data at Position = %d inches\n', position(currentPositionIndex))
    % this is where frequency is swept
    
    
    %data is read from the arduino average of 5 readings
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
    
    %turns direction around if at end of position array
    if direction == 1 || direction == 0
        if currentPositionIndex >= numPositions
            if  direction == 0
                direction = -1;
            else
                direction = 0;
            end
        end
    end
    if direction == -1 || direction == 0
        if currentPositionIndex <= 1
            if  direction == 0
                direction = 1;
            else
                direction = 0;
            end
        end        
    end
    relNextPosition = position(currentPositionIndex+direction)-position(currentPositionIndex);
    currentPositionIndex = currentPositionIndex+direction;
    fprintf(arduino, movecommand); % send move command to arduino
    while (arduino.BytesAvailable <= 0) %wait for the acknowledge from arduino 
    end
    while (fscanf(arduino) ~= acknowledge) %wait for the acknowledge from arduino
    end
    fprintf(arduino, '%f', relNextPosition); % send inches to move arduino
    while (arduino.BytesAvailable <= 0) %wait for the acknowledge from arduino 
    end
    while (fscanf(arduino) ~= done) %wait for the done command from arduino
    end
    pause(0.25);
end
clc
disp('Done!')

fclose(arduino);
delete(arduino);







