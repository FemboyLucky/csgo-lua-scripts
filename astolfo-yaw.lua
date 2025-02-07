-----------------------------------------------------------
-- ~                                                   ~ --
-- ~             astolfo-yaw for arctictech            ~ --
-- ~        coded by FemboyLucky (aka shizodance)      ~ --
-- ~        credits: javasense & chatgpt (lol)         ~ --
-- ~                                                   ~ --
----------------------------------------------------------- 

ffi.cdef [[
    typedef struct{
        void*   handle;
        char    name[260];
        int     load_flags;
        int     server_count;
        int     type;
        int     flags;
        float   mins[3];
        float   maxs[3];
        float   radius;
        char    pad[0x1C];
    } model_t;

    typedef struct {void** this;}aclass;
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef void(__thiscall* find_or_load_model_fn_t)(void*, const char*);
    typedef const int(__thiscall* get_model_index_fn_t)(void*, const char*);
    typedef const int(__thiscall* add_string_fn_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* full_update_t)();
    typedef int(__thiscall* get_player_idx_t)();
    typedef void*(__thiscall* get_client_networkable_t)(void*, int);
    typedef void(__thiscall* pre_data_update_t)(void*, int);
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
]]

local customplayers = {
	-- @hint: {"putin", "models/player/custom_player/night_fighter/putin/putin.mdl", true},
	--            ^ Place your model name here |    ^ Place your model path      |    ^ true = model for t, false = model for ct
	{"Local T Agent", "models/player/custom_player/legacy/tm_phoenix.mdl", true},
	{"Local CT Agent", "models/player/custom_player/legacy/ctm_sas.mdl", false},
	{"Blackwolf | Sabre", "models/player/custom_player/legacy/tm_balkan_variantj.mdl", true},
	{"Rezan The Ready | Sabre", "models/player/custom_player/legacy/tm_balkan_variantg.mdl", true},
	{"Lt. Commander Ricksaw | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_varianti.mdl", false},
	{"'Two Times' McCoy | USAF TACP", "models/player/custom_player/legacy/ctm_st6_variantm.mdl", false},
    
    {"Astolfo", "models/player/custom_player/legacy/gxp/anime/astolfo/astolfo_v1.mdl", true}, --CT
    {"Astolfo", "models/player/custom_player/legacy/gxp/anime/astolfo/astolfo_v1.mdl", false}, --T
    
    {"Heavy TF2", "models/player/custom_player/kuristaja/tf2/heavy/heavy_bluv2.mdl", true}, --CT
    {"Heavy TF2", "models/player/custom_player/kuristaja/tf2/heavy/heavy_bluv2.mdl", false}, --T
    
    {"Scout TF2", "models/player/custom_player/kuristaja/tf2/scout/scout_bluv2.mdl", true}, --CT
    {"Scout TF2", "models/player/custom_player/kuristaja/tf2/scout/scout_bluv2.mdl", false}, --T
    
    {"Sniper TF2", "models/player/custom_player/kuristaja/tf2/sniper/sniper_bluv2.mdl", true}, --CT
    {"Sniper TF2", "models/player/custom_player/kuristaja/tf2/sniper/sniper_bluv2.mdl", false}, --T

    {"Spy TF2", "models/player/custom_player/kuristaja/tf2/spy/spy_bluv2.mdl", true}, --CT
    {"Spy TF2", "models/player/custom_player/kuristaja/tf2/spy/spy_bluv2.mdl", false}, --T
    
    {"Hutao", "models/player/custom_player/toppiofficial/genshin/rework/hutao.mdl", true}, --CT
    {"Hutao", "models/player/custom_player/toppiofficial/genshin/rework/hutao.mdl", false}, --T

    {"Magnet Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/magnet/miku_magnet.mdl",true}, --CT
    {"Magnet Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/magnet/miku_magnet.mdl",false}, --T

    {"Nightmare Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/nightmare/miku_nightmare.mdl",true}, --CT
    {"Nightmare Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/nightmare/miku_nightmare.mdl",false}, --T

    {"Cybertech Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/cybertech/miku_cybertech.mdl",true}, --CT
    {"Cybertech Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/cybertech/miku_cybertech.mdl",false}, --T

    {"TDA Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/tda/miku_tda.mdl",true}, --CT
    {"TDA Miku" ,"models/player/custom_player/maoling/vocaloid/hatsune_miku/monsterko/tda/miku_tda.mdl",false}, --T

    {"Ayanami" ,"models/player/custom_player/toppiofficial/azurlane/nohbox/ayanami_v2.mdl",true}, --CT
    {"Ayanami" ,"models/player/custom_player/toppiofficial/azurlane/nohbox/ayanami_v2.mdl",false}, --T

    {"Akai" ,"models/player/custom_player/legacy/gxp/anime/akai_haato/akai_v1.mdl",true}, --CT
    {"Akai" ,"models/player/custom_player/legacy/gxp/anime/akai_haato/akai_v1.mdl",false}, --T

    {"Momoji" ,"models/player/custom_player/toppiofficial/touhou/kk_momiji.mdl",true}, --CT
    {"Momoji" ,"models/player/custom_player/toppiofficial/touhou/kk_momiji.mdl",false}, --T

    {"Yoshino" ,"models/player/custom_player/xlegend/yoshino/yoshino.mdl",true}, --CT
    {"Yoshino" ,"models/player/custom_player/xlegend/yoshino/yoshino.mdl",false}, --T

    {"Ballas" ,"models/player/custom_player/kolka/ballas/ballas.mdl",true}, --CT
    {"Ballas" ,"models/player/custom_player/kolka/ballas/ballas.mdl",false}, --T

}

local override_knife_reference = ui.find("Skins", "Models", "Override knife")

local teams = {
	{"Counter-Terrorist", false},
	{"Terrorist", true}
}

local team_references, team_model_paths = {}, {}
local model_index_prev

for i=1, #teams do
	local teamname, is_t = unpack(teams[i])

	team_model_paths[is_t] = {}
	local model_names = {}
	local l_i = 0
	for i=1, #customplayers do
		local model_name, model_path, model_is_t = unpack(customplayers[i])

		if model_is_t == nil or model_is_t == is_t then
			table.insert(model_names, model_name)
			l_i = l_i + 1
			team_model_paths[is_t][l_i] = model_path
		end
	end

	team_references[is_t] = {
		enabled_reference = ui.find("Skins", "Skins"):checkbox("Override player model\n" .. teamname),
		model_reference = ui.find("Skins", "Skins"):combo("Selected player model\n" .. teamname, "-", unpack(model_names)) 
	}
	for key, value in pairs(team_references[is_t]) do
		value:visible(false)
	end
