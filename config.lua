Config = {}

Config.Debug = false -- Can be toggled with /armourydebug

-- Define job groups first
local PDJobs = {'police', 'fib'}
local Highways = {'highways', 'fib'}
local FireJobs = {'fire', 'fib'}
local AmbulanceJobs = {'ambulance', 'standbymedic', 'fib'}
local MechanicJobs = {'mechanic', 'lscustoms', 'highways', 'fib'}

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
vehicleModels = {
    'police',
    -- Sedans
    'onx_polbuff',
    'onx_polmonar',
},
        [0] = {
            maxItems = 40,
            items = {{
                name = 'handcuffs',
                count = 30,
                price = 0
            }, {
                name = 'radio',
                count = 1,
                price = 0
            }, {
                name = 'burger',
                count = 5,
                price = 0
            }, {
                name = 'water',
                count = 5,
                price = 0
            }, {
                name = 'bodycam',
                count = 1,
                price = 0
            }, {
                name = 'spike_strips',
                count = 5,
                price = 0
            }, {
                name = 'cone',
                count = 20,
                price = 0
            }, {
                name = 'barrier',
                count = 5,
                price = 0
            }, {
                name = 'work_light',
                count = 8,
                price = 0
            }, {
                name = 'dash_cam',
                count = 1,
                price = 0
            }, {
                name = 'gsr_test_kit',
                count = 1,
                price = 0
            }, {
                name = 'gsr_cloth',
                count = 1,
                price = 0
            }, {
                name = 'uv_light',
                count = 1,
                price = 0
            }, {
                name = 'WEAPON_NIGHTSTICK',
                count = 1,
                price = 0
            }, {
                name = 'WEAPON_STUNGUN',
                count = 1,
                price = 0
            }, {
                name = 'WEAPON_FLASHLIGHT',
                count = 1,
                price = 0
            }, {
                name = 'fingerprint_scanner',
                count = 1,
                price = 0
            }, {
                name = 'breathalyzer',
                count = 1,
                price = 0
            }, {
                name = 'evidence_camera',
                count = 1,
                price = 0
            }, {
                name = 'repairkit',
                count = 6,
                price = 0
            }, {
                name = 'bandage',
                count = 6,
                price = 0
            }, {
                name = 'lockpick',
                count = 100,
                price = 0
            }}
        },
        [1] = {
            maxItems = 40,
            items = {{
                name = 'WEAPON_FIREEXTINGUISHER',
                count = 1,
                price = 0
            },{
                name = 'WEAPON_COMBATPISTOL',
                count = 1,
                price = 0
            },{
                name = 'ammo-9',
                count = 40,
                price = 0
            },{
                name = 'speed_camera',
                count = 40,
                price = 0
            },{
                name = 'night_vision_goggles',
                count = 1,
                price = 0
            },{
                name = 'thermal_vision_goggles',
                count = 1,
                price = 0
            }} 
        },
        [2] = {
            maxItems = 40,
            items = {{
                name = 'WEAPON_MARKSMANPISTOL',
                count = 1,
                price = 0
            },{
                name = 'WEAPON_SMG',
                count = 1,
                price = 0
            },{
                name = 'ammo-22',
                count = 40,
                price = 0
            },{
                name = 'newplate',
                count = 40,
                price = 0
            },{
                name = 'metal_riot_shield',
                count = 1,
                price = 0
            },{
                name = 'WEAPON_TEARGAS',
                count = 40,
                price = 0
            }, {
                name = 'WEAPON_SMOKEGRENADE',
                count = 40,
                price = 0
            }} 
        },
        [3] = {
            maxItems = 40,
            items = {{
                name = 'WEAPON_MARKSMANRIFLE',
                count = 1,
                price = 0
            },{
                name = 'ammo-sniper',
                count = 60,
                price = 0
            }} 
        }
    },
    [FireJobs] = {
        vehicleModels = {'firetruk', 'brutepump', 'vulcarfire', 'brutewater', 'sporeret', 'sporefire', 'imperfire',
                         'fmbenefactorpol', 'csu', 'odyfire', 'reblafire', '90cxfire', 'aleufire', 'fmargentomarkedfir',
                         'fmcypherofficer', 'benebox', 'bruteremember'},
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
            }}
        }
    },
    [MechanicJobs] = {
        vehicleModels = {'landhigh', 'highrebla', 'reblatow', 'muletow', 'tailgaterpsni', 'highrebla', 'highbri',
                         'muletow', 'carautil', 'rhinehh', 'seekerpsni'},
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
                name = 'repairkit',
                count = 1,
                price = 0
            }}
        }
    },
    [AmbulanceJobs] = {
vehicleModels = {
    'police',
},
        [0] = {
            maxItems = 10,
            items = {{
                name = 'radio',
                count = 1,
                price = 0
            }, {
                name = 'clothing_bag',
                count = 1,
                price = 0
            }}
        }
    }

}
-- Generic Armoury Locations with Job Types
Config.StandardLocations = {{
    coords = vector3(-671.31, 347.38, 83.08),
    heading = 344.82,
    label = "Mission Row Armoury",
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
    coords = vector3(152.9, -755.97, 271.07),
    heading = 300.39,
    label = "FIB PD Armoury",
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
                name = 'WEAPON_MARKSMANRIFLE',
                count = 4,
                price = 0
            },{
                name = 'ammo-sniper',
                count = 4,
                price = 0
            }}
}
