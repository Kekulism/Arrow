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
    local card = e.config.ref_table

    local ret = ref_buy_shop(e)
    if ret ~= false then
        G.GAME.shop_dollars_spent = G.GAME.shop_dollars_spent + card.cost
        if card and card:is(Card) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if card.ability.consumeable then
                        if card.config.center.set == 'Stand' then
                            inc_career_stat('c_stands_bought', 1)
                        elseif card.config.center.set == 'VHS' then
                            inc_career_stat('c_vhss_bought', 1)
                        end
                    end
                    return true
                end
            }))
        end
    end
end

local ref_reroll_shop = G.FUNCS.reroll_shop
G.FUNCS.reroll_shop = function(e)
    G.GAME.rerolls_this_round = G.GAME.rerolls_this_round + 1
    return ref_reroll_shop(e)
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

    TNSMI.config.rows = math.max(1, math.min(3, TNSMI.config.rows))
    TNSMI.config.cols =  math.max(1, math.min(8, TNSMI.config.cols))

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
    local final_cols = page_total > TNSMI.config.cols and page_total % TNSMI.config.cols or page_total
    if final_cols == 0 then final_cols = TNSMI.config.cols end

    -- adjusts the size of the cardareas based on the current size mod, determined by the rows/cols
    -- makes it easier to fit more into frame
    TNSMI.cardareas[#TNSMI.cardareas].T.w = G.CARD_W * final_cols * 0.965

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





---------------------------
--------------------------- Palette widget callbacks
---------------------------

local function update_hex_input(color)
    local new_hex_string = string.upper(tostring(string.format("%02x", color[1])..string.format("%02x", color[2])..string.format("%02x", color[3])))
    ArrowAPI.palette_ui_config.last_hex_input = ArrowAPI.palette_ui_config.hex_input
    ArrowAPI.palette_ui_config.hex_input = new_hex_string
    local args = ArrowAPI.palette_ui_config.hex_input_config

    for i = 1, args.max_length do
        local new_letter = new_hex_string:sub(i, i)
        args.text.letters[i] = new_letter
    end
end

local function set_new_ui_palette(set, color_idx, grad_idx)
    if ArrowAPI.palette_ui_config.open_palette.idx ~= color_idx then
        G.OVERLAY_MENU:get_UIE_by_ID('arrow_palette_button_'..ArrowAPI.palette_ui_config.open_palette.idx).parent.config.colour = G.C.UI.TEXT_LIGHT
        G.OVERLAY_MENU:get_UIE_by_ID('arrow_palette_button_'..color_idx).parent.config.colour = G.C.FILTER
    end

    ArrowAPI.palette_ui_config.open_palette.idx = color_idx
    ArrowAPI.palette_ui_config.open_palette.grad_idx = grad_idx

    local current_palette = ArrowAPI.colors.palettes[set].current_palette
    local color = current_palette[color_idx]

    -- set this color's new grad points
    local size = #color.grad_pos
    local grad_points = ArrowAPI.palette_ui_config.grad_widget_config.grad_points
    grad_points.selected = nil
    for i=1, grad_points.max_points do
        if i <= size then
            local start_idx = (i-1) * 3
            grad_points[i] = {pos = color.grad_pos[i], color = {color[start_idx+1], color[start_idx+2], color[start_idx+3]}}
        else
            grad_points[i] = nil
        end
    end

    local start_idx = (grad_idx - 1) * 3
    ArrowAPI.palette_ui_config.rgb[1] = color[start_idx + 1]
    ArrowAPI.palette_ui_config.rgb[2] = color[start_idx + 2]
    ArrowAPI.palette_ui_config.rgb[3] = color[start_idx + 3]

    update_hex_input(ArrowAPI.palette_ui_config.rgb)

    G.OVERLAY_MENU:get_UIE_by_ID('arrow_grad_widget_box').config.grad_colour = color

    -- calls updates to the sliders rather than interpreting their new values
    G.FUNCS.arrow_rgb_slider(G.OVERLAY_MENU:get_UIE_by_ID('r_slider'), true)
    G.FUNCS.arrow_rgb_slider(G.OVERLAY_MENU:get_UIE_by_ID('g_slider'), true)
    G.FUNCS.arrow_rgb_slider(G.OVERLAY_MENU:get_UIE_by_ID('b_slider'), true)
end

--- Insta func to immediately update and set RGB sliders upon creation
function G.FUNCS.arrow_rgb_slider_insta(e)
    G.FUNCS.arrow_rgb_slider(e, true)
end

function G.FUNCS.arrow_rgb_slider(e, update_only)
    -- this is to set the value of these sliders immediately after creation as an insta_func
    e.states.drag.can = true -- parent
    if update_only or G.CONTROLLER.dragging.target == e then
        local fill = e.children[1].children[1]
        local base = e.children[1]

        local rt = base.config.ref_table

        if not update_only and not rt.last_dragged then
            play_sound('cardSlide1', 1 + math.random() * 0.1, 0.6)
            rt.last_dragged = true
        end

        if not update_only then
            local old = rt.ref_table[rt.ref_value]
            local new = math.floor(math.min(rt.max,math.max(rt.min, rt.min + (rt.max - rt.min)*(G.CURSOR.T.x - e.parent.T.x - G.ROOM.T.x)/e.T.w)))
            if new ==  rt.ref_table[rt.ref_value] then return end
            rt.ref_table[rt.ref_value] = new

            if old == rt.ref_table[rt.ref_value] then return end
            ArrowAPI.palette_changed_flag = true


            release_text_input()
            local new_text = string.format("%.3u", rt.ref_table[rt.ref_value])
            local text = e.parent.parent.children[3].config.ref_table.text
            for i=1, 3 do
                text.letters[i] = i <= #new_text and new_text:sub(i, i) or ''
            end
        end

        fill.T.w = (rt.ref_table[rt.ref_value] - rt.min)/(rt.max - rt.min)*base.T.w
        fill.VT.w = fill.T.w
        fill.config.w = fill.T.w
    else
        e.children[1].config.ref_table.last_dragged = nil
    end
end

G.FUNCS.arrow_select_text_input = function(e)
    G.CONTROLLER.text_input_hook = e
    G.CONTROLLER.text_input_id = e.config.id

    --Start by setting the cursor position to the correct location
    TRANSPOSE_TEXT_INPUT(0)
    local args = e.config.ref_table
    sendDebugMessage('position on select: '..tostring(args.text.current_position))

    e.UIBox:recalculate()
end

G.FUNCS.arrow_text_input = function(e)
    local args = e.config.ref_table
    if G.CONTROLLER.text_input_hook == e then
        e.config.colour = args.hooked_colour
    else
        e.config.colour = args.colour
    end

    local OSkeyboard_e = e.parent.parent.parent
    if G.CONTROLLER.text_input_hook == e and G.CONTROLLER.HID.controller then
        if not OSkeyboard_e.children.controller_keyboard then
            OSkeyboard_e.children.controller_keyboard = UIBox{
            definition = create_keyboard_input{backspace_key = true, return_key = true, space_key = false},
            config = {
                align= 'cm',
                offset = {x = 0, y = G.CONTROLLER.text_input_hook.config.ref_table.keyboard_offset or -4},
                major = e.UIBox, parent = OSkeyboard_e}
            }
            G.CONTROLLER.screen_keyboard = OSkeyboard_e.children.controller_keyboard
            G.CONTROLLER:mod_cursor_context_layer(1)
        end
    elseif OSkeyboard_e.children.controller_keyboard then
        OSkeyboard_e.children.controller_keyboard:remove()
        OSkeyboard_e.children.controller_keyboard = nil
        G.CONTROLLER.screen_keyboard = nil
        G.CONTROLLER:mod_cursor_context_layer(-1)
    end
end

-- Redone text input due to a littany of changes
G.FUNCS.text_input_key = function(args)
    args = args or {}

    --shortcut to hook config
    local hook_config = G.CONTROLLER.text_input_hook.config.ref_table
    hook_config.orig_colour = hook_config.orig_colour or copy_table(hook_config.colour)

    args.key = args.key or '%'
    local hook = G.CONTROLLER.text_input_hook

    local corpus = hook_config.corpus or '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    local corpus_type = hook_config.corpus_type or 'alphanumeric'

    if corpus_type == 'alphanumeric' then
        if args.key == '[' or args.key == ']' then return end
        if args.key == '0' then args.key = 'o' end
    end

    if corpus_type == 'alphanumeric' and hook.config.ref_table.extended_corpus then
        corpus = corpus.." 0!$&()<>?:{}+-=,.[]_"
        local lower_ext = '1234567890-=;\',./'
        local upper_ext = '!@#$%^&*()_+:"<>?'
        if string.find(lower_ext, args.key) and args.caps then
            args.key = string.sub(string.sub(upper_ext, string.find(lower_ext, args.key)), 0, 1)
        end
    end

    local text = hook_config.text

    --Some special keys need to be mapped accordingly before passing through the corpus
    local keymap = {
      space = ' ',
      backspace = 'BACKSPACE',
      delete = 'DELETE',
      ['return'] = 'RETURN',
      right = 'RIGHT',
      left = 'LEFT'
    }

    args.caps = args.caps or G.CONTROLLER.capslock or hook_config.all_caps
    args.key = keymap[args.key] or (args.caps and string.upper(args.key) or args.key)

    local length = string.len(text.ref_table[text.ref_value])

    TRANSPOSE_TEXT_INPUT(0)
    if length > 0 and args.key == 'BACKSPACE' then
        MODIFY_TEXT_INPUT({letter = '', text_table = text, pos = text.current_position, delete = true})
        TRANSPOSE_TEXT_INPUT(-1)
        sendDebugMessage('current position: '..text.current_position)
    elseif length > 0 and args.key == 'DELETE' then --if not at end, remove following letter
        MODIFY_TEXT_INPUT({letter = '', text_table = text, pos = text.current_position+1,delete = true})
        TRANSPOSE_TEXT_INPUT(0)
        sendDebugMessage('current position: '..text.current_position)
    elseif args.key == 'RETURN' then --Release the hook
        release_text_input()
        return
    elseif args.key == 'LEFT' then --Move cursor position to the left
        TRANSPOSE_TEXT_INPUT(-1)
        sendDebugMessage('current position: '..text.current_position)
    elseif args.key == 'RIGHT' then --Move cursor position to the right
        TRANSPOSE_TEXT_INPUT(1)
        sendDebugMessage('current position: '..text.current_position)
    elseif hook_config.max_length > length and (string.len(args.key) == 1) and string.find(corpus, args.key, 1, true) then --check to make sure the key is in the valid corpus, add it to the string
        MODIFY_TEXT_INPUT({letter = args.key, text_table = text, pos = text.current_position+1})
        TRANSPOSE_TEXT_INPUT(1)
        sendDebugMessage('current position: '..text.current_position)
    end
end

local ref_text_from_input = GET_TEXT_FROM_INPUT
function GET_TEXT_FROM_INPUT()
    local ret = ref_text_from_input()
    local hook_config = G.CONTROLLER.text_input_hook.config.ref_table
    if hook_config.corpus_type and hook_config.corpus_type ~= 'alphanumeric' then
        ret = tonumber(ret) or 0
    end
    return ret
end

--Helper function for G.FUNCS.text_input_key\
--Moves the cursor left or right. Typing a key, deleting or backspacing also counts\
--as a cursor move, since empty strings are used to fill the hook
--
---@param amount number
function TRANSPOSE_TEXT_INPUT(amount)
    local position_child = nil
    local hook = G.CONTROLLER.text_input_hook
    local text = G.CONTROLLER.text_input_hook.config.ref_table.text
    for i = 1, #hook.children do
        if hook.children[i].config then
            if hook.children[i].config.id == G.CONTROLLER.text_input_id..'_position' then
                position_child = i; break
            end
        end
    end

    local dir = (amount/math.abs(amount)) or 0

    while amount ~= 0 do
        if position_child + dir < 1 or position_child + dir >= #hook.children then break end
        local real_letter = hook.children[position_child+dir].config.id:sub(1, 8+string.len(G.CONTROLLER.text_input_id)) == G.CONTROLLER.text_input_id..'_letter_' and hook.children[position_child+dir].config.text ~= ''
        SWAP(hook.children, position_child, position_child + dir)
        if real_letter then amount = amount - dir end
        position_child = position_child + dir
    end

    local text_length = string.len(text.ref_table[text.ref_value])
    if hook.config.ref_table.min_length then
        sendDebugMessage('clamping min')
        text_length = math.min(text_length, hook.config.ref_table.min_length)
    end

    text.current_position = math.min(position_child-1, text_length)
    hook.UIBox:recalculate(true)
    text.ref_table[text.ref_value] = GET_TEXT_FROM_INPUT()
  end

--- Callback for the main visual display of a gradient  widget, including interacting to create/remove gradient pips
function G.FUNCS.arrow_grad_box(e)
    e.states.drag.can = true
    if (G.CONTROLLER and G.CONTROLLER.dragging.target and G.CONTROLLER.dragging.target == e) then
        local grad_points = e.config.ref_table.grad_points
        local cursor_x = (G.CURSOR.T.x - e.parent.parent.T.x - G.ROOM.T.x)/e.T.w
        local cursor_y = (G.CURSOR.T.y - e.parent.parent.T.y - G.ROOM.T.y)/e.T.h

        if cursor_y < 1.25 and cursor_x > 0 and cursor_x < 1 then
            e:stop_drag()
            e.states.drag.is = false
            G.CONTROLLER.dragging.target = nil

            if #grad_points >= grad_points.max_points then
                play_sound('cancel')
                return
            end

            -- pre-sort on insert
            local pos = #grad_points == 1 and 1 or cursor_x
            local insert = #grad_points + 1
            for i = 1, #grad_points do
                if pos < grad_points[i].pos then
                    insert = i
                    break
                end
            end

            table.insert(grad_points, insert, {pos = pos, color = {255, 255, 255}})

            -- create new grad color and set the rgb to it?
            local start_idx = (insert-1) * 3
            local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set]
            local idx = ArrowAPI.palette_ui_config.open_palette.idx

            local palette_color = palette.current_palette[idx]

            -- for the sake of UI which determines drawing depending on if palette_color[4] (alpha) is greater than 0
            -- when you only have a single color, palette_color[4] is set to a dummy 1
            -- this removes it when adding colors 4-6
            if #grad_points == 2 then
                palette_color[4] = nil
            end

            table.insert(palette_color.grad_pos, insert, pos)
            table.insert(palette_color, start_idx + 1, 255)
            table.insert(palette_color, start_idx + 1, 255)
            table.insert(palette_color, start_idx + 1, 255)

            set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, idx, insert)

            G.CONTROLLER.dragging.target = e.parent.parent.children[1]
            G.CONTROLLER.dragging.target:drag()
            return
        end
    end
