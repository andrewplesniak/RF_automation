function [] = relMove(inches,a,stp,dir,MS1,MS2,EN)
%this function takes an input of inches (+ or -) and drives the
%OpenBuild linear belt actuator that amount
%This program controls a stepper motor using a sparkfun easydriver.
%1/8 micro stepping
%When attatched to Open Builds Linear belt driven actuator: 26.667 Steps/mm = 677.3418 Steps/in

steps = round(inches * 677.3418);
LOW = 0;
HIGH = 1;
writeDigitalPin(a,EN, LOW); %Pull enable pin low to allow motor control

if steps >= 0 %motor moves 'forward'
    steps = abs(steps);
    writeDigitalPin(a,dir, LOW);  %Pull direction pin low to move "forward"
    writeDigitalPin(a,MS1, HIGH); %Pull MS1, and MS2 high to set logic to 1/8th microstep resolution
    writeDigitalPin(a,MS2, HIGH);
    for x= 1:steps
        writeDigitalPin(a,stp,HIGH); %Trigger one step forward
        pause(0.001);
        writeDigitalPin(a,stp,LOW); %Pull step pin low so it can be triggered again
        pause(0.001);
    end
else %motor moves 'backward'
    steps = abs(steps);
    writeDigitalPin(a,dir, HIGH);  %Pull direction pin high to move "backward"
    writeDigitalPin(a,MS1, HIGH); %Pull MS1, and MS2 high to set logic to 1/8th microstep resolution
    writeDigitalPin(a,MS2, HIGH);
    for x= 1:steps
        writeDigitalPin(a,stp,HIGH); %Trigger one step forward
        pause(0.001);
        writeDigitalPin(a,stp,LOW); %Pull step pin low so it can be triggered again
        pause(0.001);
    end 
end

%reset pins to original state
writeDigitalPin(a,stp, LOW);
writeDigitalPin(a,dir, LOW);
writeDigitalPin(a,EN, HIGH);

end

