if ArrowAPI then
	sendDebugMessage('[ArrowAPI] already provided. Skipping...')
	return
end

ArrowAPI = SMODS.current_mod
ArrowAPI.startup_item_check = false
ArrowAPI.col_stand_hover = nil
ArrowAPI.palette_ui_config = {
	rgb = {0, 0, 0},
	display_rgb = {'0','0','0'},
	open_palette = {
		set = '',
		idx = '',
		grad_idx = ''
	},
	display_angle = '0',
	hex_input = '',
	name_input = '',
	color_specific = true,
}

ArrowAPI.optional_featues = {
	arrow_palettes = true
}

-- TNSMI setup, aliased from ArrowAPI
TNSMI = SMODS.current_mod
TNSMI.cardareas = {}
TNSMI.prompt_text_input = ''
TNSMI.search_text = ''

G.C.SECONDARY_SET.SoundPack = HEX("56A887")
G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')

G.C.BLIND.SHOWDOWN_COL_1 = copy_table(G.C.RED)
G.C.BLIND.SHOWDOWN_COL_2 = copy_table(G.C.BLUE)

-- copied from arrow
G.C.TAGS = {
    tag_uncommon = G.C.GREEN,
    tag_rare = G.C.RED,
    tag_negative = G.C.DARK_EDITION,
    tag_foil = G.C.DARK_EDITION,
    tag_holo = G.C.DARK_EDITION,
    tag_polychrome = G.C.DARK_EDITION,
    tag_investment = G.C.MONEY,
    tag_voucher = G.C.SECONDARY_SET.Voucher,
    tag_boss = G.C.IMPORTANT,
    tag_standard = G.C.IMPORTANT,
    tag_charm = G.C.SECONDARY_SET.Tarot,
    tag_meteor = G.C.SECONDARY_SET.Planet,
    tag_buffoon = G.C.RED,
    tag_handy = G.C.MONEY,
    tag_garbage = G.C.MONEY,
    tag_ethereal = G.C.SECONDARY_SET.Spectral,
    tag_coupon = G.C.MONEY,
    tag_double = G.C.IMPORTANT,
    tag_juggle = G.C.BLUE,
    tag_d_six = G.C.GREEN,
    tag_top_up = G.C.BLUE,
    tag_skip = G.C.MONEY,
    tag_orbital = G.C.SECONDARY_SET.Planet,
    tag_economy = G.C.MONEY,
	tag_spirit = G.C.STAND,
	tag_plinket = G.C.VHS
}

if not G.ARGS.LOC_COLOURS then loc_colour() end
G.ARGS.LOC_COLOURS['stand'] = G.C.STAND
G.ARGS.LOC_COLOURS['vhs'] = G.C.VHS
G.ARGS.LOC_COLOURS['eternal'] = G.C.ETERNAL
G.ARGS.LOC_COLOURS['perishable'] = G.C.PERISHABLE
G.ARGS.LOC_COLOURS['rental'] = G.C.RENTAL

-- dunno if I'll use these
G.ARGS.LOC_COLOURS['showdown1'] = G.C.BLIND.SHOWDOWN_COL_1
G.ARGS.LOC_COLOURS['showdown2'] = G.C.BLIND.SHOWDOWN_COL_2

local includes = {
	-- data types
	'loading',
	'loc',
	'sound',
	'compat',
	'math',
	'config',
	'logging',
	'string',
	'table',
	'pseudorandom',
	'colors',
	'ui',
	'credits',
	'shaders',

	'hooks/controller',
	'hooks/node',
	'hooks/blind',
	'hooks/button_callbacks',
	'hooks/misc_functions',
	'hooks/common_events',
	'hooks/cardarea',
	'hooks/card',
	'hooks/game',
	'hooks/back',
	'hooks/smods',
	'hooks/UI_definitions',

	'overrides',
	'stands',
	'vhs',
	'game',
	'misc',
}

local module_path = ArrowAPI.path.."modules/Arrow"
local load_path = NFS.getInfo(module_path) and "modules/Arrow/"
ArrowAPI.custom_path = load_path

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file((ArrowAPI.custom_path or "") .. "api/" .. include ..".lua")
	if error then sendErrorMessage("[Arrow] Failed to load "..include.." with error "..error) else
		init()
		sendDebugMessage("[Arrow] Loaded hook: " .. include)
	end
end