end

local function color_sort(array, colors, func)
    for i = 2, #array do
		local key = array[i]
        local start_idx = (i - 1) * 3
        local color_1, color_2, color_3 = colors[start_idx+1], colors[start_idx+2], colors[start_idx+3]
		local j = i - 1

		while j > 0 and func(key, array[j]) do
			array[j + 1] = array[j]
            local current = (j - 1) * 3
            local next = j * 3
            colors[next+1] = colors[current+1]
            colors[next+2] = colors[current+2]
            colors[next+3] = colors[current+3]
			j = j - 1
		end

		array[j + 1] = key
        local new_start = j * 3
        colors[new_start+1] = color_1
        colors[new_start+2] = color_2
        colors[new_start+3] = color_3
	end

    return array
end

--- Callback for the main visual display of a gradient widget, including interacting to create/remove gradient pips
function G.FUNCS.arrow_grad_pointers(e)
    e.states.drag.can = true
    if (G.CONTROLLER and G.CONTROLLER.dragging.target and G.CONTROLLER.dragging.target == e) then
        local grad_points = e.config.grad_points
        local cursor_x = math.max(0, math.min(1, (G.CURSOR.T.x - e.parent.T.x - G.ROOM.T.x)/e.T.w))
        local cursor_y = (G.CURSOR.T.y - e.parent.T.y - G.ROOM.T.y)/e.T.h

        if cursor_x < -0.25 or cursor_x > 1.25 or cursor_y < -0.25 then
            e:stop_drag()
            e.states.drag.is = false
            G.CONTROLLER.dragging.target = nil
            grad_points.selected = nil
            for i=1, #grad_points do
                grad_points[i].selected = nil
            end
            return
        end

        if cursor_y <= 1.25 and not grad_points.selected and #grad_points > 1 then
            local hitbox_width = 0.075
            for i=1, #grad_points do
                if math.abs(cursor_x - grad_points[i].pos) <= hitbox_width then
                    grad_points.selected = i
                    grad_points[i].selected = G.TIMERS.REAL
                    play_sound('cardSlide1', 1 + math.random() * 0.1)
                    break
                end
            end

            if not grad_points.selected then
                e:stop_drag()
                e.states.drag.is = false
                G.CONTROLLER.dragging.target = nil
                return
            end
        end

        if cursor_y > 1.25 then
            -- specifically, you can't remove the last grad point if there are are more than 2, so it must be removed
            -- last to maintain the full length of the gradient
            if #grad_points > grad_points.min_points and (grad_points.selected ~= #grad_points or #grad_points == 2) then
                local grad_idx = ArrowAPI.palette_ui_config.open_palette.grad_idx


                -- create new grad color and set the rgb to it?
                local start_idx = (grad_idx - 1) * 3
                local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set]
                local idx = ArrowAPI.palette_ui_config.open_palette.idx

                local palette_color = palette.current_palette[idx]
                table.remove(palette_color.grad_pos, grad_idx)

                table.remove(palette_color, start_idx + 1)
                table.remove(palette_color, start_idx + 1)
                table.remove(palette_color, start_idx + 1)

                grad_idx = grad_idx - 1
                ArrowAPI.palette_ui_config.open_palette.grad_idx = grad_idx

                local new_start_idx = (grad_idx - 1) * 3
                ArrowAPI.palette_ui_config.rgb[1] = palette_color[new_start_idx + 1]
                ArrowAPI.palette_ui_config.rgb[2] = palette_color[new_start_idx + 2]
                ArrowAPI.palette_ui_config.rgb[3] = palette_color[new_start_idx + 3]

                -- for the sake of UI which determines drawing depending on if palette_color[4] (alpha) is greater than 0
                -- when you only have a single color, palette_color[4] is set to a dummy 1
                -- this removes it when adding colors 4-6
                if #grad_points == 2 then
                    palette_color[4] = 1

                    -- resetting the angle stuff to linear mode as default
                    local angle_config =  ArrowAPI.palette_ui_config.angle_widget_config
                    angle_config.mode = 'linear'
                    angle_config.value = 0
                    angle_config.point.x = 0
                    angle_config.point.y = 0
                    angle_config.linear_toggle = true
                    angle_config.radial_toggle = false
                    angle_config.label_1 = localize('k_label_linear')
                end

                table.remove(grad_points, grad_points.selected)
                play_sound('cardSlide2', 1.2)
            end

            e:stop_drag()
            e.states.drag.is = false
            G.CONTROLLER.dragging.target = nil
            grad_points.selected = nil
            for i=1, #grad_points do
                grad_points[i].selected = nil
            end
            return
        end

        if #grad_points < 2 or grad_points.selected == 1 or grad_points.selected == #grad_points then return end

        grad_points[grad_points.selected].pos = cursor_x

        local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set]
        local idx = ArrowAPI.palette_ui_config.open_palette.idx
        local palette_color = palette.current_palette[idx]

        palette_color.grad_pos[grad_points.selected] = cursor_x

        color_sort(grad_points, palette_color, function(a, b) return a.pos < b.pos end)
        for i = 1, #grad_points do
            palette_color.grad_pos[i] = grad_points[i].pos
        end

        for i=1, #grad_points do
            if grad_points[i].selected then
                grad_points.selected = i
                break
            end
        end
    elseif e.config.grad_points.selected then
        local grad_points = e.config.grad_points
        grad_points.selected = nil
        for i=1, #grad_points do
            if grad_points[i].selected and G.TIMERS.REAL - grad_points[i].selected < 0.28 then
                -- palette button basically
                set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, ArrowAPI.palette_ui_config.open_palette.idx, i)
            end
            grad_points[i].selected = nil
        end
    end
