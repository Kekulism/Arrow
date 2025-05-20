local ps_ref = Game.prep_stage
function Game:prep_stage(new_stage, new_state, new_game_obj)
    ps_ref(self, new_stage, new_state, new_game_obj)
    G.FUNCS.initPostSplash()
end