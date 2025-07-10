return {
    misc = {
        labels = {
            vhs = "VHS Tape",
            stand = "Stand",
        },
        dictionary = {
            b_stand_cards = "Stands",
            b_evolved_stand_cards = "Evolved Stands",
            b_vhs_cards = "VHS Tapes",
            k_vhs = "VHS Tape",
            k_stand = "Stand",
            k_evolved_stand = "Evolved Stand",
            k_stand_stickers = "Stand Stickers",

            k_stand_evolved = 'Evolved!',
            k_vhs_destroyed = "Fin!",

            b_activate = "PLAY",
            b_deactivate = "PAUSE",
            b_and_activate = "& PLAY",

            -- badge titles
            ba_vinny = "Vinesauce",
            ba_vinny_wotw = "Wheel of the Weird",
            ba_vinny_pa = "Public Access",
            co_vinny = "32A852",
            te_vinny = "FFFFFF",
            ba_joel = "Vargskelethor",
            ba_mike = "Jabroni Mike",
            co_mike = "8867a5",
            te_mike = "FFFF00",
            ba_redvox = "Red Vox",
            co_redvox = "841f20",
            te_redvox = "cac5b7",
            ba_rlm = "RedLetterMedia",
            ba_rlm_botw = "Best of the Worst",
            ba_rlm_p = "Plinketto",
            ba_rlm_bs = "Black Spine",
            ba_rlm_j = "Junka",
            ba_rlm_wotw = "Wheel of the Worst",
            ba_rlm_hitb = "Half in the Bag",
            ba_rlm_r = "Re:View",
            ba_jojo = "Jojo's Bizarre Adventure",
            ba_uzumaki = "Uzumaki",
            ba_monkeywrench = "Monkey Wrench",

            -- badge colors for jojo parts
            ba_phantom = 'Phantom Blood',
            ba_battle = 'Battle Tendency',
            ba_stardust = 'Stardust Crusaders',
            ba_diamond = 'Diamond is Unbreakable',
            ba_vento = 'Golden Wind',
            ba_stone = 'Stone Ocean',
            ba_steel = 'Steel Ball Run',
            ba_lion = 'JoJolion',
            ba_lands = 'The JOJOLands',

            ba_feedback = 'Purple Haze Feedback',
        },
    },
    descriptions = {
        Other = {
            vhs_activation = {
                name = "VHS Playing",
                text = {
                    "{C:vhs}VHS Tapes{} can have",
                    "their passive abilities",
                    "{C:attention}toggled{} on/off",
                },
            },
            stand_info = {
                name = "Stand Limit",
                text = {
                    "You can only",
                    "have {C:attention}#1#{} {C:stand}#2#{}",
                    "at a time",
                },
            },
            stand_info_unlimited = {
                name = "Stand Limit",
                text = {
                    "You can have",
                    "as many {C:stand}Stands{}",
                    "as you have",
                    "consumable slots"
                },
            },

            undiscovered_vhs={
                name="Not Discovered",
                text={
                    "Purchase this card in",
                    "an unseeded run to",
                    "learn what it does",
                },
            },
            undiscovered_stand={
                name = "Not Discovered",
                text = {
                    "Purchase this card in",
                    "an unseeded run to",
                    "learn what it does",
                },
            },

            white_sticker={
                name="White Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}White",
                    "{C:attention}Stake{} difficulty",
                },
            },
            red_sticker={
                name="Red Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Red",
                    "{C:attention}Stake{} difficulty",
                },
            },
            green_sticker={
                name="Green Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Green",
                    "{C:attention}Stake{} difficulty",
                },
            },
            black_sticker={
                name="Black Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Black",
                    "{C:attention}Stake{} difficulty",
                },
            },
            blue_sticker={
                name="Blue Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Blue",
                    "{C:attention}Stake{} difficulty",
                },
            },
            purple_sticker={
                name="Purple Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Purple",
                    "{C:attention}Stake{} difficulty",
                },
            },
            orange_sticker={
                name="Orange Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Orange",
                    "{C:attention}Stake{} difficulty",
                },
            },
            gold_sticker={
                name="Gold Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Gold",
                    "{C:attention}Stake{} difficulty",
                },
            },

            artist = {
                text = {
                    "{C:inactive}Artist",
                },
            },
            artists = {
                text = {
                    "{C:inactive}Artists",
                },
            },
            artistcredit = {
                name = "Artist",
                text = {
                    "{E:1}#1#{}"
                },
            },
            artistcredit_2 = {
                name = "Artists",
                text = {
                    "{E:1}#1#{}",
                    "{E:1}#2#{}"
                },
            },

            p_arrow_analog1={
                name = 'Analog Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} VHS Tapes{}",
                },
            },
            p_arrow_analog2={
                name = 'Analog Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} VHS Tapes{}",
                },
            },
            p_arrow_analog3={
                name = 'Jumbo Analog Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} VHS Tapes{}",
                },
            },
            p_arrow_analog4={
                name = 'Mega Analog Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} VHS Tapes{}",
                },
            },

            p_arrow_spirit_reg = {
                name = 'Spirit Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} Stands{}",
                },
            },

            p_arrow_spirit_jumbo = {
                name = 'Jumbo Spirit Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} Stands{}",
                },
            },
        },
        Tarot = {
            c_arrow_tarot_arrow = {
                name = "The Arrow",
                text = {
                    "Create a random {C:stand}Stand{}",
                    "{C:inactive}(Must have room){}",
                }
            },
        },
        Spectral = {
            c_arrow_spec_diary = {
                name = "The Diary",
                text = {
                    "Create a random",
                    "{C:stand}Evolved Stand{}",
                    "{C:inactive}(Must have room){}",
                }
            },
        },
        Tag = {
            tag_arrow_plinkett = {
                name = "Plinkett Tag",
                text = {
                    "Gives a free",
                    "{C:vhs}Mega Analog Pack{}",
                },
            },
            tag_arrow_spirit = {
                name = "Spirit Tag",
                text = {
                    "Create a random {C:stand}Stand",
                    "{C:inactive}(Must have room)",
                },
            },
        },
        Voucher = {
            v_arrow_scavenger = {
                name = "Scavenger Hunt",
                text = {
                    "{C:vhs}VHS Tapes{} can be purchased",
                    "from the {C:attention}shop{}"
                }
            },
            v_arrow_raffle = {
                name = "Raffle",
                text = {
                    "{C:vhs}VHS Tapes{} appear {C:attention}2X{} more",
                    "frequently in the {C:attention}shop{}"
                },
                unlock = {
                    "Buy a total of ",
                    "{C:attention}#1#{} {C:vhs}VHS Tapes",
                    "from the shop",
                    "{C:inactive}(#2#)",
                },
            },
            v_arrow_foo = {
                name = 'Foo Fighter',
                text = {
                    "{C:stand}Stands{} can be purchased",
                    "from the {C:attention}shop{}"
                }
            },
            v_arrow_plant = {
                name = 'Plant Appraiser',
                text = {
                    "{C:stand}Evolved Stands{} can be",
                    "purchased from the {C:attention}shop{}"
                },
                unlock = {
                    "Buy a total of",
                    "{C:attention}#1#{} {C:stand}Stands",
                    "from the shop",
                    "{C:inactive}(#2#)",
                },
            },
        },
    }
}