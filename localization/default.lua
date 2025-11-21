local suit_text = {
	singular = {
		"Converts {C:attention}#1#{}",
        "selected card",
        "to {V:1}#2#{}"
	},
	multi = {
		"Converts up to",
        "{C:attention}#1#{} selected cards",
        "to {V:1}#2#{}"
	}
}

local enhance_text = {
	singular = {
		"Enhances {C:attention}#1#{} selected",
		"card into a {C:attention}#2#{}"
	},
	multi = {
		"Enhances up to {C:attention}#1#{}",
		"selected cards into",
		"{C:attention}#2#s{}"
	}
}

local seal_text = {
	singular = {
		"Add a {C:attention}#1#{} to",
		"{C:attention}#2#{} selected card",
		"in your hand"
	},
	multi = {
		"Add {C:attention}#1#s{} to up",
		"to {C:attention}#2#{} selected cards",
		"in your hand"
	}
}

return {
    misc = {
        labels = {
            vhs = "VHS Tape",
            stand = "Stand",
        },
        dictionary = {
            arrow_options_enable_DetailedDescs = "Detailed Descriptions",

            arrow_credits_direction = "Direction",
            arrow_credits_concept = "Concept",
			arrow_credits_artist = "Artists",
			arrow_credits_programmer = "Programming",
			arrow_credits_graphics = "Graphics",
			arrow_credits_special = "Special Thanks",

			arrow_options_enable_Jokers = "Jokers",
			arrow_options_enable_Consumables = "Consumables",
			arrow_options_enable_Decks = "Decks",
			arrow_options_enable_Blinds = "Boss Blinds",
			arrow_options_enable_DeckSkins = "Deck Skins",
			arrow_options_enable_Challenges = "Challenges",
			arrow_options_enable_Achievements = "Achievements",
			arrow_options_enable_VHSs = "VHS Tapes",
			arrow_options_enable_Stands = "Stands",
			arrow_options_enable_Tags = "Tags",
			arrow_options_enable_Boosters = "Booster Packs",
			arrow_options_enable_Vouchers = "Vouchers",
			arrow_options_enable_Editions = "Editions",

            --- tonsmth loc
            k_soundpack = 'Sound Pack',
            b_remove = 'Remove',
            tnsmi_cfg_rows = "Rows to display",
            tnsmi_cfg_cols = "Packs per row",
            tnsmi_manager_pause = "Soundpacks",
            tnsmi_manager_loaded = "DRAG FOR PRIORITY",
            tnsmi_filter_label = "FILTER",

            -- stand localization
            b_stand_cards = "Stands",
            b_evolved_stand_cards = "Evolved Stands",
            k_stand = "Stand",
            k_evolved_stand = "Evolved Stand",
            k_stand_stickers = "Stand Stickers",
            k_stand_evolved = 'Evolved!',

            -- vhs localization
            b_vhs_cards = "VHS Tapes",
            k_vhs = "VHS Tape",
            k_vhs_destroyed = "Fin!",
            b_activate = "PLAY",
            b_deactivate = "PAUSE",

            -- vhs related badges
            ba_rlm = "RedLetterMedia",
            ba_rlm_botw = "Best of the Worst",
            ba_rlm_p = "Plinketto",
            ba_rlm_wotw = "Wheel of the Worst",
            ba_rlm_hitb = "Half in the Bag",
            ba_rlm_r = "Re:View",

            -- jojo related badges
            ba_jojo = "Jojo's Bizarre Adventure",
            ba_diamond = 'Diamond is Unbreakable',
            ba_stone = 'Stone Ocean',
            ba_lion = 'JoJolion',
        },
        v_dictionary = {
            arrow_options_reset_achievements = "Reset #1# Achievements",
            tnsmi_search_text = "#1#-#2# of #3# results"
        },
        v_text = {
			-- general behavior
			banned_except = {"{C:attention}All Jokers{} and {C:stand}all Stands{} {C:attention}banned{} except:"},
			blinds_except = {"{C:attention}All Blinds banned{} except:"},
            ch_c_scaling = {"{C:attention}#1#X{} Blind scaling"},
            ch_c_max_stands = {"You may have up to {C:attention}#1#{} {C:stand}Stands{}"},
            ch_c_all_bosses = {"{C:attention}Small{} and {C:attention}Big Blinds{} are {C:attention}Boss Blinds{}"},
			ch_c_all_showdown = {"{C:attention}Boss Blinds{} are {C:attention}Final Boss Blinds{}"},
            ch_c_all_scores_hidden = {"{C:attention}Blind requirements{} are {C:dark_edition}hidden{}"},
            ch_c_extra_blind_active = {"{B:1,C:white}#1#{} is {C:attention}always active{}"},
		},
    },
    descriptions = {
        SoundPack = {
            sp_balatro = {
                name = "Balatro OST",
                text = {
                    "{C:blue,E:1}Luis Clemente{}",
                    "{C:blue,E:1}(LouisF){}"
                }
            },
            sp_csau_cardsauce = {
                name = "Cardsauce OST",
                text = {
                    "{C:attention,E:1}Bassclefff{}"
                }
            },
        },
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

            undiscovered_vhs = {
                name = "Not Discovered",
                text = {
                    "Purchase this card in",
                    "an unseeded run to",
                    "learn what it does",
                },
            },
            undiscovered_stand = {
                name = "Not Discovered",
                text = {
                    "Purchase this card in",
                    "an unseeded run to",
                    "learn what it does",
                },
            },

            white_sticker = {
                name="White Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}White",
                    "{C:attention}Stake{} difficulty",
                },
            },
            red_sticker = {
                name="Red Sticker",
                text={
                    "Used this #1#",
                    "to win on {C:attention}Red",
                    "{C:attention}Stake{} difficulty",
                },
            },
            green_sticker = {
                name = "Green Sticker",
                text = {
                    "Used this #1#",
                    "to win on {C:attention}Green",
                    "{C:attention}Stake{} difficulty",
                },
            },
            black_sticker = {
                name = "Black Sticker",
                text = {
                    "Used this #1#",
                    "to win on {C:attention}Black",
                    "{C:attention}Stake{} difficulty",
                },
            },
            blue_sticker = {
                name = "Blue Sticker",
                text = {
                    "Used this #1#",
                    "to win on {C:attention}Blue",
                    "{C:attention}Stake{} difficulty",
                },
            },
            purple_sticker={
                name = "Purple Sticker",
                text = {
                    "Used this #1#",
                    "to win on {C:attention}Purple",
                    "{C:attention}Stake{} difficulty",
                },
            },
            orange_sticker={
                name = "Orange Sticker",
                text = {
                    "Used this #1#",
                    "to win on {C:attention}Orange",
                    "{C:attention}Stake{} difficulty",
                },
            },
            gold_sticker = {
                name = "Gold Sticker",
                text = {
                    "Used this #1#",
                    "to win on {C:attention}Gold",
                    "{C:attention}Stake{} difficulty",
                },
            },

            artistcredit_1 = {
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
            artistcredit_3 = {
                name = "Artists",
                text = {
                    "{E:1}#1#{}",
                    "{E:1}#2#{}"
                },
            },

            p_arrow_analog1 = {
                name = 'Analog Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} VHS Tapes{}",
                },
            },
            p_arrow_analog2 = {
                name = 'Analog Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} VHS Tapes{}",
                },
            },
            p_arrow_analog3 = {
                name = 'Jumbo Analog Pack',
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:vhs} VHS Tapes{}",
                },
            },
            p_arrow_analog4 = {
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
        },
        Tarot = {
            c_strength = {
				name = "Strength",
				text = {
					"Increases rank of",
					"up to {C:attention}#1#{} selected",
					"cards by {C:attention}#2#{}"
				}
			},
			c_strength_multi = {
				name = "Strength",
				text = {
					"Increases rank",
					"of {C:attention}#1#{} selected",
					"card by {C:attention}#2#{}"
				}
			},
			c_death = {
				name = "Death",
				text = {
					"Select {C:attention}#1#{} cards,",
					"convert the {C:attention}left{} card",
					"into the {C:attention}right{} card",
					"{C:inactive}(Drag to rearrange)"
				}
			},
			c_death_multi = {
				name = "Death",
				text = {
					"Select {C:attention}#1#{} cards,",
					"convert the {C:attention}left{} cards",
					"into the {C:attention}rightmost{} card",
					"{C:inactive}(Drag to rearrange)"
				}
			},
            c_hanged_man = {
				name = "The Hanged Man",
				text = {
                    "Destroys {C:attention}#1#{} selected card",
				}
			},
			c_hanged_man_multi = {
				name = "The Hanged Man",
				text = {
					"Destroys up to",
					"{C:attention}#1#{} selected cards",
				}
			},
			c_devil = { name = "The Devil", text = enhance_text.singular },
			c_devil_multi = { name = "The Devil", text = enhance_text.multi },
            c_tower = { name = "The Tower", text = enhance_text.singular },
			c_tower_multi = { name = "The Tower", text = enhance_text.multi },
			c_magician = { name = "The Magician", text = enhance_text.singular },
			c_magician_multi = { name = "The Magician", text = enhance_text.multi },
			c_empress = { name = "The Empress", text = enhance_text.singular },
			c_empress_multi = { name = "The Empress", text = enhance_text.multi },
			c_heirophant = { name = "The Hierophant", text = enhance_text.singular },
			c_heirophant_multi = { name = "The Hierophant", text = enhance_text.multi },
			c_lovers = { name = "The Lovers", text = enhance_text.singular },
			c_lovers_multi = { name = "The Lovers", text = enhance_text.multi },
			c_chariot = { name = "The Chariot", text = enhance_text.singular },
			c_chariot_multi = { name = "The Chariot", text = enhance_text.multi },
			c_justice = { name = "Justice", text = enhance_text.singular },
			c_justice_multi = { name = "Justice", text = enhance_text.multi },

            c_star = { name = "The Star", text = suit_text.singular },
			c_star_multi = { name = "The Star", text = suit_text.multi },
			c_world = { name = "The World", text = suit_text.singular },
			c_world_multi = { name = "The World", text = suit_text.multi },
			c_moon = { name = "The Moon", text = suit_text.singular },
			c_moon_multi = { name = "The Moon", text = suit_text.multi },
			c_sun = { name = "The Sun", text = suit_text.singular },
			c_sun_multi = { name = "The Sun", text = suit_text.multi },

            c_arrow_tarot_arrow = {
                name = "The Arrow",
                text = {
                    "Create a random {C:stand}Stand{}",
                    "{C:inactive}(Must have room){}",
                }
            },
        },
        Spectral = {
            			c_talisman = { name = "Talisman", text = seal_text.singular },
			c_talisman_multi = { name = "Talisman", text = seal_text.multi },
			c_deja_vu = { name = "Deja Vu", text = seal_text.singular },
			c_deja_vu_multi = { name = "Deja Vu", text = seal_text.multi },
			c_medium = { name = "Medium", text = seal_text.singular },
			c_medium_multi = { name = "Medium", text = seal_text.multi },
			c_trance = { name = "Trance", text = seal_text.singular },
			c_trance_multi = { name = "Trance", text = seal_text.multi },

			c_cryptid = {
				name = 'Cryptid',
				text = {
					"Create {C:attention}#1#{} copies of",
					"{C:attention}#2#{} selected card",
					"in your hand"
				},
			},
			c_cryptid_multi = {
				name = 'Cryptid',
				text = {
					"Create {C:attention}#1#{} copies of",
					"up to {C:attention}#2#{} selected cards",
					"in your hand"
				},
			},

			c_aura = {
				name = 'Aura',
				text = {
					"Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
					"{C:dark_edition}#2#{} edition to",
					"{C:attention}#1#{} selected card in hand"
				},
			},
			c_aura_multi = {
				name = 'Aura',
				text = {
					"Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
					"{C:dark_edition}#2#{} edition to up to",
					"{C:attention}#1#{} selected cards in hand"
				},
			},

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