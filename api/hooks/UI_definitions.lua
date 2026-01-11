SMODS.Atlas({key = 'arrow_mystery', atlas_table = "ANIMATION_ATLAS", custom_path = ArrowAPI.path..(ArrowAPI.custom_path or ''), path = "blinds/mystery.png", px = 34, py = 34, frames = 21, prefix_config = false })

---------------------------
--------------------------- Maggie Speech Bubble Support
---------------------------

function G.UIDEF.jok_speech_bubble(text_key, loc_vars, extra)
    local text = {}
    extra = extra or {}

    localize{type = 'quips', key = text_key, vars = loc_vars or {}, nodes = text}
    local row = {}
    for k, v in ipairs(text) do
        --v[1].config.colour = extra.text_colour or v[1].config.colour or G.C.JOKER_GREY
        row[#row+1] =  {n=G.UIT.R, config={align = extra.text_alignment or "cl"}, nodes=v}
    end
    local t = {n=G.UIT.ROOT, config = {align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = extra.root_colour or G.C.JOKER_GREY, shadow = true}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.03, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes=row}}
        }
    }}
    return t
end





---------------------------
---------------------------  General custom interaction behavior
---------------------------

local ref_can_buy = G.FUNCS.can_buy_and_use
G.FUNCS.can_buy_and_use = function(e)
    local ret = ref_can_buy(e)
    if e.config.ref_table.ability.set == 'VHS' then
        e.UIBox.states.visible = false
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
    return ret
end

-- Modified Code from Malverk
local ref_use_sell_buttons = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if card.ability.set == "VHS" then
        if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
            use = {n=G.UIT.R, config={align = 'cm'}, nodes={
                {n=G.UIT.C, config={align = "cm"}, nodes={
                    {n=G.UIT.C, config={align = "bm", maxw = G.CARD_W * 0.65, shadow = true, padding = 0.1, r=0.08, minw = 0.5 * G.CARD_W, minh = 0.8, hover = true, colour = G.C.GREEN, button = "use_card", func = "can_select_from_booster", ref_table = card}, nodes={
                        {n=G.UIT.T, config={text = localize('b_select'), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
                    }}
                }}
            }}
            local t = {n=G.UIT.ROOT, config = {align = 'cm', padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={align = 'cm'}, nodes={
                    use,
                }},
            }}
            return t
        end
    end

    if card.ability.set == "Stand" then
        if (card.area == G.pack_cards and G.pack_cards) then
            return {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_from_booster'}, nodes={
                    {n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
                }},
            }}
        end
        local sell = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
                    }},
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
                        {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
                    }}
                }}
            }},
        }}
        local t = {
            n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                    {n=G.UIT.R, config={align = 'cl'}, nodes={
                        sell
                    }},
                }},
            }}
        return t
    end
    return ref_use_sell_buttons(card)
end


---------------------------
--------------------------- Blind special colour modifiers
---------------------------

local ref_uibox_blind = create_UIBox_blind_popup
function create_UIBox_blind_popup(...)
    local ret = ref_uibox_blind(...)

    local args = { ... }
    local blind = args[1]
    local discovered = args[2]

    if discovered and blind.special_colour then
        local ability_text = ret.nodes[2].nodes[1].nodes[4]
        if ability_text then
            ability_text.config.colour = blind.special_colour
        end
    end

    return ret
end

local blind_opts = {'Small', 'Big', 'Boss'}

SMODS.hidden_blinds = {}
local ref_blind_select = create_UIBox_blind_select
function create_UIBox_blind_select()
    SMODS.hidden_blinds = {}
    for i = 1, #blind_opts do
        local choice = blind_opts[i]
        local blind = G.GAME.round_resets.blind_choices[choice]
        local obj = G.P_BLINDS[blind]
        if obj.hide_blind or SMODS.blind_hidden(obj) then
            G.GAME.round_resets.blind_choices[choice] = 'bl_arrow_mystery'
            SMODS.hidden_blinds[choice] = blind
        end
    end

    local ret = ref_blind_select()

    for k, v in pairs(SMODS.hidden_blinds) do
        G.GAME.round_resets.blind_choices[k] = v
    end

    return ret
end

local ref_blind_main_colour = get_blind_main_colour
function get_blind_main_colour(blind)
    if SMODS.hidden_blinds[blind] then
        return G.P_BLINDS['bl_arrow_mystery'].boss_colour
    end

    return ref_blind_main_colour(blind)
end

local ref_blind_choice = create_UIBox_blind_choice
function create_UIBox_blind_choice(...)
    local args = { ... }
    local type = args[1]
    local obj = G.P_BLINDS[G.GAME.round_resets.blind_choices[type]]

    -- need to do this to set the proper config when blind is selected
    local ret = ref_blind_choice(...)
    if SMODS.hidden_blinds[type] then
        ret.nodes[1].nodes[1].nodes[1].config.ref_table = G.P_BLINDS[SMODS.hidden_blinds[type]]
    end

    if obj.score_invisible or SMODS.hidden_blinds[type] then
        local info_node = ret.nodes[1].nodes[3].nodes[1].nodes[2]
        info_node.config.colour = G.C.CLEAR
        info_node.nodes = {}
    end

    return ret
end

---------------------------
--------------------------- Multi line attention text support
---------------------------

local ref_attention_text = attention_text
function attention_text(args)
    if not args or not args.text or (args.text and type(args.text) ~= 'table') then
        return ref_attention_text(args)
    end

    args.scale = args.scale or 1
    args.colour = SMODS.shallow_copy(args.colour or G.C.WHITE)
    args.hold = (args.hold or 0) + 0.1*(G.SPEEDFACTOR)
    args.pos = args.pos or {x = 0, y = 0}
    args.align = args.align or 'cm'
    args.emboss = args.emboss or nil
    args.fade = 1

    if args.cover then
        args.cover_colour = SMODS.shallow_copy(args.cover_colour or G.C.RED)
        args.cover_colour_l = SMODS.shallow_copy(lighten(args.cover_colour, 0.2))
        args.cover_colour_d = SMODS.shallow_copy(darken(args.cover_colour, 0.2))
    else
        args.cover_colour = copy_table(G.C.CLEAR)
    end

    args.uibox_config = {
        align = args.align or 'cm',
        offset = args.offset or {x=0,y=0},
        major = args.cover or args.major or nil,
    }

    local nodes = {}
    for _, line in ipairs(args.text) do
        nodes[#nodes+1] = {{
            n=G.UIT.C,
            config={align = "m"},
            nodes={{
                n=G.UIT.O,
                config={
                    object = DynaText({
                        string = line,
                        colours = {args.colour},
                        silent = not args.noisy,
                        pop_in = 0,
                        pop_in_rate = 6,
                        rotate = args.rotate or nil,
                        maxw = args.maxw,
                        float = true,
                        shadow = true,
                        scale = args.scale
                    })
                }
            }}
        }}
    end

    local final_text = {
        n=G.UIT.ROOT,
        config = {
            align = args.cover_align or 'cm',
            minw = (args.cover and args.cover.T.w or 0.001) + (args.cover_padding or 0),
            minh = (args.cover and args.cover.T.h or 0.001) + (args.cover_padding or 0),
            padding = 0.03,
            r = 0.1,
            emboss = args.emboss,
            colour = args.cover_colour
        },
        nodes={}
    }

    for _, line in ipairs(nodes) do
        final_text.nodes[#final_text.nodes+1] = {n=G.UIT.R, config={align = "m"}, nodes=line}
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            args.AT = UIBox{
                T = {args.pos.x,args.pos.y, 0, 0},
                definition = final_text,
                config = args.uibox_config
            }
            args.AT.attention_text = true

            args.text = args.AT.UIRoot.children
            for _, v in ipairs(args.text) do
                v.children[1].children[1].config.object:pulse(0.5)
            end

            if args.cover then
            Particles(args.pos.x,args.pos.y, 0,0, {
                timer_type = 'TOTAL',
                timer = 0.01,
                pulse_max = 15,
                max = 0,
                scale = 0.3,
                vel_variation = 0.2,
                padding = 0.1,
                fill=true,
                lifespan = 0.5,
                speed = 2.5,
                attach = args.AT.UIRoot,
                colours = {args.cover_colour, args.cover_colour_l, args.cover_colour_d},
            })
            end
            if args.backdrop_colour then
            args.backdrop_colour = SMODS.shallow_copy(args.backdrop_colour)
            Particles(args.pos.x,args.pos.y,0,0,{
                timer_type = 'TOTAL',
                timer = 5,
                scale = 2.4*(0.75 + 0.25 * #args.text),
                lifespan = 5,
                speed = 0,
                attach = args.AT,
                colours = {args.backdrop_colour}
            })
            end
            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = args.hold,
        blockable = false,
        blocking = false,
        func = function()
            if not args.start_time then
                args.start_time = G.TIMERS.TOTAL
                for _, v in ipairs(args.text) do
                    v.children[1].children[1].config.object:pop_out(3)
                end
            else
                --args.AT:align_to_attach()
                args.fade = math.max(0, 1 - 3*(G.TIMERS.TOTAL - args.start_time))
                if args.cover_colour then args.cover_colour[4] = math.min(args.cover_colour[4], 2*args.fade) end
                if args.cover_colour_l then args.cover_colour_l[4] = math.min(args.cover_colour_l[4], args.fade) end
                if args.cover_colour_d then args.cover_colour_d[4] = math.min(args.cover_colour_d[4], args.fade) end
                if args.backdrop_colour then args.backdrop_colour[4] = math.min(args.backdrop_colour[4], args.fade) end
                args.colour[4] = math.min(args.colour[4], args.fade)
                if args.fade <= 0 then
                    args.AT:remove()
                    return true
                end
            end
        end
    }))
end





---------------------------
--------------------------- Custom Challenge display behavior
---------------------------

local ref_challenge_desc = G.UIDEF.challenge_description
function G.UIDEF.challenge_description(_id, daily, is_row)
    ArrowAPI.eternal_compat_bypass = true
    local ret = ref_challenge_desc(_id, daily, is_row)
    ArrowAPI.eternal_compat_bypass = nil
    return ret
end

