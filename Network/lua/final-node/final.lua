-- Callback para função que envia mensagem
local function cb_send_message(code, data)
  if (code < 0) then
    print("HTTP request failed: " .. code)
  else
    print("codigo: " .. code)
  end

  cfg = {}
  cfg.duration = 10000*1000
  cfg.resume_cb = function() print("WiFi resume") end
  node.sleep(cfg)
end

-- Envia mensagem para o próximo nó
local function send_message()
  http.post("http://192.168.4.2", "Content-Type: application/json\r\n", '{"value":"150"}', cb_send_message)
  --http.get("http://192.168.4.1", nil, cb_send_message)
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
print("AWAKE")
wifi.sta.disconnect()
wifi.setmode(wifi.STATIONAP)
wifi.sta.config(wificonf)
