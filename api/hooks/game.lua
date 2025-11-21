
-- blank function that is run on starting the main menu,
-- other parts of the mod can hook into this to run code
-- that needs to be run after the game has initialized
local ref_post_splash = G.FUNCS.initPostSplash or function() end
G.FUNCS.initPostSplash = function()
	local ret = ref_post_splash()
	ArrowAPI.loading.disable_empty()

	for _, mod in pairs(SMODS.Mods) do
		if mod.can_load then
			if mod.ARROW_USE_CREDITS then
				-- clean any default sections that aren't provided contributors
				if ArrowAPI.credits[mod.id].use_default_sections then
					for i = #ArrowAPI.credits[mod.id], 1, -1 do
						if not next(ArrowAPI.credits[mod.id][i].contributors) then
							table.remove(ArrowAPI.credits[mod.id], i)
						end
					end

					-- set default section dimensions
					local default_w = ArrowAPI.DEFAULT_CREDIT_MATRIX.col/#ArrowAPI.credits[mod.id]
					for i, v in ipairs(ArrowAPI.credits[mod.id]) do
						v.pos_start = {col = default_w * (i-1), row = 0}
						v.pos_end = {col = default_w * i, row = ArrowAPI.DEFAULT_CREDIT_MATRIX.row}
					end
				end

				local credits_tab = ArrowAPI.ui.create_credits_tab(mod)
				mod.credits_tab = credits_tab
			end

			if mod.ARROW_USE_CONFIG then
				local config_tab = ArrowAPI.ui.create_config_tab(mod)
				mod.config_tab = config_tab
			end
		end
	end

	for k, v in ipairs(G.CHALLENGES) do
		ArrowAPI.misc.run_challenge_functions(v)
	end

	TNSMI.save_soundpacks()


	return ret
end

local ps_ref = Game.prep_stage
function Game:prep_stage(new_stage, new_state, new_game_obj)
    ps_ref(self, new_stage, new_state, new_game_obj)

    if not ArrowAPI.INIT_POST_SPLASH then
        ArrowAPI.INIT_POST_SPLASH = true
        G.FUNCS.initPostSplash()
    end
end

local ref_game_start = Game.start_run
function Game:start_run(args)
    G.GAME.arrow_gradient_background = nil
    G.GAME.arrow_gradient_ui = nil
    local ret = ref_game_start(self, args)

    if (not args or not args.savetext) and G.GAME.modifiers.all_bosses then
        G.GAME.round_resets.blind_choices.Small = get_new_boss('Small')
        G.GAME.round_resets.blind_choices.Big = get_new_boss('Big')
    end

    local obj = G.GAME.blind.config.blind
    if G.GAME.blind.in_blind and obj.post_load and type(obj.post_load) == 'function' then
        obj:post_load()
    end

    return ret
end

local ref_game_delete = Game.delete_run
function Game:delete_run(...)
    local ret = ref_game_delete(self, ...)

    -- for the sake of cleanup, I don't want these hanging in the background
    if G.GAME and G.GAME.arrow_extra_blinds and next(G.GAME.arrow_extra_blinds) then
        for _, v in ipairs(G.GAME.arrow_extra_blinds) do
            v:remove()
        end
        G.GAME.arrow_extra_blinds = nil
    end

    return ret
end

local ref_load_profile = Game.load_profile
function Game:load_profile(_profile)
    local ret = ref_load_profile(self, _profile)
    G.PROFILES[G.SETTINGS.profile].stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage or {}

    return ret
end