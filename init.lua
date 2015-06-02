if core.setting_get("fire") == nil then
   core.setting_setbool("fire",true)
   core.setting_save()
end

local fires = {
   blacklist = core.setting_getbool("fire",false),
   flames = {}
}

function fires:spreading(name)
   if self.blacklist then
      return not self.flames[name]
   else
      return self.flames[name]
   end
end

function fires:quench(name)
   if self.blacklist then
      self.flames[name] = true
   else
      self.flames[name] = nil
   end    
end

function fires:spread(name)
   if self.blacklist then
      self.flames[name] = nil
   else
      self.flames[name] = true
   end
end

core.register_chatcommand(
   "nofire", {
      description = "Stop flames from spreading",
      privs = {server=true},
      func = function(name,param)
         if param == "" then
            if fires.blacklist then
               fires.blacklist = false
               core.setting_setbool("fire",false)
               core.setting_save()
            end
            fires.flames = {}
            core.chat_send_player(name,"fire has been quenched")
         else                                   
            fires:quench(param)
            core.chat_send_player("Quenching "..param)
         end
      end
})

core.register_chatcommand(
   "fire", {
      param="<type>?"
      description = "Start fire spreading",
      privs = {server=true},
      func = function(name,param)
         if param == "" then
            fires.blacklist = true
            fires.flames = {}
            core.setting_setbool("fire",true)
            core.setting_save()
            core.chat_send_player(name,"All fire is spreading!")
         else
            fires:spread(param)
            core.chat_send_player(name,"Fire "..name.." started spreading.")
         end
      end
})

minetest.require("fire","basic")
minetest.require("fire","quick")
print('\27[1m\27[31m[fire loaded]\27[m')