local ref_challenge_tab = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
    local ret = ref_challenge_tab(args)

    local ch = G.CHALLENGES[args._id]
    if args._tab == 'Rules' and G.localization.descriptions.Challenge[ch.key] then
        ret.nodes[1].nodes[1].config.minw = 2.5
        local custom_rules = (ch.rules and ch.rules.custom and next(ch.rules.custom)) or false
        local rule_node = ret.nodes[1].nodes[1].nodes[2]
        rule_node.config.minw = custom_rules and 3.65 or 3.8
        rule_node.config.maxw = custom_rules and 3.65 or 3.8
        rule_node.config.minh = custom_rules and 4 or 4.1
        ret.nodes[1].nodes[1].nodes[2] = {
            n = G.UIT.R,
            config = {align = "cm", padding = custom_rules and 0.05 or 0, colour = G.C.WHITE, r = 0.1 },
            nodes = { rule_node }
        }

        ret.nodes[1].nodes[2].config.minw = 1.75
        local modifier_node = ret.nodes[1].nodes[2].nodes[2]
        modifier_node.config.minw = 2.3
        modifier_node.config.maxw = 2.3
        modifier_node.config.minh = 4.1
        ret.nodes[1].nodes[2].nodes[2] = {
            n = G.UIT.R,
            config = {align = "cm", colour = G.C.WHITE, r = 0.1 },
            nodes = { modifier_node }
        }

        local story_text = {{}}
        localize{type = 'descriptions', set = 'Challenge', key = ch.key, nodes = story_text[#story_text], text_colour = G.C.BLACK }
        story_text[#story_text] = desc_from_rows(story_text[#story_text], nil, 4.2)
        story_text[#story_text].config.colour = G.C.CLEAR
        if not next(story_text[#story_text].nodes) then
            story_text[#story_text].nodes[1] = {n = G.UIT.T, config = { align = "cm", text = ''}}
        end

        local story_node = {n=G.UIT.C, config={align = "cm", minw = 3, r = 0.1, colour = G.C.BLUE}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6}, nodes={
                {n=G.UIT.T, config={text = localize('k_challenge_story'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0.075, colour = G.C.WHITE, r = 0.1 }, nodes={
                ch.origin and ArrowAPI.ui.dynamic_badge(ch) or nil,
                {n = G.UIT.R, config = {align = "cm", minh = ch.origin and 3.45 or 3.95, minw = 4.4, maxw = 4.4, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes = story_text}
            }},
        }}

        table.insert(ret.nodes[1].nodes, 1, story_node)
    end

    if args._tab == 'Restrictions' and ch.restrictions then
        if ch.restrictions.allowed_cards then
            local banned_nodes = ret.nodes[1].nodes[1].nodes[2].nodes

            -- make sure to remove them to make sure
            for _, v in ipairs(banned_nodes) do v.nodes[1].config.object:remove() end
            ArrowAPI.table.clear(banned_nodes)

            table.insert(banned_nodes, {
                n=G.UIT.R, config={align = "tm", minh = 0.3}, nodes= localize{type = 'text', key = 'banned_except', vars = {}}
            })
            table.insert(banned_nodes, {n=G.UIT.R, config={align = "cm", minh = 0.1}})

            local row_cards = {}
            local n_rows = math.max(1, math.floor(#ch.restrictions.allowed_cards/10) + 2 - math.floor(math.log(6, #ch.restrictions.allowed_cards)))
            local max_width = 1
            for k, v in ipairs(ch.restrictions.allowed_cards) do
                local _row = math.floor((k-1)*n_rows/(#ch.restrictions.allowed_cards)+1)
                row_cards[_row] = row_cards[_row] or {}
                row_cards[_row][#row_cards[_row]+1] = v
                if #row_cards[_row] > max_width then max_width = #row_cards[_row] end
            end

            local card_size = math.max(0.2, 0.65 - 0.01*(max_width*n_rows))
            for _, row_card in ipairs(row_cards) do
                local allow_area = CardArea(
                    0,0,
                    6,
                    3/n_rows,
                    {
                        card_limit = nil,
                        type = 'title_2',
                        view_deck = true,
                        highlight_limit = 0,
                        card_w = G.CARD_W*card_size
                    }
                )

                for _, v in ipairs(row_card) do
                    local card = Card(0, 0, G.CARD_W*card_size, G.CARD_H*card_size, nil, G.P_CENTERS[v.id],
                        {bypass_discovery_center = true, bypass_discovery_ui = true}
                    )
                    allow_area:emplace(card)
                end


                table.insert(banned_nodes,
                    {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                        {n=G.UIT.O, config={object = allow_area}}
                    }}
                )

            end
        end

        if ch.restrictions.allowed_other then
            local banned_nodes = ret.nodes[1].nodes[3].nodes[2].nodes
            for _, v in ipairs(banned_nodes) do v.nodes[1].config.object:remove() end
            ArrowAPI.table.clear(banned_nodes)

            table.insert(banned_nodes, {n=G.UIT.R, config={align = "tm", minh = 0.2, maxw = 2}, nodes= localize{type = 'text', key = 'blinds_except', vars = {}}})
            table.insert(banned_nodes, {n=G.UIT.R, config={align = "cm", minh = 0.1, maxw = 2}})

            local allowed_blinds = {}
            for _, v in pairs(ch.restrictions.allowed_other) do
                allowed_blinds[#allowed_blinds+1] = G.P_BLINDS[v.id]
            end

            table.sort(allowed_blinds, function (a, b) return a.order < b.order end)
            for _, v in ipairs(allowed_blinds) do
                local temp_blind = AnimatedSprite(0,0,1,1, G.ANIMATION_ATLAS[v.atlas or ''] or G.ANIMATION_ATLAS['blind_chips'], v.pos)
                temp_blind:define_draw_steps({{shader = 'dissolve', shadow_height = 0.05},{shader = 'dissolve'}})
                temp_blind.float = true
                temp_blind.states.hover.can = true
                temp_blind.states.drag.can = false
                temp_blind.states.collide.can = true
                temp_blind.config = {blind = v, force_focus = true}
                temp_blind.hover = function()
                    if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
                        if not temp_blind.hovering and temp_blind.states.visible then
                        temp_blind.hovering = true
                        temp_blind.hover_tilt = 3
                        temp_blind:juice_up(0.05, 0.02)
                        play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
                        temp_blind.config.h_popup = create_UIBox_blind_popup(v, true)
                        temp_blind.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = temp_blind}
                        Node.hover(temp_blind)
                        end
                    end
                end

                temp_blind.stop_hover = function()
                    temp_blind.hovering = false
                    Node.stop_hover(temp_blind)
                    temp_blind.hover_tilt = 0
                end

                table.insert(banned_nodes,
                {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                    {n=G.UIT.O, config={object = temp_blind}}
                }})
            end
        end
    end

    return ret
end

local ref_ui_button = UIBox_button
function UIBox_button(args)
    local ret = ref_ui_button(args)
    if not args.count and args.button == 'change_challenge_description' and G.CHALLENGES[args.id].original_mod then
        local ch = G.CHALLENGES[args.id]
        local mod = ch.original_mod or ch.mod or {}

        -- copy new animated modicon style
        local atlas_key = mod.prefix and mod.prefix .. '_modicon' or 'modicon'
        local modicon
        if G.ANIMATION_ATLAS[atlas_key] then
            modicon = AnimatedSprite(0, 0, 0.5, 0.5, G.ANIMATION_ATLAS[atlas_key] or G.ASSET_ATLAS[atlas_key] or G.ASSET_ATLAS['tags'], tag_pos)
        else
            modicon = Sprite(0, 0, 0.5, 0.5, G.ASSET_ATLAS[atlas_key] or G.ASSET_ATLAS['tags'], tag_pos)
        end

        local origin = type(ch.origin) == 'table' and (ch.origin.custom_color or ch.origin.category) or ch.origin
        local text_colour = origin and ArrowAPI.ui.badge_colors[mod.id]['te_'..origin] or args.text_colour or G.C.WHITE
        local text_nodes = ret.nodes[1].nodes
        for _, v in ipairs(text_nodes) do
            v.config.minw = math.max(0, v.config.minw - 1.2)
            v.config.maxw = math.max(v.config.minw, 2)
            v.nodes[1].config.colour = text_colour
        end


        local badge_color = origin and ArrowAPI.ui.badge_colors[mod.id]['co_'..origin] or nil
        local new_nodes = {
            {n= G.UIT.C, config={ minw = 0.8, align = 'cm', padding = args.padding or 0 }, nodes = {
                { n=G.UIT.O, config = {align = 'rm', can_collide = true, object = modicon, tooltip = {text = {mod.display_name}}}}
            }},
            {n= G.UIT.C, config={ minw = 0.8, colour = badge_color, r = 0.1, minh = args.minh, align = 'cm' }, nodes = {
                badge_color and {n = G.UIT.C, config={minw = 0.2, align = 'cm'}} or nil,
                {n = G.UIT.C, config={align = 'cm'}, nodes = text_nodes},
                {n = G.UIT.C, config={minw = badge_color and 0.2 or 0.4, align = 'cm'}}
            }},
        }

        ret.config.padding = 0
        ret.nodes[1].nodes = new_nodes
    end

    return ret
end



---------------------------
--------------------------- Deck crediting
---------------------------

local ref_run_setup = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(...)
    local ret = ref_run_setup(...)

    if G.GAME.viewed_back then
        local args = {...}

        local credit = {
            n = G.UIT.R,
            config = {align = "cm"},
            nodes = {{
                n = G.UIT.O,
                config = {
                    id = nil,
                    func = 'RUN_SETUP_check_artist',
                    object = Moveable()
                }
            }}
        }

        if args[1] == 'Continue' and V(G.SAVED_GAME.GAME.smods_version or '0.0.0') == V(SMODS.version) then
            local back_desc_nodes = ret.nodes[1].nodes[1].nodes[1].nodes[2].nodes
            back_desc_nodes[#back_desc_nodes+1] = credit
        elseif args[1] == 'New Run' then
            local back_desc_nodes = ret.nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].nodes[2].nodes
            back_desc_nodes[#back_desc_nodes+1] = credit
        end
    end

    return ret
end

function G.UIDEF.deck_credit(back)
    -- set the artists
    local vars = type(back.artist) == 'table' and back.artist or {back.artist}

    local name_nodes = localize{type = 'name', key = "artistcredit_"..#vars, set = 'Other', scale = 0.6}
    local desc_nodes = {}
    localize{type = 'descriptions', key = "artistcredit_"..#vars, set = "Other", vars = vars, nodes = desc_nodes, scale = 0.7}
    local credit = {
        n = G.UIT.ROOT,
        config = {id = back.name, align = "cm", minw = 4, r = 0, colour = G.C.CLEAR },
        nodes = {
            name_from_rows(name_nodes, nil),
            desc_from_rows(desc_nodes, nil),
        }
    }

    credit.nodes[1].config.padding = 0.035
    credit.nodes[2].config.padding = 0.03
    credit.nodes[2].config.minh = 0.15
    credit.nodes[2].config.minw = 4
    credit.nodes[2].config.r = 0.005

    return credit
end

--- this is needed to fix a bug in vanilla which will crash this whole tree if recalculate is called
local ref_toggle_seeded = G.FUNCS.toggle_seeded_run
function G.FUNCS.toggle_seeded_run(e)
    if e.config.object and not G.run_setup_seed then
        e.config.object:remove()
        e.config.object = nil
        e.UIT = G.UIT.R
        e.UIBox:recalculate()
    elseif G.run_setup_seed then
        e.UIT = G.UIT.O
    end

    return ref_toggle_seeded(e)
end


function G.UIDEF.deck_artist_popup(center)
    local vars = type(center.artist) == 'table' and center.artist or {center.artist}

    local info_nodes = {}
    localize{type = 'descriptions', key = "artistcredit_"..#vars, set = "Other", vars = vars, nodes = info_nodes}
    info_nodes.name = localize{type = 'name_text', key = "artistcredit_"..#vars, set = 'Other'}

    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
            info_tip_from_rows(info_nodes, info_nodes.name),
        }}
    }}
end

local ref_notify_alert = create_UIBox_notify_alert
function create_UIBox_notify_alert(key, type)
    local ach

    local is_arrow_achievement = false
    if SMODS.Achievements[key] then
        ach = SMODS.Achievements[key]
        if ach.original_mod then
            if SMODS.provided_mods['ArrowAPI'] then
                for i=1, #SMODS.provided_mods['ArrowAPI'] do
                    if SMODS.provided_mods['ArrowAPI'][i].mod == ach.original_mod then
                        is_arrow_achievement = true
                        break
                    end
                end
            end

            for _, x in ipairs(ach.original_mod.dependencies or {}) do
                for _, y in ipairs(x) do
                    if y.id == 'ArrowAPI' then
                        is_arrow_achievement = true
                        break
                    end
                end

                if is_arrow_achievement then break end
            end
        end
    end

    if not is_arrow_achievement then
        return ref_notify_alert(key, type)
    end

    local _atlas = G.ASSET_ATLAS[ach.atlas]

    local t_s = Sprite(0,0,1.5*(_atlas.px/_atlas.py),1.5,_atlas, ach and ach.pos or {x=3, y=0})
    t_s.states.drag.can = false
    t_s.states.hover.can = false
    t_s.states.collide.can = false

    local subtext = type == 'achievement' and localize(G.F_TROPHIES and 'k_trophy' or 'k_achievement') or
        (type == 'Joker' or type == 'Voucher') and localize('k_'..type:lower()) or
        type == 'Back' and localize('k_deck') or
        ach.set and localize('k_' .. ach.set:lower()) or
        'ERROR'
    if key == 'b_challenge' then subtext = localize('k_challenges') end

    local name_text = is_arrow_achievement
    and localize{type = 'name_text', key = key, set = 'Achievements'}
    or localize(key, 'achievement_names')

    local t = {n=G.UIT.ROOT, config = {align = 'cl', r = 0.1, padding = 0.06, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
        {n=G.UIT.R, config={align = "cl", padding = 0.2, minw = 20, r = 0.1, colour = G.C.BLACK, outline = 1.5, outline_colour = G.C.GREY}, nodes={
            {n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
                    {n=G.UIT.O, config={object = t_s}},
                }},
                type ~= 'achievement' and {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = subtext, scale = 0.5, colour = G.C.FILTER, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = localize('k_unlocked_ex'), scale = 0.35, colour = G.C.FILTER, shadow = true}},
                    }}
                }}
                or {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4, padding = 0.1}, nodes={
                        {n=G.UIT.T, config={text = name_text, scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = subtext, scale = 0.3, colour = G.C.FILTER, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = localize('k_unlocked_ex'), scale = 0.35, colour = G.C.FILTER, shadow = true}},
                    }}
                }}
            }}
        }}
    }}

    return t
end





---------------------------
--------------------------- Draws credits for a given area
---------------------------

function create_UIBox_credit_tooltip(contributor_data)
    play_sound('cardSlide2')
    local centers = {}
    for i = 1, #contributor_data do
        local data = contributor_data[i]
        if G.P_CENTERS[data.key] then
            centers[#centers+1] = data.key
        end
    end

    local credit_cards = {}
    local row_cards = {}
    local n_rows = math.max(1, math.floor(#centers/10) + 2 - math.floor(math.log(6, #centers)))
    local max_width = 1
    for i, v in ipairs(centers) do
        local _row = math.floor((i-1)*n_rows/(#centers)+1)
        row_cards[_row] = row_cards[_row] or {}
        row_cards[_row][#row_cards[_row]+1] = v
        if #row_cards[_row] > max_width then max_width = #row_cards[_row] end
    end

    local card_size = math.max(0.3, 0.75 - 0.01*(max_width*n_rows))

    for _, row_card in ipairs(row_cards) do
        local credit_area = CardArea(
            0,0,
            7.7,
            6/n_rows,
            {card_limit = nil, type = 'title_2', view_deck = true, highlight_limit = 0, card_w = G.CARD_W*card_size}
        )

        table.insert(credit_cards, {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.O, config={object = credit_area}}
        }})

        for k, v in ipairs(row_card) do
            local card = Card(0,0, G.CARD_W*card_size, G.CARD_H*card_size, nil, G.P_CENTERS[v])
            credit_area:emplace(card)
        end
    end

    local nodes = {n=G.UIT.C, config={align = "cm", r = 0.1}, nodes={
      {n=G.UIT.R, config={align = "cm", minh = 6.5, minw = 10, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes=
        credit_cards
      }
    }}

    return {n=G.UIT.ROOT, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={
      nodes
    }}
end





---------------------------
--------------------------- New settings tab with some below features
---------------------------

local ref_settings_tab = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
    if tab == 'Audio' then
        return {n=G.UIT.ROOT, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={
            create_slider({label = localize('b_set_master_vol'), w = 5, h = 0.4, ref_table = G.SETTINGS.SOUND, ref_value = 'volume', min = 0, max = 100}),
            create_slider({label = localize('b_set_music_vol'), w = 5, h = 0.4, ref_table = G.SETTINGS.SOUND, ref_value = 'music_volume', min = 0, max = 100}),
            create_slider({label = localize('b_set_game_vol'), w = 5, h = 0.4, ref_table = G.SETTINGS.SOUND, ref_value = 'game_sounds_volume', min = 0, max = 100}),
            {n = G.UIT.R, config = {align = "cm", padding = 0.1, minh = 2}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, minh = 2.5}, nodes = {
                    UIBox_button{ label = {localize("tnsmi_manager_pause")}, button = "tnsmi_packs_button", minw = 4, colour = G.C.PALE_GREEN},
                }},
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, minh = 2.5}, nodes = {
                    {n = G.UIT.R, config = {align = "cl", padding = 0.1}, nodes = {
                        {n = G.UIT.C, config = {align = "cl", minw = 2.5}, nodes = {
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.T, config = {align = "cr", text = localize("tnsmi_cfg_rows")..": ", colour = G.C.WHITE, scale = 0.3}}}},
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.O, config = {align = "cr", object = DynaText{string = {{ref_table = TNSMI.config, ref_value = "rows"}}, colours = {G.C.WHITE}, scale = 0.3}}}}},
                        }},
                        {n = G.UIT.C, config = {align = "cl", minw = 0.4}, nodes = {
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"-"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"rows",-1}}}},
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"+"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"rows",1}}}},
                        }},
                    }},
                    {n = G.UIT.R, config = {align = "cl", padding = 0.1}, nodes = {
                        {n = G.UIT.C, config = {align = "cl", minw = 2.5}, nodes = {
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.T, config = {align = "cr", text = localize("tnsmi_cfg_cols")..": ", colour = G.C.WHITE, scale = 0.3}}}},
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.O, config = {align = "cr", object = DynaText{string = {{ref_table = TNSMI.config, ref_value = "cols"}}, colours = {G.C.WHITE}, scale = 0.3}}}}},
                        }},
                        {n = G.UIT.C, config = {align = "cl", minw = 0.4}, nodes = {
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"-"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"cols",-1}}}},
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"+"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"cols",1}}}},
                        }},
                    }},
                }},
            }},
        }}
    end

    if tab == 'Palettes' then
        G.SETTINGS.paused = true
        ArrowAPI.palette_ui_config.open_palette = nil
        if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
        G.FUNCS.overlay_menu{
            definition = arrow_create_UIBox_palette_menu(),
            config = {offset = {x = 0, y = 10}}
        }
        return
	end

    return ref_settings_tab(tab)
