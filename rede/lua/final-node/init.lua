print("vai comecar")

tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()
    print("comecou")
    dofile("final.lua")
end)
