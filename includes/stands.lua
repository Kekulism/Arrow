-- stand pool
SMODS.ObjectType {
    default = 'c_csau_stardust_star',
    key = 'StandPool',
    prefix_config = false,
}

-- evolved stand pool
SMODS.ObjectType {
    default = 'c_csau_stardust_star',
    key = 'EvolvedPool',
}

SMODS.Rarity {
    key = 'StandRarity',
    default_weight = 1,
    no_mod_badges = true,
    badge_colour = 'FFFFFF'
}

SMODS.Rarity {
    key = 'EvolvedRarity',
    default_weight = 0,
    no_mod_badges = true,
    badge_colour = 'FFFFFF',
    get_weight = function(self, weight, object_type)
        return G.GAME.used_vouchers.v_stand_plant and 0.12 or 0
    end
}

-- Stand Consumable

SMODS.UndiscoveredSprite {
    key = "Stand",
    atlas = "arrow_undiscovered",
    pos = { x = 0, y = 0 },
    overlay_pos = { x = 1, y = 0 }
}
SMODS.ConsumableType {
    key = 'Stand',
    primary_colour = G.C.STAND,
    secondary_colour = G.C.STAND,
    collection_rows = { 8, 8 },
    shop_rate = 0,
    default = "c_csau_diamond_star",
    rarities = {
        {key = 'arrow_StandRarity'},
        {key = 'arrow_EvolvedRarity'},
    },
    inject_card = function(self, center)
        if center.set ~= self.key then SMODS.insert_pool(G.P_CENTER_POOLS[self.key], center) end
        local pool_key = center.config.evolved and 'arrow_EvolvedPool' or 'arrow_StandPool'
        SMODS.insert_pool(G.P_CENTER_POOLS[pool_key], center)
        if center.rarity and self.rarity_pools[center.rarity] then
            SMODS.insert_pool(self.rarity_pools[center.rarity], center)
        end
    end,
    delete_card = function(self, center)
        if center.set ~= self.key then SMODS.remove_pool(G.P_CENTER_POOLS[self.key], center.key) end
        local pool_key = center.config.evolved and 'arrow_EvolvedPool' or 'arrow_StandPool'
        SMODS.remove_pool(G.P_CENTER_POOLS[pool_key], center)
        if center.rarity and self.rarity_pools[center.rarity] then
            SMODS.remove_pool(self.rarity_pools[center.rarity], center.key)
        end
    end,
}