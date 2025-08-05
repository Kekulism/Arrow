local voucherInfo = {
    name = 'Foo Fighter',
    cost = 10,
    config = {
        extra = {
            rate = 1,
        }
    },
    origin = {
        category = 'jojo',
        sub_origins = {
            'stone',
        },
        custom_color = 'stone',
    },
    artist = 'gote',
    requires_type = 'Stand',
}

function voucherInfo.in_pool(self, args)
    return ArrowAPI.loading.consumeable_has_items('Stand')
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.stand_rate = G.GAME.stand_rate + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo