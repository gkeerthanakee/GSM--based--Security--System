#include <SoftwareSerial.h>

// Define pins for SIM900 communication
SoftwareSerial SIM900(2, 3); // RX, TX

// Define variables for SMS and sensor
String textForSMS;
int pirsensor = 9;

// Define pins for LEDs
int red = 7;
int green = 8;

void setup() {
  randomSeed(analogRead(0));
  Serial.begin(9600);
  SIM900.begin(9600);
  Serial.println("System ready. Monitoring started...");

  // Configure sensor and LEDs
  pinMode(pirsensor, INPUT);
  pinMode(red, OUTPUT);
  pinMode(green, OUTPUT);

  digitalWrite(red, LOW);
  digitalWrite(green, LOW);

  delay(100);
}

void loop() {
  // Check for PIR sensor input
  if (digitalRead(pirsensor) == HIGH) {
    // Set SMS alert message
    textForSMS = "Motion detected! Someone is in your room. Please check.";

    // Turn on red LED (alarm)
    digitalWrite(red, HIGH);
    digitalWrite(green, LOW);

    // Send SMS
    sendSMS(textForSMS);
    Serial.println(textForSMS);
    Serial.println("SMS sent.");

    delay(8000); // delay to prevent multiple rapid alerts
  } else {
    // Turn off red, turn on green LED (safe)
    digitalWrite(red, LOW);
    digitalWrite(green, HIGH);

    delay(1000);
  }
}

void sendSMS(String message) {
  SIM900.print("AT+CMGF=1\r"); // Set SMS mode to text
  delay(1000);
  
  //  Replace with your own phone number
  SIM900.println("AT+CMGS=\"+91XXXXXXXXXX\""); 
  delay(1000);
  
  SIM900.println(message); // Message content
  SIM900.write(26);        // End message with Ctrl+Z
  delay(1000);
}
	
