local D = 1

local function get_area_p0p1(pos)
        local p0 = {
           x=pos.x-D,
           y=pos.y-D,
           z=pos.z-D,
        }
        local p1 = {
           x=pos.x+D,
           y=pos.y+D,
           z=pos.z+D,
        }
        return p0, p1
end

local maxNewFlames = 0x400

-- Ignite neighboring nodes
function makeQuickFlame(victims,name)

   local newFlames = 0

   local function resetFlames()
      newFlames = 0
      minetest.after(2,resetFlames)
   end
   resetFlames()

   name = "fire:"..name
   local png = "fire_"..name..".png"
   function spreadFlames(p0)
      if minetest.setting_getbool("fire") then
         if newFlames < maxNewFlames then
            newFlames = newFlames + 1
            local minp,maxp = get_area_p0p1(p0)
            local nearby = minetest.env:find_nodes_in_area(minp,maxp,victims)
            for n,pos in pairs(nearby) do
               minetest.env:set_node(pos,{name=name})
            end
            minetest.env:remove_node(p0)
         end
      else
         minetest.env:remove_node(p0)
      end
   end

   minetest.register_node(name, {
                             description = "Fire",
                             drawtype = "glasslike",
                             tile_images = {png}
                             light_source = 14,
                             groups = {dig_immediate=3},
                             drop = name,
                             walkable = false,
   })

   -- Ignite neighboring nodes
   minetest.register_abm(
      {
         nodenames = {name}
         interval = 1 ,
         chance = 1,
         action = spreadFlames,
   })
end

makeQuickFlame("group:flammable","quick_flame")
makeQuickFlame("group:water","evaporater")
makeQuickFlame("group:lava","quencher")
