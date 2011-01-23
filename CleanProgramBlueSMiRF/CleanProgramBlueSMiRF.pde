////////////////////////////////////////////////////////////////////////
// Arduino BlueSMiRF initial baudrate changer
// 
// This is example code provided by NeuroSky, Inc. and is provided
// license free.
//
// * Connect BlueSMiRF RX and TX to Serial on Arduino board (pins 0 & 1)
// * Connect BlueSMiRF VCC to the pin corresponding to BLUESMIRFON
// * 
////////////////////////////////////////////////////////////////////////

/**** CleanProgramBlueSMiRF.pde ****
** Modified by Sean M Montgomery 2010/12
** Programs a BlueSMiRF module with the specified MAC address
** for use with the NeuroSky MindSet. 
** 
** Modified to do an automatic factory reset to avoid needing
** to run the program twice.
************************************/

/**** SET YOUR MAC ADDRESS HERE ****/

char mac[13] = "0013EF0005B1";

/***********************************/


#define LED 13
#define BLUESMIRFON 2

#define FACTORYRESETBAUD 57600
#define DEFAULTBAUD 115200

char str[3];
char passkey[5] = "0000";

boolean success = false;

int failOuts[10] = {3,4,5,6,7,8,9,10,11,12};

void setup() 
{ 
  //Initialize pins
  pinMode(LED, OUTPUT);
  pinMode(BLUESMIRFON, OUTPUT);
  for (int i=0; i<10; i++) {
    pinMode(failOuts[i], OUTPUT);
  }

  // First reset to factory defaults
  while (!success) {
    RunBlueSmirfSetup(true);
  }
  success = false;
  // Then set up with the correct mac address
  RunBlueSmirfSetup(false);
} 

void loop() {   
  if(success) {
    digitalWrite(LED,LOW);
    delay(1000);
    digitalWrite(LED,HIGH);
    delay(1000);
  }    
} 

void RunBlueSmirfSetup(boolean factoryReset) {

  //Initialize serial ports
  if (factoryReset) {
    Serial.begin(FACTORYRESETBAUD);   
  } else {
    Serial.begin(DEFAULTBAUD);   
  }   

  digitalWrite(BLUESMIRFON, LOW);
  delay(2000);
  digitalWrite(BLUESMIRFON, HIGH);  
  delay(2000);			        //Wait for BlueSMIRF to turn on

  Serial.print('$');			//Send command to put BlueSMIRF into programming mode
  Serial.print('$');
  Serial.print('$');
  
  delay(100);
  Serial.flush();
  
   //Reset the module
  if (factoryReset) {
    Serial.print('S');
    Serial.print('F');
    Serial.print(',');
    Serial.print('1');
    Serial.print('\r');  
    
    while(Serial.available() < 3);
    str[0] = (char)Serial.read();
    str[1] = (char)Serial.read();
    str[2] = (char)Serial.read();  
    if(str[0] == 'A' && str[1] == 'O' && str[2] == 'K') {
      success = true;
    } else {
      success = false;
      digitalWrite(failOuts[0],HIGH);
    }
    delay(100);
    Serial.flush();
  } else {
    //Set the baudrate
    Serial.print('S');
    Serial.print('U');
    Serial.print(',');
    Serial.print('5');
    Serial.print('7');
    Serial.print('\r');  
    
    while(Serial.available() < 3);
    str[0] = (char)Serial.read();
    str[1] = (char)Serial.read();
    str[2] = (char)Serial.read();  
    if(str[0] == 'A' && str[1] == 'O' && str[2] == 'K') {
      success = true;
    } else {
      success = false;
      digitalWrite(failOuts[1],HIGH);
    }
    delay(100);
    Serial.flush();
    
    //Set the remote MAC address
    Serial.print('S');
    Serial.print('R');
    Serial.print(',');
    for(int i = 0; i < 12; i++) {
      Serial.print(mac[i]);
    }
    Serial.print('\r');  
    
    while(Serial.available() < 3);
    str[0] = (char)Serial.read();
    str[1] = (char)Serial.read();
    str[2] = (char)Serial.read();  
    if(str[0] == 'A' && str[1] == 'O' && str[2] == 'K') {
      success = true;
    } else {
      success = false;
      digitalWrite(failOuts[2],HIGH);
    }
    delay(100);
    Serial.flush();
    
    //Set the passkey
    Serial.print('S');
    Serial.print('P');
    Serial.print(',');
    for(int i = 0; i < 4; i++) {
      Serial.print(passkey[i]);
    }
    Serial.print('\r');  
    
    while(Serial.available() < 3);
    str[0] = (char)Serial.read();
    str[1] = (char)Serial.read();
    str[2] = (char)Serial.read();  
    if(str[0] == 'A' && str[1] == 'O' && str[2] == 'K') {
      success = true;
    } else {
      success = false;
      digitalWrite(failOuts[3],HIGH);
    }
    delay(100);
    Serial.flush(); 
    
    //Set the BlueSMiRF mode
    Serial.print('S');
    Serial.print('M');
    Serial.print(',');
    Serial.print('3');
    Serial.print('\r');
    
    while(Serial.available() < 3);
    str[0] = (char)Serial.read();
    str[1] = (char)Serial.read();
    str[2] = (char)Serial.read();  
    if(str[0] == 'A' && str[1] == 'O' && str[2] == 'K') {
      success = true;
    } else {
      success = false;
      digitalWrite(failOuts[4],HIGH);
    }
    delay(100);
    Serial.flush();
    
    delay(100);
    //Exit command mode
  } 
  Serial.print('-');
  Serial.print('-');
  Serial.print('-');
  Serial.print('\r');

  //delay(100);
  //Serial.flush();
  //delay(100);
  //Serial.end();
  //digitalWrite(BLUESMIRFON, LOW);
}