end


--- Callback for the main visual display of a gradient widget, including interacting to create/remove gradient pips
function G.FUNCS.arrow_angle_widget(e)
    e.states.drag.can = #ArrowAPI.palette_ui_config.grad_widget_config.grad_points > 1
    if (G.CONTROLLER and G.CONTROLLER.dragging.target and G.CONTROLLER.dragging.target == e) then
        local config = e.config.ref_table
        local mode = e.config.ref_table.mode
        local cursor_x = math.max(0, math.min(1, (G.CURSOR.T.x - e.parent.T.x - G.ROOM.T.x)/e.T.w))
        local cursor_y = (G.CURSOR.T.y - e.parent.T.y - G.ROOM.T.y)/e.T.h

        -- just generally outside the box compared to the grad points
        if cursor_x < -0.25 or cursor_x > 1.25 or cursor_y < -0.25 or cursor_y > 1.25 then
            e:stop_drag()
            e.states.drag.is = false
            G.CONTROLLER.dragging.target = nil
            config.dragging = nil
            return
        end

        if not config.dragging then
            if mode == 'linear' then
                config.dragging = true
            else
                local hitbox_width = 0.16
                -- for linear mode, we only check the first point, as the second is always static
                local adjusted_x = config.point.x / 2 + 0.5
                local adjusted_y = config.point.y / -2 + 0.5

                if math.abs(cursor_x - adjusted_x) <= hitbox_width and math.abs(cursor_y - adjusted_y) <= hitbox_width then
                    config.dragging = true
                    play_sound('cardSlide1', 1 + math.random() * 0.1)
                else
                    e:stop_drag()
                    e.states.drag.is = false
                    G.CONTROLLER.dragging.target = nil
                    return
                end
            end
        end

        if mode == 'linear' then
            local adjusted_x = (cursor_x - 0.5) * 2
            local adjusted_y = (cursor_y - 0.5) * -2
            local angle = math.atan2(adjusted_y, adjusted_x)
            local degree_angle = tostring(math.floor(angle < 0 and 360 + math.deg(angle) or math.deg(angle)))
            ArrowAPI.palette_ui_config.angle_widget_config.value = angle
            ArrowAPI.palette_ui_config.angle_widget_config.display_val = degree_angle

            release_text_input()
            local text = e.parent.parent.parent.children[4].children[2].children[1].children[2].config.ref_table.text
            for i=1, 4 do
                text.letters[i] = i <= #degree_angle and degree_angle:sub(i, i) or ''
            end

            config.point.x = math.cos(angle)
            config.point.y = math.sin(angle)
        else
            local adjusted_x = (cursor_x - 0.5) * 2
            local adjusted_y = (cursor_y - 0.5) * -2
            config.point.x = math.floor(math.min(1, math.max(-1, adjusted_x)) * 100) / 100
            config.point.y = math.floor(math.min(1, math.max(-1, adjusted_y)) * 100) / 100

            -- don't set the value here because it's handled separately
        end
    else
        e.config.ref_table.dragging = nil
    end
