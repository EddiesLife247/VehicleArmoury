Config = {}

Config.Debug = false -- Can be toggled with /armourydebug

-- Approved Vehicles with Certifications
Config.ApprovedVehicles = {
    ['pdasbo'] = {
        cert = 'none'
    },
    ['highrebla'] = {
        cert = 'none'
    },
    ['landhigh'] = {
        cert = 'none'
    },
    ['carautil'] = {
        cert = 'none'
    },


    ['tailgaterm'] = {
        cert = 'response'
    },
    ['pdsugoi'] = {
        cert = 'response'
    },
    ['flashrsmark'] = {
        cert = 'ad'
    },
    ['bf400unm'] = {
        cert = 'ad'
    },
    ['polcyphtch'] = {
        cert = 'response'
    },
    ['strtourunm'] = {
        cert = 'sfo',
        firearms = true
    },
    ['sandmark'] = {
        cert = 'rct'
    },
    ['pdomnisegt'] = {
        cert = 'rpu'
    },
    ['gt4wbint'] = {
        cert = 'rpu'
    },
    ['marargento'] = {
        cert = 'rpu'
    },
    ['jugularunm'] = {
        cert = 'cid'
    },
    ['shinobimark'] = {
        cert = 'rpu'
    },
    ['shinobiunm'] = {
        cert = 'rpu'
    },
    ['stdmark'] = {
        cert = 'rpu'
    },
    ['kurumamark'] = {
        cert = 'interceptor'
    },
    ['vigerounm'] = {
        cert = 'cid'
    },
    ['ballerunm'] = {
        cert = 'cid'
    },
    ['buffalounm'] = {
        cert = 'cid'
    },
    ['90cxmark'] = {
        cert = 'afo',
        firearms = true
    },
    ['ballermark'] = {
        cert = 'afo',
        firearms = true
    },
    ['hyargento'] = {
        cert = 'sfo',
        firearms = true
    },
    ['jugestunm'] = {
        cert = 'response'
    },
    ['fmmarargentounmarked'] = {
        cert = 'rpu'
    },
    ['baller8i'] = {
        cert = 'spo',
        firearms = true
    },
    ['aleuunm'] = {
        cert = 'spo',
        firearms = true
    },
    ['seekermark'] = {
        cert = 'ctsfo',
        firearms = true
    },
    ['polinsurge'] = {
        cert = 'ctsfo',
        firearms = true
    },
    ['niotourmark'] = {
        cert = 'sfo',
        firearms = true
    },
    ['unvigero2'] = {
        cert = 'sfo',
        firearms = true
    },
    ['firetruk'] = {cert = 'none'},
    ['brutepump'] = {cert = 'none'},
    ['bruteremember'] = {cert = 'none'},
    ['vulcarfire'] = {cert = 'none'},
    ['brutewater'] = {cert = 'none'},
    ['sporeret'] = {cert = 'none'},
    ['sporefire'] = {cert = 'none'},
    ['imperfire'] = {cert = 'none'},
    ['fmbenefactorpol'] = {cert = 'none'},
    ['csu'] = {cert = 'none'},
    ['odyfire'] = {cert = 'none'},
    ['reblafire'] = {cert = 'none'},
    ['90cxfire'] = {cert = 'none'},
    ['aleufire'] = {cert = 'none'},
    ['fmargentomarkedfir'] = {cert = 'none'},
    ['fmcypherofficer'] = {cert = 'none'},
    ['benebox'] = {cert = 'none'},
    ['xlsambo'] = {cert = 'none'},
    ['shinobiambo'] = {cert = 'none'},
    ['egtambo'] = {cert = 'none'},
    ['ambcypher'] = {cert = 'none'},
    ['nhsomnisegt'] = {cert = 'none'},
    ['fmargentomarkedamb'] = {cert = 'none'},
    ['bruteambo'] = {cert = 'none'},
    ['sporeambo'] = {cert = 'none'},
    ['muletow'] = {cert = 'none'},
    ['carautil'] = {cert = 'none'},
    ['tailgaterpsni'] = {cert = 'none'},
    ['highrebla'] = {cert = 'none'},
    ['highbri'] = {cert = 'none'},
    ['rhinehh'] = {cert = 'none'},
    ['landhigh'] = {cert = 'none'},
    ['seekerpsni'] = {cert = 'none'},

}

