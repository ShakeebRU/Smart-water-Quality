int water_lvl;
float tds_val,turb_val,ph_val,temp_val;
//........water level sensor.....
int level1=A0;
int level2=A1;
int level3=A2;
int level4=A3;
int level5=A4;
int motor=6;
int a,b,c,d,e;//for comparison of water level wires
int r; //Water Pump status
int m=0; //SENSORS ACTIVE flag 
int z=111; // Adjust this value from 100 to 1023 if your circuit do not show correct value. 
// water level sensor end.....
//........ph sensor........
int phval = 0; 
#include <Wire.h>
float calibration_value = 21.34;
unsigned long int avgval; 
int buffer_arr[10],temp;
//........ph sensor end....

//........turbidity........
  
  //#include <Wire.h> 
   
  int Turbidity_Sensor_Pin = A5;
  float Turbidity_Sensor_Voltage;
  int samples = 800;
  float ntu; 

//.......turbidity end.....

//.......tds sensor........
  #include <EEPROM.h>
  #include "GravityTDS.h"
   
  #define TdsSensorPin A6
  GravityTDS gravityTds;
  
  float temperature = 25,tdsValue = 0;
//.......tds end...........

//........temprature.......
#include <DallasTemperature.h>
// Data wire is plugged into digital pin 2 on the Arduino
#define ONE_WIRE_BUS 2
OneWire oneWire(ONE_WIRE_BUS);  
DallasTemperature sensors(&oneWire);
//.........temperature end....
#include <SoftwareSerial.h>
#include <ArduinoJson.h>
SoftwareSerial espSerial(10,11);
void setup() 
{
  Serial.begin(115200);
  espSerial.begin(115200);
  delay(2000);
 //.....water level sensor.....
pinMode(level1,INPUT);
pinMode(level2,INPUT);
pinMode(level3,INPUT);
pinMode(level4,INPUT);
pinMode(level5,INPUT);
pinMode(motor,OUTPUT);
 //...........................
  
 //.......tds sensor..........
    gravityTds.setPin(TdsSensorPin);
    gravityTds.setAref(5.0);  
    gravityTds.setAdcRange(1024);  //1024 for 10bit ADC;4096 for 12bit ADC
    gravityTds.begin();  //initialization
 //...........................
 //..........turbidity........
    pinMode(Turbidity_Sensor_Pin, INPUT);
 //...........................  
}
void loop() 
{
//...water level...
a=analogRead(level1);
b=analogRead(level2);
c=analogRead(level3);
d=analogRead(level4);
e=analogRead(level5);

if(e>z && d>z && c>z && b>z && a>z )
{
  digitalWrite(motor,LOW);
  Serial.println("Tank is 100% FULL");
   water_lvl =100;
  m=1;
}
else
{
  if(e<z && d>z && c>z && b>z && a>z )
  {
  Serial.println("Tank is 80% FULL");
   water_lvl =80;
   m=1;
  }
  else
  {
    if(e<z && d<z && c>z && b>z && a>z )
    {
      Serial.println("Tank is 60% FULL");
      water_lvl =60;
      m=1;
    }
    else
    {
      if(e<z && d<z && c<z && b>z && a>z )
      {
        Serial.println("Tank is 40% FULL");
        water_lvl =40;
        m=1;
      }
      else
      {
        if(e<z && d<z && c<z && b<z && a>z )
        {
          Serial.println("Tank is 20% FULL");
          water_lvl = 20;
          m=1;
        }
        else
        {
          if(e<z && d<z && c<z && b<z && a<z )
          {
              digitalWrite(motor,HIGH);
              Serial.println("Tank is EMPTY");
              water_lvl =0;
              m=0;
          }
        }
      }
    }
  }
}
if(r==LOW)
{
    Serial.println("Water Pump is (OFF)");
}
else
{
    Serial.println("Water Pump is (ON)");
}
//...water level end...
if(m==1)
  {
  //....temperature...........
  
    // Send the command to get temperatures
        sensors.requestTemperatures(); 
        //print the temperature in Celsius
        float temp = sensors.getTempCByIndex(0);
        Serial.print("Temperature: ");
        temp_val = temp;
        Serial.print(temp);
        Serial.print("*");//shows degrees character
        Serial.println("C");
  //.........................
  
  //.......turbidity.........
  
      Turbidity_Sensor_Voltage = 0;
      for(int i=0; i<samples; i++)
      {
          Turbidity_Sensor_Voltage += ((float)analogRead(Turbidity_Sensor_Pin)/1023)*5;
      }
      Turbidity_Sensor_Voltage = Turbidity_Sensor_Voltage/samples;
      
      //Turbidity_Sensor_Voltage = round_to_dp(Turbidity_Sensor_Voltage,2);
   
      Serial.print("TUrbidity value : ");
      turb_val = Turbidity_Sensor_Voltage;
      Serial.print(Turbidity_Sensor_Voltage);
      Serial.println(" NTU" );
      
  //.........................
  
  //.........ph.............
  
   for(int i=0;i<10;i++) 
   { 
     buffer_arr[i]=analogRead(A7);
     delay(30);
   }
   for(int i=0;i<9;i++)
   {
     for(int j=i+1;j<10;j++)
     {
       if(buffer_arr[i]>buffer_arr[j])
       {
         temp=buffer_arr[i];
         buffer_arr[i]=buffer_arr[j];
         buffer_arr[j]=temp;
       }
     }
   }
   avgval=0;
   for(int i=2;i<8;i++)
      avgval+=buffer_arr[i];//taking average sensored values
   float volt=(float)avgval*5.0/1024/6;//to calculate voltage from sensored data
   float ph_act = -5.70 * volt + calibration_value;//to calculate actual ph value from calculated voltage
   Serial.print("pH Value:");
   Serial.println(ph_act);
   ph_val = ph_act;
   //..........................
  
   //........tds...............

      sensors.requestTemperatures(); 
      temperature = sensors.getTempCByIndex(0);  
      gravityTds.setTemperature(temperature);  // set the temperature and execute temperature compensation
      gravityTds.update();  //calculations here
      tdsValue = gravityTds.getTdsValue();  // then get the value
      Serial.print("TDS Value:");
      Serial.print(tdsValue,0);
      Serial.println("ppm");
      tds_val = tdsValue;
  //..........................
  }
  else
  {
    Serial.println("water level is not enought to get sensors values"); 
    water_lvl =0;
    tds_val = 0;
    turb_val = 0;
    ph_val = 0;
    temp_val = 0;
  }
 Serial.print('\n');
// senddata();
 
  StaticJsonBuffer<1000> jsonBuffer;
  JsonObject& data = jsonBuffer.createObject();

  data["ph_val"] =  ph_val;
  data["waterlvl"] =  water_lvl;
  data["turb_val"] =  turb_val;
  data["tds_val"] =  tds_val;
  data["temp_val"] =  temp_val;

  data.printTo(espSerial);
  jsonBuffer.clear();
 delay(10000);    
}


float round_to_dp( float in_value, int decimal_place )
{
  float multiplier = powf( 10.0f, decimal_place );
  in_value = roundf( in_value * multiplier ) / multiplier;
  return in_value;
}