end






---------------------------
--------------------------- Tonsmith UI
---------------------------

-- Creates a fake soundpack card partially based on the approach Malverk takes
function tnsmi_create_soundpack_card(area, pack, pos)
    local atlas = G.ANIMATION_ATLAS[pack.atlas] or G.ASSET_ATLAS[pack.atlas]

    -- this card is provided a "fake" SoundPack center
    -- rather than registering an unused item, it fills in the
    -- fields SMODS.GameObject normally needs to display
    -- and localize UI for centers
    local card = Card(
        area.T.x,
        area.T.y,
        G.CARD_W * 0.8,
        G.CARD_W * 0.8,
        nil,
        {key = pack.key, name = "Sound Pack", atlas = pack.atlas, pos={x=0,y=0}, set = "SoundPack", label = 'Sound Pack', config = {}, generate_ui = SMODS.Center.generate_ui},
        {tnsmi_soundpack = pack.key}
    )

    card.states.drag.can = area == TNSMI.cardareas.priority
    if atlas.frames then
        --card.T.w = W
        --card.T.h = H
        card.children.animatedSprite = AnimatedSprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas, atlas.pos)
        card.children.animatedSprite.T.w = W
        card.children.animatedSprite.T.h = H
        card.children.animatedSprite:set_role({major = card, role_type = 'Glued', draw_major = card})
        card.children.animatedSprite:rescale()
        card.children.animatedSprite.collide.can = false
        card.children.animatedSprite.drag.can = false
        card.children.center:remove()
        card.children.back:remove()
        card.no_shadow = true
        area:emplace(card, pos)
        return card
    end

    area:emplace(card, pos)

    -- This delay is set in G.FUNCS.tnsmi_toggle_soundpack for juice
    -- when TNSMI.dissolve_flag is set, the next pack created of that key
    -- will materialize rather than instantly appearing
    -- so it appears to pop out of one cardarea and pop into the next
    if TNSMI.dissolve_flag == pack.key then
        card.states.visible = false
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            blocking = false,
            blockable = false,
            func = (function()
                card:start_materialize(nil, nil, 0.25)
                return true
            end)
        }))

        TNSMI.dissolve_flag = nil
    end