-- Define job groups first
local PDJobs = {'police'}
local Highways = {'highways'}
local FireJobs = {'fire'}
local AmbulanceJobs = {'ambulance', 'standbymedic'}
local MechanicJobs = {'mechanic', 'lscustoms', 'highways'}

Config.JobTypes = {
    pd = PDJobs,
    highways = Highways,
    fire = FireJobs,
    ambulance = AmbulanceJobs,
    mechanic = MechanicJobs

}
-- Generic Armoury Configuration with Job-specific Vehicle Models and Cert Checks
Config.VehicleArmouries = {
    [PDJobs] = {
        vehicleModels = {'police', 'sheriff', 'police3', 'police4', 'tailgaterm', 'pdsugoi', 'polcyphtch', 'strtourunm',
            'sandmark', 'pdomnisegt', 'gt4wbint', 'marargento', 'jugularunm', 'shinobimark', 'shinobiunm', 'stdmark',
            'kurumamark', 'vigerounm', 'ballerunm', 'buffalounm', '90cxmark', 'ballermark', 'hyargento', 'jugestunm',
            'fmmarargentounmarked', 'baller8i', 'aleuunm', 'seekermark', 'polinsurge', 'niotourmark', 'unvigero2'},
        certChecks = {
            general = {
                maxItems = 10,
                items = {{
                    name = 'handcuffs',
                    count = 10,
                    price = 0
                }, {
                    name = 'bodycam',
                    count = 1,
                    price = 0
                }, {
                    name = 'WEAPON_NIGHTSTICK',
                    count = 1,
                    price = 0
                }, {
                    name = 'WEAPON_FLASHLIGHT',
                    count = 1,
                    price = 0
                }, {
                    name = 'finger_scanner',
                    count = 1,
                    price = 0
                }, {
		    name = 'breath_alcohol_tester',
                    count = 4,
                    price = 0
}}
            },
            medic = {
                maxItems = 100,
                items = {{
                name = 'temporary_tourniquet',
                count = 1,
                price = 0
            }, {
                name = 'clothing_bag',
                count = 1,
                price = 0
            }, {
                name = 'radio',
                count = 1,
                price = 0
            }, {
                name = 'pager',
                count = 1,
                price = 0
            }, {
                name = 'ecg',
                count = 1,
                price = 0
            }, {
                name = 'tourniquet',
                count = 1,
                price = 0
            }, {
                name = 'field_dressing',
                count = 1,
                price = 0
            }, {
                name = 'elastic_bandage',
                count = 1,
                price = 0
            }, {
                name = 'quick_clot',
                count = 1,
                price = 0
            }, {
                name = 'packing_bandage',
                count = 1,
                price = 0
            }, {
                name = 'sewing_kit',
                count = 1,
                price = 0
            }, {
                name = 'epinephrine',
                count = 1,
                price = 0
            }, {
                name = 'morphine',
                count = 1,
                price = 0
            }, {
                name = 'propofol',
                count = 1,
                price = 0
            }, {
                name = 'blood250ml',
                count = 1,
                price = 0
            }, {
                name = 'blood500ml',
                count = 1,
                price = 0
            }, {
                name = 'saline250ml',
                count = 1,
                price = 0
            }, {
                name = 'saline500ml',
                count = 1,
                price = 0
            }, {
                name = 'stretcher',
                count = 1,
                price = 0
            }, {
                name = 'wheelchair',
                count = 1,
                price = 0
            }, {
                name = 'ifak',
                count = 1,
                price = 0
            }, {
                name = 'revivekit',
                count = 1,
                price = 0
            }, {
                name = 'legsplint',
                count = 1,
                price = 0
            }, {
                name = 'legcast',
                count = 1,
                price = 0
            }, {
                name = 'armsplint',
                count = 1,
                price = 0
            }, {
                name = 'armcast',
                count = 1,
                price = 0
            }, {
                name = 'neckbrace',
                count = 1,
                price = 0
            }, {
                name = 'neckcast',
                count = 1,
                price = 0
            }},
},
            response = {
                maxItems = 5,
                items = {{
                    name = 'WEAPON_COMBATPISTOL',
                    count = 1,
                    price = 0
                }, {
                    name = 'ammo-9',
                    count = 50,
                    price = 0
                }}
            },
            rpu = {
                maxItems = 5,
                items = {{
                    name = 'spikestrip',
                    count = 2,
                    price = 0
                }, {
                    name = 'WEAPON_VINTAGEPISTOL',
                    count = 1,
                    price = 0
                }, {
                    name = 'clamp',
                    count = 5,
                    price = 0
                }}
            },
            cid = {
                maxItems = 8,
                items = {{
                    name = 'uvlight',
                    count = 1,
                    price = 0
                }, {
                    name = 'camera_tablet',
                    count = 1,
                    price = 0
                }, {
                    name = 'screwdriverset',
                    count = 1,
                    price = 0
                }, {
                    name = 'bodybag',
                    count = 1,
                    price = 0
                }}
            },
            medic = {
                maxItems = 8,
                items = {{
                    name = 'revivekit',
                    count = 1,
                    price = 0
                }, {
                    name = 'packing_bandage',
                    count = 1,
                    price = 0
                }, {
                    name = 'temporary_tourniquet',
                    count = 1,
                    price = 0
                }, {
                    name = 'blood500ml',
                    count = 1,
                    price = 0
                }, {
                    name = 'sewing_kit',
                    count = 1,
                    price = 0
                }, {
                    name = 'painkillers',
                    count = 1,
                    price = 0
                }, {
                    name = 'neckbrace',
                    count = 1,
                    price = 0
                }, {
                    name = 'ecg',
                    count = 1,
                    price = 0
                }, {
                    name = 'crutch',
                    count = 1,
                    price = 0
                }, {
                    name = 'field_dressing',
                    count = 1,
                    price = 0
                }, {
                    name = 'ifak',
                    count = 1,
                    price = 0
                }, {
                    name = 'elastic_bandage',
                    count = 1,
                    price = 0
                }, {
                    name = 'tourniquet',
                    count = 1,
                    price = 0
                }}
            },

            ftoc = {
                maxItems = 5,
                items = {{
                    name = 'ammo-9',
                    count = 100,
                    price = 0
                }, {
                    name = 'WEAPON_ANTIDOTE',
                    count = 3,
                    price = 0
                }, {
                    name = 'WEAPON_PEPPERSPRAY',
                    count = 3,
                    price = 0
                }}
            },
            afo = {
                maxItems = 5,
                items = {{
                    name = 'ammo-rifle2',
                    count = 100,
                    price = 0
                }}
            },
            ctsfo = {
                maxItems = 5,
                items = {{
                    name = 'ammo-rifle',
                    count = 100,
                    price = 0
                }, {
                    name = 'ammo-sniper',
                    count = 100,
                    price = 0
                }}
            }
        }
    },

    [FireJobs] = {
        vehicleModels = {'firetruk', 'brutepump', 'vulcarfire', 'brutewater', 'sporeret', 'sporefire', 'imperfire', 'fmbenefactorpol', 'csu', 'odyfire', 'reblafire', '90cxfire', 'aleufire', 'fmargentomarkedfir', 'fmcypherofficer', 'benebox', 'bruteremember'},
        [0] = {
            maxItems = 10,
            items = {{
                name = 'WEAPON_FIREEXTINGUISHER',
                count = 4,
                price = 0
            }, {
                name = 'WEAPON_SAW',
                count = 1,
                price = 0
            }, {
                name = 'WEAPON_HALLHAN',
                count = 1,
                price = 0
            }, {
                name = 'WEAPON_SPREADER',
                count = 1,
                price = 0
            }, {
                name = 'stabilisers',
                count = 1,
                price = 0
            }, {
                name = 'fan',
                count = 1,
                price = 0
            }, {
                name = 'WEAPON_FLASHLIGHT',
                count = 1,
                price = 0
            }, {
                name = 'panic_button',
                count = 1,
                price = 0
            }, {
                name = 'drone1',
                count = 1,
                price = 0
            }, {
                name = 'drone2',
                count = 1,
                price = 0
            }, {
                name = 'clothing_bag',
                count = 1,
                price = 0
            }, {
                name = 'radio',
                count = 1,
                price = 0
            }, {
                name = 'pager',
                count = 1,
                price = 0
            }, {
                name = 'ecg',
                count = 1,
                price = 0
            }, {
                name = 'tourniquet',
                count = 1,
                price = 0
            }, {
                name = 'field_dressing',
                count = 1,
                price = 0
            }, {
                name = 'elastic_bandage',
                count = 1,
                price = 0
            }, {
                name = 'quick_clot',
                count = 1,
                price = 0
            }, {
                name = 'packing_bandage',
                count = 1,
                price = 0
            }, {
                name = 'sewing_kit',
                count = 1,
                price = 0
            }, {
                name = 'epinephrine',
                count = 1,
                price = 0
            }, {
                name = 'morphine',
                count = 1,
                price = 0
            }, {
                name = 'propofol',
                count = 1,
                price = 0
            }, {
                name = 'blood250ml',
                count = 1,
                price = 0
            }, {
                name = 'blood500ml',
                count = 1,
                price = 0
            }, {
                name = 'saline250ml',
                count = 1,
                price = 0
            }, {
                name = 'saline500ml',
                count = 1,
                price = 0
            }, {
                name = 'stretcher',
                count = 1,
                price = 0
            }, {
                name = 'wheelchair',
                count = 1,
                price = 0
            }, {
                name = 'ifak',
                count = 1,
                price = 0
            }, {
                name = 'revivekit',
                count = 1,
                price = 0
            }, {
                name = 'legsplint',
                count = 1,
                price = 0
            }, {
                name = 'legcast',
                count = 1,
                price = 0
            }, {
                name = 'armsplint',
                count = 1,
                price = 0
            }, {
                name = 'armcast',
                count = 1,
                price = 0
            }, {
                name = 'neckbrace',
                count = 1,
                price = 0
            }, {
                name = 'neckcast',
                count = 1,
                price = 0
            }}
        },
    },
    [MechanicJobs] = {
        vehicleModels = {'landhigh', 'highrebla', 'reblatow', 'muletow', 'tailgaterpsni', 'highrebla', 'highbri', 'muletow', 'carautil', 'rhinehh', 'seekerpsni'},
        [0] = {
            maxItems = 10,
            items = {{
                name = 'kq_tow_rope',
                count = 1,
                price = 0
            }, {
                name = 'clothing_bag',
                count = 1,
                price = 0
            }, {
                name = 'radio',
                count = 1,
                price = 0
            }, {
                name = 'kq_winch',
                count = 1,
                price = 0
            }, {
                name = 'panic_button',
                count = 1,
                price = 0
            }, {
                name = 'harness',
                count = 3,
                price = 0
            }, {
                name = 'weapon_flashlight',
                count = 1,
                price = 0
            }, {
                name = 'burger',
                count = 10,
                price = 0
            }, {
                name = 'water',
                count = 10,
                price = 0
            }, {
                name = 'speedhawk',
                count = 10,
                price = 0
            }, {
                name = 'advancedrepairkit',
                count = 1,
                price = 0
            }, {
                name = 'repairkit',
                count = 1,
                price = 0
            }}
	},
    },
    [AmbulanceJobs] = {
        vehicleModels = {'benebox', 'xlsambo', 'shinobiambo', 'egtambo', 'ambcypher', 'nhsomnisegt', 'fmargentomarkedamb', 'bruteambo', 'sporeambo'},
        [0] = {
            maxItems = 10,
            items = {{
                name = 'temporary_tourniquet',
                count = 1,
                price = 0
            }, {
                name = 'clothing_bag',
                count = 1,
                price = 0
            }, {
                name = 'radio',
                count = 1,
                price = 0
            }, {
                name = 'pager',
                count = 1,
                price = 0
            }, {
                name = 'ecg',
                count = 1,
                price = 0
            }, {
                name = 'tourniquet',
                count = 1,
                price = 0
            }, {
                name = 'field_dressing',
                count = 1,
                price = 0
            }, {
                name = 'elastic_bandage',
                count = 1,
                price = 0
            }, {
                name = 'quick_clot',
                count = 1,
                price = 0
            }, {
                name = 'packing_bandage',
                count = 1,
                price = 0
            }, {
                name = 'sewing_kit',
                count = 1,
                price = 0
            }, {
                name = 'epinephrine',
                count = 1,
                price = 0
            }, {
                name = 'morphine',
                count = 1,
                price = 0
            }, {
                name = 'propofol',
                count = 1,
                price = 0
            }, {
                name = 'blood250ml',
                count = 1,
                price = 0
            }, {
                name = 'blood500ml',
                count = 1,
                price = 0
            }, {
                name = 'saline250ml',
                count = 1,
                price = 0
            }, {
                name = 'saline500ml',
                count = 1,
                price = 0
            }, {
                name = 'stretcher',
                count = 1,
                price = 0
            }, {
                name = 'wheelchair',
                count = 1,
                price = 0
            }, {
                name = 'ifak',
                count = 1,
                price = 0
            }, {
                name = 'revivekit',
                count = 1,
                price = 0
            }, {
                name = 'legsplint',
                count = 1,
                price = 0
            }, {
                name = 'legcast',
                count = 1,
                price = 0
            }, {
                name = 'armsplint',
                count = 1,
                price = 0
            }, {
                name = 'armcast',
                count = 1,
                price = 0
            }, {
                name = 'neckbrace',
                count = 1,
                price = 0
            }, {
                name = 'neckcast',
                count = 1,
                price = 0
            }}
        },
    }

}

