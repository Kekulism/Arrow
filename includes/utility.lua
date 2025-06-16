local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

--- Searches for a value (not a key) within a table
--- @param table table Table to search for a given value
--- @param element any Value to search within the table
--- @return boolean # If the table contains at least one instance of this value
function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end


---------------------------
--------------------------- Loading/Debug Functions
---------------------------

-- Modified code from Cryptid
local function dynamic_badges(info)
    if not SMODS.config.no_mod_badges then
        local function calc_scale_fac(text)
            local size = 0.9
            local font = G.LANG.font
            local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
            local calced_text_width = 0
            -- Math reproduced from DynaText:update_text
            for _, c in utf8.chars(text) do
                local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
                        + 2.7 * 1 * G.TILESCALE * font.FONTSCALE
                calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
            end
            local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
            return scale_fac
        end
        local scale_fac = {}
        local min_scale_fac = 1
        local strings = { }
        local badge_colour = HEX('32A852')
        local text_colour = G.C.WHITE
        if info.origin then
            if type(info.origin) == 'table' then
                for i, v in ipairs(info.origin) do
                    strings[#strings + 1] = localize('ba_'..v)
                end
                badge_colour = HEX(G.arrow_badge_colours['co_'..info.origin.color]) or badge_colour
                text_colour = HEX(G.arrow_badge_colours['te_'..info.origin.color]) or text_colour
            else
                strings[#strings + 1] = localize('ba_'..info.origin)
                badge_colour = HEX(G.arrow_badge_colours['co_'..info.origin]) or badge_colour
                text_colour = HEX(G.arrow_badge_colours['te_'..info.origin]) or text_colour
            end
        elseif info.part then
            strings[#strings + 1] = localize('ba_jojo')
            if info.part == "jojo" then
                badge_colour = G.C.STAND
                text_colour = G.C.WHITE
            else
                strings[#strings + 1] = localize('ba_'..info.part)
                badge_colour = HEX(G.arrow_badge_colours['co_'..info.part]) or badge_colour
                text_colour = HEX(G.arrow_badge_colours['te_'..info.part]) or text_colour
            end
        elseif info.streamer then
            strings[#strings + 1] = localize('ba_'..info.streamer)
            badge_colour = HEX(G.arrow_badge_colours['co_'..info.streamer]) or badge_colour
            text_colour = HEX(G.arrow_badge_colours['te_'..info.streamer]) or text_colour
        end
        for i = 1, #strings do
            scale_fac[i] = calc_scale_fac(strings[i])
            min_scale_fac = math.min(min_scale_fac, scale_fac[i])
        end
        local ct = {}
        for i = 1, #strings do
            ct[i] = {
                string = strings[i],
            }
        end
        return {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        colour = badge_colour,
                        r = 0.1,
                        minw = 2 / min_scale_fac,
                        minh = 0.36,
                        emboss = 0.05,
                        padding = 0.03 * 0.9,
                    },
                    nodes = {
                        { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                        {
                            n = G.UIT.O,
                            config = {
                                object = DynaText({
                                    string = ct or "ERROR",
                                    colours = { text_colour },
                                    silent = true,
                                    float = true,
                                    shadow = true,
                                    offset_y = -0.03,
                                    spacing = 1,
                                    scale = 0.33 * 0.9,
                                }),
                            },
                        },
                        { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                    },
                },
            },
        }
    end
end

function load_arrow_item(file_key, item_type, key, args)
    key = key or string.lower(item_type)..(item_type == 'VHS' and '' or 's')
    local parent_folder = 'items/'
    local info = assert(SMODS.load_file(parent_folder .. key .. "/" .. file_key .. ".lua"))()


    info.key = file_key
    if item_type ~= 'Challenge' and item_type ~= 'Edition' then
        info.atlas = file_key
        info.pos = { x = 0, y = 0 }
        if info.hasSoul then
            info.pos = { x = 1, y = 0 }
            info.soul_pos = { x = 2, y = 0 }
        end
    end

    if info.no_mod_badges then
        info.no_mod_badges = true
    elseif info.origin or info.part or (info.streamer and (info.streamer== 'vinny' or info.streamer== 'joel' or info.streamer== 'mike')) then
        info.no_mod_badges = true
        local sb_ref = function(self, card, badges) end
        if info.set_badges then
            sb_ref = info.set_badges
        end
        info.set_badges = function(self, card, badges)
            sb_ref(self, card, badges)
            if card.area and card.area == G.jokers or card.config.center.discovered then
                badges[#badges+1] = dynamic_badges(info)
            end
        end
    end

    local smods_item = item_type
    if item_type == 'Stand' or item_type == 'VHS' then
        smods_item = 'Consumable'

        -- add universal set_consumable_usage() for stands
        local ref_add_to_deck = function(self, card, from_debuff) end
        if info.add_to_deck then
            ref_add_to_deck = info.add_to_deck
        end
        function info.add_to_deck(self, card, from_debuff)
            ref_add_to_deck(self, card, from_debuff)

            -- only set initially
            if not from_debuff then
                set_consumeable_usage(card)
            end
        end

        -- force no use for stands
        if item_type == 'Stand' then
            function info.can_use(self, card)
                return false
            end

            if info.rarity == 'EvolvedRarity' then
                local sctb_ref = function(self, card, badges) end
                if info.set_card_type_badge then
                    sctb_ref = info.set_card_type_badge
                end
                function info.set_card_type_badge(self, card, badges)
                    badges[1] = create_badge(localize('k_evolved_stand'), get_type_colour(self or card.config, card), nil, 1.2)
                    sctb_ref(self, card)
                end
            end
        end
    end

    local new_item = SMODS[smods_item](info)
    for k_, v_ in pairs(new_item) do
        if type(v_) == 'function' then
            new_item[k_] = info[k_]
        end
    end

    if item_type == 'Challenge' or item_type == 'Edition' then
        return -- these dont need visuals
    end

    local width = 71
    local height = 95
    if item_type == 'Tag' then width = 34; height = 34 end
    SMODS.Atlas({ key = file_key, path = key .. "/" .. file_key .. ".png", px = new_item.width or width, py = new_item.height or height })
end


--- Wrapper for SMODS debug mesage functions
--- @param message string Message text
--- @param level string Debug level ('debug', 'info', 'warn')
function send(message, level)
    level = level or 'debug'
    if type(message) == 'table' then
        if level == 'debug' then sendDebugMessage(tprint(message))
        elseif level == 'info' then sendInfoMessage(tprint(message))
        elseif level == 'error' then sendErrorMessage(tprint(message)) end
    else
        if level == 'debug' then sendDebugMessage(message)
        elseif level == 'info' then sendInfoMessage(message)
        elseif level == 'error' then sendErrorMessage(message) end
    end
end

--- Allows for Modded Legendaries to show ????? on their normal unlock descriptions, but show the joker_locked_legendary msg on the unlock notifications
G.FUNCS.generate_legendary_desc = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table, key)
    key = key or card.config.center.key
    if card.area and card.area == G.jokers or (card.config.center.discovered or card.bypass_discovery_center) then
        -- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
        full_UI_table.name = localize{type = 'name', key = key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    if (specific_vars and not specific_vars.not_hidden) and not (card.config.center.discovered or card.bypass_discovery_center) then
        localize{type = 'unlocks', key = 'joker_locked_legendary', set = 'Other', nodes = desc_nodes, vars = {}}
    else
        localize{type = 'descriptions', key = key, set = self.set, nodes = desc_nodes, vars = (self.loc_vars(self, info_queue, card) and self.loc_vars(self, info_queue, card).vars) or {}}
    end
end

--- x^4 easing function both in and out
--- @param x number Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function arrow_ease_in_out_quart(x)
    return x < 0.5 and 8 * x * x * x * x or 1 - (-2 * x + 2)^4 / 2;
end

--- sin ease out function
--- @param x number Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function arrow_ease_out_quint(x)
    return 1 - (1-x)^5;
end

--- x^4 easing function in
--- @param x number Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function arrow_ease_in_cubic(x)
    return x * x * x
end

--- Formats a numeral for display. Numerals between 0 and 1 are written out fully
--- @param n number Numeral to format
--- @param number_type string Type of display number ('number', 'order')
--- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
function arrow_format_display_number(n, number_type, caps_style)
    number_type = number_type or 'number'
    local dict = {
        [0] = {number = 'zero', order = 'zeroth'},
        [1] = {number = 'one', order = 'first'},
        [2] = {number = 'two', order = 'second'},
        [3] = {number = 'three', order = 'third'},
        [4] = {number = 'four', order = 'fourth'},
        [5] = {number = 'five', order = 'fifth'},
        [6] = {number = 'six', order = 'sixth'},
        [7] = {number = 'seven', order = 'seventh'},
        [8] = {number = 'eight', order = 'eighth'},
        [9] = {number = 'nine', order = 'ninth'},
        [10] = {number = 'ten', order = 'tenth'},
        [11] = {number = '11', order = '11th'},
        [12] = {number = '12', order = '12th'},
    }
    if n < 0 or n > #dict then
        if number_type == 'number' then return n end

        local ret = ''
        local mod = n % 10
        if mod == 1 then
            ret = n..'st'
        elseif mod == 2 then
            ret = n..'nd'
        elseif mod == 3 then
            ret = n..'rd'
        else
            ret = n..'th'
        end
        return ret
    end

    local ret = dict[n][number_type]
    local style = caps_style and string.lower(caps_style) or 'lower'
    if style == 'upper' then
        ret = string.upper(ret)
    elseif n < 11 and style == 'first' then
        ret = ret:gsub("^%l", string.upper)
    end

    return ret
end

function G.FUNCS.arrow_consumabletype_has_items(set)
    if SMODS.ConsumableTypes[set] and SMODS.ConsumableTypes[set].no_collection then return false end
    if set == 'Stand' then 
        return not not (#G.P_CENTER_POOLS['arrow_StandPool'] > 0 or #G.P_CENTER_POOLS['arrow_EvolvedPool'] > 0)
    end

    return #G.P_CENTER_POOLS[set] > 0
end

-- Based on code from Ortalab
--- Replaces a card in-place with a card of the specified key
--- @param card Card Balatro card table of the card to replace
--- @param to_key string string key (including prefixes) to replace the given card
--- @param evolve boolean boolean for stand evolution
G.FUNCS.transform_card = function(card, to_key, evolve)
    evolve = evolve or false
    local old_card = card
    local new_card = G.P_CENTERS[to_key]
    card.children.center = Sprite(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.ASSET_ATLAS[new_card.atlas], new_card.pos)
    card.children.center.scale = {
        x = 71,
        y = 95
    }
    card.children.center.states.hover = card.states.hover
    card.children.center.states.click = card.states.click
    card.children.center.states.drag = card.states.drag
    card.children.center.states.collide.can = false
    card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
    card:set_ability(new_card)
    card:set_cost()
    if evolve and old_card.on_evolve and type(old_card.on_evolve) == 'function' then
        old_card:on_evolve(old_card, card)
    end
    if new_card.soul_pos then
        card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas], new_card.soul_pos)
        card.children.floating_sprite.role.draw_major = card
        card.children.floating_sprite.states.hover.can = false
        card.children.floating_sprite.states.click.can = false
    end

    if not card.edition then
        card:juice_up()
        play_sound('generic1')
    else
        card:juice_up(1, 0.5)
        if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
        if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
        if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
        if card.edition.negative then play_sound('negative', 1.5, 0.4) end
    end
end

---------------------------
--------------------------- VHS Helper Functios
---------------------------

G.FUNCS.find_activated_tape = function(key)
    local tapes = SMODS.find_card(key)
    if tapes and #tapes > 0 then
        for i, v in ipairs(tapes) do
            if v.ability.activated then
                return v
            end
        end
    end
    return false
end

--- Retrieves the number of VHS tapes in your consumable slots
--- @return number # Count of current VHS tapes
G.FUNCS.get_vhs_count = function()
    if not G.consumeables then return 0 end
    local count = 0
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "VHS" then
            count = count+1
        end
    end
    return count
end

--- Sends feedback for VHS tape activatio
--- @param card Card Balatro Card object of activated VHS tape
G.FUNCS.tape_activate = function(card)
    if not card.ability.activation then return end
    if card.ability.activated then
        card.ability.activated = false
        play_sound('csau_vhsclose', 0.9 + math.random()*0.1, 0.4)
    else
        card.ability.activated = true
        play_sound('csau_vhsopen', 0.9 + math.random()*0.1, 0.4)
    end
end

--- Destroys a VHS tape and calls all relevant contexts
--- @param card Card Balatro Card object of VHS tape to destroy
--- @param delay_time number Event delay in seconds
--- @param ach string | nil Achievement type key, will check for achievement unlock if not nil
--- @param silent boolean | nil Plays tarot sound effect on destruction if true
G.FUNCS.destroy_tape = function(card, delay_time, ach, silent, text)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay_time,
        func = function()
            attention_text({
                text = text or localize('k_vhs_destroyed'),
                scale = 1,
                hold = 0.5,
                backdrop_colour = G.C.VHS,
                align = 'bm',
                major = card,
                offset = {x = 0, y = 0.05*card.T.h}
            })
            play_sound('generic1')

            delay(0.15)

            if not silent then
                play_sound('tarot1')
            end
            card.T.r = -0.1
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                         func = function()
                                             if card.config.center.activate and type(card.config.center.activate) == 'function' then
                                                 card.config.center.activate(card.config.center, card, false)
                                             end

                                             SMODS.calculate_context({vhs_death = true, card = card})

                                             card:remove()
                                             return true
                                         end
            }))
            if ach then
                check_for_unlock({ type = ach })
            end
            return true
        end
    }))
