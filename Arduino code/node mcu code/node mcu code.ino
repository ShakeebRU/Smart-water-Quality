
#include <SoftwareSerial.h>
#include <ArduinoJson.h>
SoftwareSerial espSerial(D6, D5);


#include <FirebaseESP8266.h>
#include <ESP8266WiFi.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Memeee"
#define WIFI_PASSWORD "12341234"
WiFiClient  clkient;
/* 2. Define the RTDB URL */
#define DATABASE_URL "water-quality-check-76f33-default-rtdb.firebaseio.com"
//<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 3. Define the Firebase Data object */
FirebaseData fbdo;

/* 4, Define the FirebaseAuth data for authentication data */
FirebaseAuth auth;

/* Define the FirebaseConfig data for config data */
FirebaseConfig config;

unsigned long dataMillis = 0;

  int waterlvl;
  float temp,tds,turb,ph;

void setup()
{

    Serial.begin(115200);
    espSerial.begin(115200);
    while(!Serial) continue;
    // connect to wifi.  
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);  
    Serial.print("connecting");  
    while (WiFi.status() != WL_CONNECTED) {  
      Serial.print(".");  
      delay(500);  
    }  
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println(); 

   
    /* Assign the database URL(required) */
    config.database_url = DATABASE_URL;

    config.signer.test_mode = true;

    Firebase.reconnectWiFi(true);

    /* Initialize the library with the Firebase authen and config */
    Firebase.begin(&config, &auth);
}

void loop()
{
  StaticJsonBuffer<1000> jsonBuffer;
  JsonObject& data = jsonBuffer.parseObject(espSerial);
  if(data == JsonObject::invalid())
  {
    jsonBuffer.clear();
    return;
  }
  waterlvl = data["waterlvl"];
  ph = data["ph_val"];
  turb = data["turb_val"];
  tds = data["tds_val"];
  temp = data["temp_val"];
  Serial.println();
  sendDataToFirebase();
  delay(3);
}


void sendDataToFirebase()
{
        Serial.printf("Send waterlvl... %s\n", Firebase.setInt(fbdo, "/shakeebru007/waterlevel", waterlvl) ? "ok" : fbdo.errorReason().c_str());
        Serial.printf("Set ph... %s\n", Firebase.setFloat(fbdo, "/shakeebru007/ph", ph) ? "ok" : fbdo.errorReason().c_str());
        Serial.printf("Set turbidity... %s\n", Firebase.setFloat(fbdo, "/shakeebru007/turbidity", turb) ? "ok" : fbdo.errorReason().c_str());
        Serial.printf("Set tds... %s\n", Firebase.setFloat(fbdo, "/shakeebru007/tds", tds) ? "ok" : fbdo.errorReason().c_str());
        Serial.printf("Set temperature... %s\n", Firebase.setFloat(fbdo, "/shakeebru007/temp", temp) ? "ok" : fbdo.errorReason().c_str());
}