-- Generic Armoury Locations with Job Types
Config.StandardLocations = {{
    coords = vector3(458.54, -979.05, 30.69),
    heading = 347.79,
    label = "Mission Row Armoury",
    jobTypes = {'pd'}
}, {
    coords = vector3(1840.94, 3691.64, 34.26),
    heading = 41.19,
    label = "Sandy PD Armoury",
    jobTypes = {'pd'}
}, {
    coords = vector3(891.36, -179.2, 74.7),
    heading = 41.19,
    label = "JRU PD Armoury",
    jobTypes = {'pd'}
}, {
    coords = vector3(-448.54, 7101.25, 22.38),
    heading = 31.72,
    label = "Paelto PD Armoury",
    jobTypes = {'pd'}
}, {
    coords = vector3(-1079.17, -819.32, 23.15),
    heading = 300.39,
    label = "Vespucci PD Armoury",
    jobTypes = {'pd'}
}, {
    coords = vector3(1692.9, 3584.44, 35.62),
    heading = 113.74,
    label = "Fire Armoury",
    jobTypes = {'fire'}
}, {
    coords = vector3(-420.07, 7076.18, 21.68),
    heading = 220.53,
    label = "Fire Armoury",
    jobTypes = {'fire'}
}, {
    coords = vector3(-439.66, -313.36, 34.91),
    heading = 19.49,
    label = "Medic Armoury",
    jobTypes = {'ambulance'}
}, {
    coords = vector3(1834.84, 3690.36, 34.27),
    heading = 200.54,
    label = "Medic Armoury",
    jobTypes = {'ambulance'}
}, {
    coords = vector3(-562.07, 7396.6, 8.52),
    heading = 140.56,
    label = "Medic Armoury",
    jobTypes = {'ambulance'}
}, {
    coords = vector3(362.35, -1417.02, 32.99),
    heading = 140.56,
    label = "Medic Armoury",
    jobTypes = {'ambulance'}
}}

