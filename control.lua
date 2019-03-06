--------------------------
-- COPYRIGHT & LICENSE  --
--------------------------

-- Dectorio, a Factorio mod
-- Copyright (c) 2017-2019 James "PantherX" Panther

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- A copy of the GNU General Public License is packaged along with
-- this program.  You can also see <http://www.gnu.org/licenses/>.

--------------------------

-- control

DECT = require("config")

-- Send chat notification to all players or force
local function notification(txt, force)
	if force ~= nil then
		force.print(txt)
	else
		for k, p in pairs(game.players) do
			game.players[k].print(txt)
		end
	end
end

-- Initialise global vars
local function init_global()
	global = global or {}
	global.mod_incompatibility = nil
	global.icons = nil
	global.signs = global.signs or {}
	global.sign_last_built = global.sign_last_built or {}
	global.sign_gui = global.sign_gui or {}
end

-- Initialise global.icons with all the possible icons
local function init_icons()
	if global.icons == nil then
		local icons = {}
		for _, prototype in pairs(game.entity_prototypes) do
			if prototype.type == "simple-entity" then
				if prototype.name:find("dect%-icon") then
					local orig_prototype = prototype.name:gsub("dect%-icon%-", "")
					table.insert(icons, {name=prototype.name, type=prototype.order, prototype=orig_prototype})
				end
			end
		end
		global.icons = icons
	end
end

