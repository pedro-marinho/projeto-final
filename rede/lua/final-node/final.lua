local string = require "string"

-- Cria JSON
local function parseJSONArray(source, str)
  return string.sub(source, 1, string.len(source) - 1)..str.."]"
end

-- Callback para função que envia mensagem
local function cb_send_message(code, data)
  if (code < 0) then
    print("HTTP request failed: " .. code)
  else
    print("codigo: " .. code)
  end

  print("vai dormir")
  node.dsleep(10000000)
end

-- Envia mensagem para o próximo nó
local function send_message()
  cl=net.createConnection(net.TCP, 0)
  cl:on("receive", function(sck, c) print(c) end)
  cl:on("connection", function(sck, c)
    sck:send('{"value":"150","sensor":"final","time":"1530155052"}')
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