Config.AdminStashItems = {
    maxItems = 40,
    items = {{
        name = 'revivekit',
        count = 4,
        price = 0
    }, {
        name = 'handcuffs',
        count = 2,
        price = 0
    }, {
        name = 'bodycam',
        count = 1,
        price = 0
    }, {
        name = 'WEAPON_PISTOL',
        count = 1,
        price = 0
    }, {
        name = 'ammo-9',
        count = 100,
        price = 0
    }, {
        name = 'burger',
        count = 30,
        price = 0
    }, {
        name = 'water',
        count = 30,
        price = 0
    }, {
        name = 'radio',
        count = 1,
        price = 0
    }, {
        name = 'phone',
        count = 1,
        price = 0
    }, {
        name = 'cash',
        count = 1000000,
        price = 0
    }, {
        name = 'WEAPON_FIREEXTINGUISHER',
        count = 1,
        price = 0
    }, {
        name = 'WEAPON_FLASHLIGHT',
        count = 1,
        price = 0
    }, {
        name = 'advancedrepairkit',
        count = 100,
        price = 0
    }, {
                    name = 'revivekit',
                    count = 1,
                    price = 0
                }, {
                    name = 'packing_bandage',
                    count = 1,
                    price = 0
                }, {
                    name = 'temporary_tourniquet',
                    count = 1,
                    price = 0
                }, {
                    name = 'blood500ml',
                    count = 1,
                    price = 0
                }, {
                    name = 'sewing_kit',
                    count = 1,
                    price = 0
                }, {
                    name = 'painkillers',
                    count = 1,
                    price = 0
                }, {
                    name = 'neckbrace',
                    count = 1,
                    price = 0
                }, {
                    name = 'ecg',
                    count = 1,
                    price = 0
                }, {
                    name = 'crutch',
                    count = 1,
                    price = 0
                }, {
                    name = 'field_dressing',
                    count = 1,
                    price = 0
                }, {
                    name = 'ifak',
                    count = 1,
                    price = 0
                }, {
                    name = 'elastic_bandage',
                    count = 1,
                    price = 0
                }, {
                    name = 'tourniquet',
                    count = 1,
                    price = 0
                }}
}
