local ref_use_card = G.FUNCS.use_card
G.FUNCS.use_card = function(e, mute, nosave)
    local card = e.config.ref_table
    if card.area == G.consumeables and (card.ability.activation or (card.config.center.activate and type(card.config.center.activate) == 'function')) then
        if card.config.center.activate and type(card.config.center.activate) == 'function' then
            card.config.center.activate(card.config.center, card, not card.ability.activated)
        end

        if card.ability.activation then
            ArrowAPI.vhs.tape_activate(card)
            if G.CONTROLLER.HID.controller then
                card.children.focused_ui = G.UIDEF.card_focus_ui(card)
                G.CONTROLLER.locks.use = false
            else
                card:highlight(true)
            end
        end

        return
    end

    return ref_use_card(e, mute, nosave)
end

local ref_buy_shop = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
    ref_buy_shop(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if c1.ability.consumeable then
                    if c1.config.center.set == 'Stand' then
                        inc_career_stat('c_stands_bought', 1)
                    elseif c1.config.center.set == 'VHS' then
                        inc_career_stat('c_vhss_bought', 1)
                    end
                end
                return true
            end
        }))
    end
end





---------------------------
--------------------------- Stand buy space
---------------------------

local ref_check_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.ability.set == 'Stand' and not G.GAME.modifiers.unlimited_stands and ArrowAPI.stands.get_num_stands() >= G.GAME.modifiers.max_stands then
        alert_no_space(card, G.consumeables)
        return false
    end

    local ret = ref_check_buy_space(card)
    if not ret then
        return ret
    end


    return ret
end

local ref_select_booster = G.FUNCS.can_select_from_booster
G.FUNCS.can_select_from_booster = function(e)
    local ret = ref_select_booster(e)

    if e.config.button then
        local card = e.config.ref_table



        if card.ability.set == 'Stand' and not G.GAME.modifiers.unlimited_stands and ArrowAPI.stands.get_num_stands() >= G.GAME.modifiers.max_stands then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        end
    end

    return ret
end





---------------------------
--------------------------- Management for gradient backgrounds and UIs
---------------------------

local ref_start_run = G.FUNCS.start_run
G.FUNCS.start_run = function(...)
    if G.GAME.blind then
        G.GAME.blind.in_blind = false
        G.GAME.blind.newrun_flag = true
    end

    if G.GAME.arrow_gradient_background then
        G.C.BACKGROUND.L = { G.C.BACKGROUND.L[1], G.C.BACKGROUND.L[2], G.C.BACKGROUND.L[3], G.C.BACKGROUND.L[4] }
        G.C.BACKGROUND.D = { G.C.BACKGROUND.D[1], G.C.BACKGROUND.D[2], G.C.BACKGROUND.D[3], G.C.BACKGROUND.D[4] }
        G.C.BACKGROUND.C = { G.C.BACKGROUND.C[1], G.C.BACKGROUND.C[2], G.C.BACKGROUND.C[3], G.C.BACKGROUND.C[4] }
        G.C.BACKGROUND.contrast = G.C.BACKGROUND.contrast
        G.GAME.arrow_gradient_background = nil
    end

    if G.GAME.arrow_gradient_ui then
        G.C.DYN_UI.MAIN = { G.C.DYN_UI.MAIN[1], G.C.DYN_UI.MAIN[2], G.C.DYN_UI.MAIN[3], G.C.DYN_UI.MAIN[4] }
        G.C.DYN_UI.DARK = { G.C.DYN_UI.DARK[1], G.C.DYN_UI.DARK[2], G.C.DYN_UI.DARK[3], G.C.DYN_UI.DARK[4] }
        G.C.DYN_UI.BOSS_MAIN = { G.C.DYN_UI.BOSS_MAIN[1], G.C.DYN_UI.BOSS_MAIN[2], G.C.DYN_UI.BOSS_MAIN[3], G.C.DYN_UI.BOSS_MAIN[4] }
        G.C.DYN_UI.BOSS_DARK = { G.C.DYN_UI.BOSS_DARK[1], G.C.DYN_UI.BOSS_DARK[2], G.C.DYN_UI.BOSS_DARK[3], G.C.DYN_UI.BOSS_DARK[4] }
        G.GAME.arrow_gradient_ui = nil
    end

    return ref_start_run(...)
end

