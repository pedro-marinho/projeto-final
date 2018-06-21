/* 
 *  NÓ MAIS AFASTADO (FINAL)
 *  ENVIA UM POST COM O VALOR DO SEU SENSOR PARA O NÓ SEGUINTE.
 *  
*/
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

// Login e senha do nó seguinte
const char* ssid = "node_middle1";
const char* password = "a12345678";

// Verifica se já conseguiu realizar a primeira conexão com o nó seguinte.
int firstConnection = 0;

// Verifica se conseguiu comunicar durante o tempo acordado.
int connectionMade = 0;

// Para contar tempo acordado
int initTime = 0;

// Envia o valor do sensor para o nó seguinte
void sendMessage(){
  if (WiFi.status() == WL_CONNECTED){
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    HTTPClient http;
    http.begin("http://192.168.4.5");
    http.addHeader("Content-Type", "application/json");
    int httpCode = http.POST("{\"Value\": 150}");
    Serial.print("HTTP Code: ");
    Serial.println(httpCode);
    firstConnection = 1;
    connectionMade = 1;
    
    // String payload = http.getString();
    http.end();
  }
}
 
void setup () { 
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  ESP.wdtEnable(30000);

  Serial.println("###################################################################################################");
  Serial.println("AWAKE!");
}

void loop() {
  // Fica acordado "pra sempre" até fazer a primeira conexão. Depois, fica acordado por 30 segundos.
  if(millis() - initTime < 30000 || firstConnection == 0){
    if(connectionMade == 0){
      sendMessage();
    }
  } else {
    if(connectionMade == 1){
      Serial.println("Conseguiu connectar!!!");
    } else {
      Serial.println("NÃO conseguiu conectar...");
    }
    Serial.println("Sleeping ...");
  
    // Modem Sleep: dorme por 20 segundos.
    ESP.wdtFeed();
    WiFi.forceSleepBegin();
    delay(20000);
    WiFi.forceSleepWake();

    Serial.println("###################################################################################################");
    Serial.println("AWAKE!");
    initTime = millis();
    connectionMade = 0;
  }
}
