-- Dectorio configuration

local DECT = {}

-- IN-GAME OPTIONS
-- These options are configured through the in-game options (Options > Mods > Startup)
-- Don't change them here!
DECT.ENABLED = {
    ["signals"] = settings.startup["dectorio-signals"].value,
    ["walls"] = settings.startup["dectorio-walls"].value,
    ["landscaping"] = settings.startup["dectorio-landscaping"].value,
    ["wood-floor"] = settings.startup["dectorio-flooring"].value,
    ["gravel"] = settings.startup["dectorio-flooring"].value,
    ["painted-concrete"] = settings.startup["dectorio-painted-concrete"].value,
}

-- CONFIGURABLE OPTIONS
-- These options can be changed to suit individual play-style
DECT.CONFIG = {
    -- How likely it is that decorations are removed when placing flooring
    -- (0 = keep all decorations, 0.5 = remove 50% of decorations, 1 = remove all decorations)
    ["decorative_removal_probability"] = 1,

    -- Whether the base concrete recipe should be modified to use iron sticks in place of iron ore
    -- (true = recipe uses iron sticks, false = recipe uses iron ore)
    ["modified_concrete_recipe"] = true,

    -- Whether painted concrete (when enabled) disables the base game hazard concrete
    -- (true = only painted concrete is used, false = both painted and original hazard concrete variants are available)
    ["disable_hazard_concrete"] = true,

    -- How many items are stackable in a single inventory slot
    -- (integer, default flooring = 500, walls = 200)
    ["flooring_stack_size"] = 500,
    ["landscaping_stack_size"] = 500,
    ["walls_stack_size"] = 200,

}