local ref_go_menu = G.FUNCS.go_to_menu
G.FUNCS.go_to_menu = function(e)
    if G.GAME.arrow_gradient_background then
        G.C.BACKGROUND.L = { G.C.BACKGROUND.L[1], G.C.BACKGROUND.L[2], G.C.BACKGROUND.L[3], G.C.BACKGROUND.L[4] }
        G.C.BACKGROUND.D = { G.C.BACKGROUND.D[1], G.C.BACKGROUND.D[2], G.C.BACKGROUND.D[3], G.C.BACKGROUND.D[4] }
        G.C.BACKGROUND.C = { G.C.BACKGROUND.C[1], G.C.BACKGROUND.C[2], G.C.BACKGROUND.C[3], G.C.BACKGROUND.C[4] }
        G.C.BACKGROUND.contrast = G.C.BACKGROUND.contrast
        G.GAME.arrow_gradient_background = nil
    end

    if G.GAME.arrow_gradient_ui then
        G.C.DYN_UI.MAIN = { G.C.DYN_UI.MAIN[1], G.C.DYN_UI.MAIN[2], G.C.DYN_UI.MAIN[3], G.C.DYN_UI.MAIN[4] }
        G.C.DYN_UI.DARK = { G.C.DYN_UI.DARK[1], G.C.DYN_UI.DARK[2], G.C.DYN_UI.DARK[3], G.C.DYN_UI.DARK[4] }
        G.C.DYN_UI.BOSS_MAIN = { G.C.DYN_UI.BOSS_MAIN[1], G.C.DYN_UI.BOSS_MAIN[2], G.C.DYN_UI.BOSS_MAIN[3], G.C.DYN_UI.BOSS_MAIN[4] }
        G.C.DYN_UI.BOSS_DARK = { G.C.DYN_UI.BOSS_DARK[1], G.C.DYN_UI.BOSS_DARK[2], G.C.DYN_UI.BOSS_DARK[3], G.C.DYN_UI.BOSS_DARK[4] }
        G.GAME.arrow_gradient_ui = nil
    end

    return ref_go_menu(e)
end





---------------------------
--------------------------- Debuff text for blinds, including extra blinds
---------------------------

G.FUNCS.update_blind_debuff_text = function(e)
    if not e.config.object then return end

    local new_str = SMODS.debuff_text or G.GAME.blind:get_loc_debuff_text()
    if not new_str then return end

    if new_str ~= e.config.object.config.string[1].string then
        e.config.object.config.string[1].string = new_str
        e.config.object.start_pop_in = true
        e.config.object:update_text(true)
        e.UIBox:recalculate()
    end
end





---------------------------
--------------------------- Deck crediting
---------------------------

G.FUNCS.RUN_SETUP_check_artist = function(e)
    if G.GAME.viewed_back.name ~= e.config.id then
        --removes the UI from the previously selected back and adds the new one
        if G.GAME.viewed_back.effect.center.artist then
            if e.config.object then e.config.object:remove() end
            e.UIT = G.UIT.O
            e.config.object = UIBox{
                definition = G.UIDEF.deck_credit(G.GAME.viewed_back.effect.center),
                config = {offset = {x=0,y=0}, align = 'cm', parent = e}
            }

            e.config.minh = nil
            e.config.maxh = nil
            if e.parent.parent.children[1] then
                e.parent.parent.children[1].config.minh = 0.45
                e.parent.parent.children[2].config.minh = 0.9
            end
        else
            if e.config.object then e.config.object:remove() end
            e.UIT = G.UIT.R

            e.config.minh = 0
            e.config.maxh = 0
            if e.parent.parent.children[1] then
                e.parent.parent.children[1].config.minh = 0.6
                e.parent.parent.children[2].config.minh = 1.7
            end
        end
        e.config.id = G.GAME.viewed_back.name
        e.UIBox:recalculate()
    end
end



---------------------------
--------------------------- Config
---------------------------

-- Not happy about this overwrite, since it's changing function args, but the only vanilla or SMODS example
-- that declares this argument doesn't use it -- local function createClickableModBox() in SMODS > src > ui.lua
function G.FUNCS.toggle_button(e)
  e.config.ref_table.ref_table[e.config.ref_table.ref_value] = not e.config.ref_table.ref_table[e.config.ref_table.ref_value]
  if e.config.toggle_callback then
    e.config.toggle_callback(e.config.ref_table, e.config.ref_table.ref_table[e.config.ref_table.ref_value])
  end
end

function G.FUNCS.arrow_check_restart(e)
    local mod = e.ref_mod
	local match = true
	for i, v in ipairs(mod.ARROW_USE_CONFIG) do
		if v.value ~= mod.config[v.key] then
			match = false
		end
	end

	if match then
		sendDebugMessage('Settings match')
		SMODS.full_restart = 0
	else
		sendDebugMessage('Settings mismatch, restart required')
		SMODS.full_restart = 1
	end
