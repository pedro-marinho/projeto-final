local mesh = require "mesh"

print("awake")
mesh.newNode(2)

tmr.create():alarm(15000, tmr.ALARM_SINGLE, function()
    print("station")
    mesh.sendData('[{"value":"150","sensor":"middle"}]')
end)