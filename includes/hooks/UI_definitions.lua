local G_FUNCS_can_buy_and_use_ref=G.FUNCS.can_buy_and_use
G.FUNCS.can_buy_and_use = function(e)
    G_FUNCS_can_buy_and_use_ref(e)
    if e.config.ref_table.ability.set=='VHS' then
        e.UIBox.states.visible = false
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

-- Modified Code from Malverk
local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if card.ability.set == "VHS" then
        if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
            use = {n=G.UIT.R, config={align = 'cm'}, nodes={
                {n=G.UIT.C, config={align = "cm"}, nodes={
                    {n=G.UIT.C, config={align = "bm", maxw = G.CARD_W * 0.65, shadow = true, padding = 0.1, r=0.08, minw = 0.5 * G.CARD_W, minh = 0.8, hover = true, colour = G.C.GREEN, button = "use_card", func = "can_select_card", ref_table = card}, nodes={
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
    return G_UIDEF_use_and_sell_buttons_ref(card)
end