end

G.FUNCS.arrow_reset_achievements = function(e)
    local mod = e.ref_mod
	local warning_text = e.UIBox:get_UIE_by_ID(mod.id..'_warn')
	if warning_text.config.colour ~= G.C.WHITE then
		warning_text:juice_up()
		warning_text.config.colour = G.C.WHITE
		warning_text.config.shadow = true
		e.config.disable_button = true
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06, blockable = false, blocking = false, func = function()
			play_sound('tarot2', 0.76, 0.4);return true end}))
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.35, blockable = false, blocking = false, func = function()
			e.config.disable_button = nil; return true end}))
		play_sound('tarot2', 1, 0.4)
	else
        warning_text.config.colour = G.C.CLEAR
		G.FUNCS.wipe_on()
		for k, v in pairs(SMODS.Achievements) do
			if v.original_mod and v.original_mod.id == mod.id then
				G.SETTINGS.ACHIEVEMENTS_EARNED[k] = nil
				G.ACHIEVEMENTS[k].earned = nil
			end
		end
		G:save_settings()
		G.E_MANAGER:add_event(Event({
			delay = 1,
			func = function()
				G.FUNCS.wipe_off()
				return true
			end
		}))
	end
end





---------------------------
--------------------------- Tonsmith callbacks
---------------------------

function G.FUNCS.tnsmi_change_pack_display(e) -- e represents the node
    TNSMI.config[e.config.ref_table[1]] = TNSMI.config[e.config.ref_table[1]] + e.config.ref_table[2]

    TNSMI.config.rows = math.max(1, math.min(4, TNSMI.config.rows))
    TNSMI.config.cols =  math.max(1, math.min(16, TNSMI.config.cols))

    SMODS.save_mod_config(TNSMI)
end

function G.FUNCS.tnsmi_change_priority(e)
    -- check if anything has been moved from expected positions and then save
    if TNSMI.dissolve_flag then return end

    local priority_changed = false
    for i, v in ipairs(TNSMI.cardareas.priority.cards) do
        local priority = #TNSMI.cardareas.priority.cards - i + 1
        if v.params.tnsmi_soundpack ~= TNSMI.config.loaded_packs[priority] then
            priority_changed = true
            break
        end
    end

    if not priority_changed then return end

    TNSMI.config.loaded_packs = {}
    for i, v in ipairs(TNSMI.cardareas.priority.cards) do
        local priority = #TNSMI.cardareas.priority.cards - i + 1
        TNSMI.config.loaded_packs[priority] = v.params.tnsmi_soundpack
    end


    TNSMI.save_soundpacks()
end

function G.FUNCS.tnsmi_packs_button(e)
	G.SETTINGS.paused = true
    SMODS.save_mod_config(TNSMI)
    G.FUNCS.overlay_menu({
		definition = tnsmi_create_UIBox_soundpacks(),
	})
    G.OVERLAY_MENU.config.id = 'tnsmi_soundpack_menu'
    G.OVERLAY_MENU:recalculate()
end

--- Callback for soundpack page select
--- All values involving what page is selected are stored in TNSMI.cycle_config
function G.FUNCS.tnsmi_soundpacks_page(args)
    G.FUNCS.tnsmi_reload_soundpack_cards()
end

--- Function callback to determine shoulder button state
--- This is intended to update when search results decrease
--- the number of soundpacks from multiple pages to a single page
function G.FUNCS.tnsmi_shoulder_buttons(e)
    if #TNSMI.cycle_config.options > 1 then
        e.config.colour = G.C.RED
        e.config.hover = true
        e.config.shadow = true
        e.config.button = 'option_cycle'
        e.children[1].config.colour = G.C.UI.TEXT_LIGHT
    else
        e.config.colour = G.C.BLACK
        e.config.hover = nil
        e.config.shadow = nil
        e.config.button = nil
        e.children[1].config.colour = G.C.UI.TEXT_INACTIVE
    end
end

