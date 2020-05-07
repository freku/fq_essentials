local CFG = {
    ['gangs'] = {
        {
            name = "Ballas",
            baseZones = { 1, 2, 3 },
            mainZone = 2,
            spawnPoint = {['x']=109.92456054688,['y']=-1924.4937744141,['z']=20.751726150513, h=134.71337890625}, -- oddac heading
            blipColor = 83,
            rgbColor = {204, 0, 153},
            weapons = {'weapon_vintagepistol', 'weapon_assaultsmg', 'weapon_dbshotgun', 'weapon_carbinerifle'},
            models = {
                {
                    face = {15, 24, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={118,2},
                        [2]={0,0},
                        [3]={0,0},
                        [4]={26,1},
                        [5]={0,0},
                        [6]={12,0},
                        [7]={0,0},
                        [8]={116,6},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={193,4},
                    }
                },
                {
                    face = {35, 3, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={0,0},
                        [2]={14,0},
                        [3]={0,0},
                        [4]={42,2},
                        [5]={0,0},
                        [6]={32,2},
                        [7]={55,0},
                        [8]={120,24},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={128,2},
                    }
                },
                {
                    face = {2, 14, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={111,14},
                        [2]={8,1},
                        [3]={6,0},
                        [4]={33,0},
                        [5]={0,0},
                        [6]={9,0},
                        [7]={55,0},
                        [8]={23,1},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={127,6},
                    }
                },
                {
                    face = {23, 45, 0.5, 0.2},
                    model = 'mp_f_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={0,0},
                        [2]={14,0},
                        -- [3]={4,0},
                        [3]={97,0},
                        [4]={61,2},
                        [5]={0,0},
                        -- [6]={50,1}, -- 85, 25
                        [6]={25,0}, -- 85, 25
                        [7]={5,4},
                        [8]={2,0},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={171,2},
                    }
                },
                {
                    face = {2, 14, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={28,0},
                        [2]={69,0},
                        [3]={0,0},
                        [4]={49,0},
                        [5]={0,0},
                        [6]={65,1},
                        [7]={111,0},
                        [8]={135,7},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={167,8},
                    }
                },
            }
        },
        {
            name = "Famillies",
            baseZones = { 4, 5, 6 },
            mainZone = 5,
            spawnPoint = {['x']=324.41467285156,['y']=-212.1727142334,['z']=54.086273193359,h=159.81163024902},
            blipColor = 2, -- 43
            rgbColor = {46, 184, 46},
            weapons = {'weapon_combatpistol', 'weapon_combatpdw', 'weapon_sawnoffshotgun', 'weapon_assaultrifle'},
            models = {
                {
                    face = {3, 14, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={41,0},
                        [1]={111,0},
                        [2]={30,0},
                        [3]={30,0},
                        [4]={42,0},
                        [5]={0,0},
                        [6]={75,7},
                        [7]={49,0},
                        [8]={106,1},
                        [9]={37,1},
                        [10]={52,1},
                        [11]={82,4},
                    }
                },
                {
                    face = {15, 24, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={28,0},
                        [1]={118,0},
                        [2]={1,0},
                        -- [3]={39,2},
                        [3]={14,0},
                        [4]={63,0},
                        [5]={0,0},
                        [6]={7,8},
                        [7]={46,0},
                        [8]={76,9},
                        [9]={37,1},
                        [10]={0,0},
                        [11]={127,9},
                    }
                },
                {
                    face = {24, 31, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={28,0},
                        [1]={116,22},
                        [2]={44,0},
                        [3]={5,0},
                        [4]={88,2},
                        [5]={0,0},
                        [6]={32,15},
                        [7]={88,1},
                        [8]={56,2},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={5,2},
                    }
                },
                {
                    face = {35, 32, 0.5, 0.5},
                    model = 'mp_f_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={111,0},
                        [2]={14,0},
                        [3]={89,0},
                        [4]={16,6},
                        [5]={0,0},
                        [6]={79,7},
                        [7]={7,0},
                        [8]={62,4},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={33,0},
                    }
                },
                {
                    face = {24, 31, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={137,4},
                        [2]={0,0},
                        [3]={110,8},
                        [4]={107,1},
                        [5]={0,0},
                        [6]={84,7},
                        [7]={0,0},
                        [8]={139,22},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={275,8},
                    }
                },
            }
        },
        {
            name = "Vagos",
            baseZones = { 7, 8, 9 },
            mainZone = 8,
            spawnPoint = {['x']=949.57708740234,['y']=-2184.4089355469,['z']=30.552505493164,['h']=79.899559020996},
            blipColor = 46,
            rgbColor = {255, 204, 0},
            weapons = {'weapon_heavypistol', 'weapon_smg', 'weapon_bullpupshotgun', 'weapon_bullpuprifle'},
            models = {
                {
                    face = {6, 18, 0.5, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={111,14},
                        [2]={39,0},
                        [3]={5,0},
                        [4]={42,0},
                        [5]={0,0},
                        [6]={48,0},
                        [7]={86,1},
                        [8]={107,1},
                        [9]={6,5},
                        [10]={0,0},
                        [11]={237,5},
                    }
                },
                {
                    face = {6, 3, 0.0, 0.5}, -- or 0.0 0.0
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={0,0},
                        [2]={73,0},
                        [3]={0,0},
                        -- [4]={43,2},
                        [4]={62,0},
                        [5]={0,0},
                        [6]={6,0},
                        [7]={82,2},
                        [8]={55,1},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={14,1},
                    }
                },
                {
                    face = {7, 24, 0.0, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={54,4},
                        [2]={0,0},
                        [3]={0,0},
                        [4]={42,5},
                        [5]={0,0},
                        [6]={7,15},
                        [7]={87,0},
                        [8]={128,5},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={128,9},
                    }
                },
                {
                    face = {6, 45, 1.0, 0.0},
                    model = 'mp_f_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={51,8},
                        [2]={47,0},
                        [3]={4,0},
                        [4]={16,0},
                        [5]={47,0},
                        [6]={79,6},
                        [7]={5,3},
                        [8]={47,8},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={5,1},
                    }
                },
                {
                    face = {7, 24, 0.0, 0.5},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={135,11},
                        [2]={0,0},
                        [3]={0,0},
                        [4]={114,11},
                        [5]={0,0},
                        [6]={78,11},
                        [7]={0,0},
                        [8]={135,21},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={287,11},
                    }
                },
            }
        },
        {
            name = "Triads", -- long:BallWei Cheng Triadas
            baseZones = { 10, 11, 12 },
            mainZone = 11,
            spawnPoint = {['x']=-820.04370117188,['y']=-928.41162109375,['z']=16.512645721436,h=111.35749053955},
            blipColor = 1,
            rgbColor = {255, 26, 26},
            weapons = {'weapon_pistol50', 'weapon_microsmg', 'weapon_pumpshotgun', 'weapon_advancedrifle'},
            models = {
                {
                    face = {6, 39, 0.5, 0.0},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={0,0},
                        [2]={13,0},
                        [3]={0,0},
                        [4]={4,4},
                        [5]={0,0},
                        [6]={32,12},
                        [7]={0,0},
                        [8]={9,16},
                        [9]={0,0},
                        [10]={4,1},
                        [11]={153,18},
                    }
                },
                {
                    face = {6, 42, 0.5, 0.0},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={111,5},
                        [2]={71,0},
                        [3]={0,0},
                        [4]={33,0},
                        [5]={0,0},
                        [6]={65,6},
                        [7]={86,1},
                        [8]={112,6},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={193,10},
                    }
                },
                {
                    face = {18, 39, 0.5, 0.0},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={118,11},
                        [2]={47,0},
                        [3]={0,0},
                        [4]={59,8},
                        [5]={0,0},
                        [6]={8,11},
                        [7]={70,3},
                        [8]={116,1},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={69,3}, 
                    }
                },
                {
                    face = {27, 39, 0.5, 0.0},
                    model = 'mp_f_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={111,5},
                        [2]={9,3},
                        [3]={45,0},
                        [4]={83,1},
                        [5]={0,0},
                        [6]={32,2},
                        [7]={0,0},
                        [8]={116,17},
                        [9]={35,0},
                        [10]={0,0},
                        [11]={195,4},
                    }
                },
                {
                    face = {18, 39, 0.5, 0.0},
                    model = 'mp_m_freemode_01',
                    components = {
                        [0]={0,0},
                        [1]={68,0},
                        [2]={0,0},
                        [3]={22,0},
                        [4]={79,0},
                        [5]={0,0},
                        [6]={25,0},
                        [7]={0,0},
                        [8]={24,2},
                        [9]={0,0},
                        [10]={0,0},
                        [11]={264,0},
                    }
                },
            }
        }
    },
    ['zones'] = {
        [1]=55,
        [2]=55,
        [3]=85,
        [4]=85,
        [5]=85,
        [6]=55,
        [7]=55,
        [8]=55,
        [9]=85,
        [10]=70,
        [11]=55,
        [12]=55,
        [13]=55,
        [14]=100,
        [15]=70,
        [16]=70,
        [17]=85,
        [18]=70,
        [19]=85,
        [20]=70,
        [21]=85,
        [22]=55,
        [23]=55,
        [24]=85,
        [25]=55,
        [26]=70,
        [27]=100,
        [28]=100,
        [29]=70,
        [30]=100,
        [31]=85,
        -- - $55
        -- - $70
        -- - $85
        -- - $100
        -- - $105 -- not needed
    },
    ['menu'] = {
        player = {
            position = {['x']=3612.0705566406,['y']=1118.0108642578,['z']=25.11720112711191},
            heading = 269.50784912109
        },
        cam = {
            position = {['x']=3628.166015625,['y']=1117.5119628906,['z']=25.0971505641937}, 
        },
        ped = {
            position = {['x']=3632.6826171875,['y']=1117.5119628906,['z']=25.0097398925572634},
            heading = 90.602920532227,
        }
    },
    ['msg'] = {
        pl = {
            CHAT = {
                turned_off = '^1Czat jest wylaczony',
                muted = 'Jesteś zmutowany za \'%s\' przez jeszcze %s',
                cd_left = 'Nie możesz pisać jeszcze przez: %ss', 
            },
            ESS = {
                money_for_playing_msg = '~o~Ragekill.pl ~c~| ~w~Dostales ~b~$%s~w~ za granie na serwerze!',
                no_perm = '',
                too_low_rank = 'Osoba ma wyższa rangę od twojej!',

                parser_error = 'Źle podałeś czas, poprawny sposób: min+10,sec+30 (sec,min,hour,day,month,year)!',
                vanish_usage = '^1Poprawne użycie: /vanish <on/off>',
                
                binfo_not_banned = 'To konto nie jest aktualnie zbanowane!',
                binfo_pass_login = 'Podaj login!',
                
                set_cd_too_long_time = 'Opóźnienie nie może być dłuższe niż 20 sekund!',
                setcd_usage = 'Poprawne użyciee: /setcd <time>',

                mute_usage = 'Poprawne użycie: /mute <playerID> <time> <reason=optional>',
                muted_by_msg = '^3Zostałeś zmutowany przez %s!',
                admin_mute_msg = '^3Zmutowałeś gracza %s!',
                mute_player_not_online = 'Gracz z tym nickiem nie jest online!',
                mute_usage = 'Poprawne użycie: /mute <login> <time> <reason=optional>',

                clear_chat_msg = '^1^*Czat zostal wyczyszczony!',
                stopchat_wlaczony = '^3^*Czat zostal wlaczony!',
                stopchat_wylaczony = '^8^*Czat zostal wylaczony!',
                
                kick_all_msg = "Gracz \'%s\' został wyrzucony z serwera! Powód: %s",
                kick_player_offline = 'Błąd! Ten gracz nie jest online.',
                kick_pass_player_id = 'Podaj id gracza',

                ban_usage = 'Poprawne użycie: /ban <login> <time> <reason>',
                ban_no_such_login = 'Nie ma konta z takim loginem!',
                ban_dropplayer_msg = 'Zostałeś zbanowany!',
                ban_all_msg = 'Gracz \'%s\' zbanował \'%s\'. Powód: %s',
                ban_already_banned = '^1To konto już jest zbanowane^7',
                ban_pass_id = 'Podaj id gracza!',

                unban_pass_login = 'Podaj steam id!',
                unban_not_banned = 'Ten gracz nie jest zbanowany!',
                unban_msg_to_admin = 'Gracz odbanowany!',

                bl_admin_msg = '^3Gracz z id ^4%s ^3jest teraz na blackliście!^7',
                bl_usage = 'Poprawne użycie: /blacklist <server_id>',
                bl_dropplayer_msg = '(: :)',
                bl_not_online = 'Gracz nie jest online!',
                bl_pass_player_id = 'Podaj id gracza!',

                unbl_usage = 'Poprawne użycie: /ublist <bl_id>',
                unbl_not_bled = '^1Rekord blacklisty z tym id nie istnieje lub został anulowany^7',
                unbl_ubled_correctly = 'Rekord blacklisty został poprawnie anulowany!',
                unbl_pass_id = 'Podaj id rekordu blacklisty!',
            },
            GANGS = {
                too_few_in_attacked_gang = 'Not enought players from attacked zone',
                too_few_from_ur_gang = 'You need more player on the zone from your gang to start The Overtake!',
                zone_already_attacked = 'This zone is already being attacked',
                money_for_controlled_zones = '~t~[~o~GANG~t~] ~w~Dostales ~y~%s~w~za kontrolowane terytoria!',
                -- fq:gangs:server.lua:309 - brak tlumaczenia
            },
            c = {
                menu_need_vip = 'Tylko ranga VIP i wyżej może wybrać ten model',
                menu_keep_balance = 'Trzymaj balans między ilością graczy w gangach!',

                gangs_overtake_fail = '[GANGS] Przejęcie strefy %s niepowiodło się!',
                gangs_overtake_good = '[GANGS] Przejęcie strefy %s zakończone z powodzeniem!',
                gangs_blip_name = 'Właściciel: %s Zbiera $%s',
                gangs_cant_overtake = 'Nie możesz tego zrobić!',
                gangs_defend_blip = 'Obroń swój gang!',
                gangs_attack_blip = 'Atakuj gang przeciwnika!',
                gangs_spawn_text = '~o~Gang: %s%s~n~~o~Online: ~c~%s~n~~o~Dochód z terytoriów: ~c~$%s~n~~o~Twoje K/D ratio: ~c~%s~n~Dobrej zabawy!',

                pl_cons_shop = 'Skelp z leczeniami',
                pl_weapon_shop = 'Sklep z broniami',
                pl_repair_car_shop = 'Napraw swój samochód',
                pl_hp_pickup = 'Apteczka',
                pl_armor_pickup = 'Armor',
                pl_pickup_help_msg = 'Naciśnij ~INPUT_PICKUP~ aby otworzyć skelp z leczeniami!',
                pl_weapon_shop_help_msg = 'Naciśnij ~INPUT_PICKUP~ aby otworzyć sklep z broniami!',
                pl_repair_shop_help_msg = 'Naciśnij ~INPUT_PICKUP~ aby naprawić samochód!',
                pl_repaired_car_msg = 'Pojazd naprawiony! -$1250',
                pl_cant_repair_car_msg = 'Nie możesz tego kupić! Potrzebujesz $1250',
                pl_cant_change_gang = 'Nie możesz wybrać nowego gangu przez %s sekund', -- s seconds
                pl_no_med = 'Nie posiadasz apteczki!',
                pl_voice_talk_mode = 'Tryb mówienia: %s (naciśnij K)',
            }
        },
        eng = {
            CHAT = {
                turned_off = '^1Chat is turned off',
                muted = 'You are muted for %s until %s',
                cd_left = 'Slowmode left: %ss', 
            },
            ESS = {
                money_for_playing_msg = '~o~Ragekill.pl ~c~| ~w~You\'v got ~b~$%s~w~ for playing on server!',
                no_perm = '',
                too_low_rank = 'You can\'t ban that higher rank!',

                parser_error = 'Parser error, time usage: min+10,sec+30 (sec,min,hour,day,month,year)!',
                vanish_usage = '^1Usage: /vanish <on/off>',
                
                binfo_not_banned = 'Account wtih this login is not banned currently!',
                binfo_pass_login = 'Pass a login!',
                
                set_cd_too_long_time = 'Time cant be longer than 20 seconds!',
                setcd_usage = 'Usage: /setcd <time>',

                mute_usage = 'Proper usage: /mute <playerID> <time> <reason=optional>',
                muted_by_msg = '^3You\'ve been muted by %s!',
                admin_mute_msg = '^3You muted player %s!',
                mute_player_not_online = 'Player with this login is not online!',
                mute_usage = 'Proper usage: /mute <login> <time> <reason=optional>',

                clear_chat_msg = '^1^*Chat has been clearned!',
                stopchat_wlaczony = '^3^*Chat has been turned on!',
                stopchat_wylaczony = '^8^*Chat has been turned off!',
                
                kick_all_msg = "Player %s has been kicked! Reason: %s",
                kick_player_offline = 'error. This player is not active!',
                kick_pass_player_id = 'Pass player id!',

                ban_usage = 'Usage: /ban <login> <time> <reason>',
                ban_no_such_login = 'There is no account with such login!',
                ban_dropplayer_msg = 'You have been banned! ;)',
                ban_all_msg = 'Player %s banned %s. Reason: %s',
                ban_already_banned = '^1This user account is already banned!^7',
                ban_pass_id = 'Pass player id!',

                unban_pass_login = 'Pass a steam id!',
                unban_not_banned = 'This user is not banned!',
                unban_msg_to_admin = 'User unbanned!',

                bl_admin_msg = '^3Player with id ^4%s^3is now blacklisted!^7',
                bl_usage = 'Usage: /blacklist <server_id>',
                bl_dropplayer_msg = '(: :)',
                bl_not_online = 'player is not online!',
                bl_pass_player_id = 'pass player id!',

                unbl_usage = 'Usage: /ublist <bl_id>',
                unbl_not_bled = '^1This black list id is canceled or doesn\'t exist!^7',
                unbl_ubled_correctly = 'Blacklist id unlisted correctly!',
                unbl_pass_id = 'Pass blacklist id!',
            },
            GANGS = {
                too_few_in_attacked_gang = 'Not enought players from attacked zone',
                too_few_from_ur_gang = 'You need more player on the zone from your gang to start The Overtake!',
                zone_already_attacked = 'This zone is already being attacked',
                money_for_controlled_zones = '~t~[~o~GANG~t~] ~w~Dostales ~y~%s~w~za kontrolowane terytoria!',
                
            },
            c = {
                -- local lang = exports['fq_login']:getLang()
                menu_need_vip = 'You need to be VIP to pick up this model!',
                menu_keep_balance = 'Kepp the balance between gangs!',

                gangs_overtake_fail = '[GANGS] Zone %s overtake failed!',
                gangs_overtake_good = '[GANGS] Zone %s overtaken!',
                gangs_blip_name = 'Owner: %s Collects $%s',
                gangs_cant_overtake = 'You cant do that now!',
                gangs_defend_blip = 'Defend your gang!',
                gangs_attack_blip = 'Attack enemy gang!',
                gangs_spawn_text = '~o~Gang: %s%s~n~~o~Players: ~c~%s~n~~o~Teritory income: ~c~$%s~n~~o~Your K/D ratio: ~c~%s~n~Have fun!',

                pl_cons_shop = 'Consumable shop',
                pl_weapon_shop = 'Weapon shop',
                pl_repair_car_shop = 'Repair car',
                pl_hp_pickup = 'Get health',
                pl_armor_pickup = 'Get armor',
                pl_pickup_help_msg = 'Press ~INPUT_PICKUP~ to open usable shop!',
                pl_weapon_shop_help_msg = 'Press ~INPUT_PICKUP~ to open weapon shop!',
                pl_repair_shop_help_msg = 'Press ~INPUT_PICKUP~ to reapir car!',
                pl_repaired_car_msg = 'Car fixed! -$1250',
                pl_cant_repair_car_msg = 'You can\'t buy it! You need $1250',
                pl_cant_change_gang = 'You cant pick a gang for %s seconds', -- s seconds
                pl_no_med = 'You don\'t have a med kit!',
                pl_voice_talk_mode = 'Talking mode: %s (press K)',
                pl_voice_volume = 'Volume: %s (press U)',
            }
        }
    }
}

function getCFG()
    return CFG
end

exports('getCFG', getCFG)