end


G.FUNCS.arrow_can_edit_gradients = function(e)
    local points = ArrowAPI.palette_ui_config.grad_widget_config.grad_points
    if #points > 1 then
        if not e.config.grad_active then
            e.config.grad_active = true

            -- enable first toggle
            e.children[1].children[1].children[1].children[1].config.colour = G.C.UI.TEXT_LIGHT
            local toggle1 = e.children[1].children[1].children[2].children[1].children[1]
            local toggle1_active = toggle1.config.toggle_active or false
            local toggle1_args = toggle1.config.ref_table
            toggle1.config.outline_colour = G.C.WHITE
            toggle1.config.button = 'toggle_button'
            toggle1.config.hover = true
            toggle1.config.colour = toggle1_active and G.C.RED or G.C.BLACK
            toggle1_args.active_colour = G.C.RED
            toggle1_args.inactive_colour = G.C.BLACK
            toggle1.children[1].states.visible = toggle1_active
            toggle1.children[1].config.object.states.visible = toggle1_active

            -- enable second toggle
            e.children[1].children[2].children[1].children[1].config.colour = G.C.UI.TEXT_LIGHT
            local toggle2 = e.children[1].children[2].children[2].children[1].children[1]
            local toggle2_active = toggle2.config.toggle_active or false
            local toggle2_args = toggle2.config.ref_table
            toggle2.config.outline_colour = G.C.WHITE
            toggle2.config.button = 'toggle_button'
            toggle2.config.hover = 'true'
            toggle2.config.colour = toggle2_active and G.C.RED or G.C.BLACK
            toggle2_args.active_colour = G.C.RED
            toggle2_args.inactive_colour = G.C.BLACK
            toggle2.children[1].states.visible = toggle2_active
            toggle2.children[1].config.object.states.visible = toggle2_active

            local value_node = e.children[2].children[1]
            value_node.config.colour = G.C.UI.TEXT_LIGHT
            value_node.children[1].children[1].config.colour = G.C.UI.TEXT_INACTIVE

            -- this needs to change the
            local text_colour = value_node.children[2].config.ref_table.text_colour
            text_colour[1] = G.C.UI.TEXT_DARK[1]
            text_colour[2] = G.C.UI.TEXT_DARK[2]
            text_colour[3] = G.C.UI.TEXT_DARK[3]
            text_colour[4] = G.C.UI.TEXT_DARK[4]
            return
        end

        local center_node = e.children[2].children[3]
        if ArrowAPI.palette_ui_config.angle_widget_config.mode == 'radial' and not center_node.config.radial_active then
            center_node.config.radial_active = true
            center_node.config.colour = G.C.UI.TEXT_LIGHT

            center_node.children[1].children[1].config.colour = G.C.UI.TEXT_INACTIVE
            local x_node = center_node.children[2].children[1]
            x_node.config.colour = G.C.UI.TEXT_DARK
            x_node.config.ref_table = ArrowAPI.palette_ui_config.angle_widget_config.point
            x_node.config.ref_value = 'x'
            x_node.config.text = nil

            center_node.children[2].children[2].config.colour = G.C.UI.TEXT_DARK

            local y_node = center_node.children[2].children[3]
            y_node.config.colour = G.C.UI.TEXT_DARK
            y_node.config.ref_table = ArrowAPI.palette_ui_config.angle_widget_config.point
            y_node.config.ref_value = 'y'
            y_node.config.text = nil
        elseif ArrowAPI.palette_ui_config.angle_widget_config.mode == 'linear' and center_node.config.radial_active then
            center_node.config.radial_active = nil
            center_node.config.colour = G.C.UI.TEXT_INACTIVE
            center_node.children[1].children[1].config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.3)

            local x_node = center_node.children[2].children[1]
            x_node.config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.5)
            x_node.config.ref_table = nil
            x_node.config.ref_value = nil
            x_node.config.text = '0'

            center_node.children[2].children[2].config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.5)

            local y_node = center_node.children[2].children[3]
            y_node.config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.5)
            y_node.config.ref_table = nil
            y_node.config.ref_value = nil
            y_node.config.text = '0'
        end
    elseif #points <= 1 and e.config.grad_active then
        e.config.grad_active = nil

        -- disable first toggle
        e.children[1].children[1].children[1].children[1].config.colour = G.C.UI.TEXT_INACTIVE
        local toggle1 = e.children[1].children[1].children[2].children[1].children[1]
        local toggle1_args = toggle1.config.ref_table
        toggle1.config.outline_colour = lighten(G.C.UI.TEXT_INACTIVE, 0.3)
        toggle1.config.button = nil
        toggle1.config.hover = nil
        toggle1.config.colour = G.C.UI.TEXT_INACTIVE
        toggle1_args.active_colour = G.C.UI.TEXT_INACTIVE
        toggle1_args.inactive_colour = darken(G.C.UI.TEXT_INACTIVE, 0.3)
        toggle1.children[1].states.visible = false
        toggle1.children[1].config.object.states.visible = false

        -- dissable second toggle
        e.children[1].children[2].children[1].children[1].config.colour = G.C.UI.TEXT_INACTIVE
        local toggle2 = e.children[1].children[2].children[2].children[1].children[1]
        local toggle2_args = toggle2.config.ref_table
        toggle2.config.outline_colour = lighten(G.C.UI.TEXT_INACTIVE, 0.3)
        toggle2.config.button = nil
        toggle2.config.hover = nil
        toggle2.config.colour = G.C.UI.TEXT_INACTIVE
        toggle2_args.active_colour = G.C.UI.TEXT_INACTIVE
        toggle2_args.inactive_colour = darken(G.C.UI.TEXT_INACTIVE, 0.3)
        toggle2.children[1].states.visible = false
        toggle2.children[1].config.object.states.visible = false

        local value_node = e.children[2].children[1]
        value_node.config.colour = G.C.UI.TEXT_INACTIVE
        value_node.children[1].children[1].config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.3)

        local new_colour = darken(G.C.UI.TEXT_INACTIVE, 0.5)
        local val_config = value_node.children[2].config.ref_table
        local text_colour = val_config.text_colour
        text_colour[1] = new_colour[1]
        text_colour[2] = new_colour[2]
        text_colour[3] = new_colour[3]
        text_colour[4] = new_colour[4]

        local center_node = e.children[2].children[3]
        center_node.config.colour = G.C.UI.TEXT_INACTIVE
        center_node.children[1].children[1].config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.3)

        local x_node = center_node.children[2].children[1]
        x_node.config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.5)
        x_node.config.ref_table = nil
        x_node.config.ref_value = nil
        x_node.config.text = '0'

        -- comma
        center_node.children[2].children[2].config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.5)

        local y_node = center_node.children[2].children[3]
        y_node.config.colour = darken(G.C.UI.TEXT_INACTIVE, 0.5)
        y_node.config.ref_table = nil
        y_node.config.ref_value = nil
        y_node.config.text = '0'
    end
