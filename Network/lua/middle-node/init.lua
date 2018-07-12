-- Criando AP
wifi.setmode(wifi.STATIONAP)
-- SSID e Senha do AP
wifi.ap.config({ssid="middle_node1", pwd="a12345678"})
-- Definindo IP no modo AP
wifi.ap.setip({ip="192.168.4.1", netmask="255.255.255.0", gateway="192.168.4.1"})

-- Inicializando
print("AWAKE")
print(wifi.ap.getip())

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

-- Callback para função que envia mensagem
local function cb_send_message(code, data)
  if (code < 0) then
    print("HTTP request failed: " .. codigo)
  else
    print(code, data)
  end
end

-- Envia mensagem para o próximo nó
local function send_message()
  http.get("http://192.168.4.1", 'Content-Type: application/json\r\n', '{"value":"150"}', cb_send_message)
end

-- Configurando modo cliente
local function config_client_mode()
  local wificonf = {
    -- verificar ssid e senha
    ssid = "main_node",
    pwd = "a12345678",
    -- callback que vai executar qdo ganhar IP na rede:
    got_ip_cb = function (iptable) print ("ip: ".. iptable.IP); send_message(); end,
    save = false
  }
  wifi.sta.config(wificonf)
end

-- Responde a requisição
local response_connection = function(client, request)
  local end_connection =  function() 
    print("respondeu")
    print(request)
    client:close()
    config_client_mode()
  end
  client:send(buf, end_connection)
end

-- Trata a conexão
local handle_connection = function(conn)
  print ("recebeu conexao")
  conn:on("receive", response_connection) 
end

-- Espera conexão
local server = net.createServer(net.TCP)
if server then
  server:listen(80, "192.168.4.1", handle_connection)
end