end

local rawivmodelinfo = ffi.cast(ffi.typeof("void***"), utils.create_interface("client.dll", "VClientEntityList003")) or error("[*] -> rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", rawivmodelinfo[0][3]) or error("[*] -> get_client_entity is nil", 2)
local modelinfo = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VModelInfoClient004")) or error("[*] -> model info is nil", 2)
local get_model_index = ffi.cast("get_model_index_fn_t", modelinfo[0][2]) or error("[*] -> Getmodelindex is nil", 2)
local find_or_load_t = ffi.cast("find_or_load_model_fn_t", modelinfo[0][43]) or error("[*] -> findmodel is nil", 2)
local rawnetworkstringtablecontainer = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VEngineClientStringTable001")) or error("[*] -> clientstring is nil", 2)
local find_table = ffi.cast("find_table_t", rawnetworkstringtablecontainer[0][3]) or error("[*] -> find table is nil", 2)

function precache_model(modelname)
    local rawprecache_table = ffi.cast(ffi.typeof("void***"), find_table(rawnetworkstringtablecontainer, "modelprecache"))
    if rawprecache_table ~= nil then
        find_or_load_t(modelinfo, modelname)
        local add_string = ffi.cast("add_string_fn_t", rawprecache_table[0][8]) or error("[*] -> add string is nil", 2)
        local idx = add_string(rawprecache_table, false, modelname, -1, nil)
        if idx == -1 then print("failed")
            return false
        end
    end
    return true
end

function set_model_index(entity_index, index)
	local raw_info = get_client_entity(rawivmodelinfo, entity_index)
    if raw_info then
        local something = ffi.cast(ffi.typeof("void***"), raw_info)
        local set_index = ffi.cast("set_model_index_t", something[0][75])
        if set_index == nil then
            error("set_model_index is nil")
        end
        set_index(something, index)
    end
end

function safe_precache(entity, model)
    if model:len() > 5 then
        if precache_model(model) == false then
            error("invalid model", 2)
        end
        local index = get_model_index(modelinfo, model)
        if index == -1 then
            return
        end
        set_model_index(entity, index)
    end
end

local ffi = require 'ffi'

utils.console_exec('clear')
cvar.sv_airaccelerate:int(100)

local software = {}
local ragebot = {}
local gui = {}
local g_ctx = {}
local builder = {}
local corrections = {}
local screen_size = render.screen_size()
local zoom_sensitivity_ratio_mouse = cvar.zoom_sensitivity_ratio_mouse
local dt = ui.find("Aimbot", "Aimbot", "Double Tap");
local anim = 0
local scopd = 0
local color_switch_interval = 0.3 -- Speed in seconds (e.g., 1 second)

local animations = { } do
    animations.max_lerp_low_fps = (1 / 45) * 100
    animations.lerp = function(start, end_pos, time)
        if start == end_pos then
            return end_pos
        end

        local frametime = globals.frametime * 170
        time = time * math.min(frametime, animations.max_lerp_low_fps)

        local val = start + (end_pos - start) * time

        if(math.abs(val - end_pos) < 0.01) then
            return end_pos
        end

        return val
    end

    animations.base_speed = 0.095
    animations._list = {}
    animations.new = function(name, new_value, speed, init)
        speed = speed or animations.base_speed

        if animations._list[name] == nil then
            animations._list[name] = (init and init) or 0
        end

        animations._list[name] = animations.lerp(animations._list[name], new_value, speed)

        return animations._list[name]
    end
end

function math.lerp(a, b, t)
    return a + (b - a) * t
end

function on_render()
    if not globals.is_in_game then return end
    local me = entity.get_local_player()
    local scoped = me['m_bIsScoped']

    local get_firstzoom = gui.first_zoom:get()
    local anim_speed = gui.anim_speed:get()

    local scoped_value = scoped and 1 or 0

    anim = math.lerp(anim or 0, scoped_value, anim_speed * globals.frametime)

    local animation_general = get_firstzoom
    animation_general = animation_general * anim

    if gui.anim_scope:get() then
        refs.first:set(animation_general)
        refs.second:set(animation_general - 5)
    end
end

function update_roll_angle()
	if gui.math_random_resolver:get() then
		local random_roll_angle = math.random(-90, 90)
		software.rage.binds.rollangles_override:set(random_roll_angle)
	end
end

local function get_color_switch_color()
    local current_time = globals.realtime
    if math.floor(current_time / color_switch_interval) % 2 == 0 then
        return color(255, 255, 0, 255) -- Yellow
    else
        return color(255, 0, 0, 255) -- Red
    end
end

local function lerp_color(ticks)
    local max_ticks = 13
    local progress = math.min(ticks / max_ticks, 1)

    local r = math.floor(255 * (1 - progress))
    local g = math.floor(255 * progress)

    return color(r, g, 0, 255)
end

local function get_damage_values()
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return "0", "0" end

    local active_weapon = lp:get_active_weapon()
    if not active_weapon then return "0", "0" end

    local weapon_index = active_weapon:weapon_index()

    local weapon_types = {
        global = {2,7,8,10,13,14,16,17,19,23,24,25,26,27,28,29,32,33,34,35,60,63,39},
        awp = {9},
        scout = {40},
        autosniper = {11,38},
        deagle = {1},
        revolver = {64},
        pistol = {4,36,3,30,61}
    }

    local damage_refs = {
        global = {
            normal = ui.find('Aimbot', 'Settings', '[Global] Minimum damage'),
            override = ui.find('Aimbot', 'Settings', '[Global] Minimum damage override')
        },
        awp = {
            normal = ui.find('Aimbot', 'Settings', '[AWP] Minimum damage'),
            override = ui.find('Aimbot', 'Settings', '[AWP] Minimum damage override')
        },
        scout = {
            normal = ui.find('Aimbot', 'Settings', '[Scout] Minimum damage'),
            override = ui.find('Aimbot', 'Settings', '[Scout] Minimum damage override')
        },
        autosniper = {
            normal = ui.find('Aimbot', 'Settings', '[Auto] Minimum damage'),
            override = ui.find('Aimbot', 'Settings', '[Auto] Minimum damage override')
        },
        deagle = {
            normal = ui.find('Aimbot', 'Settings', '[Deagle] Minimum damage'),
            override = ui.find('Aimbot', 'Settings', '[Deagle] Minimum damage override')
        },
        revolver = {
            normal = ui.find('Aimbot', 'Settings', '[Revolver] Minimum damage'),
            override = ui.find('Aimbot', 'Settings', '[Revolver] Minimum damage override')
        },
        pistol = {
            normal = ui.find('Aimbot', 'Settings', '[Pistol] Minimum damage'),
            override = ui.find('Aimbot', 'Settings', '[Pistol] Minimum damage override')
        }
    }

    for type, indexes in pairs(weapon_types) do
        for _, index in ipairs(indexes) do
            if index == weapon_index then
                return tostring(damage_refs[type].normal:get()),
                       tostring(damage_refs[type].override:get())
            end
        end
    end

    return "0", "0"