end

function G.FUNCS.arrow_palette_button(e)
    -- grad idx is assumed to be 1 for non-gradient colors
    set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, e.config.palette_idx, 1)
end

function G.FUNCS.arrow_palette_reset(e)
    local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set]
    local idx = e.config.palette_idx

    -- reset the default color
    local default_color = palette.default_palette[idx]
    local palette_color = palette.current_palette[idx]

    for i = 1, math.max(#default_color, #palette_color) do
        palette_color[i] = default_color[i] or nil
    end

    for i = 1, math.max(#default_color.grad_pos, #palette_color.grad_pos) do
        palette_color.grad_pos[i] = default_color.grad_pos[i] or nil
    end

    local angle_config = ArrowAPI.palette_ui_config.angle_widget_config
    palette_color.grad_config.mode = default_color.grad_config.mode
    palette_color.grad_config.val = default_color.grad_config.val
    palette_color.grad_config.pos[1] = default_color.grad_config.pos[1]
    palette_color.grad_config.pos[2] = default_color.grad_config.pos[1]

    angle_config.mode = default_color.grad_config.mode
    angle_config.value = default_color.grad_config.val

    if angle_config.mode == 'linear' then
        local angle = default_color.grad_config.val
        angle_config.display_val = tostring(math.floor(angle < 0 and 360 + math.deg(angle) or math.deg(angle)))
        angle_config.point.x = math.cos(angle)
        angle_config.point.y = math.sin(angle)
    else
        -- TODO // this loses information from the save, so the first point wont accurately reflect the radius
        angle_config.display_val = tostring(angle_config.value)
        angle_config.point.x = palette_color.grad_config.pos[1]
        angle_config.point.y = palette_color.grad_config.pos[2]
    end

    --- you can reset colors that aren't focused, just don't change the UI
    if ArrowAPI.palette_ui_config.open_palette.idx == e.config.palette_idx then
        set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, idx, 1)
    end
end

function G.FUNCS.arrow_update_selected_colour(e)
    local rgb = ArrowAPI.palette_ui_config.rgb
    e.config.colour = {rgb[1]/255, rgb[2]/255, rgb[3]/255, 1}

    if not ArrowAPI.palette_changed_flag then return end

    -- update the grad point color for visual drawing
    local grad_points = ArrowAPI.palette_ui_config.grad_widget_config.grad_points
    local grad_idx = ArrowAPI.palette_ui_config.open_palette.grad_idx
    grad_points[grad_idx].color = {rgb[1], rgb[2], rgb[3]}

    local set = ArrowAPI.palette_ui_config.open_palette.set
    local palette = ArrowAPI.colors.palettes[set]
    local idx = ArrowAPI.palette_ui_config.open_palette.idx
    local current_color = palette.current_palette[idx]

    local start_idx = (grad_idx - 1) * 3
    current_color[start_idx + 1] = rgb[1]
    current_color[start_idx + 2] = rgb[2]
    current_color[start_idx + 3] = rgb[3]

    update_hex_input(current_color)

    ArrowAPI.palette_changed_flag = nil
    local tab_contents = G.OVERLAY_MENU:get_UIE_by_ID('tab_contents')
    tab_contents.UIBox:recalculate()
end

function G.FUNCS.arrow_apply_palette(e)
    local palette_color = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set].current_palette[ArrowAPI.palette_ui_config.open_palette.idx]

    local grad_points = ArrowAPI.palette_ui_config.grad_widget_config.grad_points
    local grad_pos = {}
    for k = 1, #grad_points do
        grad_pos[k] = grad_points[k].pos
    end
    palette_color.grad_pos = grad_pos

    local angle_config = ArrowAPI.palette_ui_config.angle_widget_config
    palette_color.grad_config.mode = angle_config.mode
    palette_color.grad_config.val = angle_config.value

    if angle_config.mode == 'linear' then
        palette_color.grad_config.pos[1] = 0
        palette_color.grad_config.pos[2] = 0
    else
        palette_color.grad_config.pos[1] = angle_config.point.x
        palette_color.grad_config.pos[2] = angle_config.point.y
    end

    ArrowAPI.colors.use_custom_palette(ArrowAPI.palette_ui_config.open_palette.set)