end

--- Definition for the Soundpack Overlay Menu
function tnsmi_create_UIBox_soundpacks()

    -- creates cardareas only once upon menu load to prevent any unnecessary calc
    -- updates occur within the existing cardareas
    if TNSMI.cardareas.priority then TNSMI.cardareas.priority:remove() end
    TNSMI.cardareas.priority = CardArea(0, 0, G.CARD_W * TNSMI.config.cols * 0.965, G.CARD_H * 0.725,
        {card_limit = TNSMI.config.cols, type = 'soundpack', highlight_limit = 99}
    )

    for _, v in ipairs(TNSMI.config.loaded_packs) do
        tnsmi_create_soundpack_card(TNSMI.cardareas.priority, TNSMI.SoundPacks[v], 'front')
    end

    -- these are likely unnecessary because area references get cleaned when UI is removed (I think)
    for i = #TNSMI.cardareas, 1, -1 do
        TNSMI.cardareas[i]:remove()
        TNSMI.cardareas[i] = nil
    end

    local area_nodes = {}
    for i=1, TNSMI.config.rows do
        TNSMI.cardareas[i] = CardArea(0, 0, G.CARD_W * TNSMI.config.cols * 0.965, G.CARD_H * 0.725,
            {card_limit = TNSMI.config.cols, highlight_limit = 99, type = 'soundpack'}
        )

        area_nodes[#area_nodes+1] = {n = G.UIT.R, config = {align = "cl", colour = G.C.CLEAR}, nodes = {
            {n = G.UIT.O, config = {id = 'tnsmi_area_'..i, object = TNSMI.cardareas[i]}}
        }}
    end

    -- Cycle config is stored in this global variable in order to change the state of the
    -- option cycle on the fly when filtering search results. Vanilla balatro expects
    -- they're only changed upon complete menu reload
    TNSMI.cycle_config = {
        options = {},
        w = 4.5,
        cycle_shoulders = true,
        opt_callback = 'tnsmi_soundpacks_page',
        focus_args = {snap_to = true, nav = 'wide'},
        current_option = 1,
        colour = G.C.RED,
        no_pips = true,
    }

    G.FUNCS.tnsmi_reload_soundpack_cards()

    local opt_cycle = create_option_cycle(TNSMI.cycle_config)
    opt_cycle.nodes[2].nodes[1].nodes[1].config.func = 'tnsmi_shoulder_buttons'
    opt_cycle.nodes[2].nodes[1].nodes[3].config.func = 'tnsmi_shoulder_buttons'


    local t = {
        {n = G.UIT.R, config = {align = "cm", colour = G.C.BLACK, r = 0.2, minh = 0.8, padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cl"}, nodes = {
                {n = G.UIT.T, config = {align = 'cl', text = localize("tnsmi_manager_loaded"), padding = 0.1, scale = 0.25, colour = lighten(G.C.GREY,0.2), vert = true}},
            }},
            {n = G.UIT.C, config = {align = "cr", func = 'tnsmi_change_priority'}, nodes = {
                {n = G.UIT.O, config = {align = 'cr', minw = 6, object = TNSMI.cardareas.priority}}
            }},
        }},
        {n = G.UIT.R, config = {align = "cr", padding = 0}, nodes = {
            {n = G.UIT.C, config = {align = "cr", padding = 0.1}, nodes = {
                 {n = G.UIT.T, config = {ref_table = TNSMI, ref_value = 'search_text', scale = 0.25, colour = lighten(G.C.GREY, 0.2)}},
            }},
            {n = G.UIT.C, config = {align = "cr", colour = {G.C.L_BLACK[1], G.C.L_BLACK[2], G.C.L_BLACK[3], 0.5}, r = 0.2, padding = 0.1, minw = 3.5}, nodes = {
                create_text_input({max_length = 12, w = 3.5, ref_table = TNSMI, ref_value = 'prompt_text_input'}),
                {n = G.UIT.C, config = {align = "cm", minw = 0.2, minh = 0.2, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, shadow = true, button = "tnsmi_reload_soundpack_cards"}, nodes = {
                    {n = G.UIT.R, config = {align = "cm", padding = 0.05, minw = 1.5}, nodes = {
                        {n = G.UIT.T, config = {text = localize("tnsmi_filter_label"), scale = 0.4, colour = G.C.UI.TEXT_LIGHT}}
                    }}
                }},
            }},

        }},

        {n = G.UIT.R, config = {align = "cm", colour = G.C.BLACK, r = 0.2, minh = 4, padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", colour = G.C.CLEAR}, nodes = area_nodes}
        }},
        opt_cycle
    }

    -- uses the same function as most Overlay Menu calls
    return create_UIBox_generic_options({ contents = t, back_func = 'settings', snap_back = nil })
end

--- Definition for the soundpack button that appears in the Options > Audio menu
function G.UIDEF.tnsmi_soundpack_button(card)
    local priority = card.area and card.area == TNSMI.cardareas.priority
    local text = priority and 'b_remove' or 'b_select'
    local color = priority and  G.C.RED or G.C.GREEN
    return {
        n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.5*card.T.h, hover = true, shadow = true, colour = color, one_press = true, button = 'tnsmi_toggle_soundpack'}, nodes={
                {n=G.UIT.T, config={text = localize(text), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
            }},
        }
    }
end

-- This function is weird as hell
-- there's no easy way to set a tab other than in the tab definition function
-- So this kinda fudges it to set the audio tab as chosen if tabs are being created from the soundpack menu (I.E. back to the settings menu)
local ref_create_tabs = create_tabs
function create_tabs(args)
    if args.tabs then
        local reset_chosen = false
        for i = #args.tabs, 1, -1 do
            if args.tabs[i].tab_definition_function_args == 'Audio' and G.OVERLAY_MENU.config.id == 'tnsmi_soundpack_menu' then
                args.tabs[i].chosen = true
                reset_chosen = true
                break
            end
        end

        if reset_chosen then
           for i = #args.tabs, 1, -1 do
                if args.tabs[i].tab_definition_function_args ~= 'Audio' then
                    args.tabs[i].chosen = false
                end
            end
        end
    end

    return ref_create_tabs(args)
end





---------------------------
--------------------------- Palette editor
---------------------------

function number_text_input(args)
    args = args or {}

    args.colour = copy_table(args.colour) or copy_table(G.C.BLUE)
    args.hooked_colour = copy_table(args.hooked_colour) or darken(copy_table(G.C.BLUE), 0.3)
    args.text_colour = copy_table(args.text_colour) or copy_table(G.C.UI.TEXT_LIGHT)

    args.w = args.w or 2.5
    args.h = args.h or 0.7
    args.text_scale = args.text_scale or 0.4


    args.max_length = args.max_length or 16
    args.id = args.id or "number_text_input"
    args.number_text_input = true

    local last_digit = '9'
    if args.corpus_type == 'numeric_base10' then
        args.corpus = "1234567890"
    elseif args.corpus_type == 'numeric_base10_dec' then
        args.corpus = "1234567890."
    elseif args.corpus_type == 'numeric_base16' then
        args.corpus = "1234567890ABCDEF"
        last_digit = 'F'
    else
        args.corpus_type = 'numeric_base10'
        args.corpus = "1234567890"
    end

    args.min = args.min or 0
    if not args.max then
        local max_val = ''
        while #max_val < args.max_length do
            max_val = max_val..last_digit
        end

        args.max = tonumber(max_val, last_digit == 'F' and 16 or nil)
    end

    local string_val = tostring(args.ref_table[args.ref_value])
    if args.left_padding then
        while #string_val < args.max_length do
            string_val = '0'..string_val
        end
    end
    args.ref_table[args.ref_value] = string_val

    local text = {
        ref_table = args.ref_table,
        ref_value = args.ref_value,
        letters = {},
        current_position = string.len(string_val)
    }

    local ui_letters = {}
    for i = 1, args.max_length do
        text.letters[i] = string.sub(string_val, i, i) or ''
        ui_letters[#ui_letters+1] = {n=G.UIT.T, config={ref_table = text.letters, ref_value = i, scale = args.text_scale, colour = args.text_colour, id = args.id..'_letter_'..i}}
    end

    table.insert(ui_letters, text.current_position+1, {n=G.UIT.B, config={r = 0.03, w=0, h=args.h*0.7, colour = lighten(copy_table(G.C.BLUE), 0.4), id = args.id..'_position', func = 'flash'}})
    args.text = text

    return {
        n = (args.row and G.UIT.R or G.UIT.C),
        config = {
            id = args.id,
            align = "cm",
            r = 0.1,
            res = 0.45,
            hover = true,
            colour = args.colour,
            minw = args.w,
            minh = args.h,
            button = 'number_select_text_input',
            func = 'number_text_input',
            emboss = 0.05,
            ref_table = args
        },
        nodes = ui_letters
    }
end

function arrow_create_rgb_slider(args)
    args.w = args.w or 1.2
    args.h = args.h or 0.8
    args.text_scale = args.text_scale or 0.3
    args.min = args.min or 0
    args.max = args.max or 255
    local startval = args.w * ((tonumber(args.ref_table[args.ref_value]) or args.ref_table[args.ref_value]) - args.min)/(args.max - args.min)

    return {n=G.UIT.C, config={align = "cm", minw = args.w, focus_args = {type = 'slider'}}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = args.h}, nodes={
            {n=G.UIT.R, config={id = args.id, align = "cl", r = 0.1, res = 0.45, colour = G.C.UI.TEXT_LIGHT, emboss = 0.05, padding = 0.03, collideable = true, func = 'arrow_rgb_slider', insta_func = 'arrow_rgb_slider_insta'}, nodes={
                {n=G.UIT.R, config={id = 'arrow_rgb_slider', minw = args.w * 0.7, minh = args.h, r = 0.1, res = 0.45, ref_table = args}, nodes = {
                    {n=G.UIT.B, config={slider_point = true, w = startval * 0.7, h = args.h}},
                }},
            }}
        }},
        {n=G.UIT.B, config={align = 'cm', w = 0.1, h = 0.1}},
        number_text_input({
            id = args.id and args.id..'_text_input' or 'arrow_rgb_text_input',
            max_length = 3,
            text_scale = args.text_scale,
            h = args.h*1.2,
            w = args.w * 0.3,
            corpus_type = 'numeric_base10',
            colour = G.C.UI.BACKGROUND_DARK,
            hooked_colour = darken(G.C.UI.BACKGROUND_DARK, 0.3),
            min = args.min,
            max = args.max,
            true_table = args.ref_table,
            ref_table = args.display_table,
            ref_value = args.ref_value,
            callback = function(display_table, true_table, ref_value, slider_id)
                true_table[ref_value] = tonumber(display_table[ref_value])

                -- update palette color
                local current_palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set].current_palette
                local color
                if ArrowAPI.palette_ui_config.open_palette.current_override then
                    -- set the palette override
                    color = current_palette[ArrowAPI.palette_ui_config.open_palette.idx].overrides[ArrowAPI.palette_ui_config.open_palette.current_override]
                    color.changed_flag = true
                else
                    color = current_palette[ArrowAPI.palette_ui_config.open_palette.idx]
                end

                local start_idx = (ArrowAPI.palette_ui_config.open_palette.grad_idx - 1) * 3
                color[start_idx + ref_value] = true_table[ref_value]

                -- update other visuals
                update_hex_input(ArrowAPI.palette_ui_config.display_rgb)
                G.FUNCS.arrow_rgb_slider(G.OVERLAY_MENU:get_UIE_by_ID(slider_id), true)
            end,
            callback_args = {args.display_table, args.ref_table, args.ref_value, args.id}
        }),
    }}
