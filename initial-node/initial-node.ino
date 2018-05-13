/*
 * NÓ PRINCIPAL (INICIAL)
 * VAI ENVIAR A MENSAGEM RECEBIDA PARA O SERVIDOR.
 * 
 */

#include <ESP8266WiFi.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>

// Login e senha do nó (access point)
const char *ssid = "main_node";
const char *password = "a12345678";

// Verifica se a conexão já foi feita
int firstConnection = 0;

// Para contar tempo acordado
int initTime = 0;

// Endereço de IP fixo para o nó na rede dele (access point)
IPAddress apIP(192, 168, 4, 1);  

ESP8266WebServer server(80);

void response() {
  Serial.println(server.arg("plain"));
  firstConnection = 1;
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAP(ssid, password);

  server.on("/", response);
  server.begin();

  Serial.println("###################################################################################################");
  Serial.println("AWAKE!");
}

void loop() {
  if(millis() - initTime < 30000 || firstConnection == 0){ // Fica acordado por 30 segundos.
    server.handleClient();
  } else {
    Serial.println("Sleeping ...");
    
    // Modem Sleep: dorme por 20 segundos.
    WiFi.forceSleepBegin();
    delay(20000);
    WiFi.forceSleepWake();
    
    Serial.println("###################################################################################################");
    Serial.println("AWAKE!");
    initTime = millis();
  }
}
