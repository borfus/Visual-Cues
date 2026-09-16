local mod = get_mod("visual_cues")

local Unit = Unit
local Broadphase = Broadphase
local Managers = Managers
local Vector3 = Vector3
local pairs = pairs
local math = math
local string = string
local table = table
local type = type

dofile("scripts/mods/visual_cues/visual_cues_hud")

local MOD_VERSION = "0.1.0"

local notification_queue = mod:persistent_table("notification_queue", {})
local MAX_QUEUED_NOTIFICATIONS = 4

local MONSTERS = {
    skaven_rat_ogre = {
        display_name = "Rat Ogre",
        setting_id = "announce_rat_ogre",
    },
    skaven_stormfiend = {
        display_name = "Stormfiend",
        setting_id = "announce_stormfiend",
    },
    chaos_spawn = {
        display_name = "Spawn of Chaos",
        setting_id = "announce_chaos_spawn",
    },
    chaos_troll = {
        display_name = "Bile Troll",
        setting_id = "announce_bile_troll",
    },
    beastmen_minotaur = {
        display_name = "Minotaur",
        setting_id = "announce_minotaur",
    },
}

local SPECIALS = {
    skaven_gutter_runner = {
        display_name = "Gutter Runner",
        setting_id = "announce_gutter_runner",
    },
    skaven_pack_master = {
        display_name = "Packmaster",
        setting_id = "announce_pack_master",
    },
    skaven_ratling_gunner = {
        display_name = "Ratling Gunner",
        setting_id = "announce_ratling_gunner",
    },
    skaven_warpfire_thrower = {
        display_name = "Warpfire Thrower",
        setting_id = "announce_warpfire_thrower",
    },
    skaven_poison_wind_globadier = {
        display_name = "Globadier",
        setting_id = "announce_globadier",
    },
    chaos_corruptor_sorcerer = {
        display_name = "Leech",
        setting_id = "announce_leech",
    },
    chaos_vortex_sorcerer = {
        display_name = "Blightstormer",
        setting_id = "announce_blightstormer",
    },
    beastmen_standard_bearer = {
        display_name = "Standard Bearer",
        setting_id = "announce_standard_bearer",
    },
}

-- { alpha, red, green, blue }
local CATEGORIES = {
    boss = { prefix = "[BOSS]", color = { 255, 255, 176, 64 } },
    special = { prefix = "[SPECIAL]", color = { 255, 205, 140, 255 } },
    horde = { prefix = "[HORDE]", color = { 255, 255, 96, 96 } },
}

local function game_time()
    local success, t = pcall(function()
        return Managers.time:time("game")
    end)

    return success and t or nil
end

local cooldowns = {}

local function on_cooldown(key, seconds)
    local t = game_time()

    if not t then
        return false
    end

    local ready_at = cooldowns[key]

    if ready_at and t < ready_at then
        return true
    end

    cooldowns[key] = t + seconds

    return false
end

local function show_hud_notification(text, color)
    if mod:get("hud_enabled") == false then
        return
    end

    notification_queue[#notification_queue + 1] = {
        text = text,
        color = color,
        duration = mod:get("hud_duration") or 5,
        font_size = mod:get("hud_font_size") or 32,
        offset_x = mod:get("hud_offset_x") or 0,
        offset_y = mod:get("hud_offset_y") or 220,
    }

    while #notification_queue > MAX_QUEUED_NOTIFICATIONS do
        table.remove(notification_queue, 1)
    end
end

local function announce(category_name, text)
    local category = CATEGORIES[category_name] or CATEGORIES.boss

    show_hud_notification(text, category.color)

    if mod:get("chat_enabled") == true then
        mod:echo(category.prefix .. " " .. text)
    end
end

local function local_player_unit()
    local network_manager = Managers.state and Managers.state.network

    if not network_manager or not network_manager:game() then
        return nil
    end

    local player = Managers.player and Managers.player:local_player()

    return player and player.player_unit
end

-- earshot
local ENGINE_EARSHOT_FALLBACK = 30
local SCAN_INTERVAL = 0.5

local scan_timer = 0
local broadphase_result = {}

-- weak keys prevent this table from keeping old game units alive
local announced_units = setmetatable({}, { __mode = "k" })

local function engine_earshot_range()
    local settings = rawget(_G, "DialogueSettings")

    return settings and settings.special_proximity_distance_heard or ENGINE_EARSHOT_FALLBACK
end

-- earshot range setting can only be shortened, never widened past what the game itself treats as audible.
local function earshot_range()
    local engine_range = engine_earshot_range()

    return math.min(mod:get("earshot_range") or engine_range, engine_range)
end

local function special_units_broadphase()
    local entity_manager = Managers.state and Managers.state.entity

    if not entity_manager then
        return nil
    end

    local system = entity_manager:system("proximity_system")

    return system and system.special_units_broadphase
end

