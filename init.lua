if core.setting_get("fire") == nil then
   core.setting_setbool("fire",true)
   core.setting_save()
end

fires = {
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
      param = "<flame>?",
      privs = {server=true},
      func = function(player,flame)
         if flame == "" then
            if fires.blacklist then
               fires.blacklist = false
               core.setting_setbool("fire",false)
               core.setting_save()
            end
            fires.flames = {}
            core.chat_send_player(player,"fire has been quenched")
         else                                   
            fires:quench(flame)
            core.chat_send_player(player,"Quenching "..flame)
         end
      end
})

core.register_chatcommand(
   "fire", {
      param="<type>?",
      description = "Start fire spreading",
      privs = {server=true},
      func = function(player,flame)
         if flame == "" then
            fires.blacklist = true
            fires.flames = {}
            core.setting_setbool("fire",true)
            core.setting_save()
            core.chat_send_player(player,"All fire is spreading!")
         else
            fires:spread(flame)
            core.chat_send_player(player,"Fire "..flame.." started spreading.")
         end
      end
})

dofile(core.get_modpath("fire").."/basic.lua")
dofile(core.get_modpath("fire").."/quick.lua")
print('\27[1m\27[31m[fire loaded]\27[m')
