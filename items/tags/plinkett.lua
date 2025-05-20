local tagInfo = {
    name = 'Plinkett Tag',
    config = {type = 'new_blind_choice'},
    alerted = true,
}

function tagInfo.in_pool(self, args)
    if not G.FUNCS.arrow_consumabletype_has_items('VHS') then
        return false
    end
end

tagInfo.loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { G.arrow_team.gote } }
end

tagInfo.apply = function(self, tag, context)
    if context.type == self.config.type then
        tag:yep('+', G.C.VHS,function()
            local key = 'p_arrow_analog4'
            local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                    G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
            card.cost = 0
            card.from_tag = true
            G.FUNCS.use_card({config = {ref_table = card}})
            card:start_materialize()
            G.CONTROLLER.locks[tag.ID] = nil
            return true
        end)
        self.triggered = true
        return true
    end
end

return tagInfo