end

function G.FUNCS.arrow_copy_palette(e)
    local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set].current_palette
    local serialized = serialize(palette)

    love.system.setClipboardText(serialized)
    print('Copied to clipboard')
end

function G.FUNCS.arrow_can_save_palette(e)
    local set = ArrowAPI.palette_ui_config.open_palette.set
    local palette = ArrowAPI.colors.palettes[set]
    local valid_save = #ArrowAPI.config.saved_palettes[set] <= 15
    if valid_save and ArrowAPI.palette_ui_config.name_input ~= palette.current_palette.name then
        for i=1, #ArrowAPI.config.saved_palettes[set] do
            if ArrowAPI.palette_ui_config.name_input == ArrowAPI.config.saved_palettes[set][i].name then
                valid_save = false
                break
            end
        end
    end

    if not valid_save then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.BLUE
        e.config.button = 'arrow_save_palette'
    end
end

function G.FUNCS.arrow_save_palette(e)
    -- enable this palette first
    local set = ArrowAPI.palette_ui_config.open_palette.set
    ArrowAPI.colors.use_custom_palette(set)

    local palette = ArrowAPI.colors.palettes[set]
    if ArrowAPI.palette_ui_config.name_input == palette.current_palette.name then
        -- just save
        for i, v in ipairs(ArrowAPI.config.saved_palettes[set]) do
            if v.name == palette.current_palette.name then
                for j, color in ipairs(palette.current_palette) do
                    local default = palette.default_palette[j]
                    local palette_table = {key = default.key, grad_pos = copy_table(color.grad_pos), grad_config = copy_table(color.grad_config)}
                    for k, channel in ipairs(color) do
                        palette_table[k] = channel
                    end
                    if not palette_table[4] then palette_table[4] = 1 end
                    ArrowAPI.config.saved_palettes[set][i][j] = palette_table
                end

                SMODS.save_mod_config(ArrowAPI)
                return
            end
        end

        return
    end

    local new_idx = #ArrowAPI.config.saved_palettes[set]+1
    local save_palette = {name = ArrowAPI.palette_ui_config.name_input}

    for i = 1, #palette.current_palette do
        local current_color = palette.current_palette[i]
        local palette_table = {key = current_color.key, grad_pos = copy_table(current_color.grad_pos), grad_config = copy_table(current_color.grad_config)}
        for j = 1, #current_color do
            palette_table[j] = current_color[j]
        end
        if not palette_table[4] then palette_table[4] = 1 end
        save_palette[i] = palette_table
    end

    palette.last_palette = copy_table(save_palette)
    palette.current_palette = save_palette
    ArrowAPI.config.saved_palettes[set][new_idx] = save_palette
    ArrowAPI.config.saved_palettes[set].saved_index = new_idx
    SMODS.save_mod_config(ArrowAPI)

    local tab_config = ArrowAPI.palette_ui_config.tabs_config
    local tab_contents = G.OVERLAY_MENU:get_UIE_by_ID('tab_contents')
    tab_contents.config.object:remove()
    tab_contents.config.object = UIBox{
        definition = tab_config.current.v.tab_definition_function(tab_config.current.v.tab_definition_function_args),
        config = {offset = {x=0,y=0}, parent = tab_contents, type = 'cm'}
    }
    tab_contents.UIBox:recalculate()
