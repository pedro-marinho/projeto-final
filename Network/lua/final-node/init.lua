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
local wificonf = {
  -- verificar ssid e senha
  ssid = "PEDRO",
  pwd = "MARCELOM",
  -- callback que vai executar qdo ganhar IP na rede:
  -- got_ip_cb = function (iptable) print ("ip: ".. iptable.IP); send_message(); end,
  save = false
}
wifi.setmode(wifi.STATIONAP)
wifi.sta.config(wificonf)

print("COMECOU")
while true do
    if wifi.sta.getip() ~= nil then
        print(wifi.sta.getip())
    end
end
