local string = require "string"

local key = '1234567890abcdef'

-- Lê valor
local function getValue()
  return '[{"value":"150","sensor":"final"}]'
end

-- Envia mensagem para o próximo nó
local function send_message()
  cl=net.createConnection(net.TCP, 0)
  cl:on("receive", function(sck, c) print(c) end)
  cl:on("disconnection", function(sck, c) print("vai dormir"); node.dsleep(10000000); end)
  cl:on("connection", function(sck, c)
    dataToSend = getValue()
    encryptedData = crypto.encrypt("AES-CBC", key, dataToSend)
    sck:send(encryptedData)
    if file.open("log.txt", "a+") then
      file.writeline("Data sent at 1530155052") 
      file.close()
    end
  end)
  cl:connect(80,"192.168.4.2")
end

-- Configurando modo cliente
local wificonf = {
  -- verificar ssid e senha
  ssid = "middle_node1",
  pwd = "a12345678",
  -- callback que vai executar qdo ganhar IP na rede:
  got_ip_cb = function (iptable) print ("ip: ".. iptable.IP); send_message(); end,
  save = false
}

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)

print("AWAKE")