end

function G.FUNCS.arrow_delete_palette(e)
    -- enable this palette first
    local set = ArrowAPI.palette_ui_config.open_palette.set
    local idx = ArrowAPI.config.saved_palettes[set].saved_index
    table.remove(ArrowAPI.config.saved_palettes[set], idx)

    ArrowAPI.colors.use_custom_palette(set, idx - 1)

    -- kinda have to recreate it
    local tab_config = ArrowAPI.palette_ui_config.tabs_config
    local tab_contents = G.OVERLAY_MENU:get_UIE_by_ID('tab_contents')
    ArrowAPI.palette_ui_config.open_palette.grad_idx = 1
    tab_contents.config.object:remove()
    tab_contents.config.object = UIBox{
        definition = tab_config.current.v.tab_definition_function(tab_config.current.v.tab_definition_function_args),
        config = {offset = {x=0,y=0}, parent = tab_contents, type = 'cm'}
    }
    tab_contents.UIBox:recalculate()

    G.OVERLAY_MENU:recalculate()
end

function G.FUNCS.arrow_can_delete_palette(e)
    local set = ArrowAPI.palette_ui_config.open_palette.set
    if ArrowAPI.colors.palettes[set].current_palette.default then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'arrow_delete_palette'
    end
end

function G.FUNCS.arrow_load_palette_preset(args)
    local set = ArrowAPI.palette_ui_config.open_palette.set
    ArrowAPI.config.saved_palettes[set].saved_index = args.cycle_config.current_option
    ArrowAPI.palette_ui_config.name_input = ArrowAPI.config.saved_palettes[set][args.cycle_config.current_option].name

    -- kinda have to recreate it
    local tab_config = ArrowAPI.palette_ui_config.tabs_config
    local tab_contents = G.OVERLAY_MENU:get_UIE_by_ID('tab_contents')
    tab_contents.config.object:remove()
    tab_contents.config.object = UIBox{
        definition = tab_config.current.v.tab_definition_function(tab_config.current.v.tab_definition_function_args),
        config = {offset = {x=0,y=0}, parent = tab_contents, type = 'cm'}
    }
    tab_contents.UIBox:recalculate()