end

function arrow_create_grad_widget(args)
    args.w = args.w or 1
    args.h = args.h or 0.8
    args.id = args.id or 'arrow_grad_widget'
    local subh = args.h > 0.35 and 0.35 or args.h/2
    local mainh = args.h - subh
    args.grad_points = args.grad_points or {selected = nil, min_points = 1, max_points = 8, {pos = 0, color = {255, 255, 255}}}

    return {n=G.UIT.C, config={align = "cm", focus_args = {type = 'slider'}}, nodes={
        {n=G.UIT.R, config = {id = args.id and args.id..'_pointers', minw = args.w, minh = subh, grad_points = args.grad_points, collideable = true, func = 'arrow_grad_pointers'}, nodes={
        }},
        {n=G.UIT.R, config={align = "cm", colour = G.C.UI.TEXT_LIGHT, emboss = 0.05, r = 0.1, res = 0.45, minw = args.w, minh = mainh, padding = 0.025}, nodes={
            {
                n=G.UIT.R,
                config={
                    id = args.id and args.id..'_box',
                    align = "cl",
                    minw = args.w-0.05,
                    minh=mainh-0.05,
                    r = 0.1,
                    ref_table = args,
                    grad_colour = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set].current_palette[1],
                    collideable = true,
                    func = 'arrow_grad_box'
                },
                nodes={}
            }
        }},
    }}
end

function arrow_create_angle_widget(args)
    args.w = args.w or 1
    args.h = args.h or 1
    args.mode = args.mode or 'linear' -- alt is 'radial'
    args.selected = nil

    -- in linear mode, the first point is always along the outside of the node, while the second point is static in the center
    -- in radial mode, both points can be dragged. The second point is the center and the first point determines the radius relative to the first
    args.point = {x = 1, y = 0}

    return {n=G.UIT.C, config={align = "cm", minw = args.w, minh = args.w, padding = 0.05, focus_args = {type = 'slider'}}, nodes={
            {n=G.UIT.R, config={id = 'arrow_angle_widget', align = "cm", minw = args.w-0.1, minh = args.h-0.1, ref_table = args, collideable = true, func = 'arrow_angle_widget', refresh_movement = true}, nodes={
        }},
    }}
end

local palette_order = {
    Tarot = 1,
    Planet = 2,
    Spectral = 3,
    Background = 4,
    Hearts = 5,
    Spades = 6,
    Diamonds = 7,
    Clubs = 8
}

