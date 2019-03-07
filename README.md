# Automated Radio Frequency Testing Scripts 
## --Andrew Plesniak

These Matlab scripts automate the process of collecting spatial RF power data with the use of a RF Generator, belt driven linear actuator, an arduino, a stepper motor, stepper motor driver and a RF power sensor. Matlab handles the high-level logic and commands, data processing, controlling the RF generator, and communication to the arduino. The arduino has locally running code that is responsible for taking data readings and motor control based on the values passed from Matlab.