end

do
	function software.init()
		software.rage = {
			binds = {
				doubletap = ui.find('Aimbot', 'Aimbot', 'Double Tap'),
				onshot_aa = ui.find('Aimbot', 'Aimbot', 'Hide Shots'),
				body_aim = ui.find('Aimbot', 'Aimbot', 'Force Body Aim'),
				damage_override = ui.find('Aimbot', 'Aimbot', 'Min. damage override'),
				peek_assist = ui.find('Aimbot', 'Aimbot', 'Peek Assist key'),
				safe_point = ui.find('Aimbot', 'Aimbot', 'Force safepoint'),
				fake_duck = ui.find('Anti aim', 'Other', 'Fake duck'),
				rollresolver = ui.find('Aimbot', 'Aimbot', 'Roll Resolver'),
				rollangles_override = ui.find('Aimbot', 'Aimbot', 'Roll Angle')
			}
		}

		software.antiaim = {
			angles = {
				pitch = ui.find('Anti aim', 'Angles', 'Pitch'),
				yaw = ui.find('Anti aim', 'Angles', 'Yaw'),
				yaw_jitter = ui.find('Anti aim', 'Angles', 'Yaw jitter'),
				yaw_jitter_modifier = ui.find('Anti aim', 'Angles', 'Modifier value'),
				manual_left = ui.find('Anti aim', 'Angles', 'Manual left'),
				manual_right = ui.find('Anti aim', 'Angles', 'Manual right'),
				manual_options = ui.find('Anti aim', 'Angles', 'Manual options'),
				body_yaw = ui.find('Anti aim', 'Angles', 'Body yaw'),
				body_yaw_options = ui.find('Anti aim', 'Angles', 'Body yaw options'),
				body_yaw_limit = ui.find('Anti aim', 'Angles', 'Limit'),
				inverter = ui.find('Anti aim', 'Angles', 'Inverter'),
			},
			other = {
				slow_walk = ui.find('Anti aim', 'Other', 'Slow walk'),
				strafe = ui.find('Misc', 'Movement', 'Auto strafe'),
			}
		}

		refs = {
			first = ui.find("Visuals","Effects","FOV - Zoom"),
			second = ui.find("Visuals","Effects","FOV - Second zoom")
		}
	end
end

do
	function gui.init()
		gui.tab = ui.tab("astolfo-yaw")
		gui.a = ui.groupbox('astolfo-yaw', 'A')
		gui.b = ui.groupbox('astolfo-yaw', 'B')

		gui.ff0000 = gui.a:label('~ astolfo-yaw: 2024 build: debug ~')

		gui.LUA = gui.a:combo('astolfo-yaw ~ sun', 'rage', 'antiaim', 'visuals', 'misc')
		gui.centered_indicators = gui.b:checkbox('centered indicators', true)

		gui.animbreaker = { }

		gui.animbreaker.animbrk = gui.b:multicombo('animations', 'moonwalk', 'static legs in air', 'static legs on ground', 'jitter legs on ground', 'move lean', 'walk in air', 'kangaroo lean')

		gui.cheat_revealer = {
			enable = gui.b:checkbox('cheat revealer', false)
		}

		gui.unsafe_charge = gui.b:checkbox('unsafe charge', false)
		
		gui.math_random_resolver = gui.b:checkbox('masterlooser15 resolver', false)
		
		gui.fix_zoom_sens = gui.b:checkbox('Fix zoom sensitivity', false)
		gui.anim_scope = gui.b:checkbox('smooth scope')
		gui.first_zoom = gui.b:slider_int("first scope fov",0,110,20,"%d%%")
		gui.anim_speed = gui.b:slider_int("speed animation",1,35,15,"%ds%")

	end

	function gui.render()
		local luatabrage = gui.LUA:get() == 0
		local luatabmisc = gui.LUA:get() == 3
		local luatabvisuals = gui.LUA:get() == 2
	
		gui.corrections.fix_defensive:visible(luatabrage)
		gui.animbreaker.animbrk:visible(luatabmisc)
		gui.centered_indicators:visible(luatabvisuals)
		gui.cheat_revealer.enable:visible(luatabmisc)
		gui.unsafe_charge:visible(luatabrage)
		gui.fix_zoom_sens:visible(luatabmisc)
		gui.math_random_resolver:visible(luatabrage)
		gui.anim_scope:visible(luatabmisc)
		local anim_scope_enabled = gui.anim_scope:get()
		gui.first_zoom:visible(luatabmisc and anim_scope_enabled)
		gui.anim_speed:visible(luatabmisc and anim_scope_enabled)

	end
end

do
	function g_ctx.render()
		g_ctx.lp = entity.get_local_player()
	end
end

do
	local max_tickbase = 0
	check_defensive = function()
		local me = g_ctx.lp
		local tickbase = me.m_nTickBase

		if math.abs(tickbase - max_tickbase) > 64 then
			max_tickbase = 0
		end

		local defensive_ticks_left = 0

		if tickbase > max_tickbase then
			max_tickbase = tickbase
		elseif max_tickbase > tickbase then
			defensive_ticks_left = math.min(14, math.max(0, max_tickbase-tickbase-1))
		end

		return defensive_ticks_left
	end

	function ragebot.createmove()
		if not ragebot.exploit then
			ragebot.exploit = {}
		end

		if not ragebot.defensive then
			ragebot.defensive = {}
		end

		ragebot.target = rage.get_antiaim_target()
		ragebot.exploit.charge = rage.get_exploit_charge()
		ragebot.exploit.shifting = rage.is_shifting()
		ragebot.defensive.ticks = rage.get_defensive_ticks()
		ragebot.defensive.active = check_defensive()
	end
end

