////////////////////////////////////////////////////////////////////////
// Arduino Bluetooth Interface with Mindset
// 
// This is example code provided by NeuroSky, Inc. and is provided
// license free.
//
// MindSetArduinoReader.pde
// Modified from Tutorial.pde by Sean M. Montgomery 2010/09
// Program displays selected brainwave measurement on a bar LED and 
// the "errorRate" measure of signal quality (zero = good) on an LED
// and sends selected brainwave measurements and time of data aquisition
// to a computer via the arduino serial port.
//
// See http://www.produceconsumerobot.com/mindset/ for additional 
// installation and usage instructions.
//
// 2010/09/16
// Selected data is output in csv serial stream
// added raw data parsing
// added power data parsing
// added sampling delay to accomodate slower display programs
// fixed payloadData too small bug
// fixed syncing bug
// 
////////////////////////////////////////////////////////////////////////

#define LED 13
#define BAUDRATE 57600
#define DEBUGOUTPUT 0
#define BLUESMIRFON 2

#define GREENLED1  3
#define GREENLED2  4
#define GREENLED3  5
#define YELLOWLED1 6
#define YELLOWLED2 7
#define YELLOWLED3 8
#define YELLOWLED4 9
#define REDLED1    10
#define REDLED2    11
#define REDLED3    12

// neuro data variables
byte errorRate = 200;
byte attention = 0;
byte meditation = 0;
short raw;
unsigned int delta;
unsigned int theta;
unsigned int alpha1;
unsigned int alpha2;
unsigned int beta1;
unsigned int beta2;
unsigned int gamma1;
unsigned int gamma2;

// system variables
unsigned long lastReceivedPacket = micros();
unsigned long totalTime = 0;
boolean newRawData = false;
boolean bigPacket = false;

//////////////////////////
// Microprocessor Setup //
//////////////////////////
void setup() {
 
  pinMode(GREENLED1, OUTPUT);
  pinMode(GREENLED2, OUTPUT);
  pinMode(GREENLED3, OUTPUT);
  pinMode(YELLOWLED1, OUTPUT);
  pinMode(YELLOWLED2, OUTPUT);
  pinMode(YELLOWLED3, OUTPUT);
  pinMode(YELLOWLED4, OUTPUT);
  pinMode(REDLED1, OUTPUT);
  pinMode(REDLED2, OUTPUT);
  pinMode(REDLED3, OUTPUT);
  
  pinMode(LED, OUTPUT);
  pinMode(BLUESMIRFON, OUTPUT);
  digitalWrite(BLUESMIRFON, HIGH);
  Serial.begin(BAUDRATE);           // USB
}



/////////////
//MAIN LOOP//
/////////////
void loop() {
  ReadData();

#if !DEBUGOUTPUT

  // *** Add your code here ***
 
  /* samplingDelay interposes a delay (in microseconds) between serial writes.
  ** This can be necessary for viewing data in an oscilloscope program that runs slowly.
  ** 3906 ~ 256Hz 
  ** 7812 ~ 128Hz is a good starting point on most computers
  ** Typically raw data sampled at least 4x the frequency of interest is advised. 
  ** NOTE that using MindSetViewer.pde, the data logging to file appears to work correctly 
  ** at short samplingDelay (even zero) that cause problems for on-screen plotting. */
  unsigned long samplingDelay = 7812; // in microseconds
  unsigned long lastDelay = GetMicrosDelay(lastReceivedPacket);  
  if ( lastDelay > samplingDelay ) {
    if (newRawData) {
      newRawData = false;
      totalTime += (lastDelay / 100); // in 0.1 milliseconds
      lastReceivedPacket = micros();      
      Serial.print(raw, DEC);
      Serial.print(",");
      Serial.print(alpha2, DEC);
      Serial.print(",");
      Serial.print(alpha1, DEC);
      Serial.print(",");
      Serial.print(meditation, DEC);
      //Serial.print(",");
      //Serial.print(attention, DEC);
      Serial.print(",");
      Serial.print(totalTime, DEC); // record time (in 0.1 ms) data was received for accuracy
      Serial.println(",");
    }
  }
          
  if(bigPacket) {
    bigPacket = false;        
    if(errorRate == 0)
      digitalWrite(LED, HIGH);
    else
      digitalWrite(LED, LOW);
                 
    ControlLEDs( meditation / 10 );              
  }
  
#endif        
}