local function handle_nearby_unit(unit)
    local breed = Unit.get_data(unit, "breed")
    local breed_name = breed and breed.name

    if not breed_name then
        return
    end

    local monster = MONSTERS[breed_name]
    local special = not monster and SPECIALS[breed_name]
    local entry = monster or special

    if not entry then
        return
    end

    -- mark it either way so that turning a setting on mid-run cannot announce something already near you
    announced_units[unit] = true

    if monster then
        if mod:get(entry.setting_id) == false then
            return
        end

        announce("boss", mod:localize("notification_text", entry.display_name))

        return
    end

    if mod:get("announce_specials") == false or mod:get(entry.setting_id) == false then
        return
    end

    announce("special", mod:localize("notification_text", entry.display_name))
end

local function scan_for_nearby_enemies()
    local player_unit = local_player_unit()

    if not player_unit or not Unit.alive(player_unit) then
        return
    end

    local broadphase = special_units_broadphase()

    if not broadphase then
        return
    end

    local position = Unit.local_position(player_unit, 0)

    if not position then
        return
    end

    local alive_lookup = rawget(_G, "HEALTH_ALIVE")
    local count = Broadphase.query(broadphase, position, earshot_range(), broadphase_result)

    for i = 1, count do
        local unit = broadphase_result[i]

        broadphase_result[i] = nil

        if unit and not announced_units[unit] and (not alive_lookup or alive_lookup[unit]) then
            handle_nearby_unit(unit)
        end
    end
end

mod.update = function(dt)
    scan_timer = scan_timer + dt

    if scan_timer < SCAN_INTERVAL then
        return
    end

    scan_timer = 0

    scan_for_nearby_enemies()
end

-- hordes
local HORDE_STINGERS = {
    enemy_horde_stinger = true,
    enemy_horde_chaos_stinger = true,
    enemy_horde_beastmen_stinger = true,
    enemy_horde_stingers_plague_monk = true,
}

-- the horde stinger is positional, played at the epicentre, so one spawning
-- far across the level makes a sound this client cannot actually hear.
local MAX_HEAR_FALLBACK = 40

local function max_hear_distance()
    local settings = rawget(_G, "DialogueSettings")

    return settings and settings.max_hear_distance or MAX_HEAR_FALLBACK
end

local function within_earshot_of(position)
    if not position then
        return false
    end

    local player_unit = local_player_unit()

    if not player_unit or not Unit.alive(player_unit) then
        return false
    end

    local player_position = Unit.local_position(player_unit, 0)

    if not player_position then
        return false
    end

    return Vector3.distance(player_position, position) <= max_hear_distance()
end

local function announce_horde()
    if mod:get("announce_hordes") ~= true then
        return
    end

    -- one horde can announce itself through more than one cue.
    -- use a cooldown to avoid duplicate alerts
    if on_cooldown("horde", mod:get("horde_cooldown") or 30) then
        return
    end

    announce("horde", mod:localize("horde_notification_text"))
end

local function handle_horde_stinger(stinger_name, position)
    if mod:get("announce_hordes") ~= true then
        return
    end

    if not stinger_name or not HORDE_STINGERS[stinger_name] then
        return
    end

    -- checked before the cooldown, so a horde too far away to hear cannot consume
    -- the cooldown and suppress a later one that is close enough
    if not within_earshot_of(position) then
        return
    end

    announce_horde()
end

local function sound_event_name(sound_id)
    local lookup = rawget(_G, "NetworkLookup")

    return lookup and lookup.sound_events and lookup.sound_events[sound_id]
end

mod:hook_safe("HordeSpawner", "play_sound", function(self, stinger_name, pos)
    handle_horde_stinger(stinger_name, pos)
end)

mod:hook_safe("AudioSystem", "rpc_server_audio_event_at_pos", function(self, channel_id, sound_id, position)
    handle_horde_stinger(sound_event_name(sound_id), position)
end)

local HORDE_MUSIC_STATES = {
    ambush = true,
    horde = true,
    horde_beastmen = true,
    horde_chaos = true,
    pre_ambush = true,
    pre_ambush_beastmen = true,
    pre_ambush_chaos = true,
    pre_horde = true,
}

local last_game_state

local function handle_music_state(group, value)
    if group ~= "game_state" or value == last_game_state then
        return
    end

    last_game_state = value

    if HORDE_MUSIC_STATES[value] then
        announce_horde()
    end
end

mod:hook_safe("Music", "set_group_state", function(self, group, value)
    handle_music_state(group, value)
end)

-- incoming attack warning
local warning_queue = mod:persistent_table("warning_queue", {})

local function show_attack_warning()
    if mod:get("warning_enabled") ~= true then
        return
    end

    warning_queue[#warning_queue + 1] = {
        duration = mod:get("warning_duration") or 1,
        font_size = mod:get("warning_font_size") or 80,
        offset_x = mod:get("warning_offset_x") or 0,
        offset_y = mod:get("warning_offset_y") or -150,
    }

    while #warning_queue > 1 do
        table.remove(warning_queue, 1)
    end