ArrowAPI.config_tools.use_credits(ArrowAPI, {
    {
		key = 'direction',
		title_colour = G.C.YELLOW,
		pos_start = {col = 0, row = 0},
		pos_end = {col = 4, row = 7},
		contributors = {
			{name = "BarrierTrio/Gote"},
			{name = "Kekulism"},
			{name = "Vivian Giacobbi"},
		}
	},
	{
		key = 'artist',
		title_colour = G.C.ETERNAL,
		pos_start = {col = 4, row = 0},
		pos_end = {col = 11.5, row = 7},
	},
	{
		key = 'programmer',
		title_colour = G.C.GOLD,
		pos_start = {col = 11.5, row = 0},
		pos_end = {col = 18.5, row = 3.5},
	},
	{
		key = 'graphics',
		title_colour = G.C.DARK_EDITION,
		pos_start = {col = 11.5, row = 3.5},
		pos_end = {col = 18.5, row = 7},
		contributors = {
			{name = "Vivian Giacobbi"},
			{name = "Sir. Gameboy"}
		}
	}
})


ArrowAPI.config_tools.use_default_config(ArrowAPI, {
	{key = 'enable_ItemCredits', default_value = true},
	{key = 'enable_DetailedDescs', default_value = false},
	{key = 'rows', default_value = 2, exclude_from_ui = true},
	{key = 'cols', default_value = 6, exclude_from_ui = true},
	{key = 'loaded_packs', default_value = {
		[1] = "sp_balatro",
		replace_map = {}
	}, exclude_from_ui = true},
	{key = 'saved_palettes', default_value = {
		["Hearts"] = {
            {
                {
                    174,
                    27,
                    67,
                    1,
                    ["overrides"] = {
                        ["H_Q_7"] = {
                            150,
                            99,
                            28,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_J_2"] = {
                            211,
                            36,
                            81,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_J_7"] = {
                            90,
                            154,
                            193,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_6"] = {
                            113,
                            77,
                            51,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_2"] = {
                            211,
                            36,
                            81,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_7"] = {
                            177,
                            111,
                            11,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_J_6"] = {
                            192,
                            52,
                            88,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_2"] = {
                            211,
                            36,
                            81,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "174-27-67",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    240,
                    52,
                    100,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "240-52-100",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    99,
                    136,
                    1,
                    ["overrides"] = {
                        ["H_Q_6"] = {
                            148,
                            104,
                            66,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_3"] = {
                            174,
                            38,
                            72,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-99-136",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    253,
                    160,
                    182,
                    1,
                    ["overrides"] = {
                        ["H_Q_7"] = {
                            211,
                            141,
                            168,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_J_3"] = {
                            240,
                            94,
                            131,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_3"] = {
                            240,
                            94,
                            131,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_J_6"] = {
                            137,
                            57,
                            96,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "253-160-182",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    253,
                    189,
                    207,
                    1,
                    ["overrides"] = {
                        ["H_Q_7"] = {
                            254,
                            172,
                            199,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_3"] = {
                            240,
                            52,
                            99,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_J_6"] = {
                            205,
                            79,
                            166,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "253-189-207",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    253,
                    211,
                    223,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "253-211-223",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    163,
                    0,
                    1,
                    ["overrides"] = {
                        ["H_Q_3"] = {
                            255,
                            218,
                            109,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_7"] = {
                            199,
                            127,
                            0,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_J_7"] = {
                            199,
                            127,
                            0,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-163-0",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    0,
                    156,
                    253,
                    1,
                    ["overrides"] = {
                        ["H_Q_3"] = {
                            166,
                            110,
                            255,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_6"] = {
                            80,
                            101,
                            159,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_7"] = {
                            199,
                            127,
                            0,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_J_7"] = {
                            92,
                            205,
                            211,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_7"] = {
                            83,
                            154,
                            126,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_5"] = {
                            255,
                            163,
                            0,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "0-156-253",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    55,
                    70,
                    73,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "55-70-73",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    255,
                    255,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-255-255",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    240,
                    52,
                    100,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "badge",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                ["name"] = "Default",
            },
            {
                {
                    150,
                    27,
                    29,
                    1,
                    ["overrides"] = {
                        ["H_Q_7"] = {
                            189,
                            39,
                            29,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5877383376686,
                            },
                        },
                        ["H_K_2"] = {
                            216,
                            42,
                            31,
                            216,
                            42,
                            31,
                            166,
                            21,
                            12,
                            166,
                            21,
                            12,
                            ["grad_pos"] = {
                                0,
                                0.17957509070205,
                                0.80053057387252,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5838076797881,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_J_2"] = {
                            216,
                            42,
                            31,
                            216,
                            42,
                            31,
                            166,
                            21,
                            12,
                            166,
                            21,
                            12,
                            ["grad_pos"] = {
                                0,
                                0.17957509070205,
                                0.80053057387252,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5838076797881,
                            },
                        },
                        ["H_J_7"] = {
                            172,
                            172,
                            172,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_2"] = {
                            216,
                            42,
                            31,
                            216,
                            42,
                            31,
                            166,
                            21,
                            12,
                            166,
                            21,
                            12,
                            ["grad_pos"] = {
                                0,
                                0.17957509070205,
                                0.80053057387252,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5838076797881,
                            },
                        },
                        ["H_Q_6"] = {
                            145,
                            73,
                            73,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5872415463036,
                            },
                        },
                        ["H_J_6"] = {
                            176,
                            25,
                            16,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "174-27-67",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    248,
                    59,
                    47,
                    248,
                    59,
                    47,
                    208,
                    29,
                    17,
                    208,
                    29,
                    17,
                    ["overrides"] = {
                        ["changed_flag"] = true,
                    },
                    ["grad_pos"] = {
                        0,
                        0.2,
                        0.8,
                        1,
                    },
                    ["key"] = "240-52-100",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 1.571,
                    },
                },
                {
                    255,
                    99,
                    103,
                    255,
                    99,
                    103,
                    220,
                    77,
                    81,
                    220,
                    77,
                    81,
                    ["overrides"] = {
                        ["H_J_7"] = {
                            41,
                            173,
                            255,
                            41,
                            173,
                            255,
                            41,
                            173,
                            255,
                            41,
                            173,
                            255,
                            ["grad_pos"] = {
                                0,
                                0.1889127671407,
                                0.79586173565319,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_Q_6"] = {
                            170,
                            85,
                            85,
                            170,
                            85,
                            85,
                            170,
                            85,
                            85,
                            170,
                            85,
                            85,
                            ["grad_pos"] = {
                                0,
                                0.22159463467599,
                                0.79586173565319,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5872415463036,
                            },
                        },
                        ["H_K_3"] = {
                            184,
                            46,
                            37,
                            184,
                            46,
                            37,
                            184,
                            46,
                            37,
                            184,
                            46,
                            37,
                            ["grad_pos"] = {
                                0,
                                0.1889127671407,
                                0.77251754455656,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                        0.2,
                        0.8,
                        1,
                    },
                    ["key"] = "255-99-136",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 1.571,
                    },
                },
                {
                    237,
                    131,
                    131,
                    1,
                    ["overrides"] = {
                        ["H_Q_7"] = {
                            189,
                            39,
                            29,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5877383376686,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_K_3"] = {
                            227,
                            43,
                            31,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_J_3"] = {
                            227,
                            43,
                            31,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_J_6"] = {
                            137,
                            57,
                            96,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "253-160-182",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    159,
                    162,
                    1,
                    ["overrides"] = {
                        ["H_Q_7"] = {
                            248,
                            59,
                            47,
                            189,
                            39,
                            29,
                            ["grad_pos"] = {
                                0,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_7"] = {
                            253,
                            167,
                            159,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_3"] = {
                            255,
                            93,
                            82,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_J_6"] = {
                            235,
                            86,
                            147,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "253-189-207",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    196,
                    196,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "253-211-223",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    163,
                    0,
                    1,
                    ["overrides"] = {
                        ["H_Q_3"] = {
                            255,
                            218,
                            109,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_J_7"] = {
                            216,
                            35,
                            23,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_7"] = {
                            248,
                            59,
                            47,
                            208,
                            29,
                            17,
                            ["grad_pos"] = {
                                0,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5877383376686,
                            },
                        },
                        ["H_K_7"] = {
                            248,
                            59,
                            47,
                            208,
                            29,
                            17,
                            ["grad_pos"] = {
                                0,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5872415463036,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-163-0",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    41,
                    173,
                    255,
                    1,
                    ["overrides"] = {
                        ["H_Q_7"] = {
                            145,
                            228,
                            97,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_6"] = {
                            176,
                            25,
                            16,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5872415463036,
                            },
                        },
                        ["changed_flag"] = true,
                        ["H_J_7"] = {
                            202,
                            217,
                            224,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_6"] = {
                            247,
                            58,
                            46,
                            208,
                            29,
                            17,
                            ["grad_pos"] = {
                                0,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5872415463036,
                            },
                        },
                        ["H_J_4"] = {
                            248,
                            59,
                            47,
                            248,
                            59,
                            47,
                            208,
                            29,
                            17,
                            208,
                            29,
                            17,
                            ["grad_pos"] = {
                                0,
                                0.19825044357936,
                                0.79586173565319,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_3"] = {
                            166,
                            110,
                            255,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_7"] = {
                            189,
                            39,
                            29,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.5872415463036,
                            },
                        },
                        ["H_Q_5"] = {
                            186,
                            35,
                            25,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_Q_4"] = {
                            248,
                            59,
                            47,
                            248,
                            59,
                            47,
                            208,
                            29,
                            17,
                            208,
                            29,
                            17,
                            ["grad_pos"] = {
                                0,
                                0.19825044357936,
                                0.79586173565319,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["H_K_5"] = {
                            186,
                            35,
                            25,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "0-156-253",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    55,
                    70,
                    73,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "55-70-73",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    255,
                    255,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-255-255",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    248,
                    59,
                    47,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "badge",
                    ["grad_config"] = {
                        ["pos"] = {
                            0,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                ["name"] = "High Contrast",
            },
			["saved_index"] = 1,
		},
		["Spades"] = {
            {
                {
                    64,
                    72,
                    111,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "64-72-111",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    84,
                    78,
                    138,
                    1,
                    ["overrides"] = {
                        ["S_J_3"] = {
                            96,
                            108,
                            169,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            166,
                            26,
                            31,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_6"] = {
                            78,
                            94,
                            114,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_7"] = {
                            89,
                            85,
                            109,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_7"] = {
                            89,
                            85,
                            109,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_3"] = {
                            145,
                            89,
                            118,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "84-78-138",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    104,
                    99,
                    156,
                    1,
                    ["overrides"] = {
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            236,
                            45,
                            51,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_6"] = {
                            96,
                            125,
                            145,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_2"] = {
                            145,
                            89,
                            118,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_7"] = {
                            125,
                            115,
                            124,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_3"] = {
                            136,
                            119,
                            184,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_2"] = {
                            136,
                            119,
                            184,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_3"] = {
                            136,
                            119,
                            184,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_4"] = {
                            89,
                            122,
                            144,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_2"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "104-99-156",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    158,
                    155,
                    205,
                    1,
                    ["overrides"] = {
                        ["S_J_2"] = {
                            255,
                            163,
                            0,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_3"] = {
                            158,
                            155,
                            205,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    1,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            199,
                            122,
                            50,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_6"] = {
                            142,
                            176,
                            199,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_7"] = {
                            145,
                            145,
                            161,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_4"] = {
                            111,
                            161,
                            192,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_3"] = {
                            96,
                            108,
                            169,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "158-155-205",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    189,
                    186,
                    231,
                    1,
                    ["overrides"] = {
                        ["S_Q_6"] = {
                            172,
                            172,
                            172,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_4"] = {
                            125,
                            198,
                            243,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_4"] = {
                            255,
                            214,
                            29,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "189-186-231",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    230,
                    229,
                    246,
                    1,
                    ["overrides"] = {
                        ["S_Q_6"] = {
                            230,
                            230,
                            230,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_4"] = {
                            230,
                            229,
                            246,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_4"] = {
                            133,
                            97,
                            66,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "230-229-246",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    181,
                    51,
                    1,
                    ["overrides"] = {
                        ["S_K_2"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            253,
                            162,
                            0,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-163-0",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    0,
                    156,
                    253,
                    1,
                    ["overrides"] = {
                        ["changed_flag"] = true,
                        ["S_K_6"] = {
                            177,
                            47,
                            47,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_6"] = {
                            76,
                            116,
                            194,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_6"] = {
                            53,
                            129,
                            49,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "0-156-253",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    240,
                    52,
                    100,
                    1,
                    ["overrides"] = {
                        ["S_Q_4"] = {
                            213,
                            118,
                            221,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            255,
                            99,
                            104,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_6"] = {
                            227,
                            43,
                            31,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_2"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_3"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_6"] = {
                            177,
                            47,
                            47,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_2"] = {
                            214,
                            50,
                            139,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_3"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_5"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_5"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_6"] = {
                            227,
                            43,
                            31,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_J_5"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_Q_7"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                        ["S_K_3"] = {
                            254,
                            95,
                            85,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 0,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "240-52-100",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    255,
                    255,
                    1,
                    6,
                    ["overrides"] = {
                    },
                    ["key"] = "255-255-255",
                    ["grad_pos"] = {
                        0,
                    },
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    64,
                    72,
                    111,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "badge",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                ["name"] = "Default",
            },
            {
                {
                    79,
                    99,
                    103,
                    79,
                    99,
                    103,
                    55,
                    70,
                    73,
                    55,
                    70,
                    73,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                        0.2,
                        0.8,
                        1,
                    },
                    ["key"] = "64-72-111",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 1.571,
                    },
                },
                {
                    91,
                    108,
                    110,
                    91,
                    108,
                    110,
                    62,
                    71,
                    73,
                    62,
                    71,
                    73,
                    ["overrides"] = {
                        ["S_K_4"] = {
                            79,
                            83,
                            111,
                            79,
                            83,
                            111,
                            79,
                            83,
                            111,
                            79,
                            83,
                            111,
                            ["grad_pos"] = {
                                0,
                                0.10020484097349,
                                0.8845696618204,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_K_7"] = {
                            84,
                            100,
                            103,
                            84,
                            100,
                            103,
                            84,
                            100,
                            103,
                            84,
                            100,
                            103,
                            ["grad_pos"] = {
                                0,
                                0.10020484097349,
                                0.89857617647838,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_6"] = {
                            90,
                            76,
                            115,
                            90,
                            76,
                            115,
                            90,
                            76,
                            115,
                            90,
                            76,
                            115,
                            ["grad_pos"] = {
                                0,
                                0.10954251741215,
                                0.88923850003973,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_7"] = {
                            84,
                            100,
                            103,
                            84,
                            100,
                            103,
                            84,
                            100,
                            103,
                            84,
                            100,
                            103,
                            ["grad_pos"] = {
                                0,
                                0.095536002754166,
                                0.87990082360107,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_3"] = {
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            ["grad_pos"] = {
                                0,
                                0.12354903207013,
                                0.87523198538174,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_K_3"] = {
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            ["grad_pos"] = {
                                0,
                                0.11421135563147,
                                0.89857617647838,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                        0.1,
                        0.9,
                        1,
                    },
                    ["key"] = "84-78-138",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 1.571,
                    },
                },
                {
                    105,
                    123,
                    127,
                    105,
                    123,
                    127,
                    69,
                    83,
                    87,
                    69,
                    83,
                    87,
                    ["overrides"] = {
                        ["S_Q_4"] = {
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            ["grad_pos"] = {
                                0,
                                0.11421135563147,
                                0.89390733825905,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_7"] = {
                            99,
                            123,
                            128,
                            99,
                            123,
                            128,
                            99,
                            123,
                            128,
                            99,
                            123,
                            128,
                            ["grad_pos"] = {
                                0,
                                0.12354903207013,
                                0.88923850003973,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_4"] = {
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            ["grad_pos"] = {
                                0,
                                0.13755554672811,
                                0.91258269113636,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_6"] = {
                            132,
                            121,
                            152,
                            132,
                            121,
                            152,
                            132,
                            121,
                            152,
                            69,
                            83,
                            87,
                            ["grad_pos"] = {
                                0,
                                0.10487367919282,
                                0.89857617647838,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_K_2"] = {
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            ["grad_pos"] = {
                                0,
                                0.10020484097349,
                                0.91725152935569,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_K_7"] = {
                            108,
                            125,
                            128,
                            108,
                            125,
                            128,
                            108,
                            125,
                            128,
                            108,
                            125,
                            128,
                            ["grad_pos"] = {
                                0,
                                0.095536002754166,
                                0.89390733825905,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_3"] = {
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            ["grad_pos"] = {
                                0,
                                0.10487367919282,
                                0.8845696618204,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_2"] = {
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            112,
                            91,
                            170,
                            ["grad_pos"] = {
                                0,
                                0.086198326315513,
                                0.8845696618204,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_2"] = {
                            115,
                            93,
                            189,
                            115,
                            93,
                            189,
                            115,
                            93,
                            189,
                            115,
                            93,
                            189,
                            ["grad_pos"] = {
                                0,
                                0.10954251741215,
                                0.89390733825905,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_K_4"] = {
                            107,
                            97,
                            139,
                            107,
                            97,
                            139,
                            107,
                            97,
                            139,
                            107,
                            97,
                            139,
                            ["grad_pos"] = {
                                0,
                                0.13288670850878,
                                0.91725152935569,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_K_3"] = {
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            138,
                            113,
                            225,
                            ["grad_pos"] = {
                                0,
                                0.12354903207013,
                                0.87990082360107,
                                1,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                        0.1,
                        0.9,
                        1,
                    },
                    ["key"] = "104-99-156",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 1.571,
                    },
                },
                {
                    133,
                    146,
                    149,
                    1,
                    ["overrides"] = {
                        ["S_K_4"] = {
                            138,
                            113,
                            225,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            164,
                            118,
                            153,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_6"] = {
                            166,
                            152,
                            192,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_7"] = {
                            131,
                            152,
                            156,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_2"] = {
                            138,
                            113,
                            225,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "158-155-205",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    153,
                    167,
                    171,
                    1,
                    ["overrides"] = {
                        ["S_Q_6"] = {
                            234,
                            175,
                            37,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_K_4"] = {
                            202,
                            189,
                            245,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            233,
                            195,
                            67,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "189-186-231",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    185,
                    200,
                    202,
                    1,
                    ["overrides"] = {
                        ["S_Q_6"] = {
                            255,
                            200,
                            71,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_J_4"] = {
                            116,
                            98,
                            126,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "230-229-246",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    181,
                    51,
                    1,
                    ["overrides"] = {
                        ["S_J_5"] = {
                            158,
                            133,
                            244,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-163-0",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    107,
                    97,
                    139,
                    1,
                    ["overrides"] = {
                        ["S_J_3"] = {
                            138,
                            113,
                            225,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["changed_flag"] = true,
                        ["S_Q_6"] = {
                            104,
                            87,
                            136,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_2"] = {
                            138,
                            113,
                            225,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_2"] = {
                            138,
                            113,
                            225,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "0-156-253",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    138,
                    113,
                    225,
                    1,
                    ["overrides"] = {
                        ["S_Q_4"] = {
                            196,
                            117,
                            221,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_4"] = {
                            202,
                            189,
                            245,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_6"] = {
                            138,
                            113,
                            225,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_3"] = {
                            197,
                            129,
                            9,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_3"] = {
                            197,
                            129,
                            9,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_J_2"] = {
                            107,
                            97,
                            139,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_Q_7"] = {
                            157,
                            139,
                            218,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                        ["S_K_3"] = {
                            197,
                            129,
                            9,
                            1,
                            ["grad_pos"] = {
                                0,
                            },
                            ["grad_config"] = {
                                ["pos"] = {
                                    1,
                                    0,
                                },
                                ["mode"] = "linear",
                                ["val"] = 1.571,
                            },
                        },
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "240-52-100",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    255,
                    255,
                    255,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "255-255-255",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                {
                    55,
                    70,
                    73,
                    1,
                    ["overrides"] = {
                    },
                    ["grad_pos"] = {
                        0,
                    },
                    ["key"] = "badge",
                    ["grad_config"] = {
                        ["pos"] = {
                            1,
                            0,
                        },
                        ["mode"] = "linear",
                        ["val"] = 0,
                    },
                },
                ["name"] = "High Contrast",
            },
			["saved_index"] = 1,
		},
		["Diamonds"] = {
			{
				{141,79,29,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="141-79-29"},
				{204,87,27,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="207-84-27"},
				{240,107,63,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="240-107-63"},
				{246,142,84,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="246-142-84"},
				{251,165,133,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="251-165-133"},
				{225,179,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="225-179-131"},
				{246,207,177,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="246-207-177"},
				{255,222,194,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-222-194"},

				{240,107,63,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-163-0"},
				{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="0-156-253"},
				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-255-255"},

				{240,107,63,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			{
				{141,79,29,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="141-79-29"},
				{232,131,6,232,131,6,186,104,4,186,104,4,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="207-84-27"},
				{255,163,0,255,163,0,199,127,0,199,127,0,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="240-107-63"},
				{246,142,84,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="246-142-84"},
				{251,165,133,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="251-165-133"},
				{251,210,111,251,210,111,207,181,99,207,181,99,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="225-179-131"},
				{255,227,159,255,227,159,251,210,111,251,210,111,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="246-207-177"},
				{255,232,166,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-222-194"},
				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-163-0"},
				{209,55,45,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="0-156-253"},
				{255,163,0,255,163,0,199,127,0,199,127,0 ,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-255-255"},
				{232,131,6,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="badge"},
				["default"] = true,
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Clubs"] = {
			{
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="37-93-89"},
				{28,112,106,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="28-112-106"},
				{58,143,135,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="58-143-135"},
				{72,147,141,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="72-147-141"},
				{137,179,180,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="137-179-180"},
				{184,210,212,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="184-210-212"},
				{82,121,132,82,121,132,110,165,179,110,165,179,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="96-143-155"},
				{109,149,160,109,149,160,155,202,214,155,202,214,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="131-175-187"},
				{144,189,201,144,189,201,215,234,250,215,234,250,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="207-233-231"},
				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-163-0"},
				{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="0-156-253"},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="240-52-100"},
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-255-255"},
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			{
				{0,156,253,0,156,253,0,123,199,0,123,199,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="37-93-89"},
				{61,200,255, 61,200,255, 38,161,237, 38,161,237,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="28-112-106"},
				{125,208,255, 125,208,255, 51,173,244, 51,173,244,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="58-143-135"},
				{51,148,209,1,["grad_pos" ]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="72-147-141"},
				{120,198,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="137-179-180"},
				{177,227,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="184-210-212"},
				{82,121,132,82,121,132,110,165,179,110,165,179,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="96-143-155"},
				{109,149,160,109,149,160,155,202,214,155,202,214,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="131-175-187"},
				{202,237,255,202,237,255,165,201,220,165,201,220,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="207-233-231"},

				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-163-0"},
				{254,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="0-156-253"},
				{0,156,253,0,123,199 ,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}},["overrides"]={},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-255-255"},

				{0,156,253 ,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="badge"},
				["default"] = true,
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Spectral"] = {
			{
				-- blues
				{61,68,96,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="61-68-96"},
				{78,87,121,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_sixth_sense"] = {156,102,163,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="78-87-121"},
				{94,114,151,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_seance"] = {83,93,127, 94,114,151, 83,93,127,["grad_pos"]={0,0.5,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}}},
					["j_sixth_sense"] = {138,102,149,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="94-114-151"},
				{82,100,162,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="82-100-162"},
				{91,127,193,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_sixth_sense"] = {228,152,238,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="91-127-193"},
				{99,143,225,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="99-143-225"},
				{122,164,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_sixth_sense"] = {205,108,217,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="122-164-242"},

				-- pack highlight blues
				{114,151,217,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="114-151-217"},
				{137,198,234,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="137-198-234"},
				{144,226,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="144-226-249"},
				{169,226,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="169-226-242"},

				-- golds
				{106,101,81,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="106-101-81"},
				{139,131,97,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_sixth_sense"] = {139,124,99,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="139-131-97"},
				{167,156,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_sixth_sense"] = {182,151,102,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="167-156-103"},
				{199,178,74,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_sixth_sense"] = {214,177,120,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="199-178-74"},
				{232,214,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="232-214-127"},

				-- pack highlight golds
				{192,223,174,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="192-223-174"},
				{207,229,185,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="207-229-185"},
				{225,235,133,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="225-235-133"},
				{239,241,156,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="239-241-156"},

				-- grays
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="79-99-103"},
				{92,120,125,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="92-120-125"},

				{150,170,203,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_seance"] = {121,138,169,150,170,203,121,138,169,["grad_pos"]={0,0.5,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}}}
				},["key"]="150-170-203"},

				{191,204,227,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_seance"] = {136,154,185,191,204,227,136,154,185,["grad_pos"]={0,0.5,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}}},
					["j_sixth_sense"] = {191,199,213,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="191-204-227"},

				{226,235,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_seance"] = {159,175,201,226,235,249,159,175,201,["grad_pos"]={0,0.5,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={1,0}}},
					["j_sixth_sense"] = {220,200,200,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="226-235-249"},

				-- whites
				{239,250,254,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="239-250-254"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-255-255"},

				-- badge
				{69,132,250,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
		["Tarot"] = {
			{
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="79-99-103"},
				{255,229,180,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {255,144,137,255,144,137,141,165,205,141,165,205,["grad_pos"]={0,0.35,0.6,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="255-229-180"},
				{218,183,114,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {228,57,46,228,57,46,0,132,216,0,132,216,["grad_pos"]={0,0.4,0.6,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="218-183-114"},
				{243,198,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {253,95,85,253,95,85,0,156,253,0,156,253,["grad_pos"]={0,0.4,0.6,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="243-198-89"},
				{165,133,71,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {195,49,39,195,49,39,0,107,175,0,107,175,["grad_pos"]={0,0.4,0.6,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="165-133-71"},
				{233,216,254,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {60,180,255,60,180,255,255,150,144,["grad_pos"]={0,0.2,1},["grad_config"]={["mode"]="linear",["val"]=1.13,["pos"]={1,0}}}
				},["key"]="233-216-254"},
				{214,186,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="214-186-249"},
				{183,162,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {64,155,210,64,155,210,251,96,87,["grad_pos"]={0,0.2,1},["grad_config"]={["mode"]="linear",["val"]=1.13,["pos"]={1,0}}}
				},["key"]="183-162-253"},
				{167,145,243,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="167-145-243"},
				{153,129,234,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {253,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="153-129-234"},
				{138,113,225,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {0,139,227,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="138-113-225"},
				{107,97,139,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_superposition"] = {221,70,60,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}}}
				},["key"]="107-97-139"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-255-255"},
				{167,130,209,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="badge"},
				["default"] = true,
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Background"] = {
			{
				{80,132,110,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="Small"},
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="won"},
				{254,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
				{0,157,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
				["default"] = true,
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Planet"] = {
			{
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="79-99-103"},
				-- blues
				{79,108,116,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_supernova"] = {79,108,116, 79,108,116, 84,99,123, 79,108,116,["grad_pos"]={0,0.45,0.5,1},["grad_config"]={["mode"]="linear",["val"]=1.13,["pos"]={1,0}}}
				},["key"]="79-108-116"},
				{87,125,136,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_supernova"] = {87,125,136, 87,125,136, 93,112,142, 87,125,136,["grad_pos"]={0,0.45,0.5,1},["grad_config"]={["mode"]="linear",["val"]=1.13,["pos"]={1,0}}}
				},["key"]="87-125-136"},
				{91,155,170,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_supernova"] = {91,155,170, 91,155,170, 106,142,172, 91,155,170,["grad_pos"]={0,0.45,0.5,1},["grad_config"]={["mode"]="linear",["val"]=1.13, ["pos"]={1,0}}}
				},["key"]="91-155-170"},
				{103,176,209,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="103-176-209"},
				{132,197,210,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="132-197-210"},
				{116,198,208,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="116-198-208"},
				{113,206,233,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="113-206-233"},
				{137,232,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="137-232-253"},


				-- purples
				{88,96,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_supernova"] = {88,96,127 ,84,99,123, 88,96,127, 88,96,127,["grad_pos"]={0,0.5,0.55,1},["grad_config"]={["mode"]="linear",["val"]=1.13,["pos"]={1,0}}}
				},["key"]="88-96-127",},
				{102,99,149,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_supernova"] = {102,99,149, 93,112,142, 102,99,149, 102,99,149,["grad_pos"]={0,0.5,0.55,1},["grad_config"]={["mode"]="linear",["val"]=1.13,["pos"]={1,0}}}
				},["key"]="102-99-149"},
				{135,119,176,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={
					["j_supernova"] = {135,119,176 ,106,142,172, 135,119,176, 135,119,176,["grad_pos"]={0,0.5,0.55,1},["grad_config"]={["mode"]="linear",["val"]=1.13,["pos"]={1,0}}}
				},["key"]="135-119-176"},
				{183,162,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="183-162-253"},

				-- earth colors
				{59,102,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="59-102-131"},
				{72,94,137,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="72-94-137"},
				{54,116,157,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="54-116-157"},
				{66,86,186,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="66-86-186"},
				{77,138,223,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="77-138-223"},

				-- gold
				{253,220,160,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="253-220-160"},

				-- whites/grays
				{140,157,199,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="140-157-199"},
				{176,189,214,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="176-189-214"},
				{223,245,252, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="223-245-252", ["default"] = true,},
				{255,255,255, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="255-255-255", ["default"] = true},

				{19,175,206,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={1,0}},["overrides"]={},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
	}, exclude_from_ui = true}
})
