UsableModPath = SMODS.current_mod.path:match("Mods/[^/]+")
PathPatternReplace = UsableModPath:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace
arrow_config = SMODS.current_mod.config
arrow_enabled = copy_table(arrow_config)

SMODS.current_mod.DT = {}

G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')

local includes = {
	'atlases',
	'tables',
	'utility',
	'ui',
	'shaders',
	'smods',

	'hooks/overrides',
	'hooks/button_callbacks',
	'hooks/card',
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/smods',
	'hooks/game',

	'stands',
	'vhs',
	'items',
}

-- blank function that is run on starting the main menu,
-- other parts of the mod can hook into this to run code
-- that needs to be run after the game has initialized
local ref_ips = function() end
if G.FUNCS.initPostSplash then ref_ips = G.FUNCS.initPostSplash end
G.FUNCS.initPostSplash = function()
	ref_ips()
end

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("includes/" .. include ..".lua")
	if error then sendErrorMessage("[Arrow] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Arrow] Loaded hook: " .. include)
	end
end