end

-- evil overwrite
G.FUNCS.change_tab = function(e)
    if not e then return end
    local _infotip_object = G.OVERLAY_MENU:get_UIE_by_ID('overlay_menu_infotip')
    if _infotip_object and _infotip_object.config.object then
        _infotip_object.config.object:remove()
        _infotip_object.config.object = Moveable()
    end

    local tab_contents = e.UIBox:get_UIE_by_ID('tab_contents')
    tab_contents.config.object:remove()

    local def = e.config.ref_table.tab_definition_function(e.config.ref_table.tab_definition_function_args)
    if not def then return end

    tab_contents.config.object = UIBox{
        definition = def,
        config = {offset = {x=0,y=0}, parent = tab_contents, type = 'cm'}
        }
    tab_contents.UIBox:recalculate()
end

-- TODO rework refresh contrast mode to use palette settings
G.FUNCS.refresh_contrast_mode = function()
    local new_colour_proto = G.C["SO_"..(G.SETTINGS.colourblind_option and 2 or 1)]
    sendDebugMessage('[ArrowAPI] refreshing contrast colors')
    G.C.SUITS.Hearts = new_colour_proto.Hearts
    G.C.SUITS.Diamonds = new_colour_proto.Diamonds
    G.C.SUITS.Spades = new_colour_proto.Spades
    G.C.SUITS.Clubs = new_colour_proto.Clubs
    for k, v in pairs(G.I.CARD) do
        if v.config and v.config.card and v.children.front and v.ability.effect ~= 'Stone Card' then
            v:set_sprites(nil, v.config.card)
        end
    end
end