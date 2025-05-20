---LIST OF FOOD JOKERS:
-- ✔️ = Bunji/Don Beveridge compatibility
G.foodjokers = {
    -- Balatro (Vanilla) ✔️
    ['j_gros_michel'] = true, -- ✔️
    ['j_ice_cream'] = true, -- ✔️
    ['j_cavendish'] = true, -- ✔️
    ['j_turtle_bean'] = true, -- ✔️
    ['j_popcorn'] = true, -- ✔️
    ['j_ramen'] = true, -- ✔️
    ['j_selzer'] = true, -- ✔️
    ['j_diet_cola'] = true, -- ❌
    ['j_egg'] = true, -- ❌
    -- Cardsauce ✔️
    ['j_csau_meat'] = true, -- ✔️
    ['j_csau_fantabulous'] = true, -- ✔️
    ['j_csau_crudeoil'] = true, -- ✔️
    ['j_csau_grannycream'] = true, -- ✔️
    ['j_csau_toeofsatan'] = true, -- ✔️
    ['j_csau_chips'] = true, -- ✔️
    ['j_csau_mug'] = true, -- ✔️
    -- Cryptid
    ['j_cry_pickle'] = true,
    ['j_cry_chili_pepper'] = true,
    ['j_cry_tropical_smoothie'] = true,
    ['j_cry_cotton_candy'] = true,
    ['j_cry_wrapped'] = true,
    ['j_cry_candy_cane'] = true,
    ['j_cry_candy_buttons'] = true,
    ['j_cry_jawbreaker'] = true,
    ['j_cry_mellowcreme'] = true,
    ['j_cry_brittle'] = true,
    ['j_cry_caramel'] = true,
    ['j_cry_oldcandy'] = true,
    -- Neato's Jokers ✔️
    ['j_neat_icecreamsandwich'] = true, -- ✔️
    ['j_neat_frostedprimerib'] = true, -- ✔️
    ['j_neat_bananastand'] = true, -- ✔️
    -- Extra Credit
    ['j_ExtraCredit_badapple'] = true, -- ✔️
    ['j_ExtraCredit_espresso'] = true, -- ✔️
    ['j_ExtraCredit_ambrosia'] = true, -- ✔️
    ['j_ExtraCredit_candynecklace'] = true, -- ✔️
    ['j_ExtraCredit_compost'] = true, -- ✔️
    ['j_ExtraCredit_starfruit'] = true, -- ✔️
    -- Bunco
    ['j_bunc_starfruit'] = true,
    -- Ortalab
    ['j_ortalab_taliaferro'] = true,
    ['j_ortalab_sunnyside'] = true,
    ['j_ortalab_hot_chocolate'] = true,
    ['j_ortalab_royal_gala'] = true,
    ['j_ortalab_fine_wine'] = true,
    ['j_ortalab_mystery_soda'] = true,
    ['j_ortalab_popcorn_bag'] = true,
    ['j_ortalab_salad'] = true,
    -- Paperback
    ['j_paperback_apple'] = true,
    ['j_paperback_joker_cookie'] = true,
    ['j_paperback_nachos'] = true,
    ['j_paperback_crispy_taco'] = true,
    ['j_paperback_soft_taco'] = true,
    ['j_paperback_complete_breakfast'] = true,
    ['j_paperback_ghost_cola'] = true,
    ['j_paperback_b_soda'] = true,
    ['j_paperback_ice_cube'] = true,
    ['j_paperback_cream_liqueur'] = true,
    ['j_paperback_champagne'] = true,
    ['j_paperback_coffee'] = true,
    ['j_paperback_matcha'] = true,
    ['j_paperback_epic_sauce'] = true,
    ['j_paperback_dreamsicle'] = true,
    ['j_paperback_cakepop'] = true,
    ['j_paperback_caramel_apple'] = true,
    ['j_paperback_charred_marshmallow'] = true,
    ['j_paperback_rock_candy'] = true,
    ['j_paperback_tanghulu'] = true,
    -- Buffoonery
    ['j_buf_gfondue'] = true,
    ['j_buf_camarosa'] = true,
    -- Aikoyori's Shenanigans ❌
    ['j_akyrs_eat_pant'] = true, -- ❌
    -- Prism
    ['j_prism_pizza_cap'] = true,
    ['j_prism_pizza_mar'] = true,
    ['j_prism_pizza_for'] = true,
    ['j_prism_pizza_ruc'] = true,
    ['j_prism_pizza_haw'] = true,
    ['j_prism_pizza_det'] = true,
    ['j_prism_cookie'] = true,
    ['j_prism_whiskey'] = true,
    -- JoeyJokers
    ['j_joey_vegemite'] = true,
    -- Plantain ✔️
    ['j_pl_plantain'] = true, -- ✔️
    ['j_pl_apple_pie'] = true, -- ✔️
    ['j_pl_grape_soda'] = true, -- ✔️
    ['j_pl_raw_meat'] = true, -- ❌
}

local function inject(self)
    for k, v in pairs(G.foodjokers) do
        if G.P_CENTERS[k] or SMODS.Centers[k] then
            local center = G.P_CENTERS[k] or SMODS.Centers[k]
            if not table.contains(self, center) then
                self:inject_card(center)
            end
        end
    end
end

--- ObjectType representing "food" jokers, including vanilla Balatro jokers like Ice Cream and Ramen. Compatible with Cryptid
if not SMODS.ObjectTypes.Food then
    SMODS.ObjectType({
        key = "Food",
        default = "j_reserved_parking",
        cards = {},
        inject = function(self)
            SMODS.ObjectType.inject(self)
            inject(self)
        end,
    })
else
    local inj_ref = SMODS.ObjectTypes.Food.inject
    SMODS.ObjectType:take_ownership("Food", {
        inject = function(self)
            inj_ref(self)
            inject(self)
        end
    })
end

--- Table containing all names of people who contributed to the mod, used in crediting
G.arrow_team = {
    ['gote'] = "BarrierTrio/Gote",
    ['keku'] = "Keku",
    ['cejai'] = "SagaciousCejai",
    ['eremel'] = "Eremel",
    ['yunkie'] = "yunkie101",
    ['joey'] = "Joey",
}

-- colors used for dynamic badges, used to be in localization file which is a bad place to put hex codes -keku
G.arrow_badge_colours = {
    co_vinny = "32A852",
    te_vinny = "FFFFFF",
    co_joel = "3b4635",
    te_joel = "b0cf56",
    co_mike = "8867a5",
    te_mike = "FFFF00",
    co_redvox = "841f20",
    te_redvox = "cac5b7",
    co_rlm = "FFFFFF",
    te_rlm = "b1212a",
    co_uzumaki = "374244",
    te_uzumaki = "bfc7d5",
    co_monkeywrench = "194528",
    te_monkeywrench = "edffee",

    -- badge colors for jojo parts
    co_phantom = '245482',
    te_phantom = 'eee4a6',
    co_battle = 'DD5668',
    te_battle = '338FC4',
    co_stardust = '425F7C',
    te_stardust = 'EFCB70',
    co_diamond = 'BEE5E5',
    te_diamond = 'C479BE',
    co_vento = 'EDCE49',
    te_vento = 'D168BC',
    co_feedback = '7e2786',
    te_feedback = 'fe9818',
    co_stone = '0076b2',
    te_stone = '97c348',
    co_steel = 'A38168',
    te_steel = 'A9CF3C',
    co_lion = 'dcf5fc',
    te_lion = '7832c4',
    co_lands = '394E90',
    te_lands = '409CE8',
}