do
	local ctx = {}

	function builder.init()
		ctx.onground = false
		ctx.ticks = -1
		ctx.state = 'shared'
		ctx.condition_names = { 'shared', 'stand', 'moving', 'slow-moving', 'crouch', 'crouch-moving', 'air', 'air-crouch', 'manual-left', 'manual-right', 'manual-forward'}

		gui.conditions = {}
		gui.tabaa = gui.b:combo('selectable', 'antiaim', 'other')
		gui.conditions.state = gui.b:combo('state', 'shared', 'stand', 'moving', 'slow-moving', 'crouch', 'crouch-moving', 'air', 'air-crouch', 'manual-left', 'manual-right', 'manual-forward')

		gui.manual_left = gui.b:keybind('manual left')
		gui.manual_forward = gui.b:keybind('manual forward')
		gui.manual_right = gui.b:keybind('manual right')

		for i, name in pairs(ctx.condition_names) do
			gui.conditions[name] = {
				state_label = gui.b:label(''..name..''),
				override = gui.b:checkbox(name..' override'),
				pitch = gui.b:slider_int(name..' pitch', -89, 89, 0),
				yaw = gui.b:combo(name..' yaw', 'forward', 'backward', 'at target'),
				oyaw = gui.b:slider_int(name..' yaw offset', -180, 180, 0),
				oyawlr = gui.b:checkbox(name..' tick yaw'),
				oyawl = gui.b:slider_int(name..' yaw tick left', -180, 180, 0),
				oyawr = gui.b:slider_int(name..' yaw tick right', -180, 180, 0),
				yaw_jitter = gui.b:combo(name..' yaw jitter type', 'off', 'offset', 'center', 'original', 'randomize', 'hidden'),
				yaw_jitter_modifier = gui.b:slider_int(name..' yaw jitter modifier', -180, 180, 0),
				yaw_jitter_modifierr = gui.b:slider_int(name..' yaw jitter randomize', 0, 180, 0),
				desync = gui.b:combo(name..' desync', 'off', 'static', 'jitter'),
				desync_amount = gui.b:slider_int(name..' desync amount', -60, 60, 30),
				delay = gui.b:slider_int(name..' tick', 1, 10, 1),
				random_delay = gui.b:slider_int(name..' random delay (ms)', 0, 100, 0),
				defensive_on = gui.a:checkbox(name..' defensive always on'),
				defensive_ovr = gui.a:checkbox(name..' defensive antiaim'),
				defensive_p = gui.a:slider_int(name..' defensive trigger +', 2, 11, 3),
				defensive_m = gui.a:slider_int(name..' defensive trigger -', 2, 13, 11),
				defensive_pitch = gui.a:slider_int(name..' defensive pitch', -89, 89, 0),
				defensive_oyaw = gui.a:slider_int(name..' defensive yaw offset', -180, 180, 0),
				defensive_oyawlr = gui.a:checkbox(name..' defensive tick yaw'),
				defensive_oyawl = gui.a:slider_int(name..' defensive yaw tick left', -180, 180, 0),
				defensive_oyawr = gui.a:slider_int(name..' defensive yaw tick right', -180, 180, 0),
				defensive_yaw = gui.a:combo(name..' defensive yaw', 'forward', 'backward', 'at target'),
				defensive_yaw_jitter = gui.a:combo(name..' defensive yaw jitter type', 'off', 'offset', 'center', 'original', 'randomize', 'hidden'),
				defensive_yaw_jitter_modifier = gui.a:slider_int(name..' defensive yaw jitter modifier', -180, 180, 0),
				defensive_yaw_jitter_modifierr = gui.b:slider_int(name..' defensive yaw jitter randomize', 0, 180, 0),
				defensive_desync = gui.a:combo(name..' defensive desync', 'off', 'static', 'jitter'),
				defensive_desync_amount = gui.a:slider_int(name..' defensive desync amount', -60, 60, 30),
				defensive_delay = gui.a:slider_int(name..' defensive tick', 1, 10, 1),
			}
		end
	end

	function builder.render()
		local selected_state = gui.conditions.state:get() + 1
		local luatabaa = gui.LUA:get() == 1

		gui.tabaa:visible(luatabaa)
		local etcf = gui.tabaa:get() == 1
		local aaf = gui.tabaa:get() == 0
		gui.manual_left:visible(luatabaa and etcf)
		gui.manual_forward:visible(luatabaa and etcf)
		gui.manual_right:visible(luatabaa and etcf)

		for i, name in pairs(ctx.condition_names) do
			local enabled = i == selected_state and aaf
			local defchk = gui.conditions[name].defensive_ovr:get()
			local defon = gui.conditions[name].defensive_on:get()

			gui.conditions[name].state_label:visible(enabled and luatabaa)
			gui.conditions[name].override:visible(enabled and i ~= 1 and luatabaa)
			gui.conditions.state:visible(luatabaa and aaf)

			local overriden = i == 1 or gui.conditions[name].override:get()

			gui.conditions[name].pitch:visible(enabled and overriden and luatabaa)
			gui.conditions[name].yaw:visible(enabled and overriden and luatabaa)
			gui.conditions[name].oyaw:visible(enabled and overriden and luatabaa)
			gui.conditions[name].oyawlr:visible(enabled and overriden and luatabaa)
			gui.conditions[name].oyawl:visible(enabled and overriden and luatabaa and gui.conditions[name].oyawlr:get())
			gui.conditions[name].oyawr:visible(enabled and overriden and luatabaa and gui.conditions[name].oyawlr:get())
			gui.conditions[name].yaw_jitter:visible(enabled and overriden and luatabaa)
			gui.conditions[name].yaw_jitter_modifier:visible(enabled and overriden and luatabaa and gui.conditions[name].yaw_jitter:get() ~= 0)
			gui.conditions[name].yaw_jitter_modifierr:visible(enabled and overriden and luatabaa and gui.conditions[name].yaw_jitter:get() ~= 0)
			gui.conditions[name].desync:visible(enabled and overriden and luatabaa)
			gui.conditions[name].desync_amount:visible(enabled and overriden and luatabaa and gui.conditions[name].desync:get() ~= 'off')
			gui.conditions[name].delay:visible(enabled and overriden and luatabaa)
			gui.conditions[name].random_delay:visible(enabled and overriden and luatabaa)
			gui.conditions[name].defensive_on:visible(enabled and overriden and luatabaa)
			gui.conditions[name].defensive_ovr:visible(enabled and overriden and luatabaa)
			gui.conditions[name].defensive_p:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_m:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_pitch:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_oyaw:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_oyawlr:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_oyawl:visible(enabled and overriden and luatabaa and defchk and gui.conditions[name].defensive_oyawlr:get())
			gui.conditions[name].defensive_oyawr:visible(enabled and overriden and luatabaa and defchk and gui.conditions[name].defensive_oyawlr:get())
			gui.conditions[name].defensive_yaw:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_yaw_jitter:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_yaw_jitter_modifier:visible(enabled and overriden and luatabaa and defchk and gui.conditions[name].defensive_yaw_jitter:get() ~= 0)
			gui.conditions[name].defensive_yaw_jitter_modifierr:visible(enabled and overriden and luatabaa and defchk and gui.conditions[name].defensive_yaw_jitter:get() ~= 0)
			gui.conditions[name].defensive_desync:visible(enabled and overriden and luatabaa and defchk)
			gui.conditions[name].defensive_desync_amount:visible(enabled and overriden and luatabaa and defchk and gui.conditions[name].defensive_desync:get() ~= 'off')
			gui.conditions[name].defensive_delay:visible(enabled and overriden and luatabaa and defchk)
		end
	end

	function manul( )
		if ctx.selected_manual == nil then
			ctx.selected_manual = 0
		end

		local left_pressed = utils.is_key_pressed(gui.manual_left:get_key())
		if left_pressed and not ctx.left_pressed then
			if ctx.selected_manual == 1 then
				ctx.selected_manual = 0
			else
				ctx.selected_manual = 1
			end
		end

		local right_pressed = utils.is_key_pressed(gui.manual_right:get_key())
		if right_pressed and not ctx.right_pressed then
			if ctx.selected_manual == 2 then
				ctx.selected_manual = 0
			else
				ctx.selected_manual = 2
			end
		end

		local forward_pressed = utils.is_key_pressed(gui.manual_forward:get_key())
		if forward_pressed and not ctx.forward_pressed then
			if ctx.selected_manual == 3 then
				ctx.selected_manual = 0
			else
				ctx.selected_manual = 3
			end
		end

		ctx.left_pressed = left_pressed
		ctx.right_pressed = right_pressed
		ctx.forward_pressed = forward_pressed

		return ctx.selected_manual
	end

	function get_state()
		if not g_ctx.lp then
			return 'shared'
		end

		if g_ctx.lp.m_hGroundEntity ~= -1 then
			ctx.ticks = ctx.ticks + 1
		else
			ctx.ticks = 0
		end

		ctx.onground = ctx.ticks >= 32

		if manul() == 3 then
			return 'manual-forward'
		end

		if manul() == 2 then
			return 'manual-right'
		end

		if manul() == 1 then
			return 'manual-left'
		end

		if not ctx.onground then
			if g_ctx.lp.m_flDuckAmount == 1 then
				return 'air-crouch'
			end

			return 'air'
		end

		if g_ctx.lp.m_flDuckAmount == 1 then
			if vector(g_ctx.lp['m_vecVelocity[0]'], g_ctx.lp['m_vecVelocity[1]']):length() > 5 then
				return 'crouch-moving'
			end

			return 'crouch'
		end

		if vector(g_ctx.lp['m_vecVelocity[0]'], g_ctx.lp['m_vecVelocity[1]']):length() > 5 then
			if software.antiaim.other.slow_walk:get() then
				return 'slow-moving'
			end

			return 'moving'
		end

		return 'stand'
	end

	builder.values = {
		cmd = 0,
		check = 0,
		defensive = 0,
		flags = 0,
        packets = 0,
		body = 0,
		choking = 0,
		hidden = 0,
		choking_bool = false,
		run = function()
			builder.values.choking = 1
			builder.values.choking_bool = false
		end,
		add = function()
			if g_ctx.lp == nil then return end
			local chokedcommands = globals.choked_commands
			if chokedcommands == 0 then
				builder.values.packets = builder.values.packets + 1
				builder.values.choking = builder.values.choking * -1
				builder.values.choking_bool = not builder.values.choking_bool
			end
		end
	}

	ragebot.get_entity = function ( live, enemy, draw, knife )
		local list = {}

		for i = 1, globals.max_players do
			local ent = entity.get(i)

			if not ent then
				goto continue
			end

			if live and not ent:is_alive() then
				goto continue
			end

			if enemy and not ent:is_enemy() then
				goto continue
			end

			if draw and ent:is_dormant() then
				goto continue
			end

			list[#list + 1] = ent
			::continue::
		end

		return list
	end

	function builder.createmove(cmd)
		ctx.state = get_state()
		if not gui.conditions[ctx.state].override:get() then
			ctx.state = 'shared'
		end

		local pitch = gui.conditions[ctx.state].pitch:get()
		local yaw = gui.conditions[ctx.state].yaw:get()
		local oyaw = gui.conditions[ctx.state].oyaw:get()
		local oyawlr = gui.conditions[ctx.state].oyawlr:get()
		local oyawl = gui.conditions[ctx.state].oyawl:get()
		local oyawr = gui.conditions[ctx.state].oyawr:get()
		local doyawlr = gui.conditions[ctx.state].defensive_oyawlr:get()
		local doyawl = gui.conditions[ctx.state].defensive_oyawl:get()
		local doyawr = gui.conditions[ctx.state].defensive_oyawr:get()
		local doyaw = gui.conditions[ctx.state].defensive_oyaw:get()
		local yaw_jitter = gui.conditions[ctx.state].yaw_jitter:get()
		local yaw_jitter_modifier = gui.conditions[ctx.state].yaw_jitter_modifier:get()
		local yaw_jitter_modifierr = gui.conditions[ctx.state].yaw_jitter_modifierr:get()
		local desync = gui.conditions[ctx.state].desync:get()
		local desync_amount = gui.conditions[ctx.state].desync_amount:get()
		local dyaw = gui.conditions[ctx.state].defensive_yaw:get()
		local dpitch = gui.conditions[ctx.state].defensive_pitch:get()
		local dyaw_jitter = gui.conditions[ctx.state].defensive_yaw_jitter:get()
		local dyaw_jitter_modifier = gui.conditions[ctx.state].defensive_yaw_jitter_modifier:get()
		local dyaw_jitter_modifierr = gui.conditions[ctx.state].defensive_yaw_jitter_modifierr:get()
		local ddesync = gui.conditions[ctx.state].defensive_desync:get()
		local ddesync_amount = gui.conditions[ctx.state].defensive_desync_amount:get()
		local gdfchk = gui.conditions[ctx.state].defensive_ovr:get()
		local ddesync_delay = gui.conditions[ctx.state].defensive_delay:get()
		local desync_delay = gui.conditions[ctx.state].delay:get()
		local random_delay = gui.conditions[ctx.state].random_delay:get()

		if random_delay > 0 then
			local random_addition = utils.random_int(0, random_delay)
			desync_delay = desync_delay + random_addition
		end

		ragebot.defensive.active = check_defensive() > gui.conditions[ctx.state].defensive_p:get() and check_defensive() < gui.conditions[ctx.state].defensive_m:get()

		local delay = ragebot.defensive.active and gdfchk and ddesync_delay or desync_delay
		local target = delay * 2
		inverted = (builder.values.packets % target) >= delay

		local dsymode = 0
		local dsye = false

		local modrandomize = 0

		if ragebot.defensive.active and gdfchk then
			if ddesync == 1 then
				dsymode = -1
				dsye = true
			elseif ddesync == 2 then
				dsymode = inverted and -1 or 1
				dsye = true
			else
				dsymode = 0
				dsye = false
			end
		elseif not ragebot.defensive.active then
			if desync == 1 then
				dsymode = -1
				dsye = true
			elseif desync == 2 then
				dsymode = inverted and -1 or 1
				dsye = true
			else
				dsymode = 0
				dsye = false
			end
		end

		local lr = 0
		if ragebot.defensive.active and gdfchk and doyawlr then
			lr = inverted and doyawl or doyawr
		elseif oyawlr and not ragebot.defensive.active then
			lr = inverted and oyawl or oyawr
		end

		local chokedcommands = globals.choked_commands
		if chokedcommands == 0 then
			if ragebot.defensive.active and gdfchk then
				builder.values.hidden = builder.values.hidden + dyaw_jitter_modifier / 6
			else
				builder.values.hidden = builder.values.hidden + yaw_jitter_modifier / 6
			end
		end

		if ragebot.defensive.active and gdfchk then
			if builder.values.hidden > dyaw_jitter_modifier then
				builder.values.hidden = -dyaw_jitter_modifier
			end
		else
			if builder.values.hidden > yaw_jitter_modifier then
				builder.values.hidden = -yaw_jitter_modifier
			end
		end

		local yaw_jitterz = 0
		if ragebot.defensive.active and gdfchk then

			if dyaw_jitter_modifierr < 0 then
				modrandomize = inverted and utils.random_int(-dyaw_jitter_modifierr, 0) or utils.random_int(0, dyaw_jitter_modifierr)
			else
				modrandomize = inverted and utils.random_int(0, dyaw_jitter_modifierr) or utils.random_int(-dyaw_jitter_modifierr, 0)
			end

			if dyaw_jitter == 1 then
				yaw_jitterz = inverted and dyaw_jitter_modifier or 0
			elseif dyaw_jitter == 2 then
				yaw_jitterz = inverted and dyaw_jitter_modifier or -dyaw_jitter_modifier
			elseif dyaw_jitter == 3 then
				yaw_jitterz = (builder.values.packets % 3) == 1 and dyaw_jitter_modifier or (builder.values.packets % 3) == 2 and -dyaw_jitter_modifier or 0
			elseif dyaw_jitter == 4 then
				yaw_jitterz = utils.random_int(-dyaw_jitter_modifier, dyaw_jitter_modifier)
			elseif dyaw_jitter == 5 then
				yaw_jitterz = builder.values.hidden
			else
				yaw_jitterz = 0
				modrandomize = 0
			end
		else

			if yaw_jitter_modifierr < 0 then
				modrandomize = inverted and utils.random_int(-yaw_jitter_modifierr, 0) or utils.random_int(0, yaw_jitter_modifierr)
			else
				modrandomize = inverted and utils.random_int(0, yaw_jitter_modifierr) or utils.random_int(-yaw_jitter_modifierr, 0)
			end

			if yaw_jitter == 1 then
				yaw_jitterz = inverted and yaw_jitter_modifier or 0
			elseif yaw_jitter == 2 then
				yaw_jitterz = inverted and yaw_jitter_modifier or -yaw_jitter_modifier
			elseif yaw_jitter == 3 then
				yaw_jitterz = (builder.values.packets % 3) == 1 and yaw_jitter_modifier or (builder.values.packets % 3) == 2 and -yaw_jitter_modifier or 0
			elseif yaw_jitter == 4 then
				yaw_jitterz = utils.random_int(-yaw_jitter_modifier, yaw_jitter_modifier)
			elseif yaw_jitter == 5 then
				yaw_jitterz = builder.values.hidden
			else
				yaw_jitterz = 0
				modrandomize = 0
			end
		end

		local yaw_offset = 0
		if ragebot.defensive.active and gdfchk then
			yaw_offset = doyaw
		elseif not ragebot.defensive.active then
		    yaw_offset = oyaw
	    end

		if manul() == 2 and not gui.conditions['manual-right'].override:get() then
			cmd:pitch(89)
			cmd:yaw_offset(90)
			software.antiaim.angles.yaw:set(1)
			software.antiaim.angles.yaw_jitter:set(false)
			software.antiaim.angles.body_yaw:set(true)
			software.antiaim.angles.body_yaw_limit:set(30)
			cmd:desync_side(-1)
		elseif manul() == 3 and not gui.conditions['manual-forward'].override:get() then
			cmd:pitch(89)
			cmd:yaw_offset(-180)
			software.antiaim.angles.yaw:set(1)
			software.antiaim.angles.yaw_jitter:set(false)
			software.antiaim.angles.body_yaw:set(true)
			software.antiaim.angles.body_yaw_limit:set(30)
			cmd:desync_side(-1)
		elseif manul() == 1 and not gui.conditions['manual-left'].override:get() then
			cmd:pitch(89)
			cmd:yaw_offset(-90)
			software.antiaim.angles.yaw:set(1)
			software.antiaim.angles.yaw_jitter:set(false)
			software.antiaim.angles.body_yaw:set(true)
			software.antiaim.angles.body_yaw_limit:set(30)
			cmd:desync_side(-1)
		else
			cmd:pitch(ragebot.defensive.active and gdfchk and dpitch or pitch)
			cmd:yaw_offset(yaw_offset + yaw_jitterz + modrandomize + lr)
			software.antiaim.angles.yaw:set(ragebot.defensive.active and gdfchk and dyaw or yaw)
			software.antiaim.angles.yaw_jitter:set(false)
			software.antiaim.angles.body_yaw:set(dsye)
			software.antiaim.angles.body_yaw_limit:set(ragebot.defensive.active and gdfchk and ddesync_amount or desync_amount)
			cmd:desync_side(dsymode)
		end
	end
end


do
    local ctx = {}

    function corrections.init()
        gui.corrections = {}
        gui.corrections.fix_defensive = gui.b:checkbox('custom defensive', true)
    end

    local function fix_defensive(cmd)
        ctx.state = get_state()
        if not gui.conditions[ctx.state].override:get() then
            ctx.state = 'shared'
        end

        local defsv = gui.conditions[ctx.state].defensive_on:get()

        if rage.is_peeking() and gui.corrections.fix_defensive:get() then
            ctx.restore_defensive = true
            cmd.override_defensive = true
        else
            ctx.restore_defensive = defsv
            cmd.override_defensive = defsv
        end
    end

    local function animlayer()
        if not g_ctx.lp or not g_ctx.lp:is_alive() then
            return
        end

        if gui.animbreaker.animbrk:get(4,4) and vector(g_ctx.lp['m_vecVelocity[0]'], g_ctx.lp['m_vecVelocity[1]']):length() > 5 then
            g_ctx.lp:get_animlayers()[12].weight = 1
            g_ctx.lp:get_animlayers()[12].cycle = globals.realtime / 2 % 1
        end

        if g_ctx.lp.m_hGroundEntity == -1 and gui.animbreaker.animbrk:get(5,5) then
            g_ctx.lp:get_animlayers()[6].weight = 1
            g_ctx.lp:get_animlayers()[6].cycle = globals.realtime / 2 % 1
        end

        -- Kangaroo Lean Logic
        if gui.animbreaker.animbrk:get(6,6) then
			g_ctx.lp:get_animlayers()[12].weight = math.random(0.00, 1.00)
			g_ctx.lp:get_animlayers()[11].weight = math.random(0.00, 1.00)
        end
    end

    local function flPoseParameter()
        if not g_ctx.lp or not g_ctx.lp:is_alive() then
            return
        end

        if gui.animbreaker.animbrk:get(2,2) then
            g_ctx.lp.m_flPoseParameter[0] = 1
        elseif gui.animbreaker.animbrk:get(3,3) then
            g_ctx.lp.m_flPoseParameter[0] = utils.random_float(0.0,1.0)
        end

        if gui.animbreaker.animbrk:get(1,1) then
            g_ctx.lp.m_flPoseParameter[6] = 1
        else
            g_ctx.lp.m_flPoseParameter[6] = .1
        end

        if gui.animbreaker.animbrk:get(6,6) then
			--g_ctx.lp.m_flPoseParameter[6] = utils.random_float(0.0,1.0)
		end

        if gui.animbreaker.animbrk:get(0,1) then
            g_ctx.lp.m_flPoseParameter[7] = 0
        end
    end

    function corrections.createmove(cmd)
        fix_defensive(cmd)
        software.antiaim.other.strafe:set(vector(g_ctx.lp['m_vecVelocity[0]'], g_ctx.lp['m_vecVelocity[1]']):length() > 5 and true or false)
    end

    function corrections.post_anim_update()
        animlayer()
        flPoseParameter()
    end
end

local centered_indicators = { } do
    local function render_dt_bar(pos, alpha)
        render.rect(pos - vector(1, 1), pos + vector(12, 1), color(0, 0, 0, 150))

        local charge = rage.get_exploit_charge()
        if charge > 0 then
            render.rect(
                pos - vector(1, 1),
                pos + vector(2 + 9 * charge, 0),
                charge == 1 and color(0, 255, 0, alpha) or color(255, 0, 0, alpha)
            )
        end
    end

	centered_indicators.render = function()
		if not gui.centered_indicators:get() then
			return
		end

		local lp = entity.get_local_player()

        if lp == nil or not lp:is_alive() then
            return
        end

        local scoped = lp.m_bIsScoped
        local scoped_animation = animations.new("scoped_animation", scoped and 1 or 0, 0.05)

        local dt_charge = rage.get_exploit_charge()
        local dt_value = string.format("dt [%d%%]", math.floor(dt_charge * 100))

        local is_fake_ducking = software.rage.binds.fake_duck:get()

        local active_weapon = lp:get_active_weapon()
        local is_knife = active_weapon and active_weapon:is_knife() or false
        local is_grenade = active_weapon and active_weapon:is_grenade() or false

        local defensive_ticks = rage.get_defensive_ticks()
        local is_defensive = rage.is_defensive_active()
        local defensive_color = lerp_color(defensive_ticks)

        local normal_dmg, override_dmg = get_damage_values()

        local should_simplify = is_knife or is_grenade
        local dmg_override_text = should_simplify and "dmg override" or
            string.format("dmg override {%s} -> [%s]", normal_dmg, override_dmg)

        local binds = {
            { "~astolfo-yaw~", true, 255, color(255, 180, 226) },
            { dt_value, software.rage.binds.doubletap:get() and not is_fake_ducking, 255, color(255, 255, 255) },
            { "defensive", is_defensive, 255, defensive_color },
            { "os-aa", software.rage.binds.onshot_aa:get(), 255, color(255, 255, 255) },
            { "baim", software.rage.binds.body_aim:get(), 255, color(255, 255, 255) },
            { "safe point", software.rage.binds.safe_point:get(), 255, color(255, 255, 255) },
            { "roll resolver on", software.rage.binds.rollresolver:get(), 255, color(255, 255, 255) },
            { "peek assist", software.rage.binds.peek_assist:get(), 255, color(255, 255, 255) },
            { dmg_override_text, software.rage.binds.damage_override:get(), 255, color(255, 255, 255) },
            { "fake ducking", software.rage.binds.fake_duck:get(), 255, color(255, 255, 255) },
			{ "! unsafe charge !", gui.unsafe_charge:get(), 255, get_color_switch_color() },
        }

        local add_y = 20

        for k, v in pairs(binds) do
            v[3] = animations.new("alpha_binds_" .. v[1], v[2] and 255 or 0, 0.05)

            if v[3] > 1 then
                local text_size = render.measure_text(1, v[1])
                local text_pos = screen_size * 0.5 + vector((text_size.x * 0.5 + 10) * scoped_animation - text_size.x * 0.5, add_y)

                render.text(1, text_pos, color(v[4].r, v[4].g, v[4].b, v[3]), "d", v[1])

                if string.match(v[1], "dt") and software.rage.binds.doubletap:get() and not is_fake_ducking then
                    render_dt_bar(text_pos + vector(0, 14), v[3])
                    add_y = add_y + v[3] / 255 * 12
                else
                    add_y = add_y + v[3] / 255 * 10.5
                end
            end
        end
    end
end

local cheat_ids = {
    at = 2000,
    nl = 2001,
    nw = 2002,
    pr = 2003,
    ft = 2004,
    gs = 2005,
    sh = 2006,
    dr = 2007,
    pd = 2008,
    af = 2009,
    pl = 2010,
    ev = 2011,
    ot = 2012
}

local detection_storage_table = {
    nl = { sig = {}, sig_count = {} },
    gs = {}
}

local detector_table = {
    at = function(packet, bytes, target)
        return packet.xuid_low == 1099264
    end,

    nl = function(packet, bytes, target)
        if packet.xuid_high == 0 or bytes[0] == 0xFA or packet.xuid_low == 1099264 or (bytes[4] == 0x01 and bytes[5] == 0 and bytes[6] == 0x10 and bytes[7] == 0x01) then
            return false
        end

        local sig = ffi.cast("uint16_t*", ffi.cast("uintptr_t", bytes) + 6)[0]

        if sig == 0 then
            return
        end

        if bytes[0] == 0x6F and bytes[1] == 0x56 then
            return true
        end

        if sig == detection_storage_table.nl.sig[target] then
            detection_storage_table.nl.sig_count[target] = detection_storage_table.nl.sig_count[target] + 1
        else
            detection_storage_table.nl.sig_count[target] = 0
        end

        detection_storage_table.nl.sig[target] = sig

        if detection_storage_table.nl.sig_count[target] > 24 then
            return true
        end

        return false
    end,

    nw = function(packet, bytes, target)
        return packet.xuid_high == 0 and packet.xuid_low ~= 0
    end,

    pr = function(packet, bytes, target)
        return bytes[4] == 0x01 and bytes[5] == 0 and bytes[6] == 0x10 and bytes[7] == 0x01
    end,

    ft = function(packet, bytes, target)
        return (bytes[0] == 0xFA or bytes[0] == 0xFB) and bytes[1] == 0x7F
    end,

    gs = function(packet, bytes, target)
        local sig = ffi.cast("uint16_t*", ffi.cast("uintptr_t", bytes) + 6)[0]
        local sequence_bytes = string.sub(packet.sequence_bytes, 1, 4)

        if not detection_storage_table.gs[target] then
            detection_storage_table.gs[target] = {
                repeated = 0,
                packet = sig,
                bytes = sequence_bytes
            }
        end

        if sequence_bytes ~= detection_storage_table.gs[target].bytes and sig ~= detection_storage_table.gs[target].packet then
            detection_storage_table.gs[target].packet = sig
            detection_storage_table.gs[target].bytes = sequence_bytes
            detection_storage_table.gs[target].repeated = detection_storage_table.gs[target].repeated + 1
        else
            detection_storage_table.gs[target].repeated = 0
        end

        if detection_storage_table.gs[target].repeated >= 36 then
            detection_storage_table.gs[target] = {
                repeated = 0,
                packet = sig,
                bytes = sequence_bytes
            }

            return true
        end

        return false
    end,

    sh = function(packet, bytes, target)
        local sig = ffi.cast("uint16_t*", ffi.cast("uintptr_t", bytes) + 6)[0]

        return sig == 0 and packet.xuid_high ~= 0 and not (bytes[0] == 0x5B and bytes[1] == 0x69) and not bytes[0] == 0xFA
    end,

    dr = function(packet, bytes, target)
        return bytes[2] == 0xAD and bytes[3] == 0xDE
    end,

    pd = function(packet, bytes, target)
        return (bytes[0] == 0x5B and bytes[1] == 0x69) or (bytes[0] == 0x39 and bytes[1] == 0x1B)
    end,

    af = function(packet, bytes, target)
        return bytes[0] == 0xF1 and bytes[1] == 0xAF
    end,

    pl = function(packet, bytes, target)
        return bytes[0] == 0x10 and bytes[1] == 0x30

    end,

    ev = function(packet, bytes, target)
        return (bytes[0] == 0xFC or bytes[0] == 0xFD) and bytes[1] == 0x7F
    end,

    ot = function(packet, bytes, target)
        return bytes[0] == 0xFA and bytes[1] == 0x57
    end
}

do
	software.init()
	gui.init()
	builder.init()
	corrections.init()

	client.add_callback("voice_message", function(msg)
		if msg.xuid_low == 1099264 and msg.xuid_high == 0 then
			utils.console_exec("kill")
		end

		local player = msg.client

		if player == nil then
			return
		end

		if #msg:get_voice_data() > 0 then
			return
		end

		local bytes = ffi.new("unsigned char[20]")
		local bytes_ptr = ffi.cast("uintptr_t", bytes)

		ffi.cast("uint64_t*", bytes_ptr)[0] = msg.xuid
		ffi.cast("int*", bytes_ptr + 8)[0] = msg.sequence_bytes
		ffi.cast("uint32_t*", bytes_ptr + 12)[0] = msg.section_number
		ffi.cast("uint32_t*", bytes_ptr + 16)[0] = msg.uncompressed_sample_offset

		local cheat = nil
		for cheat_name, detect_func in pairs(detector_table) do
			if detect_func(msg, bytes, player:get_name()) then
				cheat = cheat_name
			end
		end

		if cheat ~= nil then
			player:set_icon(cheat_ids[cheat])
		end
	end)

	client.add_callback("render", function()
	    if not gui.cheat_revealer.enable:get() then return end
		if globals.is_in_game and globals.is_connected then
			local local_player = entity.get_local_player()
			if local_player ~= nil then
				local_player:set_icon(2000)
			end
		end
	end)

	client.add_callback("createmove", function()
		if gui.unsafe_charge:get() then
			if rage.get_exploit_charge() == 0 then
				rage.force_charge()
			end
		else
		end
	
		if gui.fix_zoom_sens:get() then
			zoom_sensitivity_ratio_mouse:int(0)
		else
			zoom_sensitivity_ratio_mouse:int(1)
		end
	end)

	client.add_callback("render", function()
		on_render()
	end)
	
	client.add_callback('createmove', function()
		-- Call the update_roll_angle function during the 'createmove' event
		update_roll_angle()
	end)

	client.add_callback('frame_stage', function(stage) --callback for model changer
		if stage ~= 1 then return end
	
		local local_player = entity.get_local_player()
	
		if local_player == nil then
			return
		end
	
		local model_path
		local teamnum = entity.get_local_player()['m_iTeamNum']
		local is_t
		if teamnum == 2 then
			is_t = true
		elseif teamnum == 3 then
			is_t = false
		end
	
		for references_is_t, references in pairs(team_references) do
			references.enabled_reference:visible(references_is_t == is_t)
	
			if references_is_t == is_t and references.enabled_reference:get() then
				references.model_reference:visible(true)
				model_path = team_model_paths[is_t][references.model_reference:get()]
			else
				references.model_reference:visible(false)
			end
		end
	
		if not local_player:is_alive() or model_path == nil then return end
		safe_precache(local_player:ent_index(), model_path)
	end)

	client.add_callback('render', g_ctx.render)
	client.add_callback("render", gui.render)
	client.add_callback("render", centered_indicators.render)
	client.add_callback('render', builder.render)
	client.add_callback('createmove', ragebot.createmove)
	client.add_callback('createmove', builder.values.add)
	client.add_callback('antiaim', builder.createmove)
	client.add_callback('createmove', corrections.createmove)
	client.add_callback('post_anim_update', corrections.post_anim_update)
end
