/*
 * NÓ NO MEIO
 * RECEBE MENSAGEM DO NÓ ANTERIOR E ENVIA PARA O NÓ SEGUINTE
 * 
 */

#include <ESP8266WiFi.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>

// Login e senha do nó (modo AP)
const char *ssid = "node_middle1";
const char *password = "a12345678";

// Login e senha do nó seguinte
const char *nextSSID = "main_node";
const char *nextPassword = "a12345678";

// Verifica se a conexão já foi feita com o nó anterior
int connectionMadeWithLastNode = 0;

// Verifica se fez a conexao com o nó seguinte
int connectionMadeWithNextNode = 0;

// Verifica se o modo cliente já foi configurado
int clientModeConfigured = 0;

// Verifica se já fez primeira conexão com o nó anterior
int firstConnection = 0;

// Para contar tempo acordado
int initTime = 0;

// Endereço de IP fixo para o nó na rede dele (access point)
IPAddress apIP(192, 168, 4, 1);  

ESP8266WebServer server(80);

void response();
void configAPMode();
void configClientMode();
void sendMessage();
void handleAwakeTime();

void setup() {
  Serial.begin(115200);
  ESP.wdtEnable(30000);
  configAPMode();
}

void loop() {
  if(millis() - initTime < 30000 || firstConnection == 0){ // Fica acordado por 30 segundos.
    handleAwakeTime();
  } else {
    if(connectionMadeWithNextNode == 1){
      Serial.println("Conseguiu connectar com nó seguinte!!!");
    } else {
      Serial.println("NÃO conseguiu conectar com nó seguinte...");
    }
    
    Serial.println("Sleeping ...");
    
    // Modem Sleep: dorme por 20 segundos.
    ESP.wdtFeed();
    WiFi.forceSleepBegin();
    delay(20000);
    WiFi.forceSleepWake();
    
    Serial.println("###################################################################################################");
    Serial.println("AWAKE!");
    configAPMode();
    initTime = millis();
    connectionMadeWithLastNode = 0;
    connectionMadeWithNextNode = 0;
    clientModeConfigured = 0;
  }
}

void response() {
  Serial.print("MENSAGEM DO ULTIMO NÓ: ");
  Serial.println(server.arg("plain"));
  server.send(200);
  connectionMadeWithLastNode = 1;
  firstConnection = 1;
}

void configAPMode() {
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAP(ssid, password);

  server.on("/", response);
  server.begin();

  Serial.println("###################################################################################################");
  Serial.println("AWAKE!");
}

void configClientMode() {
  WiFi.softAPdisconnect(true);
  WiFi.disconnect(true);
  // WiFi.mode(WIFI_STA);
  WiFi.begin(nextSSID, nextPassword);
  WiFi.mode(WIFI_AP_STA);
  clientModeConfigured = 1;
  Serial.println("CLIENT MODE");
}

void sendMessage(){
  if (WiFi.status() == WL_CONNECTED){
    Serial.println(WiFi.localIP());
    HTTPClient http;
    http.begin("http://192.168.4.1");
    http.addHeader("Content-Type", "application/json");
    Serial.println("aguardando ......");
    int httpCode = http.POST("{\"Value\": 200}");
    Serial.print("HTTP Code: ");
    Serial.println(httpCode);
    connectionMadeWithNextNode = 1;
    
    http.end();
  }
}

void handleAwakeTime() {
  if(connectionMadeWithLastNode == 0){
    server.handleClient();
  } else {
    if(clientModeConfigured == 0) {
      configClientMode();
    } else if(connectionMadeWithNextNode == 0) {
      sendMessage();
    }
  }
}

