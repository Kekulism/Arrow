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
    --[[
    local new_hex_string = string.upper(tostring(string.format("%02x", color[1])..string.format("%02x", color[2])..string.format("%02x", color[3])))
    ArrowAPI.palette_ui_config.last_hex_input = ArrowAPI.palette_ui_config.hex_input
    ArrowAPI.palette_ui_config.hex_input = new_hex_string
    local args = ArrowAPI.palette_ui_config.hex_input_config

    for i = 1, args.max_length do
        local new_letter = new_hex_string:sub(i, i)
        args.text.letters[i] = new_letter
    end
    --]]
end

local function set_new_ui_palette(set, color_idx, grad_idx)
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
    local fill = e.children[1].children[1]
    local base = e.children[1]
    e.states.drag.can = true -- parent

    if update_only or (G.CONTROLLER and G.CONTROLLER.dragging.target and G.CONTROLLER.dragging.target == e) then
        local rt = base.config.ref_table
        if not update_only then
            rt.ref_table[rt.ref_value] = math.floor(math.min(rt.max,math.max(rt.min, rt.min + (rt.max - rt.min)*(G.CURSOR.T.x - e.parent.T.x - G.ROOM.T.x)/e.T.w)))
            ArrowAPI.palette_changed_flag = true
        end
        rt.text = string.format("%.0f", rt.ref_table[rt.ref_value])
        fill.T.w = (rt.ref_table[rt.ref_value] - rt.min)/(rt.max - rt.min)*base.T.w
        fill.config.w = fill.T.w
    end
end

--- Callback for the main visual display of a gradient widget, including interacting to create/remove gradient pips
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

            sendDebugMessage('adding new palette colors for index: '..idx)

            table.insert(palette_color.grad_pos, insert, pos)
            table.insert(palette_color, start_idx + 1, 255)
            table.insert(palette_color, start_idx + 1, 255)
            table.insert(palette_color, start_idx + 1, 255)


            sendDebugMessage('num colors: '..#palette_color)

            set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, idx, insert)

            G.CONTROLLER.dragging.target = e.parent.parent.children[1]
            G.CONTROLLER.dragging.target:drag()
            return
        end
    end
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
                    ArrowAPI.palette_ui_config.open_palette.grad_idx = i
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
            if #grad_points > grad_points.min_points then
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
        sendDebugMessage('adding gradient to color at index: '..idx)
        local palette_color = palette.current_palette[idx]

        palette_color.grad_pos[grad_points.selected] = cursor_x

        table.sort(grad_points, function(a, b) return a.pos < b.pos end)
        table.sort(palette_color.grad_pos, function(a, b) return a < b end)

        for i=1, #grad_points do
            if grad_points[i].selected then
                grad_points.selected = i
                ArrowAPI.palette_ui_config.open_palette.grad_idx = i
                break
            end
        end
    elseif e.config.grad_points.selected then
        local grad_points = e.config.grad_points
        grad_points.selected = nil
        for i=1, #grad_points do
            if grad_points[i].selected and G.TIMERS.REAL - grad_points[i].selected < 0.2 then
                -- palette button basically
                set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, ArrowAPI.palette_ui_config.open_palette.idx, i)
            end
            grad_points[i].selected = nil
        end
    end
end


