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
				{174,27,67,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="174-27-67"},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100"},
				{255,99,136,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-99-136"},
				{253,160,182,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-160-182"},
				{253,189,207,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-189-207"},
				{253,211,223,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-211-223"},
				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			{
				{150,27,29,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="174-27-67"},
				{248,59,47,248,59,47,208,29,17,208,29,17,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="240-52-100"},
				{255,99,103,255,99,103,220,77,81,220,77,81,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="255-99-136"},
				{237,131,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-160-182"},
				{255,159,162,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-189-207"},
				{255,196,196,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-211-223"},

				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{41,173,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},

				{248,59,47,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Spades"] = {
			{
				{64,72,111,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="64-72-111"},
				{84,78,138,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="84-78-138"},
				{104,99,156,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="104-99-156"},

				{158,155,205,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="158-155-205"},
				{189,186,231,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="189-186-231"},
				{230,229,246,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="230-229-246"},

				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},

				{64,72,111,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			{
				{79,99,103,79,99,103,55,70,73,55,70,73,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="64-72-111"},
				{91,108,110,91,108,110,62,71,73,62,71,73,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="84-78-138"},
				{105,123,127,105,123,127,69,83,87,69,83,87,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="104-99-156"},

				{133,146,149,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="158-155-205"},
				{153,167,171,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="189-186-231"},
				{185,200,202,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="230-229-246"},

				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{107,97,139,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{138,113,225, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},

				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Diamonds"] = {
			{
				{141,79,29,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="141-79-29"},
				{204,87,27,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="207-84-27"},
				{240,107,63,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-107-63"},
				{246,142,84,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="246-142-84"},
				{251,165,133,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="251-165-133"},
				{225,179,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="225-179-131"},
				{246,207,177,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="246-207-177"},
				{255,222,194,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-222-194"},

				{240,107,63,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},

				{240,107,63,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			{
				{141,79,29,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="141-79-29"},
				{232,131,6,232,131,6,186,104,4,186,104,4,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="207-84-27"},
				{255,163,0,255,163,0,199,127,0,199,127,0,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="240-107-63"},
				{246,142,84,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="246-142-84"},
				{251,165,133,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="251-165-133"},
				{251,210,111,251,210,111,207,181,99,207,181,99,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="225-179-131"},
				{255,227,159,255,227,159,251,210,111,251,210,111,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="246-207-177"},
				{255,232,166,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-222-194"},
				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{209,55,45,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{255,163,0,255,163,0,199,127,0,199,127,0 ,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},
				{232,131,6,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Clubs"] = {
			{
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="37-93-89"},
				{28,112,106,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="28-112-106"},
				{58,143,135,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="58-143-135"},
				{72,147,141,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-147-141"},
				{137,179,180,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-179-180"},
				{184,210,212,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="184-210-212"},
				{82,121,132,82,121,132,110,165,179,110,165,179,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="96-143-155"},
				{109,149,160,109,149,160,155,202,214,155,202,214,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="131-175-187"},
				{144,189,201,144,189,201,215,234,250,215,234,250,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="207-233-231"},
				{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{240,52,100,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="240-52-100"},
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},
				{37,93,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			{
				{0,156,253,0,156,253,0,123,199,0,123,199,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="37-93-89"},
				{61,200,255, 61,200,255, 38,161,237, 38,161,237,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="28-112-106"},
				{125,208,255, 125,208,255, 51,173,244, 51,173,244,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="58-143-135"},
				{51,148,209,1,["grad_pos" ]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-147-141"},
				{120,198,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-179-180"},
				{177,227,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="184-210-212"},
				{82,121,132,82,121,132,110,165,179,110,165,179,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="96-143-155"},
				{109,149,160,109,149,160,155,202,214,155,202,214,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="131-175-187"},
				{202,237,255,202,237,255,165,201,220,165,201,220,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="207-233-231"},

				{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-163-0"},
				{254,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="0-156-253"},
				{0,156,253,0,123,199 ,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["key"]="240-52-100"},
				{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="55-70-73"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},

				{0,156,253 ,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "High Contrast",
			},
			["saved_index"] = 1,
		},
		["Spectral"] = {
			{
				{61,68,96,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="61-68-96"},
				{106,101,81,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="106-101-81"},
				{78,87,121,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="78-87-121"},
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="79-99-103"},
				{92,120,125,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="92-120-125"},
				{139,131,97,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="139-131-97"},
				{167,156,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="167-156-103"},
				{199,178,74,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="199-178-74"},
				{232,214,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="232-214-127"},
				{94,114,151,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="94-114-151"},
				{82,100,162,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="82-100-162"},
				{91,127,193,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="91-127-193"},
				{114,151,217,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="114-151-217"},
				{99,143,225,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="99-143-225"},
				{122,164,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="122-164-242"},
				{225,235,133,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="225-235-133"},
				{239,241,156,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="239-241-156"},
				{192,223,174,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="192-223-174"},
				{207,229,185,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="207-229-185"},
				{150,170,203,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="150-170-203"},
				{137,198,234,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-198-234"},
				{191,204,227,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="191-204-227"},
				{144,226,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="144-226-249"},
				{169,226,242,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="169-226-242"},
				{226,235,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="226-235-249"},
				{239,250,254,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="239-250-254"},
				{255,84,104,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-84-104"},
				{170,64,92,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="170-64-92"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},
				{69,132,250,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
		["Tarot"] = {
			{
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="79-99-103"},
				{255,229,180,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-229-180"},
				{218,183,114,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="218-183-114"},
				{243,198,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="243-198-89"},
				{165,133,71,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="165-133-71"},
				{233,216,254,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="233-216-254"},
				{214,186,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="214-186-249"},
				{183,162,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="183-162-253"},
				{167,145,243,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="167-145-243"},
				{153,129,234,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="153-129-234"},
				{138,113,225,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="138-113-225"},
				{107,97,139,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="107-97-139"},
				{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="255-255-255"},
				{167,130,209,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Background"] = {
			{
				{80,132,110,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="Small"},
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="won"},
				{254,95,85,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="SHOWDOWN_COL_1"},
				{0,157,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="SHOWDOWN_COL_2"},
				["default"] = true,
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Planet"] = {
			{
				{61,68,96,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"] = "61-68-96"},
				{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="79-99-103"},
				{88,96,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="88-96-127",},
				{59,102,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="59-102-131"},
				{54,116,157,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="54-116-157"},
				{72,94,137,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="72-94-137"},
				{87,125,136,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="87-125-136"},
				{102,99,149,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="102-99-149"},
				{66,86,186,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="66-86-186"},
				{135,119,176,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="135-119-176"},
				{91,155,170,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="91-155-170"},
				{77,138,223,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="77-138-223"},
				{103,176,209,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="103-176-209"},
				{116,198,208,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="116-198-208"},
				{113,206,233,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="113-206-233"},
				{253,220,160,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="253-220-160"},
				{140,157,199,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="140-156-199"},
				{176,189,214,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="176-189-214"},
				{183,162,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="183-162-253"},
				{132,197,210,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="132-197-210"},
				{137,232,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="137-232-253"},
				{223, 245, 252, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"] = "223-245-252", ["default"] = true,},
				{255, 255, 255, 1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"] = "255-255-255", ["default"] = true},
				{19,175,206,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["key"]="badge"},
				["default"] = true,
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
	}, exclude_from_ui = true}
})
