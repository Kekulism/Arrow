local ref_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local ret = ref_set_ability(self, center, initial, delay_sprites)

    if self.ability.set == 'Stand' then
        G.FUNCS.arrow_set_stand_sprites(self)
    end

    if self.ability.set == 'VHS' then
        if self.config.center.discovered and not (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
            local moodies = SMODS.find_card("c_csau_vento_moody")
            for _, v in ipairs(moodies) do
                self.ability.extra.runtime = self.ability.extra.runtime*2
            end
        end

        self.no_shadow = true
    end

    return ret
end

---------------------------
--------------------------- Stand visual loading
---------------------------

local ref_card_load = Card.load
function Card:load(cardTable, other_card)
    local ret = ref_card_load(self, cardTable, other_card)

    if self.ability.set == 'Stand' then
        G.FUNCS.arrow_set_stand_sprites(self)
    end

    return ret
end

---------------------------
--------------------------- For stand auras in the collection
---------------------------

local ref_card_hover = Card.hover
function Card:hover()

    if G.col_stand_hover and G.col_stand_hover ~= self then
        G.col_stand_hover.ability.aura_flare_queued = nil
        G.col_stand_hover.ability.stand_activated = nil
        G.col_stand_hover = nil
    end

    if self.ability.aura_hover or (self.area and (self.area.config.collection or self.area == G.pack_cards) and self.ability.set == 'Stand') then
        G.col_stand_hover = self
        self.ability.aura_flare_queued = true
    end

    return ref_card_hover(self)
end

local ref_card_stop_hover = Card.stop_hover
function Card:stop_hover()
    if self.ability.aura_hover or (self.area and (self.area.config.collection or self.area == G.pack_cards) and self.ability.set == 'Stand') then
        self.ability.aura_flare_queued = nil
        self.ability.stand_activated = nil
    end

    return ref_card_stop_hover(self)
end

function love.focus(f)
    if not f then return end

    if G.col_stand_hover then
        G.col_stand_hover.ability.aura_flare_queued = nil
        G.col_stand_hover.ability.stand_activated = nil
        G.col_stand_hover = nil
    end
end