--- Callback for the main visual display of a gradient widget, including interacting to create/remove gradient pips
function G.FUNCS.arrow_angle_widget(e)
    --[[
    e.states.drag.can = true
    if (G.CONTROLLER and G.CONTROLLER.dragging.target and G.CONTROLLER.dragging.target == e) then
        local points = e.config.ref_table.points
        local mode = e.config.ref_table.mode
        local cursor_x = math.max(0, math.min(1, (G.CURSOR.T.x - e.parent.T.x - G.ROOM.T.x)/e.T.w))
        local cursor_y = (G.CURSOR.T.y - e.parent.T.y - G.ROOM.T.y)/e.T.h
        if cursor_x < -0.25 or cursor_x > 1.25 or cursor_y < -0.25 or cursor_y > 1.25 then
            e:stop_drag()
            e.states.drag.is = false
            G.CONTROLLER.dragging.target = nil
            points.selected = nil
            for i=1, #points do
                points[i].selected = nil
            end

            return
        end

        if cursor_y <= 1.25 and not points.selected then
            local hitbox_width = 0.075
            for i=1, #points - (mode == 'linear' and 1 or 0) do
                if math.abs(cursor_x - points[i].x) <= hitbox_width and math.abs(cursor_y - points[i].y) <= hitbox_width then
                    points.selected = i
                    points[i].selected = G.TIMERS.REAL
                    play_sound('cardSlide1', 1 + math.random() * 0.1)
                    break
                end
            end

            if not points.selected then
                e:stop_drag()
                e.states.drag.is = false
                G.CONTROLLER.dragging.target = nil
                return
            end
        end

        points[points.selected].x = cursor_x
        points[points.selected].y = cursor_x

        local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set]
        local idx = ArrowAPI.palette_ui_config.open_palette.idx
        local palette_color = idx == 0 and palette.current_palette.badge_colour or palette.current_palette[idx]
        local config = palette_color.grad_config

        if mode == 'linear' then
            config.value = math.atan(points[1].y)
        end

        palette_color.grad_pos[points.selected] = cursor_x

        table.sort(points, function(a, b) return a.pos < b.pos end)
        table.sort(palette_color.grad_pos, function(a, b) return a < b end)

        for i=1, #points do
            if points[i].selected then
                points.selected = i
                ArrowAPI.palette_ui_config.open_palette.grad_idx = i
                break
            end
        end
    elseif e.config.points.selected then
        local points = e.config.points
        points.selected = nil
        for i=1, #points do
            points[i].selected = nil
        end
    end
    --]]
end

function G.FUNCS.arrow_palette_button(e)
    -- grad idx is assumed to be 1 for non-gradient colors
    set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, e.config.palette_idx, 1)
end

function G.FUNCS.arrow_palette_reset(e)
    if ArrowAPI.palette_ui_config.open_palette.idx ~= e.config.palette_idx then
        return
    end
    local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set]
    local idx = e.config.palette_idx

    -- reset the default color
    local default_color = palette.default_palette[idx]
    local palette_color = palette.current_palette[idx]
    palette_color[1] = default_color[1]
    palette_color[2] = default_color[2]
    palette_color[3] = default_color[3]

    set_new_ui_palette(ArrowAPI.palette_ui_config.open_palette.set, idx, 1)
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
    G.OVERLAY_MENU:recalculate()
end

function G.FUNCS.arrow_apply_palette(e)
    local grad_points = ArrowAPI.palette_ui_config.grad_widget_config.grad_points
    local grad_pos = {}
    for k = 1, #grad_points do
        grad_pos[k] = grad_points[k].pos
    end

    ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set].current_palette[ArrowAPI.palette_ui_config.open_palette.idx].grad_pos = grad_pos
    ArrowAPI.colors.use_custom_palette(ArrowAPI.palette_ui_config.open_palette.set)
end

function G.FUNCS.arrow_can_save_palette(e)
    local set = ArrowAPI.palette_ui_config.open_palette.set
    local palette = ArrowAPI.colors.palettes[set]
    local valid_save = ArrowAPI.palette_ui_config.name_input ~= 'Default' or #ArrowAPI.config.saved_palettes[set] >= 12
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
                    -- TODO // save grad pos
                    local palette_table = {key = default.key, default = true, grad_pos = copy_table(color.grad_pos)}
                    for k, channel in ipairs(color) do
                        if channel ~= default[k] then
                            palette_table.default = false
                        end
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
        local palette_table = {key = current_color.key, default = current_color.default, grad_pos = copy_table(current_color.grad_pos)}
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
    if ArrowAPI.colors.palettes[set].current_palette.name == 'Default' or #ArrowAPI.config.saved_palettes[set] <= 1 then
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