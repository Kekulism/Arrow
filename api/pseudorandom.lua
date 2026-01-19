local ref_pseudoseed = pseudoseed
function pseudoseed(key, predict_seed, ...)
    if not G.GAME.pseudorandom.predict_mode then return ref_pseudoseed(key, predict_seed, ...) end

    -- maintain these two cases ig
    if key == 'seed' then return math.random() end
    if G.SETTINGS.paused and key ~= 'to_do' then return math.random() end

    local _pseed = 0
    if not G.GAME.pseudorandom.predicts[key] then
        _pseed = pseudohash(key..(predict_seed or G.GAME.pseudorandom.seed or ''))
        G.GAME.pseudorandom.predicts[key] = {
            value = G.GAME.pseudorandom[key] or _pseed,
            pos = 0
        }
    end

    _pseed = math.abs(tonumber(string.format("%.13f", (2.134453429141+G.GAME.pseudorandom.predicts[key].value*1.72431234)%1)))
    G.GAME.pseudorandom.predicts[key].value = _pseed
    G.GAME.pseudorandom.predicts[key].pos = G.GAME.pseudorandom.predicts[key].pos + 1

    return (_pseed + (G.GAME.pseudorandom.hashed_seed or 0))/2
end

ArrowAPI.pseudorandom = {
    --- Sets the pseudorandom system to predict mode. All pseudorandom calls until predict mode is set to false
    --- are set in a different table, allowing seeds to be predicted ahead of time
    --- @param bool boolean
    --- @return boolean # Current predict mode state
    set_predict_mode = function(bool)
        G.GAME.pseudorandom.predict_mode = bool or false
        G.GAME.pseudorandom.predicts = {}
        return G.GAME.pseudorandom.predict_mode
    end


}