%% Intro
% This Program runs a frequency sweep through the RF transmitter with the 
% Rigol function generator and reads data from an Arduino off of a peak 
% detector that is connected to the receiver. It is basically the same
% thing as RF_reader, except it is a bit more automated so that you don't
% have to input as much during the testing, so it accelerates the
% procedure.

%% Setup
% Here, we create a VISA object to open the driver for the function 
% generator, we create an arduino interface, and we initialize the
% matrices that will contain the data

clear
dsg3000 = visa( 'ni','USB0::0x1AB1::0x0992::DSG3B191900011::INSTR' ); %Create Visa object

a = arduino; % arduino object
freq = zeros(41,1);
voltage = zeros(41,1);
j = 1;
num_pos = 5;
k = 1;
data = zeros(41, 2, num_pos);
answer = input('Press y to start ','s');
position = [-4 -2 0 2 4]; % set the positions that you'll be collecting

%% Data collection loop
% We loop through the specified frequencies (in this case 800 - 1000 MHz in
% 5 MHz increments). We print commands specified by Rigol to the function
% generator to send the frequency and level of the output. We then read the
% value of the response from the arduino (I'm averaging the response of 5
% readings) and output to the screen.

while answer ~= 'n'
    
    for i = 800:5:1000
        fopen( dsg3000 ); %Open the visa object created
        fprintf(dsg3000, ':SYST:PRES:TYPE FAC' ); %Send request to query the frequency
        fprintf(dsg3000, ':SYST:PRES');
        fprintf(dsg3000, strcat(':FREQ', 32, num2str(i), 'MHz')); % send the frequency of the given iteration
        fprintf(dsg3000, ':LEV 10'); % set the level
        fprintf(dsg3000, ':OUTP ON'); % turn on output
        fprintf(dsg3000, ':FREQ?' );
        meas_RF_FREQ = fscanf(dsg3000); %Read the frequency data
        fprintf(dsg3000, ':LEV?' ); %Send request to query the amplitude
        meas_RF_LEV = fscanf(dsg3000); %Read the amplitude data
        fclose(dsg3000); %Close the visa object
        freq(j) = i;
        display(meas_RF_FREQ) %Display the amplitude read
        pause(0.01);
        % read and average the voltage:
        v1 = readVoltage(a,'A0');
        v2 = readVoltage(a,'A0');
        v3 = readVoltage(a,'A0');
        v4 = readVoltage(a,'A0');
        v5 = readVoltage(a,'A0');
        voltage(j) = mean([v1 v2 v3 v4 v5]);
        %st = std([v1 v2 v3 v4 v5]);
        display(voltage(j))
        %display(st);
        j = j + 1;
    end
    
    j = 1;
    % put data into a matrix
    pos_array(k) = position(k);
    data(:, 1, k) = freq;
    data(:, 2, k) = voltage;
    data(:, 3, k) = position(k);
    
    % ask user to continue
    answer = input('Would you like to keep going? (y or n) ','s');
    k = k + 1;
end

%% Save data
% This snippet saves the data with a user set filename. Note that I've got
% two potential inputs for the test_type variable. If you know you're going
% to be running a lot of one type of test, it makes sense to just set it
% and leave it. If you're going to be running different types of tests, it
% makes sense to allow user input.

test_type = 'flesh'; % input('Enter the type of test (eg. flesh, air, water, etc) ');
test_num = input('Enter the test number ','s');

filename = strcat(test_type,test_num,"_B4_11.mat"); % note that I included the transmitter and receiver identifiers
save(filename, 'data');

%% Graphing
% The rest of the code does some fancy matrix stuff to get the data into
% graphable form and then graphs it in a 3D plot
X = data(:,1,1); % frequency
X = repmat(X,1,length(data(1,:,:))); %create an array of frequencies for each position
X = reshape(X.',1,[]); % rearrange into a 1D array (800 800 800 805 805 805 ....)
Y = data(1,3,1):data(1,3,2) - data(1,3,1):data(1,3,length(data(1,1,:))); % positions
Y = repmat(Y,41,1); % position tag for each frequency
Y = reshape(Y.',1,[]); % rearrage into 1D array
Z = zeros(41,length(data(1,:,:))); % magnitude
for i = 1:length(data(1,:,:))
    for j = 1:41
        Z(j,i) = data(j,2,i);
    end
end
Z = reshape(Z.',1,[])/0.0293 - 86.4; % reshape into 1D array and convert from voltage to dB)
cfrequency=780:1:1020;  %x
cposition=-6.5:0.1:6.5;  %y
cpowergain=griddata(Y,X,Z,cposition',cfrequency,'cubic'); % 3D interpolation
meshz(cposition,cfrequency,cpowergain); % 3D plot
title('data through peak detector');
ylabel('Frequency(MHz)','FontSize',20);
xlabel('Position(in)','FontSize',20);
zlabel('Power Gain(dB)','FontSize',20);
set(gca,'Fontsize',20);
az = 0;
el = 90;
view(az, el);
xlim([-5 5]);
ylim([750 1050]);
colorbar('Limits',[-56 -35]);
% pcolor(Y,X,Z);cyl''