end

local backstab_sounds

local function is_backstab_sound(event_name)
    if not event_name then
        return false
    end

    if not backstab_sounds then
        backstab_sounds = {}

        local breeds = rawget(_G, "Breeds")

        if breeds then
            for _, breed in pairs(breeds) do
                local event = type(breed) == "table" and breed.backstab_player_sound_event

                if event then
                    backstab_sounds[event] = true
                end
            end
        end
    end

    return backstab_sounds[event_name] == true
end

-- only ever runs on the machine the sound was played on.
mod:hook_safe("AudioSystem", "_play_event_with_source", function(self, wwise_world, event, source)
    if is_backstab_sound(event) then
        show_attack_warning()
    end
end)

local TEST_ALIASES = {
    ["rat"] = "Rat Ogre",
    ["ogre"] = "Rat Ogre",
    ["ratogre"] = "Rat Ogre",
    ["rat ogre"] = "Rat Ogre",
    ["rat_ogre"] = "Rat Ogre",
    ["storm"] = "Stormfiend",
    ["fiend"] = "Stormfiend",
    ["stormfiend"] = "Stormfiend",
    ["chaos"] = "Spawn of Chaos",
    ["spawn"] = "Spawn of Chaos",
    ["chaosspawn"] = "Spawn of Chaos",
    ["chaos spawn"] = "Spawn of Chaos",
    ["chaos_spawn"] = "Spawn of Chaos",
    ["spawn of chaos"] = "Spawn of Chaos",
    ["troll"] = "Bile Troll",
    ["biletroll"] = "Bile Troll",
    ["bile troll"] = "Bile Troll",
    ["bile_troll"] = "Bile Troll",
    ["minotaur"] = "Minotaur",
    ["mino"] = "Minotaur",
}

local TEST_SPECIAL_ALIASES = {
    ["assassin"] = "Gutter Runner",
    ["gutter"] = "Gutter Runner",
    ["gutter runner"] = "Gutter Runner",
    ["runner"] = "Gutter Runner",
    ["pack"] = "Packmaster",
    ["packmaster"] = "Packmaster",
    ["pack master"] = "Packmaster",
    ["hook"] = "Packmaster",
    ["hookrat"] = "Packmaster",
    ["ratling"] = "Ratling Gunner",
    ["ratling gunner"] = "Ratling Gunner",
    ["gunner"] = "Ratling Gunner",
    ["fire"] = "Warpfire Thrower",
    ["warpfire"] = "Warpfire Thrower",
    ["warpfire thrower"] = "Warpfire Thrower",
    ["flamer"] = "Warpfire Thrower",
    ["globadier"] = "Globadier",
    ["gas"] = "Globadier",
    ["gasrat"] = "Globadier",
    ["gas rat"] = "Globadier",
    ["leech"] = "Leech",
    ["corruptor"] = "Leech",
    ["blightstormer"] = "Blightstormer",
    ["stormer"] = "Blightstormer",
    ["standard"] = "Standard Bearer",
    ["standard bearer"] = "Standard Bearer",
    ["banner"] = "Standard Bearer",
}

mod:command(
    "vc_test",
    "Preview a Visual Cues message. Example: /vc_test stormfiend",
    function(...)
        local args = { ... }
        local query = string.lower(table.concat(args, " "))

        if query == "" then
            query = "rat ogre"
        end

        if query == "warning" or query == "attack" then
            if mod:get("warning_enabled") ~= true then
                mod:echo("[VC] Turn on 'Show incoming attack marker' in the mod settings first.")
                return
            end

            show_attack_warning()

            return
        end

        local preview

        if TEST_ALIASES[query] then
            preview = { category = "boss", text = mod:localize("notification_text", TEST_ALIASES[query]) }
        elseif TEST_SPECIAL_ALIASES[query] then
            preview = {
                category = "special",
                text = mod:localize("notification_text", TEST_SPECIAL_ALIASES[query]),
            }
        elseif query == "horde" then
            preview = { category = "horde", text = mod:localize("horde_notification_text") }
        end

        if not preview then
            mod:echo(
                "[VC] Unknown preview. Try a monster (rat ogre, stormfiend, chaos spawn, bile troll, " ..
                "minotaur), a special (leech, assassin, packmaster, ratling, warpfire, globadier, " ..
                "blightstormer, standard bearer), or horde / warning."
            )
            return
        end

        if mod:get("hud_enabled") == false and mod:get("chat_enabled") == false then
            mod:echo(
                "[VC] Nothing to preview: the screen notification and the chat announcement are both turned off."
            )
            return
        end

        announce(preview.category, preview.text)
    end
)

mod.on_enabled = function()
    mod:info("Visual Cues v%s enabled", MOD_VERSION)
end
