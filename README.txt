*** MindSetAruduino ***
MindSetAruduino is a collection of Arduino and Processing scripts put together by Dr. Sean M. Montgomery - http://produceconsumerobot.com/ - to read EEG data off the NeuroSky MindSet. These scripts allow MindSet data to be read into an Arduino via a BlueSMiRF to directly control physical computing projects with brainwaves. The Arduino may also be connected to a computer USB port to relay the data over the serial stream for live plotting and logging in Processing. The scripts including in this package are:

CleanProgramBlueSMiRF - Arduino program modified from code provided by NeuroSky to reset the BlueSMiRF to communicate with the MAC address of your MindSet.

MindSetArduinoReader - Arduino program modified from code provided by NeuroSky to read and parse the data incoming from the MindSet via BlueSMiRF for control of attached LEDs and to pass the data over the Arduino serial stream in CSV format.

MindSetArduinoViewer - Processing program using the Arduinoscope library that reads live data off of the Ardiuno serial stream for display and logging to disk in CSV format.


Materials (as seen in materials.jpg):
1	NeuroSky MindSet	   
1	Arduino	   
1	BlueSMiRF Gold	   
1	prototyping breadboard with wire kit	   
1	10 segment bar LED	   
1	LED	   
11	75 Ohm (or similar) resistors	 


Required Software (see below for download instructions):
Arduino
Processing
Arduinoscope library
ControlP5 library
MindSetAruduino 


Instructions:

Download and extract arduino software
http://arduino.cc/en/Main/Software
getting started - http://arduino.cc/en/Guide/HomePage

Download the MindSetArduino package from https://github.com/produceconsumerobot/MindSetArduino including CleanProgramBlueSMiRF, MindSetArduinoReader, and MindSetArduinoViewer.

Wire up your Arduino to the BlueSMiRF in "Program Mode" as seen in wiring_diagram.jpg and plug the Arduino into one of your computer's USB ports. Open CleanProgramBlueSMiRF.pde with Arduino, go to the Tools menu and set your "Board" to match your specific Arduino board type and then go to "Serial Port" (also under Tools) and set the serial port to match the serial port your Arduino is communicating through. For more information on how to do this look at http://arduino.cc/en/Guide/HomePage.

To get your BlueSMiRF to listen to the MindSet, in CleanProgramBlueSMiRF.pde you need to change the MAC address (under "SET YOUR MAC ADDRESS HERE") to match the MAC address of your MindSet. This MAC address can be found labeled on the MindSet itself, in the documentation that came with your MindSet or in your Bluetooth settings for the MindSet after you have paired the MindSet with your computer's bluetooth. Once you've changed CleanProgramBlueSMiRF.pde to match your MindSet's MAC address, verify and upload the program to your Arduino. After the program completes successfully, the LED on I/O13 will flash at one second intervals. If the program failed, I/O13 will not flash and the bar LED will light up to indicate where in the program sequence it failed. If you experience a failure, try uploading the program a second time.

Once you successfully program the BlueSMiRF with your MindSet's MAC address, you can disconnect the RX pin on the BlueSMiRF (TX on the Arduino) to enter Run mode (as seen in wiring­_diagram.jpg). Open MindSetArduinoReader.pde in Arduino and then verify and upload. Turn on your MindSet and after a short negotiation period, the MindSet should auto-connect to the BlueSMiRF module indicated by a solid green LED on the BlueSmirf and a solid blue LED on the MindSet. If everything is working properly, when you open the Arduino Serial Monitor (under Tools), after a brief delay you should see several columns of CSV data streaming over the serial port.

It's now possible to use your MindSet to control your physical computing projects. You can change MindSetArduinoReader.pde in the "Add your code here" section to control the Arduino outputs with your brainwaves. 

It's VERY important to assess the quality of the EEG signal you are getting from the MindSet. When the EEG detection ErrorRate=0, the LED on I/O13 will light indicating good signal. This is a good start, but it's really important to look at the raw EEG signal to assess the quality visually. 

To look at the live signal being read from your MindSet, you can use MindSetArduinoViewer by following the below instructions.

Download and extract processing software
http://processing.org/download/
getting started - http://processing.org/learning/gettingstarted/

Download arduinoscope
http://arduinoscope.googlecode.com/files/processing-arduinoscope.zip
getting started -  http://code.google.com/p/arduinoscope/wiki/Usage
optional downloads - http://code.google.com/p/arduinoscope/downloads/list

Download and extract controlP5
http://www.sojamo.de/libraries/controlP5/

In the processing\libraries\ directory
create folder named arduinoscope
create folder named controlP5
unzip contents of processing-arduinoscope.zip into arduinoscope
unzip contents of controlp5.zip into controlP5.zip into controlP5
directory structure should be:
processing\libraries\arduinoscope\examples\
processing\libraries\arduinoscope\library\
processing\libraries\arduinoscope\reference\
processing\libraries\arduinoscope\src\
processing\libraries\controlP5\examples\
processing\libraries\controlP5\library\
processing\libraries\controlP5\reference\
processing\libraries\controlP5\src\

Open MindSetArduinoViewer.pde in Processing, change "the serialPort" variable to that of your Arduino (same port as set under Serial Port in Arduino) and hit Run. This should open a window that after a short delay displays your live EEG data coming off the MindSet. If you want to record data, press the green record button. You must have write privileges in your processing directory or change the directory specified in MindSetArduinoViewer.pde. You may change the y-scale of the individual plots using the "*2" and "/2" buttons or in the user-variable section of the code.

If you haven’t already, put the MindSet on your head and try to get a good EEG signal. Look for low background noise in the Raw EEG and low ErrorRates as seen in the top panel of "signal_quality.jpg". Note how you can clearly see eyeblinks on a low noise background indicating a a high quality signal in the top panel, while in the lower two panels it is not possible to distinguish eyeblinks from background noise. Many times you will get a good signal very quickly, but depending on several factors it can take as much as 30 seconds or more for the MindSet to settle into a good signal. To speed up that process it can be quite helpful to dab your forehead and ear with some salt water (1/4 teaspoon of salt in a cup of water works).