DECT.CONFIG.SIGNALS = {
    -- All the signal colors to be changed/added
    -- RGBA values from 0 to 1, alpha is optional
    -- The order of the virtual signals is the order they will appear in-game
    -- NOTE: New virtual signals will need localised names to be provided in '/locale/[language]/signals.cfg'
    -- Color names are from Name That Color (http://chir.ag/projects/name-that-color/)
    {type="virtual", name="signal-red", color={r=1.00,g=0.16,b=0.10,a=1.00}},           -- Scarlet
    {type="virtual", name="signal-orange", color={r=0.99,g=0.44,b=0.22,a=1.00}},        -- Orange
    {type="virtual", name="signal-tangerine", color={r=1.00,g=0.58,b=0.14,a=1.00}},     -- Tree Poppy
    {type="virtual", name="signal-yellow", color={r=1.00,g=0.96,b=0.27,a=1.00}},        -- Lemon Yellow
    {type="virtual", name="signal-green", color={r=0.00,g=0.95,b=0.17,a=1.00}},         -- Free Speech Green
    {type="virtual", name="signal-cyan", color={r=0.01,g=0.98,b=1.00,a=1.00}},          -- Aqua
    {type="virtual", name="signal-aqua", color={r=0.05,g=0.67,b=0.99,a=1.00}},          -- Spiro Disco Ball
    {type="virtual", name="signal-blue", color={r=0.07,g=0.35,b=0.98,a=1.00}},          -- Crayon Blue
    {type="virtual", name="signal-purple", color={r=0.65,g=0.38,b=0.99,a=1.00}},        -- Lavender Indigo
    {type="virtual", name="signal-pink", color={r=1.00,g=0.42,b=0.99,a=1.00}},          -- Ultra Pink
    {type="virtual", name="signal-white", color={r=1.00,g=1.00,b=1.00,a=1.00}},         -- White
    {type="virtual", name="signal-grey", color={r=0.80,g=0.80,b=0.80,a=1.00}},          -- Iron
    {type="virtual", name="signal-black", color={r=0.22,g=0.13,b=0.56,a=1.00}},         -- Blue Gem

    {type="item", name="raw-wood", color={r=0.57,g=0.36,b=0.12,a=0.86}},                -- Afghan Tan
    {type="item", name="coal", color={r=0.17,g=0.17,b=0.17,a=0.86}},                    -- Bunker
    {type="item", name="stone", color={r=0.64,g=0.50,b=0.30,a=0.86}},                   -- Muesli
    {type="item", name="iron-ore", color={r=0.24,g=0.80,b=0.99,a=0.86}},                -- Picton Blue
    {type="item", name="iron-plate", color={r=0.63,g=0.64,b=0.64,a=0.86}},              -- Grey Chateau
    {type="item", name="steel-plate", color={r=0.80,g=0.80,b=0.80,a=0.86}},             -- Iron
    {type="item", name="copper-ore", color={r=0.91,g=0.58,b=0.13,a=0.86}},              -- Carrot Orange
    {type="item", name="copper-plate", color={r=0.92,g=0.59,b=0.46,a=0.86}},            -- Dark Salmon
    {type="item", name="uranium-ore", color={r=0.69,g=0.96,b=0.18,a=0.86}},             -- Green Yellow
    {type="item", name="science-pack-1", color={r=0.71,g=0.05,b=0.09,a=1.00}},          -- Cornell Red
    {type="item", name="science-pack-2", color={r=0.18,g=0.60,b=0.11,a=1.00}},          -- Forest Green
    {type="item", name="science-pack-3", color={r=0.15,g=0.65,b=0.75,a=1.00}},          -- Blue Green
    {type="item", name="military-science-pack", color={r=0.23,g=0.27,b=0.31,a=1.00}},   -- Limed Spruce
    {type="item", name="production-science-pack", color={r=0.58,g=0.11,b=0.76,a=1.00}}, -- Dark Orchid
    {type="item", name="high-tech-science-pack", color={r=0.81,g=0.69,b=0.08,a=1.00}},  -- Galliano
    {type="item", name="space-science-pack", color={r=0.96,g=0.96,b=0.96,a=1.00}},      -- White Smoke
    {type="item", name="transport-belt", color={r=0.90,g=0.75,b=0.10,a=0.92}},          -- Sunflower
    {type="item", name="underground-belt", color={r=0.90,g=0.75,b=0.10,a=0.92}},        -- Sunflower
    {type="item", name="splitter", color={r=0.90,g=0.75,b=0.10,a=0.92}},                -- Sunflower
    {type="item", name="fast-transport-belt", color={r=0.84,g=0.08,b=0.02,a=0.92}},     -- Rosso Corsa
    {type="item", name="fast-underground-belt", color={r=0.84,g=0.08,b=0.02,a=0.92}},   -- Rosso Corsa
    {type="item", name="fast-splitter", color={r=0.84,g=0.08,b=0.02,a=0.92}},           -- Rosso Corsa
    {type="item", name="express-transport-belt", color={r=0.02,g=0.60,b=0.83,a=0.92}},  -- Rich Electric Blue
    {type="item", name="express-underground-belt", color={r=0.02,g=0.60,b=0.83,a=0.92}},-- Rich Electric Blue
    {type="item", name="express-splitter", color={r=0.02,g=0.60,b=0.83,a=0.92}},        -- Rich Electric Blue
    {type="item", name="electronic-circuit", color={r=0.18,g=0.60,b=0.00,a=0.92}},      -- Napier Green
    {type="item", name="advanced-circuit", color={r=0.72,g=0.00,b=0.00,a=0.92}},        -- Guardsman Red
    {type="item", name="processing-unit", color={r=0.27,g=0.26,b=1.00,a=0.92}},         -- Neon Blue
    {type="item", name="burner-inserter", color={r=0.38,g=0.31,b=0.26,a=0.92}},         -- Saddle
    {type="item", name="inserter", color={r=0.78,g=0.51,b=0.20,a=0.92}},                -- Golden Bell
    {type="item", name="long-handed-inserter", color={r=0.76,g=0.20,b=0.13,a=0.92}},    -- Dark Pastel Red
    {type="item", name="fast-inserter", color={r=0.27,g=0.45,b=0.58,a=0.92}},           -- Jelly Bean
    {type="item", name="filter-inserter", color={r=0.45,g=0.27,b=0.54,a=0.92}},         -- Affair
    {type="item", name="stack-inserter", color={r=0.56,g=0.63,b=0.16,a=0.92}},          -- Citron
    {type="item", name="stack-filter-inserter", color={r=0.70,g=0.70,b=0.69,a=0.92}},   -- Magnesium

    {type="fluid", name="water", color={r=0.00,g=0.43,b=0.75,a=0.68}},                  -- French Blue
    {type="fluid", name="crude-oil", color={r=0.10,g=0.10,b=0.10,a=0.68}},              -- Rangoon Green
    {type="fluid", name="heavy-oil", color={r=0.63,g=0.05,b=0.00,a=0.68}},              -- Dark Candy Apple Red
    {type="fluid", name="light-oil", color={r=0.71,g=0.42,b=0.00,a=0.68}},              -- Ginger
    {type="fluid", name="petroleum-gas", color={r=0.38,g=0.13,b=0.38,a=0.68}},          -- Palatinate Purple
    {type="fluid", name="sulfuric-acid", color={r=0.94,g=0.82,b=0.13,a=0.68}},          -- Broom
    {type="fluid", name="lubricant", color={r=0.00,g=0.75,b=0.30,a=0.68}},              -- Dark Pastel Green
}

-- INTERNAL CONFIGURATION
-- DO NOT CHANGE BELOW THIS LINE
-- ---------------------------------

DECT.INCOMPATIBLE = {}
DECT.INCOMPATIBLE.REASONS = {
    ["signals"] = "dect-notify-reason-signals",
    ["tech"] = "dect-notify-reason-tech",
}
DECT.INCOMPATIBLE.MODS = {
    ["Expanded_Color_Lamps"] = DECT.INCOMPATIBLE.REASONS["signals"],
    ["more-colours"] = DECT.INCOMPATIBLE.REASONS["signals"],
    ["More signal color"] = DECT.INCOMPATIBLE.REASONS["signals"],
    ["Reinforced-Walls"] = DECT.INCOMPATIBLE.REASONS["tech"],
    ["concrete-and-stone"] = DECT.INCOMPATIBLE.REASONS["tech"],
}

return DECT