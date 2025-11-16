SMODS.Atlas({key = 'default_music_pack', path = 'default_music_pack.png', px = 71, py = 75, prefix_config = false})
SMODS.Atlas({key = 'balatro_music_pack', path = 'balatro_music_pack.png', px = 71, py = 75, prefix_config = false})

ArrowAPI.CURRENT_MUSIC = 'balatro'
ArrowAPI.MusicPacks = {}
ArrowAPI.MusicPack = SMODS.GameObject:extend {
    obj_buffer = {},
    set = 'MusicPack',
    obj_table = ArrowAPI.MusicPack,
    class_prefix = "arrowmp",
    atlas = 'default_music_pack',
    required_params = {
        'key',
        'sounds'
    },
    process_loc_text = function(self) -- LOC_TXT structure = name = string, text = table of strings
        SMODS.process_loc_text(G.localization.descriptions.music_packs, self.key, self.loc_txt)
    end,
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end

        ArrowAPI.MusicPack.super.register(self)
    end,
    inject = function(self)
        for i, v in ipairs(self.sounds) do
            local music_key = 'music_'..(v.key or (self.key..i))
            self.sounds[i].key = music_key
            SMODS.Sound({
                key = music_key,
                path = v.path,
                pitch = v.pitch or self.pitch or nil,
                volume = v.volume or self.volume or nil,
                get_current_music = i <= 5 and nil or v.get_current_music,
                prefix_config = false,
            })
        end
        ArrowAPI.MusicPacks[self.key] = self
    end,
}

local default_music = {}
for i=1, 5 do
    default_music[i] = {key = 'music'..i, path = 'resources/sounds/music'..i..'.ogg'}
end

ArrowAPI.MusicPacks['balatro'] = {
    key = 'balatro',
    sounds = default_music,
}
ArrowAPI.MusicPack.obj_buffer[1] = 'balatro'
G.localization.descriptions.music_packs = {default = {name = 'Balatro OST', text = {'Vanilla music'}}}