void ControlLEDs(unsigned int controlVar) {
  switch(controlVar) {
    case 0:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, LOW);
      digitalWrite(GREENLED3, LOW);
      digitalWrite(YELLOWLED1, LOW);
      digitalWrite(YELLOWLED2, LOW);
      digitalWrite(YELLOWLED3, LOW);
      digitalWrite(YELLOWLED4, LOW);
      digitalWrite(REDLED1, LOW);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);           
      break;
    case 1:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, LOW);
      digitalWrite(YELLOWLED1, LOW);
      digitalWrite(YELLOWLED2, LOW);
      digitalWrite(YELLOWLED3, LOW);
      digitalWrite(YELLOWLED4, LOW);
      digitalWrite(REDLED1, LOW);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);
      break;
    case 2:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);
      digitalWrite(YELLOWLED1, LOW);
      digitalWrite(YELLOWLED2, LOW);
      digitalWrite(YELLOWLED3, LOW);
      digitalWrite(YELLOWLED4, LOW);
      digitalWrite(REDLED1, LOW);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);
      break;
    case 3:              
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, LOW);
      digitalWrite(YELLOWLED3, LOW);
      digitalWrite(YELLOWLED4, LOW);
      digitalWrite(REDLED1, LOW);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);             
      break;
    case 4:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, HIGH);
      digitalWrite(YELLOWLED3, LOW);
      digitalWrite(YELLOWLED4, LOW);
      digitalWrite(REDLED1, LOW);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);              
      break;
    case 5:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, HIGH);
      digitalWrite(YELLOWLED3, HIGH);
      digitalWrite(YELLOWLED4, LOW);
      digitalWrite(REDLED1, LOW);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);               
      break;
    case 6:              
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, HIGH);
      digitalWrite(YELLOWLED3, HIGH);
      digitalWrite(YELLOWLED4, HIGH);
      digitalWrite(REDLED1, LOW);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);              
      break;
    case 7:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, HIGH);
      digitalWrite(YELLOWLED3, HIGH);
      digitalWrite(YELLOWLED4, HIGH);
      digitalWrite(REDLED1, HIGH);
      digitalWrite(REDLED2, LOW);
      digitalWrite(REDLED3, LOW);              
      break;    
    case 8:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, HIGH);
      digitalWrite(YELLOWLED3, HIGH);
      digitalWrite(YELLOWLED4, HIGH);
      digitalWrite(REDLED1, HIGH);
      digitalWrite(REDLED2, HIGH);
      digitalWrite(REDLED3, LOW);
      break;
   case 9:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, HIGH);
      digitalWrite(YELLOWLED3, HIGH);
      digitalWrite(YELLOWLED4, HIGH);
      digitalWrite(REDLED1, HIGH);
      digitalWrite(REDLED2, HIGH); 
      digitalWrite(REDLED3, HIGH);
      break;
   case 10:
      digitalWrite(GREENLED1, HIGH);
      digitalWrite(GREENLED2, HIGH);
      digitalWrite(GREENLED3, HIGH);              
      digitalWrite(YELLOWLED1, HIGH);
      digitalWrite(YELLOWLED2, HIGH);
      digitalWrite(YELLOWLED3, HIGH);
      digitalWrite(YELLOWLED4, HIGH);
      digitalWrite(REDLED1, HIGH);
      digitalWrite(REDLED2, HIGH); 
      digitalWrite(REDLED3, HIGH);
      break;           
  }
}

////////////////////////////////
// Read data from Serial UART //
////////////////////////////////
byte ReadOneByte() {
  int ByteRead;

  while(!Serial.available());
  ByteRead = Serial.read();

#if DEBUGOUTPUT  
  Serial.print((char)ByteRead);   // echo the same byte out the USB serial (for debug purposes)
#endif

  return ByteRead;
}

