local mod = get_mod("visual_cues")

return {
    name = "Visual Cues",
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {
            {
                setting_id = "detection_settings",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "earshot_range",
                        type = "numeric",
                        default_value = 30,
                        range = { 5, 30 }, -- can never go above 30 since this is what game uses
                        unit_text = "m",
                        tooltip = "earshot_range_tooltip",
                    },
                },
            },
            {
                setting_id = "notification_settings",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "hud_enabled",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "hud_enabled_tooltip",
                        sub_widgets = {
                            {
                                setting_id = "hud_duration",
                                type = "numeric",
                                default_value = 5,
                                range = { 2, 15 },
                                unit_text = "s",
                                tooltip = "hud_duration_tooltip",
                            },
                            {
                                setting_id = "hud_font_size",
                                type = "numeric",
                                default_value = 32,
                                range = { 16, 72 },
                                unit_text = "px",
                                tooltip = "hud_font_size_tooltip",
                            },
                            {
                                setting_id = "hud_offset_x",
                                type = "numeric",
                                default_value = 0,
                                range = { -800, 800 },
                                unit_text = "px",
                                tooltip = "hud_offset_x_tooltip",
                            },
                            {
                                setting_id = "hud_offset_y",
                                type = "numeric",
                                default_value = 220,
                                range = { -400, 400 },
                                unit_text = "px",
                                tooltip = "hud_offset_y_tooltip",
                            },
                        },
                    },
                    {
                        setting_id = "chat_enabled",
                        type = "checkbox",
                        default_value = false,
                        tooltip = "chat_enabled_tooltip",
                    },
                },
            },
            {
                setting_id = "monster_settings",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "announce_rat_ogre",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "announce_rat_ogre_tooltip",
                    },
                    {
                        setting_id = "announce_stormfiend",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "announce_stormfiend_tooltip",
                    },
                    {
                        setting_id = "announce_chaos_spawn",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "announce_chaos_spawn_tooltip",
                    },
                    {
                        setting_id = "announce_bile_troll",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "announce_bile_troll_tooltip",
                    },
                    {
                        setting_id = "announce_minotaur",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "announce_minotaur_tooltip",
                    },
                },
            },
            {
                setting_id = "special_settings",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "announce_specials",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "announce_specials_tooltip",
                        sub_widgets = {
                            {
                                setting_id = "announce_leech",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_leech_tooltip",
                            },
                            {
                                setting_id = "announce_gutter_runner",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_gutter_runner_tooltip",
                            },
                            {
                                setting_id = "announce_pack_master",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_pack_master_tooltip",
                            },
                            {
                                setting_id = "announce_ratling_gunner",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_ratling_gunner_tooltip",
                            },
                            {
                                setting_id = "announce_warpfire_thrower",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_warpfire_thrower_tooltip",
                            },
                            {
                                setting_id = "announce_globadier",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_globadier_tooltip",
                            },
                            {
                                setting_id = "announce_blightstormer",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_blightstormer_tooltip",
                            },
                            {
                                setting_id = "announce_standard_bearer",
                                type = "checkbox",
                                default_value = true,
                                tooltip = "announce_standard_bearer_tooltip",
                            },
                        },
                    },
                },
            },
            {
                setting_id = "event_settings",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "announce_hordes",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "announce_hordes_tooltip",
                        sub_widgets = {
                            {
                                setting_id = "horde_cooldown",
                                type = "numeric",
                                default_value = 30,
                                range = { 5, 120 },
                                unit_text = "s",
                                tooltip = "horde_cooldown_tooltip",
                            },
                        },
                    },
                },
            },
            {
                setting_id = "warning_settings",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "warning_enabled",
                        type = "checkbox",
                        default_value = true,
                        tooltip = "warning_enabled_tooltip",
                        sub_widgets = {
                            {
                                setting_id = "warning_duration",
                                type = "numeric",
                                default_value = 1,
                                range = { 1, 5 },
                                unit_text = "s",
                                tooltip = "warning_duration_tooltip",
                            },
                            {
                                setting_id = "warning_font_size",
                                type = "numeric",
                                default_value = 80,
                                range = { 24, 140 },
                                unit_text = "px",
                                tooltip = "warning_font_size_tooltip",
                            },
                            {
                                setting_id = "warning_offset_x",
                                type = "numeric",
                                default_value = 0,
                                range = { -900, 900 },
                                unit_text = "px",
                                tooltip = "warning_offset_x_tooltip",
                            },
                            {
                                setting_id = "warning_offset_y",
                                type = "numeric",
                                default_value = -150,
                                range = { -500, 500 },
                                unit_text = "px",
                                tooltip = "warning_offset_y_tooltip",
                            },
                        },
                    },
                },
            },
        },
    },
}
