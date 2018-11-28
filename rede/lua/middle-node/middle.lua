local string = require "string"

-- Criando AP
wifi.setmode(wifi.SOFTAP)
-- SSID e Senha do AP
wifi.ap.config({ssid="middle_node1", pwd="a12345678"})
-- Definindo IP no modo AP
wifi.ap.setip({ip="192.168.4.2", netmask="255.255.255.0", gateway="192.168.4.2"})

-- Variável que armazena dado recebido
local data

local key = '1234567890abcdef'

-- Lê valor
local function getValue()
  return ',{"value":"250","sensor":"middle1"}'
end

-- Inicializando
print("AWAKE")
print(wifi.ap.getip())

-- Cria JSON
local function parseJSONArray(source, str)
  return string.sub(source, 1, string.len(source) - 1)..str.."]"
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

-- Envia mensagem para o próximo nó
local function send_message()
  cl=net.createConnection(net.TCP, 0)
  cl:on("receive", function(sck, c)
    print(c)
    if file.open("log.txt", "a+") then
      file.writeline("fim do envio: " .. tmr.time()) 
      file.close()
    end
  end)

  cl:on("disconnection", function(sck, c) print("vai dormir"); node.dsleep(10000000); end)

  cl:on("connection", function(sck, c)
    dataToSend = parseJSONArray(data, getValue())
    encryptedData = crypto.encrypt("AES-CBC", key, dataToSend)
    sck:send(encryptedData)
  end)
  cl:connect(80,"192.168.4.3")
end

-- Configurando modo cliente
local function config_client_mode()
  if file.open("log.txt", "a+") then
    file.writeline("inicio do envio: " .. tmr.time()) 
    file.close()
  end
  local wificonf = {
    -- verificar ssid e senha
    ssid = "main_node",
    pwd = "a12345678",
    -- callback que vai executar qdo ganhar IP na rede:
    got_ip_cb = function (iptable) print ("ip: ".. iptable.IP); send_message(); end,
    save = false
  }
  wifi.setmode(wifi.STATION)
  wifi.sta.config(wificonf)
end

-- Responde a requisição
local function response_connection(client, request)
  local end_connection =  function() 
    print("requisicao")
    data = crypto.decrypt("AES-CBC", key, request):match("(.-)%z*$")
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
    server:listen(80, "192.168.4.2", handle_connection)
  end
end

initialize()