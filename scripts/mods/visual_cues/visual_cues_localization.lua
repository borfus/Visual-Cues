return {
    mod_description = {
        en =
        "Shows on screen what the game normally only tells you through sound: monsters and specials within earshot, incoming hordes, and incoming attacks. Everything it shows is local to you and is never sent to other players.",
    },

    -- detection
    detection_settings = {
        en = "Detection",
    },
    earshot_range = {
        en = "Earshot range",
    },
    earshot_range_tooltip = {
        en =
        "A monster or special is announced once it comes this close to you. The default matches the distance the game itself treats as within earshot, which is also the highest this can be set. Lower it if you only want warnings about things that are almost on top of you.",
    },

    -- notification settings
    notification_settings = {
        en = "Notification",
    },
    notification_text = {
        en = "%s nearby!",
    },
    horde_notification_text = {
        en = "Horde incoming!",
    },
    hud_enabled = {
        en = "Show screen notification",
    },
    hud_enabled_tooltip = {
        en = "Draws the announcement on screen. Only you can see it.",
    },
    hud_duration = {
        en = "Duration",
    },
    hud_duration_tooltip = {
        en = "How long the screen notification stays visible before fading out.",
    },
    hud_font_size = {
        en = "Text size",
    },
    hud_font_size_tooltip = {
        en = "Font size of the screen notification.",
    },
    hud_offset_x = {
        en = "Horizontal position",
    },
    hud_offset_x_tooltip = {
        en =
        "Offset of the screen notification from the centre of the screen. Negative values move it left, positive values move it right.",
    },
    hud_offset_y = {
        en = "Vertical position",
    },
    hud_offset_y_tooltip = {
        en =
        "Height of the screen notification above the centre of the screen. Lower the value to move it down, or go negative to place it below the crosshair.",
    },
    chat_enabled = {
        en = "Show chat announcement",
    },
    chat_enabled_tooltip = {
        en =
        "Also prints the announcement in your chat log, for example [BOSS] Rat Ogre nearby! The message is written to your own chat log only and is never sent to the party.",
    },

    -- monster settings
    monster_settings = {
        en = "Monsters",
    },
    announce_rat_ogre = {
        en = "Rat Ogre",
    },
    announce_rat_ogre_tooltip = {
        en = "Announce a Rat Ogre within earshot.",
    },
    announce_stormfiend = {
        en = "Stormfiend",
    },
    announce_stormfiend_tooltip = {
        en = "Announce a Stormfiend within earshot.",
    },
    announce_chaos_spawn = {
        en = "Spawn of Chaos",
    },
    announce_chaos_spawn_tooltip = {
        en = "Announce a Spawn of Chaos within earshot.",
    },
    announce_bile_troll = {
        en = "Bile Troll",
    },
    announce_bile_troll_tooltip = {
        en = "Announce a Bile Troll within earshot.",
    },
    announce_minotaur = {
        en = "Minotaur",
    },
    announce_minotaur_tooltip = {
        en = "Announce a Minotaur within earshot.",
    },

    -- special settings
    special_settings = {
        en = "Specials",
    },
    announce_specials = {
        en = "Announce specials",
    },
    announce_specials_tooltip = {
        en = "Announces special enemies once they come within earshot. Each one is announced at most once.",
    },
    announce_leech = {
        en = "Leech",
    },
    announce_leech_tooltip = {
        en = "Announce a Leech (Corruptor Sorcerer) within earshot.",
    },
    announce_gutter_runner = {
        en = "Gutter Runner",
    },
    announce_gutter_runner_tooltip = {
        en = "Announce a Gutter Runner (Assassin) within earshot.",
    },
    announce_pack_master = {
        en = "Packmaster",
    },
    announce_pack_master_tooltip = {
        en = "Announce a Packmaster within earshot.",
    },
    announce_ratling_gunner = {
        en = "Ratling Gunner",
    },
    announce_ratling_gunner_tooltip = {
        en = "Announce a Ratling Gunner within earshot.",
    },
    announce_warpfire_thrower = {
        en = "Warpfire Thrower",
    },
    announce_warpfire_thrower_tooltip = {
        en = "Announce a Warpfire Thrower within earshot.",
    },
    announce_globadier = {
        en = "Globadier",
    },
    announce_globadier_tooltip = {
        en = "Announce a Poison Wind Globadier within earshot.",
    },
    announce_blightstormer = {
        en = "Blightstormer",
    },
    announce_blightstormer_tooltip = {
        en = "Announce a Blightstormer (Vortex Sorcerer) within earshot.",
    },
    announce_standard_bearer = {
        en = "Standard Bearer",
    },
    announce_standard_bearer_tooltip = {
        en = "Announce a Beastmen Standard Bearer within earshot.",
    },

    -- horde settings
    event_settings = {
        en = "Hordes",
    },
    announce_hordes = {
        en = "Announce hordes",
    },
    announce_hordes_tooltip = {
        en =
        "Announces a horde when the game's combat music turns to horde music, and when it plays a horde stinger within earshot. Nothing is announced for a horde the game gives you no audible warning about.",
    },
    horde_cooldown = {
        en = "Horde cooldown",
    },
    horde_cooldown_tooltip = {
        en =
        "Minimum time between horde announcements, so a wave that plays its stinger more than once is only announced once.",
    },

    -- incoming attack warning
    warning_settings = {
        en = "Incoming Attack",
    },
    warning_enabled = {
        en = "Show incoming attack marker",
    },
    warning_enabled_tooltip = {
        en =
        "Flashes a red exclamation mark on screen whenever the game plays you its backstab warning sound, as a visual companion to that sound. It never appears for an attack the game did not already warn you about.",
    },
    warning_duration = {
        en = "Duration",
    },
    warning_duration_tooltip = {
        en = "How long the marker stays on screen.",
    },
    warning_font_size = {
        en = "Marker size",
    },
    warning_font_size_tooltip = {
        en = "Size of the exclamation mark.",
    },
    warning_offset_x = {
        en = "Horizontal position",
    },
    warning_offset_x_tooltip = {
        en =
        "Offset from the centre of the screen. Negative values move it left, positive values move it right.",
    },
    warning_offset_y = {
        en = "Vertical position",
    },
    warning_offset_y_tooltip = {
        en = "Height relative to the centre of the screen. Negative values move it down towards the health bar.",
    },
}
