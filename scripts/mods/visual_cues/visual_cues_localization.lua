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
        "A special is announced once it comes this close to you. The default matches the distance the game itself treats as within earshot, which is also the highest this can be set. Lower it if you only want warnings about things that are almost on top of you. Monsters ignore this, because their boss music announces them however far away they are.",
    },

    debug_logging = {
        en = "Log detected cues",
    },
    debug_logging_tooltip = {
        en = "Writes extra details to the log. Only useful for diagnosing. Disable this when playing normally.",
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
        en = "Offset of the screen notification from the centre of the screen.",
    },
    hud_offset_y = {
        en = "Vertical position",
    },
    hud_offset_y_tooltip = {
        en = "Height of the screen notification above the centre of the screen",
    },
    chat_enabled = {
        en = "Show chat announcement",
    },
    chat_enabled_tooltip = {
        en = "Also prints the announcement in your chat log, for example [BOSS] Rat Ogre nearby!",
    },

    -- monster settings
    monster_settings = {
        en = "Monsters",
    },
    announce_rat_ogre = {
        en = "Rat Ogre",
    },
    announce_rat_ogre_tooltip = {
        en = "Announce Rat Ogres.",
    },
    announce_stormfiend = {
        en = "Stormfiend",
    },
    announce_stormfiend_tooltip = {
        en = "Announce Stormfiends.",
    },
    announce_chaos_spawn = {
        en = "Spawn of Chaos",
    },
    announce_chaos_spawn_tooltip = {
        en = "Announce Chaos Spawns.",
    },
    announce_bile_troll = {
        en = "Bile Troll",
    },
    announce_bile_troll_tooltip = {
        en = "Announce Bile Trolls.",
    },
    announce_minotaur = {
        en = "Minotaur",
    },
    announce_minotaur_tooltip = {
        en = "Announce Minotaurs.",
    },

    -- special settings
    special_settings = {
        en = "Specials",
    },
    announce_specials = {
        en = "Announce specials",
    },
    announce_specials_tooltip = {
        en =
        "Announces special enemies. Each type is announced at most once even when multiple are spawned at a given moment.",
    },
    announce_leech = {
        en = "Leech",
    },
    announce_leech_tooltip = {
        en = "Announce Leeches.",
    },
    announce_gutter_runner = {
        en = "Gutter Runner",
    },
    announce_gutter_runner_tooltip = {
        en = "Announce Gutter Runners.",
    },
    announce_pack_master = {
        en = "Packmaster",
    },
    announce_pack_master_tooltip = {
        en = "Announce Packmasters.",
    },
    announce_ratling_gunner = {
        en = "Ratling Gunner",
    },
    announce_ratling_gunner_tooltip = {
        en = "Announce Ratling Gunners.",
    },
    announce_warpfire_thrower = {
        en = "Warpfire Thrower",
    },
    announce_warpfire_thrower_tooltip = {
        en = "Announce Warpfire Throwers.",
    },
    announce_globadier = {
        en = "Globadier",
    },
    announce_globadier_tooltip = {
        en = "Announce Globadiers.",
    },
    announce_blightstormer = {
        en = "Blightstormer",
    },
    announce_blightstormer_tooltip = {
        en = "Announce Blightstormers.",
    },
    announce_standard_bearer = {
        en = "Standard Bearer",
    },
    announce_standard_bearer_tooltip = {
        en = "Announce Standard Bearers.",
    },

    -- horde settings
    event_settings = {
        en = "Hordes",
    },
    announce_hordes = {
        en = "Announce hordes",
    },
    announce_hordes_tooltip = {
        en = "Announces hordes. Nothing is announced for a horde the game gives you no audible warning about.",
    },

    -- incoming attack warning
    warning_settings = {
        en = "Incoming Attack",
    },
    warning_enabled = {
        en = "Show incoming attack marker",
    },
    warning_enabled_tooltip = {
        en = "Flashes a red exclamation mark on screen whenever the game plays you its backstab warning sound.",
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
        en = "Offset from the centre of the screen. Negative values move it left, positive values move it right.",
    },
    warning_offset_y = {
        en = "Vertical position",
    },
    warning_offset_y_tooltip = {
        en = "Height relative to the centre of the screen. Negative values move it down towards the health bar.",
    },
}