--- Reloads soundpack cards in existing cardareas based on current page and search query
G.FUNCS.tnsmi_reload_soundpack_cards = function()
    -- removes any existing cards and highlights
    -- slightly unperformant, but better than recreating it
    for i = #TNSMI.cardareas, 1, -1 do
        if #TNSMI.cardareas[i].cards > 0 then
            remove_all(TNSMI.cardareas[i].cards)
        end
        TNSMI.cardareas[i].highlighted = {}
    end

    -- Mark already loaded packs to not be shown as "available"
    local loaded_map = {}
    for _, v in ipairs(TNSMI.config.loaded_packs) do
        loaded_map[v] = true
    end

    local num_per_page = TNSMI.config.cols * TNSMI.config.rows
    local start_index = num_per_page * (TNSMI.cycle_config.current_option - 1)

    -- filtering for the current text input and selected packs
    local soundpack_cards = {}
    for i, v in ipairs(TNSMI.SoundPack.obj_buffer) do
        if not loaded_map[v] and (TNSMI.prompt_text_input == ''
        or string.find(string.lower(localize{type = 'name_text', key = v, set = 'SoundPack'}), string.lower(TNSMI.prompt_text_input))) then
            soundpack_cards[#soundpack_cards+1] = v
        end
    end

    -- if it would result in too many pages, go to the last page
    if #soundpack_cards < start_index then
        start_index = num_per_page * (TNSMI.cycle_config.current_option - 1)
    end

    -- update the search text, a "1-10 of 50 results" type thing
    TNSMI.search_text = localize{type = 'variable', key = 'tnsmi_search_text', vars = {
        #soundpack_cards > 0 and start_index + 1 or 0,
        math.min((start_index + num_per_page), #soundpack_cards),
        #soundpack_cards
    }}

    if #soundpack_cards < 1 then
        TNSMI.cycle_config.options = {localize('k_page')..' 1/1'}
        TNSMI.cycle_config.current_option = 1
        TNSMI.cycle_config.current_option_val = TNSMI.cycle_config.options[TNSMI.cycle_config.current_option]
        G.OVERLAY_MENU:recalculate()
        return
    end

    local num_options = math.ceil(#soundpack_cards/num_per_page)
    local options = {}
    for i=1, num_options do
        options[i] = localize('k_page')..' '..tostring(i)..'/'..tostring(num_options)
    end

    TNSMI.cycle_config.options = options
    TNSMI.cycle_config.current_option = math.min(TNSMI.cycle_config.current_option, num_options)
    TNSMI.cycle_config.current_option_val = TNSMI.cycle_config.options[TNSMI.cycle_config.current_option]

    local end_index = math.min(start_index + num_per_page, #soundpack_cards)
    local page_total = math.min(start_index + num_per_page, #soundpack_cards) - start_index
    local final_cols = page_total % TNSMI.config.cols
    final_cols = final_cols ~= 0 and final_cols or TNSMI.config.cols

    -- adjusts the size of the cardareas based on the current size mod, determined by the rows/cols
    -- makes it easier to fit more into frame
    TNSMI.cardareas[#TNSMI.cardareas].T.w = G.CARD_W * final_cols * TNSMI.get_size_mod() * 1.1

    for i=(start_index+1), end_index do
        local pack = TNSMI.SoundPacks[soundpack_cards[i]]
        local area_idx = math.floor((i - start_index - 1)/TNSMI.config.cols) + 1
        tnsmi_create_soundpack_card(TNSMI.cardareas[area_idx], pack)
    end

    G.OVERLAY_MENU:recalculate()
end

--- Callback for toggling a soundpack with a button
G.FUNCS.tnsmi_toggle_soundpack = function(e)
    local card = e.config.ref_table
    local key = card.params.tnsmi_soundpack
    local is_priority = card.area and card.area == TNSMI.cardareas.priority

    if is_priority then -- Disable pack
        for i = #TNSMI.config.loaded_packs, 1, -1 do
            if TNSMI.config.loaded_packs[i] == key then
                card:start_dissolve(nil, nil, 0.25)
                table.remove(TNSMI.config.loaded_packs, i)
                break
            end
        end
        TNSMI.dissolve_flag = key
    else
        for _, pack_area in ipairs(TNSMI.cardareas) do
            for _, pack_card in ipairs(pack_area.cards) do
                if pack_card.params.tnsmi_soundpack == key then
                    pack_card:start_dissolve(nil, nil, 0.25)
                    break
                end
            end
        end

        TNSMI.dissolve_flag = key
        tnsmi_create_soundpack_card(TNSMI.cardareas.priority, TNSMI.SoundPacks[key])
        table.insert(TNSMI.config.loaded_packs, key)
    end

    -- This delay is to account for the dissolve flag causing the recreated card to be delayed
    -- since reload/save are based on cards in the current areas
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.25,
        blocking = false,
        blockable = false,
        func = (function()
            G.FUNCS.tnsmi_reload_soundpack_cards()
            TNSMI.save_soundpacks()
            return true
        end)
    }))
end