-- Callback para função que envia mensagem
local function cb_send_message(code, data)
  if (code < 0) then
    print("HTTP request failed: " .. code)
  else
    print("codigo")
    print(code)
    print("data")
    print(data)
  end
end

-- Envia mensagem para o próximo nó
local function send_message()
  --http.post("http://192.168.4.1", "Content-Type: application/json\r\n", '{"value":"150"}', cb_send_message)
  --http.get("http://192.168.4.1", nil, cb_send_message)
  tmr.alarm(1, 2000, tmr.ALARM_AUTO, function()
     if(wifi.sta.getip()~=nil) then
          tmr.stop(1)
          print("Connected!")
          print("Client IP Address: " .. wifi.sta.getip())
          cl=net.createConnection(net.TCP, 0)
          cl:connect(80, "192.168.4.1")
          tmr.alarm(2, 5000, tmr.ALARM_AUTO, function()
          r1, r1 = cl:getpeer()
            if r1 ~= nil then
                print("Connected")
                tmr.stop(2)
                cl:send("Hello World!")
            else
                print("Connecting")
            end
          end)
      else
         print("Connecting...")
      end
end)
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
