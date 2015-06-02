if core.setting_get("fire") == nil then
   core.setting_setbool("fire",true)
   core.setting_save()
end

local fires = {
   any = core.setting_getbool("fire",false)
}

function fires:spreading(name)
   return self[name] or self.any
end

function fires:quench(name)
   self[name] = true
end

core.register_chatcommand("nofire", {
                             description = "Stop flames from spreading",
                             privs = {server=true},
                             func = function(name,param)
                                if param == "" then
                                   fires.any = false
                                   core.setting_setbool("fire",false)
                                   core.setting_save()
                                   core.chat_send_player(name,"fire has been quenched")
                                end
                             end
})
core.register_chatcommand("fire", {
                             param="<type>|all"
                             description = "Selectively start fire spreading",
                             privs = {server=true},
                             func = function(name,param)
                                if param == "" then
                                   fires.burning = true
                                   core.setting_setbool("fire",true)
                                   core.setting_save()
                                   core.chat_send_player(name,"fire has been quenched")
                                end
                             end
})
minetest.require("fire","basic")
minetest.require("fire","quick")
print('\27[1m\27[31m[fire loaded]\27[m')
