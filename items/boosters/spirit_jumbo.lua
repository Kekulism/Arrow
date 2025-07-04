local packInfo = {
    name = 'Jumbo Spirit Pack',
    config = {
        extra = 3,
        choose = 1,
    },
    weight = 0.15,
    cost = 10,
    kind = 'Stand',
    group_key = "k_mega_spirit_pack",
    select_card = 'consumeables',
    part = 'jojo'
}

function packInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.choose, card.ability.extra} }
end

function packInfo.create_card(self, card)
    return {set = "Stand", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = 'fnwk_stand1'}
end

packInfo.ease_background_colour = function(self)
    ease_colour(G.C.DYN_UI.MAIN, G.C.VHS)
    ease_background_colour{new_colour = darken(G.C.VHS, 0.2), special_colour = G.C.VHS, contrast = 5}
end

packInfo.particles = function(self)
    G.booster_pack_sparkles = Particles(1, 1, 0,0, {
        timer = 0.015,
        scale = 0.2,
        initialize = true,
        lifespan = 1,
        speed = 1.1,
        padding = -1,
        attach = G.ROOM_ATTACH,
        colours = {G.C.WHITE, lighten(G.C.VHS, 0.4), lighten(G.C.VHS, 0.2), lighten(G.C.RED, 0.2)},
        fill = true
    })
    G.booster_pack_sparkles.fade_alpha = 1
    G.booster_pack_sparkles:fade(1, 0)
end

return packInfo