return {
    run = function()
        fassert(
            rawget(_G, "new_mod"),
            "Visual Cues must be lower than Vermintide Mod Framework in the load order."
        )

        new_mod("visual_cues", {
            mod_script = "scripts/mods/visual_cues/visual_cues",
            mod_data = "scripts/mods/visual_cues/visual_cues_data",
            mod_localization = "scripts/mods/visual_cues/visual_cues_localization",
        })
    end,

    packages = {
        "resource_packages/visual_cues/visual_cues",
    },
}