-- Initialise some command handlers
local function init_commands()
	-- Clear out any old ones before we attempt to add them
	-- (mainly because when some old saves are migrated they might already have these and will with throw an error)
	commands.remove_command("dect-destroy-orphaned-signs")
	commands.remove_command("dect-debug-reset-signs")

	-- Command to remove any unminable signs from the player's current surface
	commands.add_command("dect-destroy-orphaned-signs", {"dect-cmd.destroy-orphaned-signs"}, function()
		local surface = game.player.surface
		local signs = surface.find_entities_filtered{name={"dect-sign-wood", "dect-sign-steel"}}
		local gui_open = false
		local match = false

		for _, sign in pairs(signs) do
			if sign.minable == false then
				-- TODO: Potential issue will arise here if command is executed in MP while someone has GUI open
				local pos = sign.position
				match = true
				sign.destroy()
				notify({"dect-notify.cmd-removed-orphaned-sign", {"dect-notify.dectorio"}, pos})
			end
		end
		if not match then
			notify({"dect-notify.cmd-no-orphaned-signs", {"dect-notify.dectorio"}})
		end
	end)

	if DECT.DEBUG then
		-- Special debug command to remove all signs and reset global sign data (normal use shouldn't require this)
		commands.add_command("dect-debug-reset-signs", "Destroy all signs and reset sign data", function()
			-- Find and remove all signs on all surfaces
			for _, surface in pairs(game.surfaces) do
				local signs = surface.find_entities_filtered{name={"dect-sign-wood", "dect-sign-steel"}}
				for _, sign in pairs(signs) do
					sign.destroy()
				end
			end
			-- Find and remove any sign icons
			for _, sign in pairs(global.signs) do
				for _, object in pairs(sign.objects) do
					object.destroy()
				end
			end
			-- Clear out any global sign data
			global.signs = {}
			for _, player in pairs(game.players) do
				global.sign_last_built[player.index] = nil
				global.sign_gui[player.index] = nil
			end
		end)
	end
end

-- Check game for known incompatibile mods
local function check_incompatible_mods()
	for mod, version in pairs(game.active_mods) do
		if DECT.INCOMPATIBLE.MODS[mod] then
			if DECT.ENABLED[DECT.INCOMPATIBLE.MODS[mod].component] then
				return true
			end
		end
	end
	return false
end

-- Notify player of incompatible mods
local function incompability_detected()
	for mod, version in pairs(game.active_mods) do
		if DECT.INCOMPATIBLE.MODS[mod] then
			incompatible = DECT.INCOMPATIBLE.MODS[mod]
			if DECT.ENABLED[incompatible.component] and not incompatible.setting then
				notification({"dect-notify.incompatible", {"dect-notify.dectorio"}})
				notification({"dect-notify.reason-"..incompatible.reason, {"dect-notify.dectorio"}, incompatible.name})
				notification({"dect-notify.recommended-action", {"dect-notify.dectorio"}, incompatible.name, incompatible.component})
				notification({"dect-notify.mod-portal", {"dect-notify.dectorio"}})
			elseif DECT.ENABLED[incompatible.component] and incompatible.setting then
				if settings[incompatible.setting.type][incompatible.setting.name].value == incompatible.setting.value then
					notification({"dect-notify.incompatible", {"dect-notify.dectorio"}})
					notification({"dect-notify.reason-"..incompatible.reason, {"dect-notify.dectorio"}, incompatible.name})
					notification({"dect-notify.recommended-setting", {"dect-notify.dectorio"}, {"mod-setting-name."..incompatible.setting.name}, incompatible.name})
				end
			end
		end
	end
end

-- Initialisation stuff
local function on_init(data)
	init_global()
	init_commands()
	init_icons()
end

-- Load stuff (on every load)
local function on_load(data)
	init_commands()
end

local function on_configuration_changed(data)
	init_global()

	-- Notify version and updates
	if data.mod_changes ~= nil and data.mod_changes["Dectorio"] ~= nil and data.mod_changes["Dectorio"].old_version == nil then
		notification({"dect-notify.version", {"dect-notify.dectorio"}, data.mod_changes["Dectorio"].new_version})
	elseif data.mod_changes ~= nil and data.mod_changes["Dectorio"] ~= nil and data.mod_changes["Dectorio"].old_version ~= nil then

		-- Reset tech and recipes
		for _,force in pairs(game.forces) do
			force.reset_recipes()
			force.reset_technologies()
		end

		-- Re-initialise command handlers
		init_commands()

		-- Notify version change
		local oldver = data.mod_changes["Dectorio"].old_version
		local newver = data.mod_changes["Dectorio"].new_version
		notification({"dect-notify.new-version", {"dect-notify.dectorio"}, oldver, newver})
	end

	-- Check for incompatible mods and notify
	if data.mod_changes ~= nil then
		global.mod_incompatibility = check_incompatible_mods()
		if global.mod_incompatibility == true then
			incompability_detected()
		end
	end

	-- Re-scan for icon changes
	global.icons = nil
	init_icons()

	-- Check if Alien Biomes was added
	if data.mod_changes ~= nil and data.mod_changes["alien-biomes"] ~= nil and data.mod_changes["alien-biomes"].old_version == nil then
		if DECT.ENABLED["landscaping"] then
			for _,force in pairs(game.forces) do
				local tech = force.technologies
				local rec = force.recipes
				if tech["dect-landscaping"].researched and settings.startup["alien-biomes-terrain-scale"] then
					for _, tile in pairs(DECT.CONFIG.ALIEN_BIOMES) do
						if rec["dect-alien-biomes-"..tile] then
							rec["dect-alien-biomes-"..tile].enabled = true
						end
					end
					notification({"dect-notify.supported-mod-added", {"dect-notify.dectorio"}, "Alien Biomes"})
				end
			end
		end
	end

	-- Check if Alien Biomes was removed
	if data.mod_changes ~= nil and data.mod_changes["alien-biomes"] ~= nil and data.mod_changes["alien-biomes"].new_version == nil then
		if DECT.ENABLED["landscaping"] then
			for _,force in pairs(game.forces) do
				local tech = force.technologies
				local rec = force.recipes
				if tech["dect-landscaping"].researched then
					for _, tile in pairs(DECT.CONFIG.BASE_TILES) do
						rec["dect-base-"..tile].enabled = true
					end
					notification({"dect-notify.supported-mod-removed", {"dect-notify.dectorio"}, "Alien Biomes"})
				end
			end
		end
	end

end

-- SIGN FUNCTIONS
-- Show the GUI for sign icon selection
local function create_sign_gui(player)
	if global.sign_gui[player.index] ~= nil then
		destroy_sign_gui(player)
	end
	global.sign_gui[player.index] = player.gui.center.add({type="frame", name="dect-gui-sign", caption={"dect-gui.sign-title"}, direction="vertical"})
	local gui_scroll = global.sign_gui[player.index].add({type="scroll-pane", name="dect-gui-scroll", vertical_scroll_policy="auto", horizontal_scroll_policy="auto", style="dect-scroll"})
	local gui_table = gui_scroll.add({type="table", name="dect-icons-table", column_count=20, style="dect-icon-table"})
	local gui_cancel = global.sign_gui[player.index].add({type="button", name="dect-gui-button-cancel", caption={"dect-gui.sign-cancel"}})
	for _, icon in pairs(global.icons) do
			local match = false
			for _, child in pairs(gui_table.children_names) do
				if child == icon.name then
					match = true
				end
			end
			if not match then
				if player.gui.is_valid_sprite_path("entity/"..icon.name) then
					gui_table.add({type="sprite-button", name=icon.name, sprite="entity/"..icon.name, style="dect-icon-button", tooltip={"", icon.prototype}})
				end
			end
		end
end

-- Destroy the sign GUI
local function destroy_sign_gui(player)
	if global.sign_gui[player.index] ~= nil then
		global.sign_gui[player.index].destroy()
	end
	global.sign_gui[player.index] = nil
end

-- Place a sign on game surface
local function create_sign(player, icon, position, parent)
	local offset = {x=0, y=0.75}
	local icon_entity = game.surfaces[player.surface.name].create_entity({name=icon, position={position.x-offset.x, position.y-offset.y}})
	icon_entity.destructible = false
	table.insert(global.signs, {sign=parent, objects={icon_entity}})
end

-- When a new sign is built
local function on_built_entity(event)
	local player = game.players[event.player_index]
	if event.created_entity.name == "dect-sign-wood" or event.created_entity.name == "dect-sign-steel" then
		if global.sign_gui[event.player_index] ~= nil then
			player.insert({name=event.created_entity.name, count=1})
			event.created_entity.destroy()
		else
			global.sign_last_built[event.player_index] = event.created_entity
			event.created_entity.destructible = false
			event.created_entity.minable = false
			create_sign_gui(player)
		end
	end
end

-- When an existing sign is mined
local function on_mined_entity(event)
	if event.entity.name == "dect-sign-wood" or event.entity.name == "dect-sign-steel" then
		for i=1, #global.signs do
			if event.entity == global.signs[i].sign then
				for j=1, #global.signs[i].objects do
					global.signs[i].objects[j].destroy();
				end
				table.remove(global.signs, i)
				break
			end
		end
	end
end

-- Handle GUI clicks
local function on_gui_click(event)
	if event.element.parent then
		if event.element.parent.name == "dect-gui-sign" then
			if event.element.name == "dect-gui-button-cancel" then
				if global.sign_last_built[event.player_index] then
					game.players[event.player_index].insert({name = global.sign_last_built[event.player_index].name, count = 1})
					global.sign_last_built[event.player_index].destroy()
				end
				destroy_sign_gui(game.players[event.player_index])
			end
		elseif event.element.parent.name == "dect-icons-table" then
			for _, icon in pairs(global.icons) do
				if event.element.name == icon.name then
					create_sign(game.players[event.player_index], icon.name, global.sign_last_built[event.player_index].position, global.sign_last_built[event.player_index])
					global.sign_last_built[event.player_index].destructible = true
					global.sign_last_built[event.player_index].minable = true
					destroy_sign_gui(game.players[event.player_index])
					break
				end
			end
		end
	end
end

-- Kill off any ophaned signs when a player leaves the game while still selecting an icon
local function on_player_state_changed(event)
	local player = game.players[event.player_index]
	if global.sign_gui[player.index] ~= nil then
		destroy_sign_gui(player)
		global.sign_last_built[player.index].destroy()
	end
end

-- Fire events!
script.on_load(on_load)
script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_pre_player_mined_item, on_mined_entity)
script.on_event(defines.events.on_robot_pre_mined, on_mined_entity)
script.on_event(defines.events.on_entity_died, on_mined_entity)
script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_pre_player_left_game, on_player_state_changed)
script.on_event(defines.events.on_pre_player_died, on_player_state_changed)
script.on_event(defines.events.on_player_joined_game, on_player_state_changed)
