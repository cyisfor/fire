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

local maxNewFlames = 0x1000

-- Ignite neighboring nodes
function makeQuickFlame(victims,name,replace)

   local newFlames = 0
   -- no indication that a block is DEactivated,
   -- but they will be continually reactivated,
   -- so just reset the number to 0 every
   -- now and again, and only the active ones
   -- will add to it.
   local function resetFlames()
      newFlames = 0
      minetest.after(2,resetFlames)
   end
   resetFlames()

   local png = "fire_"..name..".png"
   local nodename = "fire:"..name
   local function spreadFlames(p0)
      if fires:spreading(name) then
         if newFlames < maxNewFlames then
            newFlames = newFlames - 1
            local minp,maxp = get_area_p0p1(p0)
            local nearby = minetest.env:find_nodes_in_area(minp,maxp,victims)
            for n,pos in pairs(nearby) do
               if newFlames < maxNewFlames then
                  newFlames = newFlames + 1
                  minetest.env:set_node(pos,{name=nodename})
               else
                  break
               end
            end
         else
            newFlames = newFlames - 1
         end
         if replace then
            minetest.env:set_node(p0,{name=replace})
         else
            minetest.env:remove_node(p0)
         end
      else
         minetest.env:remove_node(p0)
      end
   end

   minetest.register_node(nodename, {
                             description = "Quick Fire ("..name..')',
                             drawtype = "glasslike",
                             tile_images = {png},
                             light_source = 14,
                             groups = {dig_immediate=3},
                             drop = nodename,
                             walkable = false,
   })

   -- Ignite neighboring nodes
   minetest.register_abm(
      {
         nodenames = {nodename},
         interval = 1 ,
         chance = 1,
         action = spreadFlames,
   })
end

makeQuickFlame("group:flammable","quick_flame")
makeQuickFlame("group:water","boiling_water")
makeQuickFlame("group:lava","quenching_lava")
makeQuickFlame("group:liquid","dry_dust")
makeQuickFlame("group:leafdecay","leaf_cutter")