function arrow_create_UIBox_palette_menu()
    -- clear additional garbage
    local palette_tabs = {}
    for k, v in pairs(ArrowAPI.colors.palettes) do
        if (v.items and #v.items > 0) or k == 'Background' then
            local loc = localize('b_arrow_pal_'..string.lower(k))
            palette_tabs[#palette_tabs+1] = {
                label = loc ~= 'ERROR' and loc or k,
                tab_definition_function = G.UIDEF.arrow_palette_tab,
                tab_definition_function_args = k
            }
        end
    end

    table.sort(palette_tabs, function(a, b)
        return palette_order[a.tab_definition_function_args] < palette_order[b.tab_definition_function_args]
    end)

    palette_tabs[1].chosen = true
    if not ArrowAPI.palette_ui_config.open_palette then
        ArrowAPI.palette_ui_config.open_palette = {set = palette_tabs[1].tab_definition_function_args, idx = 1, grad_idx = 1}
    end

    ArrowAPI.palette_ui_config.tabs_config = {tabs = palette_tabs, snap_to_nav = true}
    local tabs = create_tabs(ArrowAPI.palette_ui_config.tabs_config)

    -- set the tabs to be the set colors
    local tab_buttons = tabs.nodes[1].nodes[2].nodes
    for i = 1, #tab_buttons do
        local set = palette_tabs[i].tab_definition_function_args
        local tab_colour = ArrowAPI.colors.badge_colours[set] or G.C.RED
        tab_buttons[i].nodes[1].config.colour = tab_colour
        tab_buttons[i].nodes[1].config.minh = tab_buttons[i].nodes[1].config.minh * 0.75

        local label_node = tab_buttons[i].nodes[1].nodes[1]
        label_node.config.minw = label_node.config.minw * 0.75

        local button_text = tab_buttons[i].nodes[1].nodes[1].nodes[1]
        button_text.config.scale = button_text.config.scale * 0.75
    end

    return create_UIBox_generic_options({back_func = 'settings', contents = {tabs}})
end

function G.UIDEF.arrow_palette_tab(tab)
    local tab_config = ArrowAPI.palette_ui_config.tabs_config
    for k, v in ipairs(tab_config.tabs) do
        if v.tab_definition_function_args == tab then tab_config.current = {k = k, v = v} end
    end

    ArrowAPI.colors.use_custom_palette(tab, ArrowAPI.config.saved_palettes[tab].saved_index)
    local palette = ArrowAPI.colors.palettes[tab]


    ----------------- initial palette setup
    if tab ~= ArrowAPI.palette_ui_config.open_palette.set then
        ArrowAPI.palette_ui_config.open_palette = {set = tab, idx = 1, grad_idx = 1}
    end

    local idx = ArrowAPI.palette_ui_config.open_palette.idx

    local current_palette = palette.current_palette
    local button_color = current_palette[idx]

    local start_idx = (ArrowAPI.palette_ui_config.open_palette.grad_idx - 1) * 3

    ArrowAPI.palette_ui_config.rgb = {button_color[start_idx + 1], button_color[start_idx + 2], button_color[start_idx + 3]}
    ArrowAPI.palette_ui_config.display_rgb = {
        tostring(ArrowAPI.palette_ui_config.rgb[1]),
        tostring(ArrowAPI.palette_ui_config.rgb[2]),
        tostring(ArrowAPI.palette_ui_config.rgb[3]),
    }

    ----------------- palette_items
    local deck_tables = {}
    local items_per_page = 0
    local items = {}

    ArrowAPI.palette_ui_config.item_page_config = {
        options = {'Page 1'},
        w = 5,
        h = 0.6,
        opt_callback = 'arrow_palette_page',
        current_option = 1,
        colour = G.C.RED,
        no_pips = true,
        focus_args = {snap_to = true, nav = 'wide'}
    }

    if tab ~= 'Background' then
        local w_mod = 0.85
        local h_mod = 0.85
        items = palette.items

        G.arrow_palette_collection = {current_page_option = 1}
        local num_rows = 2
        local num_columns = 5
        items_per_page = num_rows * num_columns
        for i = 1, num_rows do
            G.arrow_palette_collection[i] = CardArea(
                0,
                0,
                (w_mod*num_columns+0.15)*G.CARD_W,
                h_mod*G.CARD_H,
                {card_limit = num_columns, type = 'title', highlight_limit = 99, collection = true}
            )
            G.arrow_palette_collection[i].can_highlight = function()
                return true
            end

            G.arrow_palette_collection[i].align_cards = function(self)
                for k, card in ipairs(self.cards) do
                    if not card.states.drag.is then
                        card.T.r = 0.03*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
                        local max_cards = math.max(#self.cards, self.config.temp_limit)
                        card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self.card_w - card.T.w) + card.shadow_parrallax.x/30
                        local highlight_height = card.highlighted and G.HIGHLIGHT_H * 0.5 or 0
                        card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - highlight_height + (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(0.666*G.TIMERS.REAL+card.T.x)
                    end
                end
                table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
                for k, card in ipairs(self.cards) do
                    card.rank = k
                end
            end

            table.insert(deck_tables,
            {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
                {n=G.UIT.O, config={object = G.arrow_palette_collection[i]}}
            }})
        end

        G.FUNCS.arrow_palette_page = function(e)
            -- this is specifically for making sure the current option value is updated
            -- if this is updated without using G.FUNCS.option_cycle

            for j = 1, #G.arrow_palette_collection do
                for i = #G.arrow_palette_collection[j].cards, 1, -1 do
                    local c = G.arrow_palette_collection[j]:remove_card(G.arrow_palette_collection[j].cards[i])
                    c:remove()
                    c = nil
                end
            end

            local current_page = e and e.cycle_config.current_option or G.arrow_palette_collection.current_page_option

            local palette = ArrowAPI.colors.palettes[ArrowAPI.palette_ui_config.open_palette.set]
            local palette_color = palette.current_palette[ArrowAPI.palette_ui_config.open_palette.idx]

            local display_items = {}
            for i = 1, #items do
                local item = items[i]
                for _, atlas_data in pairs(palette.image_data.pixel_map) do
                    local main_data = atlas_data[item.key]
                    local soul_data = atlas_data[item.key..'_soul']
                    if (main_data and main_data[palette_color.key]) or (soul_data and soul_data[palette_color.key]) then
                        display_items[#display_items+1] = {
                            item = item,
                            override_status = palette_color.overrides[item.item_key] and 'active' or 'inactive'
                        }
                    elseif (main_data or soul_data) and not ArrowAPI.palette_ui_config.color_specific then
                        display_items[#display_items+1] = {
                            item = item,
                            override_status = 'disabled'
                        }
                    end
                end
            end

            local num_pages = math.max(1, math.ceil(#display_items / items_per_page))
            current_page = math.min(current_page, num_pages)
            G.arrow_palette_collection.current_page_option = current_page

            local config_args = ArrowAPI.palette_ui_config.item_page_config
            for i = 1, math.max(num_pages, #config_args.options) do
                config_args.options[i] = i <= num_pages and (localize('k_page')..' '..tostring(i)..'/'..tostring(num_pages)) or nil
            end

            config_args.current_option = current_page
            config_args.current_option_val = config_args.options[config_args.current_option]

            local start_idx = (current_page - 1) * items_per_page

            local row_idx = 1
            local col_idx = 0

            local num_iterations = math.min(items_per_page, #display_items - start_idx)
            for i = 1, num_iterations do
                col_idx = col_idx + 1

                local item = display_items[start_idx + i].item
                local center_key = item.item_key or item.key
                local center = G.P_CENTERS[(item.table == 'SEALS' or item.table == 'CARDS') and 'c_base' or center_key]
                local disp_card = Card(
                    G.arrow_palette_collection[row_idx].T.x + G.arrow_palette_collection[row_idx].T.w/2,
                    G.arrow_palette_collection[row_idx].T.y,
                    G.CARD_W * 0.85,
                    G.CARD_H * 0.85,
                    G.P_CARDS[item.table == 'CARDS' and center_key or 'empty'],
                    {
                        key = center_key,
                        name = "Palette Card",
                        atlas = center.atlas,
                        pos = center.pos,
                        soul_pos = center_key == 'c_soul' and {x = 9, y = 2} or center.soul_pos,
                        no_soul_shadow = center.no_soul_shadow,
                        set = center.set,
                        label = 'Palette Card',
                        config = {},
                        generate_ui = function() end
                    },
                    {
                        arrow_palette_card = display_items[start_idx + i].override_status ~= 'disabled' and item.key or nil,
                        bypass_discovery_center = true
                    }
                )

                disp_card.no_ui = true

                if display_items[start_idx + i].override_status == 'active' then
                    disp_card.arrow_palette_outline = true
                elseif display_items[start_idx + i].override_status == 'disabled' then
                    disp_card.greyed = true
                end

                if item.front_atlas then
                    disp_card.children.front.atlas = G.ASSET_ATLAS[item.front_atlas]
                    disp_card.children.front:set_sprite_pos(item.front_pos)
                end

                if item.table == 'SEALS' then disp_card:set_seal(item.key, true) end

                --disp_card:start_materialize(nil, i>1 or j>1)
                G.arrow_palette_collection[row_idx]:emplace(disp_card)

                if col_idx == num_columns then
                    col_idx = 0
                    row_idx = row_idx + 1
                end
            end
        end

        G.FUNCS.arrow_palette_page{cycle_config = { current_option = 1 }}
    else
        items_per_page = 1
        items = {
            {key = 'palette_bkg_standard', args = {new_colour = G.C.BLIND.Small, contrast = 3}},
            {key = 'palette_bkg_boss', args = {new_colour = G.C.BLIND.SHOWDOWN_COL_2, special_colour = G.C.BLIND.SHOWDOWN_COL_1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}},
            {key = 'palette_bkg_endless', args = {new_colour = G.C.BLIND.won, contrast = 3}}
        }

        G.ARROW_DUMMY_BACKGROUND = {
            L = {1, 1, 1, 1},
            D = {1, 1, 1, 1},
            C = {1, 1, 1, 1},
            contrast = 0,
            amount = 0,
            real = 0,
            eased = 0,
            current_page_option = 1
        }

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            blocking = false,
            blockable = false,
            func = function()
                if ArrowAPI.palette_ui_config.open_palette.set ~= 'Background' then
                    -- return whenever this is no longer amanging the background
                    return true
                end
                local _dt = G.ARROW_DUMMY_BACKGROUND.amount > G.ARROW_DUMMY_BACKGROUND.eased and G.real_dt*2. or 0.3*G.real_dt
                local delta = G.ARROW_DUMMY_BACKGROUND.real - G.ARROW_DUMMY_BACKGROUND.eased
                if math.abs(delta) > _dt then delta = delta*_dt/math.abs(delta) end
                G.ARROW_DUMMY_BACKGROUND.eased = G.ARROW_DUMMY_BACKGROUND.eased + delta
                G.ARROW_DUMMY_BACKGROUND.amount = _dt*(G.ARROW_DUMMY_BACKGROUND.eased) + (1 - _dt)*G.ARROW_DUMMY_BACKGROUND.amount
                G.TIMERS.BACKGROUND = G.TIMERS.BACKGROUND - 60*(G.ARROW_DUMMY_BACKGROUND.eased - G.ARROW_DUMMY_BACKGROUND.amount)*_dt
            end
        }))

        if G.arrow_background_palette then G.arrow_background_palette:remove() end
        G.arrow_background_palette = Sprite(0, 0, 7, 5, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
        G.arrow_background_palette:define_draw_steps({{
            shader = 'background',
            send = {
                {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
                {name = 'spin_time', ref_table = G.TIMERS, ref_value = 'BACKGROUND'},
                {name = 'colour_1', ref_table = G.ARROW_DUMMY_BACKGROUND, ref_value = 'C'},
                {name = 'colour_2', ref_table = G.ARROW_DUMMY_BACKGROUND, ref_value = 'L'},
                {name = 'colour_3', ref_table = G.ARROW_DUMMY_BACKGROUND, ref_value = 'D'},
                {name = 'contrast', ref_table = G.ARROW_DUMMY_BACKGROUND, ref_value = 'contrast'},
                {name = 'spin_amount', ref_table = G.ARROW_DUMMY_BACKGROUND, ref_value = 'amount'}
            }}})

        deck_tables[1] = {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
            {n=G.UIT.O, config={object = G.arrow_background_palette}}
        }}

        local config_args = ArrowAPI.palette_ui_config.item_page_config
        for i = 1, #items do
            config_args.options[i] = localize(items[i].key)..' ('..i..'/'..#items..')'
        end

        G.FUNCS.arrow_palette_page = function(e)
            G.ARROW_DUMMY_BACKGROUND.current_page_option = e and e.cycle_config.current_option or  G.ARROW_DUMMY_BACKGROUND.current_page_option
            local args = items[G.ARROW_DUMMY_BACKGROUND.current_page_option].args

            local color_c = args.special_colour or args.new_colour
            local color_l = args.new_colour
            local color_d = args.tertiary_colour or args.new_colour
            local bright_c = 0.9
            local bright_l = 1.3
            local bright_d = 0.7
            if args.special_colour and args.tertiary_colour then
                bright_c = 1
                bright_l = 1
                bright_d = 1
            end

            G.ARROW_DUMMY_BACKGROUND.C[1] = color_c[1]*bright_c
            G.ARROW_DUMMY_BACKGROUND.C[2] = color_c[2]*bright_c
            G.ARROW_DUMMY_BACKGROUND.C[3] = color_c[3]*bright_c
            G.ARROW_DUMMY_BACKGROUND.C[4] = 1

            G.ARROW_DUMMY_BACKGROUND.L[1] = color_l[1]*bright_l
            G.ARROW_DUMMY_BACKGROUND.L[2] = color_l[2]*bright_l
            G.ARROW_DUMMY_BACKGROUND.L[3] = color_l[3]*bright_l
            G.ARROW_DUMMY_BACKGROUND.L[4] = 1

            G.ARROW_DUMMY_BACKGROUND.D[1] = color_d[1]*bright_d
            G.ARROW_DUMMY_BACKGROUND.D[2] = color_d[2]*bright_d
            G.ARROW_DUMMY_BACKGROUND.D[3] = color_d[3]*bright_d
            G.ARROW_DUMMY_BACKGROUND.D[4] = 1

            G.ARROW_DUMMY_BACKGROUND.contrast = args.contrast
        end

        G.FUNCS.arrow_palette_page{cycle_config = { current_option = 1 }}
    end

    -- fix the option cycle to always allow page cycling
    local item_page_cycle = create_option_cycle(ArrowAPI.palette_ui_config.item_page_config)
    local left_shoulder = item_page_cycle.nodes[1].nodes[1]
    left_shoulder.config.hover = true
    left_shoulder.config.colour = G.C.RED
    left_shoulder.config.shadow = true
    left_shoulder.config.button = 'option_cycle'
    left_shoulder.nodes[1].config.colour = G.C.UI.TEXT_LIGHT

    local right_shoulder = item_page_cycle.nodes[1].nodes[3]
    right_shoulder.config.hover = true
    right_shoulder.config.colour = G.C.RED
    right_shoulder.config.shadow = true
    right_shoulder.config.button = 'option_cycle'
    right_shoulder.nodes[1].config.colour = G.C.UI.TEXT_LIGHT


    ----------------- palette buttons
    local width = 6
    local color_nodes = {}
    local row_count = 8
    local row_idx = 0
    local count = 0

    local default_palette = palette.default_palette
    local button_size = width / row_count * (0.95 - #default_palette * 0.01)

    for i=1, #default_palette do
        local default_color = default_palette[i]
        local custom_color = current_palette[i]

        if count % row_count == 0 then
            row_idx = row_idx + 1
            color_nodes[row_idx] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={}}
        end

        local default_id = 'arrow_palette_default_'..i
        local button_id = 'arrow_palette_button_'..i
        color_nodes[row_idx].nodes[#color_nodes[row_idx].nodes+1] = {
            n=G.UIT.C, config={
                id = 'arrow_palette_wrapper',
                align = "cm",
                res = 0.3,
                colour = i == ArrowAPI.palette_ui_config.open_palette.idx and G.C.FILTER or G.C.UI.TEXT_LIGHT,
                padding = 0.037,
                r = 0.02,
                shadow = true,
            },
            nodes={
                {n = G.UIT.R,
                    config = {
                        palette_idx = i,
                        id = default_id,
                        button = 'arrow_palette_reset',
                        align = "cm",
                        minw = button_size,
                        minh = button_size*0.35,
                        hover = true,
                        r = 0.05,
                        button_dist = 0.05,
                        res = 0.3,
                        grad_colour = default_color,
                        emboss = 0.025,
                        tooltip = {text = {"Reset Color"}}
                    },
                    nodes = {}
                },
                {n = G.UIT.R,
                    config = {
                        palette_idx = i,
                        id = button_id,
                        button = 'arrow_palette_button',
                        align = "cm",
                        minw = button_size,
                        minh = button_size * 0.65,
                        hover = true,
                        r = 0.01,
                        button_dist = 0.05,
                        res = 0.3,
                        grad_colour = custom_color,
                        emboss = 0.025

                    },
                    nodes = {
                        custom_color.key == 'badge' and {n = G.UIT.T, config = {text = localize('arrow_pal_badge_text'), colour = G.C.UI.TEXT_LIGHT, shadow = true, scale = button_size * 0.3}} or nil
                    }
                }
            }
        }
        custom_color = nil
        count = count + 1
    end

    ----------------- hex input
    local new_hex_string = string.upper(tostring(string.format("%02x", button_color[1])..string.format("%02x", button_color[2])..string.format("%02x", button_color[3])))
    ArrowAPI.palette_ui_config.hex_input = new_hex_string

    ArrowAPI.palette_ui_config.hex_input_config = {
        id = 'arrow_hex_input',
        max_length = 6,
        left_padding = true,
        w = 1.4,
        colour = G.C.UI.BACKGROUND_DARK,
        corpus_type = 'numeric_base16',
        hooked_colour = darken(G.C.UI.BACKGROUND_DARK, 0.3),
        ref_table = ArrowAPI.palette_ui_config,
        ref_value = 'hex_input',
        callback = function(i)
            i = i or ArrowAPI.palette_ui_config.hex_input
            local hex_str = tostring(i)

            ArrowAPI.palette_ui_config.rgb[1] = math.min(255, math.max(0, tonumber(hex_str:sub(1, 2), 16) or 0))
            ArrowAPI.palette_ui_config.rgb[2] = math.min(255, math.max(0, tonumber(hex_str:sub(3, 4), 16) or 0))
            ArrowAPI.palette_ui_config.rgb[3] = math.min(255, math.max(0, tonumber(hex_str:sub(5, 6), 16) or 0))

            ArrowAPI.palette_ui_config.display_rgb[1] = tostring(ArrowAPI.palette_ui_config.rgb[1])
            ArrowAPI.palette_ui_config.display_rgb[2] = tostring(ArrowAPI.palette_ui_config.rgb[2])
            ArrowAPI.palette_ui_config.display_rgb[3] = tostring(ArrowAPI.palette_ui_config.rgb[3])

            -- fix the sliders
            local sliders = {
                G.OVERLAY_MENU:get_UIE_by_ID('r_slider'),
                G.OVERLAY_MENU:get_UIE_by_ID('g_slider'),
                G.OVERLAY_MENU:get_UIE_by_ID('b_slider')
            }
            for i = 1, #sliders do
                G.FUNCS.arrow_rgb_slider(sliders[i], true)
                -- update text letters
                local display_str = ArrowAPI.palette_ui_config.display_rgb[i]
                local text_config = sliders[i].parent.parent.children[3].config.ref_table
                for i = 1, text_config.max_length do
                    text_config.text.letters[i] = (i <= #display_str) and string.sub(display_str, i, i) or ''
                end
            end

            local grad_points = ArrowAPI.palette_ui_config.grad_widget_config.grad_points
            local grad_idx = ArrowAPI.palette_ui_config.open_palette.grad_idx
            grad_points[grad_idx].color = {
                ArrowAPI.palette_ui_config.rgb[1],
                ArrowAPI.palette_ui_config.rgb[2],
                ArrowAPI.palette_ui_config.rgb[3]
            }

            local idx = ArrowAPI.palette_ui_config.open_palette.idx
            local palette_color

            if ArrowAPI.palette_ui_config.open_palette.current_override then
                palette_color = palette.current_palette[idx].overrides[ArrowAPI.palette_ui_config.open_palette.current_override]
                palette.current_palette[idx].overrides.changed_flag = true
            else
                palette_color = palette.current_palette[idx]
            end

            local start_idx = (grad_idx - 1) * 3
            palette_color[start_idx + 1] = ArrowAPI.palette_ui_config.rgb[1]
            palette_color[start_idx + 2] = ArrowAPI.palette_ui_config.rgb[2]
            palette_color[start_idx + 3] = ArrowAPI.palette_ui_config.rgb[3]

            local tab_contents = G.OVERLAY_MENU:get_UIE_by_ID('tab_contents')
            tab_contents.UIBox:recalculate()
        end
    }

    function G.FUNCS.arrow_palette_paste_hex(e)
        local raw_clipboard = (G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()) or ''
        if not raw_clipboard then return end
        local clean_hex = raw_clipboard:gsub("#", ""):gsub("[^%x]", ""):upper()
        local clipboard = clean_hex

        G.CONTROLLER.text_input_hook = e.UIBox:get_UIE_by_ID('arrow_hex_input')
        G.CONTROLLER.text_input_id = 'arrow_hex_input'
        for i = 1, 6 do G.FUNCS.text_input_key({key = 'right'}) end
        for i = 1, 6 do G.FUNCS.text_input_key({key = 'backspace'}) end
        for i = 1, #clipboard do
            local c = clipboard:sub(i,i)
            G.FUNCS.text_input_key({key = c})
        end
        G.FUNCS.text_input_key({key = 'return'})

        local tab_contents = G.OVERLAY_MENU:get_UIE_by_ID('tab_contents')
        tab_contents.UIBox:recalculate()
        ArrowAPI.palette_ui_config.hex_input_config.callback(clipboard)
    end


    ----------------- name input
    ArrowAPI.palette_ui_config.name_input_config = {
        id = 'arrow_save_name_input',
        max_length = 15,
        h = 1,
        w = 2.65,
        colour = G.C.UI.BACKGROUND_DARK,
        hooked_colour = darken(G.C.UI.BACKGROUND_DARK, 0.3),
        prompt_text = 'Enter Name',
        ref_table = ArrowAPI.palette_ui_config,
        ref_value = 'name_input'
    }

    ArrowAPI.palette_ui_config.name_input = ArrowAPI.config.saved_palettes[tab][ArrowAPI.config.saved_palettes[tab].saved_index].name


    ----------------- palette preset cycle
    local preset_options = {}
    for _, v in ipairs(ArrowAPI.config.saved_palettes[tab]) do
        preset_options[#preset_options+1] = v.name
    end

    ArrowAPI.palette_ui_config.preset_cycle_config = {
        options = preset_options,
        h = 0.6,
        w = 6.5,
        cycle_shoulders = true,
        current_option = ArrowAPI.config.saved_palettes[tab].saved_index,
        colour = G.C.ORANGE,
        opt_callback = 'arrow_load_palette_preset',
        focus_args = {snap_to = true, nav = 'wide'}
    }
    local preset_cycle = create_option_cycle(ArrowAPI.palette_ui_config.preset_cycle_config)
    preset_cycle.nodes[1].config.minw = nil
    preset_cycle.nodes[3].config.minw = nil


    ----------------- grad widget
    local size = #button_color.grad_pos
    local grad_points = {selected = nil, min_points = 1, max_points = 8}
    for i=1, size do
        local start_idx = (i-1) * 3
        grad_points[i] = {pos = button_color.grad_pos[i], color = {button_color[start_idx+1], button_color[start_idx+2], button_color[start_idx+3]}}
    end

    ArrowAPI.palette_ui_config.grad_widget_config = {
        id = 'arrow_grad_widget',
        w = 3,
        h = 0.75,
        grad_points = grad_points
    }

    local radial = button_color.grad_config.mode == 'radial'
    local start_point = {}
    if not radial then
        start_point.x = math.cos(button_color.grad_config.val)
        start_point.y = math.sin(button_color.grad_config.val)
    else
        start_point.x = button_color.grad_config.pos[1]
        start_point.y = button_color.grad_config.pos[2]
    end

    ArrowAPI.palette_ui_config.angle_widget_config = {
        w = 1,
        h = 1,
        value = button_color.grad_config.val,
        display_val = tostring(radial and button_color.grad_config.val or math.deg(button_color.grad_config.val)),
        point = start_point,
        mode = button_color.grad_config.mode,
        linear_toggle = not radial,
        radial_toggle = radial,
        label_1 = localize('k_label_'..button_color.grad_config.mode),
    }

    ----------------- put it all together
    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes={
                {n=G.UIT.R, config={align = "cm", minw = 7}, nodes={
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        preset_cycle
                    }},
                    {n=G.UIT.R, config={align = "tm", minh = 0.8}, nodes={
                        {n=G.UIT.C, config={align = "tm"}, nodes={
                            {n=G.UIT.C, config={align = "tm", minw = 2.8}, nodes={
                                create_text_input(ArrowAPI.palette_ui_config.name_input_config)
                            }},
                        }},
                        {n=G.UIT.C, config={align = "tm", minw = 1.575}, nodes={
                            {n=G.UIT.C, config={align = "tm", minw = 1.4, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, button = 'arrow_save_palette', func = 'arrow_can_save_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                                {n=G.UIT.T, config={align = 'tm', text = localize('b_save_palette'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                            }},
                        }},
                        {n=G.UIT.C, config={align = "tm", minw = 1.575}, nodes={
                            {n=G.UIT.C, config={align = "tm", minw = 1.4, padding = 0.1, r = 0.1, hover = true, colour = G.C.RED, button = 'arrow_delete_palette', func = 'arrow_can_delete_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                                {n=G.UIT.T, config={align = 'tm', text = localize('b_delete_palette'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                            }},
                        }},
                    }},
                    {n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.2, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables},
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            create_toggle({
                                label = localize('arrow_pal_color_specific'),
                                ref_table = ArrowAPI.palette_ui_config,
                                ref_value = 'color_specific',
                                label_scale = 0.2,
                                w = 0.4,
                                h = 0.4,
                                scale = 0.55,
                                callback = function()
                                    G.FUNCS.arrow_palette_page()
                                end
                            }),
                        }},
                        {n=G.UIT.C, config={align = "cm", minw = 0.35}, nodes={}},
                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            item_page_cycle
                        }}
                    }},
                }}
            }},
            {n=G.UIT.C, config={align = "cm", minw = 0.4}, nodes = {}},
            {n=G.UIT.C, config={align = "cm"}, nodes = {
                {n = G.UIT.R, config = {align = "cm", colour = G.C.BLACK, emboss = 0.04, r = 0.1, minh = 4}, nodes = {
                    {n = G.UIT.R, config={align = "cm", minw = width * 0.9, padding = 0.1}, nodes = color_nodes},
                }},
                {n = G.UIT.R, config = {align = "cm"}, nodes = {
                    {n = G.UIT.R, config = {align = "cm"}, nodes = {
                        {n = G.UIT.C, config = {align = "cm"}, nodes = {
                            arrow_create_grad_widget(ArrowAPI.palette_ui_config.grad_widget_config),
                        }},
                        {n = G.UIT.B, config = {align = "cm", w = 0.15, h = 0.1}},
                        {n = G.UIT.C, config = {align = "cm"}, nodes = {
                            arrow_create_angle_widget(ArrowAPI.palette_ui_config.angle_widget_config)
                        }},
                        {n = G.UIT.C, config = {align = "cm", grad_active = true, func = 'arrow_can_edit_gradients'}, nodes = {
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                create_toggle({
                                    col = true,
                                    label = localize('k_gradient_linear'),
                                    label_scale = 0.2,
                                    w = 0.4,
                                    h = 0.4,
                                    scale = 0.55,
                                    ref_table = ArrowAPI.palette_ui_config.angle_widget_config,
                                    ref_value = 'linear_toggle',
                                    callback = function()
                                        local config = ArrowAPI.palette_ui_config.angle_widget_config
                                        config.mode = 'linear'
                                        config.value = 0
                                        config.display_val = '0'
                                        local text_config = G.OVERLAY_MENU:get_UIE_by_ID('arrow_grad_text_input').config.ref_table
                                        for i = 1, text_config.max_length do
                                            text_config.text.letters[i] = (i <= #config.display_val) and string.sub(config.display_val, i, i) or ''
                                        end

                                        config.point.x = 1
                                        config.point.y = 0
                                        config.linear_toggle = true
                                        config.radial_toggle = false
                                        config.label_1 = localize('k_label_linear')

                                        G.CONTROLLER.text_input_hook = nil
                                        G.CONTROLLER.text_input_id = nil
                                        return true
                                    end
                                }),
                                create_toggle({
                                    col = true,
                                    label = localize('k_gradient_radial'),
                                    label_scale = 0.2,
                                    w = 0.4,
                                    h = 0.4,
                                    scale = 0.55,
                                    ref_table = ArrowAPI.palette_ui_config.angle_widget_config,
                                    ref_value = 'radial_toggle',
                                    callback = function()
                                        local config = ArrowAPI.palette_ui_config.angle_widget_config
                                        config.mode = 'radial'
                                        config.value = 1
                                        config.display_val = '1'
                                        local text_config = G.OVERLAY_MENU:get_UIE_by_ID('arrow_grad_text_input').config.ref_table
                                        for i = 1, text_config.max_length do
                                            text_config.text.letters[i] = (i <= #config.display_val) and string.sub(config.display_val, i, i) or ''
                                        end

                                        config.point.x = 0
                                        config.point.y = 0
                                        config.linear_toggle = false
                                        config.radial_toggle = true
                                        config.label_1 = localize('k_label_radial')

                                        G.CONTROLLER.text_input_hook = nil
                                        G.CONTROLLER.text_input_id = nil
                                        return true
                                    end
                                }),
                            }},
                            {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                                {n = G.UIT.C, config = {align = "cm", colour = G.C.UI.TEXT_LIGHT, padding = 0.05, r = 0.1, emboss = 0.05}, nodes = {
                                    {n = G.UIT.R, config = {align = "cm", minw = 0.6}, nodes = {
                                        {n = G.UIT.T, config = {align = "cm", ref_table = ArrowAPI.palette_ui_config.angle_widget_config, ref_value = 'label_1', colour = G.C.UI.TEXT_INACTIVE, scale = 0.25}},
                                    }},
                                    number_text_input({
                                        id = 'arrow_grad_text_input',
                                        row = true,
                                        min = 0,
                                        max = 360,
                                        max_length = 4,
                                        text_scale = 0.32,
                                        w = 0.25,
                                        h = 0.25,
                                        corpus_type = 'numeric_base10_dec',
                                        colour = G.C.CLEAR,
                                        hooked_colour = G.C.CLEAR,
                                        text_colour = G.C.UI.TEXT_DARK,
                                        ref_table = ArrowAPI.palette_ui_config.angle_widget_config,
                                        ref_value = 'display_val',
                                        callback = function()
                                            local angle_config = ArrowAPI.palette_ui_config.angle_widget_config
                                            local num_val = tonumber(angle_config.display_val)
                                            if angle_config.mode == 'linear' then
                                                local rad = math.rad(num_val)
                                                angle_config.value = rad
                                                angle_config.point.x = math.cos(rad)
                                                angle_config.point.y = math.sin(rad)
                                            else
                                                angle_config.value = num_val
                                            end
                                        end,
                                        callback_args = {'value', }
                                    }),
                                }},
                                {n = G.UIT.B, config = {align = "cm", w = 0.05, h = 0.1}},
                                {n = G.UIT.C, config = {align = "cm", colour = G.C.UI.TEXT_LIGHT, padding = 0.05, r = 0.1, emboss = 0.05}, nodes = {
                                    {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                        {n = G.UIT.T, config = {align = "cm", text = localize('k_label_center'), colour = G.C.UI.TEXT_INACTIVE, scale = 0.25}},
                                    }},
                                    {n = G.UIT.R, config = {align = "cm", minw = 1.35}, nodes = {
                                        {n = G.UIT.T, config = {align = "cm", text = '0', colour = G.C.UI.TEXT_DARK, shadow = true, scale = 0.3}},
                                        {n = G.UIT.T, config = {align = "cm", text = ', ', colour = G.C.UI.TEXT_DARK, shadow = true, scale = 0.3}},
                                        {n = G.UIT.T, config = {align = "cm",  text = '0', colour = G.C.UI.TEXT_DARK, shadow = true, scale = 0.3}},
                                    }},
                                }},
                            }},
                        }},
                    }},
                    {n=G.UIT.R, config={align = "cm", minh = 0.15}, nodes = {}},
                    {n = G.UIT.R, config = {align = "cm"}, nodes = {
                        {n = G.UIT.C, config={align = "cm", padding = 0.1}, nodes = {
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                {n = G.UIT.C, config={align = "cm", colour = G.C.UI.TEXT_LIGHT, emboss = 0.05, r = 0.1, res = 0.45, padding = 0.03}, nodes = {
                                    {n = G.UIT.R,
                                        config = {
                                            id = 'arrow_selected_colour',
                                            align = "cm",
                                            minw = 1.3,
                                            minh = 0.5,
                                            func = 'arrow_update_selected_colour',
                                            r = 0.05,
                                            res = 0.45,
                                        },
                                        nodes = {}
                                    }
                                }},
                            }},
                            {n = G.UIT.R, config={align = "cm"}, nodes ={
                                number_text_input(ArrowAPI.palette_ui_config.hex_input_config),
                            }},
                            {n = G.UIT.R, config={align = "cm"}, nodes ={
                                UIBox_button({minw = 1.3, minh = 0.4, button = "arrow_palette_paste_hex", colour = G.C.BLUE, label = {localize('b_arrow_palette_paste_hex')}, scale = 0.35})
                            }},
                        }},
                        {n = G.UIT.C, config={align = "cm", padding = 0.05}, nodes = {
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                arrow_create_rgb_slider({
                                    id = 'r_slider',
                                    w = 4.4,
                                    h = 0.4,
                                    text_scale = 0.32,
                                    ref_table = ArrowAPI.palette_ui_config.rgb,
                                    display_table =  ArrowAPI.palette_ui_config.display_rgb,
                                    ref_value = 1,
                                    min = 0,
                                    max = 255
                                }),
                            }},
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                arrow_create_rgb_slider({
                                    id = 'g_slider',
                                    w = 4.4,
                                    h = 0.4,
                                    text_scale = 0.32,
                                    ref_table = ArrowAPI.palette_ui_config.rgb,
                                    display_table =  ArrowAPI.palette_ui_config.display_rgb,
                                    ref_value = 2,
                                    min = 0,
                                    max = 255
                                }),
                            }},
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                arrow_create_rgb_slider({
                                    id = 'b_slider',
                                    w = 4.4,
                                    h = 0.4,
                                    text_scale = 0.32,
                                    ref_table = ArrowAPI.palette_ui_config.rgb,
                                    display_table =  ArrowAPI.palette_ui_config.display_rgb,
                                    ref_value = 3,
                                    min = 0,
                                    max = 255
                                })
                            }},
                        }},
                    }},
                }},
                {n=G.UIT.R, config={align = "cm", minh = 0.15}, nodes = {}},
                {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm"}, nodes={
                        {n=G.UIT.C, config={align = "cm", minw = 3.5, padding = 0.1, r = 0.1, hover = true, colour = G.C.ORANGE, button = 'arrow_apply_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                            {n=G.UIT.T, config={align = 'cm', text = localize('b_apply_palette'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                        }},
                    }},
                    {n=G.UIT.C, config={align = "cm"}, nodes={
                        {n=G.UIT.C, config={align = "cm", minw = 1.5, padding = 0.1, r = 0.1, hover = true, colour = G.C.GREEN, button = 'arrow_copy_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                            {n=G.UIT.T, config={align = 'cm', text = localize('b_copy_palette'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                        }},
                    }},
                }}
            }}
        }}
    }}
end