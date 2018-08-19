-- Criando AP
wifi.setmode(wifi.STATIONAP)
-- SSID e Senha do AP
wifi.ap.config({ssid="main_node", pwd="a12345678"})
-- Definindo IP no modo AP
wifi.ap.setip({ip="192.168.4.3", netmask="255.255.255.0", gateway="192.168.4.3"})

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

-- Responde a requisição
local response_connection = function(client, request)
  local end_connection =  function() 
    print("requisicao")
    print(request)
    client:close()
    
    -- cfg = {}
    -- cfg.duration = 10000*1000
    -- cfg.resume_cb = function() print("WiFi resume") end
    -- node.sleep(cfg)
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
  server:listen(80, "192.168.4.3", handle_connection)
end
