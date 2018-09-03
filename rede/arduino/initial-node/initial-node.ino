/*
 * NÓ PRINCIPAL (INICIAL)
 * VAI ENVIAR A MENSAGEM RECEBIDA PARA O SERVIDOR.
 * 
 */

#include <ESP8266WiFi.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>

extern "C" { 
#include<user_interface.h>
}

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


WiFiEventHandler stationConnectedHandler;
struct station_info *stat_info;
struct ip_addr *IPaddress;
IPAddress address;



void response() {
  Serial.println(server.arg("plain"));
  firstConnection = 1;
  server.send(200);
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP(ssid, password);

  server.on("/", response);
  server.begin();

  Serial.println("###################################################################################################");
  Serial.println("AWAKE!");
  Serial.print("AP MODE IP: ");
  Serial.println(WiFi.softAPIP());

  stationConnectedHandler = WiFi.onSoftAPModeStationConnected(&onStationConnected);
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

void onStationConnected(const WiFiEventSoftAPModeStationConnected& evt) {
  Serial.print("Station connected: ");
  Serial.println(evt.aid);
  Serial.print("Stations connected to soft-AP: ");
  Serial.println(WiFi.softAPgetStationNum());
  dumpClients();
}

void dumpClients()
{
  Serial.print("Clients:\r\n");
  stat_info = wifi_softap_get_station_info();
  while (stat_info != NULL)
  {
    IPaddress = &stat_info->ip;
    address = IPaddress->addr;
    Serial.print("\t");
    Serial.print(address);
    Serial.print("\r\n");
    stat_info = STAILQ_NEXT(stat_info, next);
  } 
}
