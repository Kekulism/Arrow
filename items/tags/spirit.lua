local tagInfo = {
    name = 'Spirit Tag',
    config = {type = 'immediate'},
    alerted = true,
}

function tagInfo.in_pool(self, args)
    if not G.FUNCS.arrow_consumabletype_has_items('Stand') then
        return false
    end
end

tagInfo.loc_vars = function(self, info_queue, card)
    if G.GAME.modifiers.unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME.modifiers.max_stands or 1, ((G.GAME.modifiers.max_stands and G.GAME.modifiers.max_stands > 1) and localize('b_stand_cards') or localize('k_stand')) }}
    end
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { G.arrow_team.keku } }
end

tagInfo.apply = function(self, tag, context)
    if context.type == self.config.type then
        tag:yep('+', G.C.STAND,function()
            if (G.GAME.modifiers.unlimited_stands and G.consumeables.config.card_limit > #G.consumeables.cards) or (G.FUNCS.get_num_stands() < G.GAME.modifiers.max_stands) then
                G.FUNCS.new_stand(false)
            end
            return true
        end)
        tag.triggered = true
        return true
    end
end

return tagInfo