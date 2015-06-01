core.setting_setbool("fire",true)
core.register_chatcommand("nofire", {
                             description = "Stop flames from spreading",
                             privs = {server=true},
                             func = function(name,param)
                                core.setting_setbool("fire",false)
                                core.chat_send_player(name,"fire has been quenched")
                             end
})
minetest.require("fire","basic")
minetest.require("fire","quick")
print('\27[1m\27[31m[fire loaded]\27[m')
