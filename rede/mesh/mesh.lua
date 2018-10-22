local string = require "string"
local buf = "resposta"

local key = '1234567890abcdef'
local baseSSID = "MeshNetwork"

local nodeId;

local M = {}


-- Envia mensagem
local function send_message(data)
    cl=net.createConnection(net.TCP, 0)
    cl:on("receive", function(sck, c) print(c) end)
    -- cl:on("disconnection", function(sck, c) print("vai dormir"); node.dsleep(10000000); end)
    cl:on("connection", function(sck, c)
      encryptedData = crypto.encrypt("AES-CBC", key, data)
      sck:send(encryptedData)
    end)
    cl:connect(80,"192.168.4.1")
end

-- Configura modo cliente
local function config_client_mode(ssid, data)
    local wificonf = {
      ssid = ssid,
      pwd = "a12345678",
      got_ip_cb = function (iptable) print ("ip: ".. iptable.IP); send_message(data); end,
      save = false
    }
    wifi.sta.config(wificonf)
end

-- Responde a requisição
local function response_connection(client, request)
    local end_connection =  function() 
        print("requisicao")
        data = crypto.decrypt("AES-CBC", key, request):match("(.-)%z*$")
        print(data)
        client:close()
        if nodeId ~= 1 then
            M.sendData(data)
        else
            print('no final')
            -- mandar pro servidor
        end
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
      server:listen(80, "192.168.4.1", handle_connection)
    end
end

-- Coloca um novo nó na rede
function M.newNode(id)
    nodeId = id
    wifi.setmode(wifi.SOFTAP)
    wifi.ap.config({ssid=baseSSID .. tostring(id), pwd="a12345678"})
    wifi.ap.setip({ip="192.168.4.1", netmask="255.255.255.0", gateway="192.168.4.1"})

    initialize()
end

-- Envia dado para o próximo nó
function M.sendData(data)
    function listap(t)
        for ssid, mac in pairs(t) do
            local initial, final = string.find(ssid, 'MeshNetwork', 1, true)
            if initial ~= nil and final ~= nil then
                local nextNodeId = tonumber(string.sub(ssid, final + 1, string.len(ssid)))
                if nodeId > nextNodeId then
                    print('vai mandar')
                    config_client_mode(ssid, data)
                    break
                end
            end
        end
    end
    wifi.setmode(wifi.STATION)
    wifi.sta.getap(listap)
end

return M