end

local ref_select_card = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
    local card = e.config.ref_table
    if card.ability.set == 'VHS' then
        if #G.consumeables.cards < G.consumeables.config.card_limit then
            e.config.colour = G.C.GREEN
            e.config.button = "use_card"
        else
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        end
        return
    end

    return ref_select_card(e)
end

---------------------------
--------------------------- Stand Helper Functions
---------------------------

--- Gets the leftmost stand in the consumable slots
--- @return Card | nil # The first Stand in the consumables slot, or nil if you have no Stands
G.FUNCS.get_leftmost_stand = function()
    if not G.consumeables then return nil end

    local stand = nil
    for i, card in ipairs(G.consumeables.cards) do
        if card.ability.set == "Stand" then
            stand = card
            break
        end
    end

    return stand
end

--- Gets the number of stands in your consumable slots
--- @return integer
G.FUNCS.get_num_stands = function()
    if not G.consumeables then return 0 end

    local count = 0
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "Stand" then
            count = count+1
        end
    end

    return count
end

--- Evolves a Stand. A Stand must have an 'evolve_key' field to evolve
--- @param stand Card Balatro card table representing a Stand consumable
G.FUNCS.evolve_stand = function(stand, loc_message)
    if stand.children.stand_aura then
        stand.children.stand_aura.atlas = G.ASSET_ATLAS[stand.ability.evolved and 'arrow_blank_evolved' or 'arrow_blank']
    end
    G.FUNCS.flare_stand_aura(stand, 0.50)

    G.E_MANAGER:add_event(Event({
        func = function()

            G.FUNCS.transform_card(stand, stand.ability.evolve_key, true)
            check_for_unlock({ type = "evolve_stand" })

            attention_text({
                text = loc_message or localize('k_stand_evolved'),
                scale = 0.7,
                hold = 0.55,
                backdrop_colour = G.C.STAND,
                align = 'bm',
                major = stand,
                offset = {x = 0, y = 0.05*stand.T.h}
            })

            if not stand.edition then
                play_sound('polychrome1')
            end

            return true
        end
    }))