/////////////////////////////////////////
// Reading data from MindSet bluetooth //
////////////////////////////////////////
void ReadData() {
  static unsigned char payloadData[256]; 
  byte generatedChecksum;
  byte checksum; 
  byte vLength;
  int payloadLength;
  int powerLength = 3; // defined in MindSet Communications Protocol
  int k;

  
  // Look for sync bytes
  if(ReadOneByte() == 170) {
    if(ReadOneByte() == 170) {

      do { payloadLength = ReadOneByte(); }
      while (payloadLength == 170);
      
      if(payloadLength > 170) {    //Payload length can not be greater than 170
         return;
      }
      
      generatedChecksum = 0;        
      for(int i = 0; i < payloadLength; i++) {  
        payloadData[i] = ReadOneByte();            //Read payload into memory
        generatedChecksum += payloadData[i];
      }   

      checksum = ReadOneByte();                      //Read checksum byte from stream      
      generatedChecksum = 255 - generatedChecksum;   //Take one's compliment of generated checksum
      
      if(checksum != generatedChecksum) {  
        // checksum error  
      } else {  

        for(int i = 0; i < payloadLength; i++) {    // Parse the payload
          switch (payloadData[i]) {
          case 2:
            bigPacket = true;            
            i++;            
            errorRate = payloadData[i];         
            break;
          case 4:
            i++;
            attention = payloadData[i];                        
            break;
          case 5:
            i++;
            meditation = payloadData[i];
            break;
          case 0x80: // raw data
            newRawData = true;
            i++;
            vLength = payloadData[i]; 
            raw = 0;
            for (int j=0; j<vLength; j++) {
              raw = raw | ( payloadData[i+vLength-j]<<(8*j) ); // bit-shift little-endian
            }
            i += vLength;
            break;
          case 0x83:  // power data
            i++;
            vLength = payloadData[i]; 
            k = 0;
            
            // parse power data starting at the last byte
            gamma2 = 0; // mid-gamma (41 - 49.75Hz)
            for (int j=0; j<powerLength; j++) {
              gamma2 = gamma2 | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            gamma1 = 0; // low-gamma (31 - 39.75Hz)
            for (int j=0; j<powerLength; j++) {
              gamma1 = gamma1 | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            beta2 = 0; // high-beta (18 - 29.75Hz)
            for (int j=0; j<powerLength; j++) {
              beta2 = beta2 | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            beta1 = 0; // low-beta (13 - 16.75Hz)
            for (int j=0; j<powerLength; j++) {
              beta1 = beta1 | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            alpha2 = 0; // high-alpha (10 - 11.75Hz)
            for (int j=0; j<powerLength; j++) {
              alpha2 = alpha2 | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            alpha1 = 0; // low-alpha (7.5 - 9.25Hz)
            for (int j=0; j<powerLength; j++) {
              alpha1 = alpha1 | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            theta = 0; // theta (3.5 - 6.75Hz)
            for (int j=0; j<powerLength; j++) {
              theta = theta | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            delta = 0; // delta (0.5 - 2.75Hz)
            for (int j=0; j<powerLength; j++) {
              delta = delta | ( payloadData[i+vLength-k]<<(8*j) ); // bit-shift little-endian
              k++;
            }
            
            i += vLength;
            break;          
          default:
            break;
          } // switch
        } // for loop
      } // checksum success
    } // sync 2
  } // sync 1
} // ReadData

/* GetMicrosDelay 
** calculates time difference in microseconds between current time
** and passed time
** accounts for rollover of unsigned long
*/
unsigned long GetMicrosDelay(unsigned long t0) {
  unsigned long dt; // delay time (change)
  
  unsigned long t1 = micros();
  if ( (t1 - t0) < 0 ) { // account for unsigned long rollover
    dt = 4294967295 - t0 + t1 + 1; 
  } else {
    dt = t1 - t0;
  }
  return dt;
}
    
