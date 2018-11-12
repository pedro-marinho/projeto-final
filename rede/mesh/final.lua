local mesh = require "mesh"

print("awake")
mesh.newNode(3)

tmr.create():alarm(15000, tmr.ALARM_SINGLE, function()
    print("station")
    mesh.sendData('[{"value":"250","sensor":"final"}]')
end)