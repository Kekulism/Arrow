local ref_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local ret = ref_set_ability(self, center, initial, delay_sprites)

    if self.ability.set == 'csau_Stand' then
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