-- Mod Icon in Mods tab
SMODS.Atlas({
    key = "modicon",
    path = "arrow_icon.png",
    px = 32,
    py = 32
})

function G.UIDEF.preview_cardarea(preview_num, scale)
    local preview_cards = {}
    local count = 0
    local deck_size = #G.deck.cards

    while count < preview_num and deck_size >= 1 do
        local card = G.deck.cards[deck_size]
        if card then
            table.insert(preview_cards, card)
            count = count + 1
        end
        deck_size = deck_size - 1
    end

    if count < 1 then
        return nil
    end

    local scale = scale or 0.7
    local preview_area = CardArea(
            0, 0,
            (math.min(preview_num, #preview_cards) * G.CARD_W)*scale,
            G.CARD_H*scale,
            {card_limit = #preview_cards, type = 'title', highlight_limit = 0, card_w = G.CARD_W*scale}
    )

    for i=1, #preview_cards do
        local copied_card = copy_card(preview_cards[i], nil, nil, G.playing_card)
        copied_card:hard_set_T(copied_card.T.x, copied_card.T.y, G.CARD_W*scale, G.CARD_H*scale)
        preview_area:emplace(copied_card)
    end

    return {{
        n=G.UIT.R, 
        config = {align = "cm", colour = G.C.CLEAR, r = 0.0, padding = 0.5},
        nodes={{
            n=G.UIT.O, config = {object = preview_area}
        }}
    }}
end


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

-- helper functions for ui generation
ArrowAPI.ui = {
     --- Create dynamic badge for a center based on its 'origin' property
    --- @param center table Center table representing the item
    --- @return table # badge UI tree
    dynamic_badge = function(center)
        local scale_fac = {}
        local min_scale_fac = 1
        local strings = { }
        local badge_colour = HEX('32A852')
        local text_colour = G.C.WHITE

        local mod = center.original_mod or center.mod

        if center.origin then
            if type(center.origin) == 'table' then
                strings[#strings+1] = ' '..localize('ba_'..center.origin.category)..' '
                for _, v in ipairs(center.origin.sub_origins or {}) do
                    strings[#strings+1] = ' '..localize('ba_'..v)..' '
                end
                
                local color_key = center.origin.custom_color or center.origin.category
                sendDebugMessage('mod_id: '..mod.id)
                sendDebugMessage('color key: '..color_key)
                badge_colour = ArrowAPI.ui.badge_colors[mod.id]['co_'..color_key] or badge_colour
                text_colour = ArrowAPI.ui.badge_colors[mod.id]['te_'..color_key] or text_colour
            else
                strings[#strings + 1] = ' '..localize('ba_'..center.origin)..' '
                badge_colour = ArrowAPI.ui.badge_colors[mod.id]['co_'..center.origin] or badge_colour
                text_colour = ArrowAPI.ui.badge_colors[mod.id]['te_'..center.origin] or text_colour
            end
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
                        minw = 1.4 / min_scale_fac,
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
    end,

    --- Allows Modded Legendaries to show ????? unlock descriptions, but shows the joker_locked_legendary msg on the unlock notifications
    generate_legendary_desc = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table, key)
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
    end,

    --- Helper function that reloads the main Balatro UI
    --- @param hud_offset number Starting y offset of the hud
    manual_ui_reload = function(hud_offset)
        if G.HUD then G.HUD:remove(); G.HUD = nil end
        if G.HUD_blind then
            -- manually nil out the blind object so this remove call doesn't destroy it unnecessarily
            G.HUD_blind.UIRoot.children[2].children[2].children[1].config.object = nil
            G.HUD_blind:remove();
            G.HUD_blind = nil
        end
        G.HUD = UIBox{
            definition = create_UIBox_HUD(),
            config = {align=('cli'), offset = {x=-0.7,y=0}, major = G.ROOM_ATTACH}
        }
        G.HUD_blind = UIBox{
            definition = create_UIBox_HUD_blind(),
            config = {major = G.HUD:get_UIE_by_ID('row_blind_bottom'), align = 'bmi', offset = {x=0,y=hud_offset or -10}, bond = 'Weak'}
        }

        G.hand_text_area = {
            chips = G.HUD:get_UIE_by_ID('hand_chips'),
            mult = G.HUD:get_UIE_by_ID('hand_mult'),
            ante = G.HUD:get_UIE_by_ID('ante_UI_count'),
            round = G.HUD:get_UIE_by_ID('round_UI_count'),
            chip_total = G.HUD:get_UIE_by_ID('hand_chip_total'),
            handname = G.HUD:get_UIE_by_ID('hand_name'),
            hand_level = G.HUD:get_UIE_by_ID('hand_level'),
            game_chips = G.HUD:get_UIE_by_ID('chip_UI_count'),
            blind_chips = G.HUD_blind:get_UIE_by_ID('HUD_blind_count'),
            blind_spacer = G.HUD:get_UIE_by_ID('blind_spacer')
        }
    end,

    -- A table of badge_colors. Backgrounds are prefixed with `co_`, text is prefixed with `te_`
    badge_colors = {
        ArrowAPI = {
            co_rlm = HEX('FFFFFF'),
            te_rlm = HEX('b1212a'),

            -- badge colors for jojo parts
            co_jojo = G.C.STAND,
            te_jojo = HEX('FFFFFF'),
            co_diamond = HEX('BEE5E5'),
            te_diamond = HEX('C479BE'),
            co_stone = HEX('0076b2'),
            te_stone = HEX('97c348'),
            co_lion = HEX('dcf5fc'),
            te_lion = HEX('7832c4'),
        },
    },

    add_badge_colors = function(mod, args)
        ArrowAPI['ui']['badge_colors'][mod.id] = copy_table(args)
    end
}