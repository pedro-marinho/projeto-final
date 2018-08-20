local string = require "string"

-- Criando AP
wifi.setmode(wifi.STATIONAP)
-- SSID e Senha do AP
wifi.ap.config({ssid="main_node", pwd="a12345678"})
-- Definindo IP no modo AP
wifi.ap.setip({ip="192.168.4.3", netmask="255.255.255.0", gateway="192.168.4.3"})

-- Inicializando
print("AWAKE")
print(wifi.ap.getip())

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

  -- print("vai dormir")
  -- cfg = {}
  -- cfg.wake_pin = 4
  -- cfg.duration = 1000000
  -- cfg.preserve_mode=false
  -- cfg.resume_cb = function() print("WiFi resume"); initialize(); end
  -- node.sleep(cfg)
end

-- Envia mensagem para o próximo nó
local function send_message()
  http.post("http://polar-dawn-30624.herokuapp.com/values", 'Content-Type: application/json\r\n', parseJSONArray('[{"value":"150","sensor":"final","time":"1530155052"},{"value":"250","sensor":"middle1","time":"1530155052"}]',',{"value":"350","sensor":"initial","time":"1530155052"}'), cb_send_message)
end

local function config_client_mode()
  local wificonf = {
    -- verificar ssid e senha
    ssid = "PEDRO 2.4",
    pwd = "MARCELOM",
    -- callback que vai executar qdo ganhar IP na rede:
    got_ip_cb = function (iptable) print ("ip: ".. iptable.IP); send_message(); end,
    save = false
  }
  wifi.sta.config(wificonf)
end

-- Conteúdo da resposta da conexao
buf = [[
HTTP/1.1 200 OK
Content-Type: text/html
Connection: Closed

<html>
<body>
<h1>Hello, World!</h1>
</body>
</html>
]]

-- Responde a requisição
local function response_connection(client, request)
  local end_connection =  function() 
    print("requisicao")
    print(request)
    client:close()
    config_client_mode()
  end
  client:send(buf, end_connection)
end

-- Trata a conexão
local function handle_connection(conn)
  print ("recebeu conexao")
  conn:on("receive", response_connection) 
end

-- Espera conexão
local function initialize()
  local server = net.createServer(net.TCP)
  if server then
    server:listen(80, "192.168.4.3", handle_connection)
  end
end

initialize()