end

--- Creates a new stand in the consumables card area, on the side of Stands
--- @param evolved boolean Whether or not to use the Evolved Stand pool
G.FUNCS.new_stand = function(evolved)
    local pool_key = evolved and 'arrow_EvolvedPool' or 'arrow_StandPool'
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    local stand = create_card(pool_key, G.consumeables, nil, nil, nil, nil, nil, 'arrow')
    stand:add_to_deck()
    G.consumeables:emplace(stand, #G.consumeables.cards <= 2 and 'front' or nil)
    stand:juice_up(0.3, 0.5)
    G.GAME.consumeable_buffer = 0
end

--- Queues a stand aura to flare for delay_time if a Stand has an aura attached
--- @param stand Card Balatro card table representing a stand
--- @param delay_time number length of flare in seconds
G.FUNCS.flare_stand_aura = function(stand, delay_time, on_hover)
    if not stand.children.stand_aura then
        return
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        blocking = false,
        func = function()
            stand.ability.aura_flare_queued = true
            stand.ability.aura_flare_target = delay_time and (delay_time / 2) or nil
            return true
        end
    }))
end

--- Sets relevant sprites for stand auras and overlays (if applicable)
--- @param stand Card Balatro card table representing a stand
G.FUNCS.arrow_set_stand_sprites = function(stand)
    -- add stand aura
    if stand.ability.aura_colors and #stand.ability.aura_colors == 2 then
        stand.no_shadow = true
        G.ASSET_ATLAS['arrow_stand_noise'].image:setWrap('repeat', 'repeat', 'clamp')

        local blank_atlas = G.ASSET_ATLAS[stand.ability.evolved and 'arrow_stand_blank_evolved' or 'arrow_stand_blank']
        local aura_scale_x = blank_atlas.px / stand.children.center.atlas.px
        local aura_scale_y = blank_atlas.py / stand.children.center.atlas.py
        local aura_width = stand.T.w * aura_scale_x
        local aura_height = stand.T.h * aura_scale_y
        local aura_x_offset = (aura_width - stand.T.w) / 2
        local aura_y_offset = (aura_height - stand.T.h) / 1.1

        stand.ability.aura_spread = 0.47
        stand.ability.aura_rate = 0.7
        stand.children.stand_aura = Sprite(
                stand.T.x - aura_x_offset,
                stand.T.y - aura_y_offset,
                aura_width,
                aura_height,
                blank_atlas,
                stand.children.center.config.pos
        )
        stand.children.stand_aura:set_role({
            role_type = 'Minor',
            major = stand,
            offset = { x = -aura_x_offset, y = -aura_y_offset },
            xy_bond = 'Strong',
            wh_bond = 'Weak',
            r_bond = 'Strong',
            scale_bond = 'Strong',
            draw_major = stand
        })
        stand.children.stand_aura:align_to_major()
        stand.children.stand_aura.custom_draw = true
    end
end