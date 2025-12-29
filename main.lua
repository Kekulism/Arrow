if ArrowAPI then
	sendDebugMessage('[ArrowAPI] already provided. Skipping...')
	return
end

ArrowAPI = SMODS.current_mod
ArrowAPI.startup_item_check = false
ArrowAPI.col_stand_hover = nil
ArrowAPI.palette_ui_config = {
	rgb = {0, 0, 0},
	open_palette = {
		set = '',
		idx = '',
		grad_idx = ''
	},
	hex_input = '',
	name_input = ''
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


ArrowAPI.config_tools.use_config(ArrowAPI, {
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
				{174,27,67,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="174-27-67",["default"]=true},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100",["default"]=true},
				{255,99,136,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-99-136",["default"]=true},
				{253,160,182,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-160-182",["default"]=true},
				{253,189,207,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-189-207",["default"]=true},
				{253,211,223,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-211-223",["default"]=true},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge",["default"]=true},
				["name"] = "Default",
			},
			{
				{174,27,79,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="174-27-67"},
				{225,56,80,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100"},
				{249,107,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-99-136"},
				{251,166,178,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-160-182"},
				{252,191,200,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-189-207"},
				{253,213,218,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-211-223"},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["name"] = "Cardsauce",
			},
			["saved_index"] = 1,
		},
		["Spades"] = {
			{
				{64,72,111,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="64-72-111",["default"]=true},
				{84,78,138,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="84-78-138",["default"]=true},
				{104,99,156,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="104-99-156",["default"]=true},
				{150,146,207,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="150-146-207",["default"]=true},
				{180,176,233,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="180-176-233",["default"]=true},
				{222,220,245,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="222-220-245",["default"]=true},
				{64,72,111,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge",["default"]=true},
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
		["Diamonds"] = {
			{
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="37-93-89",["default"]=true},
				{28,112,106,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="28-112-106",["default"]=true},
				{58,143,135,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="58-143-135",["default"]=true},
				{72,147,141,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-147-141",["default"]=true},
				{114,168,169,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="114-168-169",["default"]=true},
				{156,194,197,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="156-194-197",["default"]=true},
				{82,121,132,110,165,179,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="96-143-155",["default"]=true},
				{109,149,160,155,202,214,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="131-175-187",["default"]=true},
				{144,189,201,215,234,250,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="173-220-217",["default"]=true},
				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0",["default"]=true},
				{209,55,45,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253",["default"]=true},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100",["default"]=true},
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73",["default"]=true},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255",["default"]=true},
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge",["default"]=true},
				["name"] = "Default",
			},
			{
				{0,156,253,0,156,253,0,123,199,0,123,199,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="37-93-89"},
				{73,185,255,73,185,255,32,145,215,32,145,215,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="28-112-106"},
				{116,199,251,116,199,251,80,164,215,80,164,215,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="58-143-135"},
				{72,162,209,1,["grad_pos" ]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-147-141"},
				{107,195,244,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-179-180"},
				{202,237,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="184-210-212"},
				{82,121,132,82,121,132,110,165,179,110,165,179,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="96-143-155",["default"]=true},
				{109,149,160,109,149,160,155,202,214,155,202,214,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="131-175-187",["default"]=true},
				{202,237,255,202,237,255,165,201,220,165,201,220,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="207-233-231",["default"]=true},

				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{254,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{0,156,253,0,123,199 ,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},

				{0,156,253 ,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Clubs"] = {
			{
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="37-93-89",["default"]=true},
				{28,112,106,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="28-112-106",["default"]=true},
				{58,143,135,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="58-143-135",["default"]=true},
				{72,147,141,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-147-141",["default"]=true},
				{137,179,180,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-179-180",["default"]=true},
				{184,210,212,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="184-210-212",["default"]=true},
				{82,121,132,82,121,132,110,165,179,110,165,179,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="96-143-155",["default"]=true},
				{109,149,160,109,149,160,155,202,214,155,202,214,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="131-175-187",["default"]=true},
				{144,189,201,144,189,201,215,234,250,215,234,250,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="207-233-231",["default"]=true},

				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0",["default"]=true},
				{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253",["default"]=true},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100",["default"]=true},
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73",["default"]=true},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255",["default"]=true},

				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge",["default"]=true},
				["name"] = "Default",
			},
			{
				{0,156,253,0,156,253,0,123,199,0,123,199,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="37-93-89"},
				{73,185,255,73,185,255,32,145,215,32,145,215,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="28-112-106"},
				{116,199,251,116,199,251,80,164,215,80,164,215,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="58-143-135"},
				{72,162,209,1,["grad_pos" ]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-147-141"},
				{107,195,244,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-179-180"},
				{154,219,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="184-210-212"},
				{82,121,132,82,121,132,110,165,179,110,165,179,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="96-143-155",["default"]=true},
				{109,149,160,109,149,160,155,202,214,155,202,214,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="131-175-187",["default"]=true},
				{202,237,255,202,237,255,165,201,220,165,201,220,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="207-233-231",["default"]=true},

				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{254,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{0,156,253,0,123,199 ,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},

				{0,156,253 ,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Spectral"] = {
			{
				{61,68,96,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="61-68-96",["default"]=true},
				{106,101,81,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="106-101-81",["default"]=true},
				{78,87,121,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="78-87-121",["default"]=true},
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="79-99-103",["default"]=true},
				{92,120,125,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="92-120-125",["default"]=true},
				{139,131,97,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="139-131-97",["default"]=true},
				{167,156,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="167-156-103",["default"]=true},
				{199,178,74,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="199-178-74",["default"]=true},
				{232,214,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="232-214-127",["default"]=true},
				{94,114,151,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="94-114-151",["default"]=true},
				{82,100,162,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="82-100-162",["default"]=true},
				{91,127,193,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="91-127-193",["default"]=true},
				{114,151,217,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="114-151-217",["default"]=true},
				{99,143,225,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="99-143-225",["default"]=true},
				{122,164,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="122-164-242",["default"]=true},
				{225,235,133,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="225-235-133",["default"]=true},
				{239,241,156,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="239-241-156",["default"]=true},
				{192,223,174,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="192-223-174",["default"]=true},
				{207,229,185,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="207-229-185",["default"]=true},
				{150,170,203,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="150-170-203",["default"]=true},
				{137,198,234,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-198-234",["default"]=true},
				{191,204,227,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="191-204-227",["default"]=true},
				{144,226,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="144-226-249",["default"]=true},
				{169,226,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="169-226-242",["default"]=true},
				{226,235,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="226-235-249",["default"]=true},
				{239,250,254,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="239-250-254",["default"]=true},
				{255,84,104,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-84-104",["default"]=true},
				{170,64,92,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="170-64-92",["default"]=true},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255",["default"]=true},
				{69,132,250,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge",["default"]=true},
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
		["Tarot"] = {
			{
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="79-99-103",["default"]=true},
				{255,229,180,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-229-180",["default"]=true},
				{218,183,114,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="218-183-114",["default"]=true},
				{243,198,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="243-198-89",["default"]=true},
				{165,133,71,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="165-133-71",["default"]=true},
				{233,216,254,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="233-216-254",["default"]=true},
				{214,186,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="214-186-249",["default"]=true},
				{183,162,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="183-162-253",["default"]=true},
				{167,145,243,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="167-145-243",["default"]=true},
				{153,129,234,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="153-129-234",["default"]=true},
				{138,113,225,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="138-113-225",["default"]=true},
				{107,97,139,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="107-97-139",["default"]=true},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255",["default"]=true},
				{167,130,209,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge",["default"]=true},
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Background"] = {
			{
				{80,132,110,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="Small",["default"]=true},
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="won",["default"]=true},
				{254,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="SHOWDOWN_COL_1",["default"]=true},
				{0,157,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="SHOWDOWN_COL_2",["default"]=true},
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Planet"] = {
			{
				{61,68,96,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"] = "61-68-96",["default"]=true},
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="79-99-103",["default"]=true},
				{88,96,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="88-96-127",["default"]=true,},
				{59,102,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="59-102-131",["default"]=true},
				{54,116,157,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="54-116-157",["default"]=true},
				{72,94,137,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-94-137",["default"]=true},
				{87,125,136,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="87-125-136",["default"]=true},
				{102,99,149,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="102-99-149",["default"]=true},
				{66,86,186,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="66-86-186",["default"]=true},
				{135,119,176,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="135-119-176",["default"]=true},
				{91,155,170,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="91-155-170",["default"]=true},
				{77,138,223,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="77-138-223",["default"]=true},
				{103,176,209,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="103-176-209",["default"]=true},
				{116,198,208,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="116-198-208",["default"]=true},
				{113,206,233,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="113-206-233",["default"]=true},
				{253,220,160,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-220-160",["default"]=true},
				{140,157,199,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="140-156-199",["default"]=true},
				{176,189,214,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="176-189-214",["default"]=true},
				{183,162,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="183-162-253",["default"]=true},
				{132,197,210,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="132-197-210",["default"]=true},
				{137,232,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-232-253",["default"]=true},
				{223, 245, 252, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"] = "223-245-252", ["default"] = true,},
				{255, 255, 255, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"] = "255-255-255", ["default"] = true},
				{19,175,206,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge",["default"]=true},
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
	}, exclude_from_ui = true},
})
