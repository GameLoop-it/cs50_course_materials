--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = "pot",
        texture = "tiles",
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        destructible = true,
        defaultState = "intact",
        states = {
            ["intact"] = {
                frame = 14
            },
            ["throwing"] = {
            },
            ["broken"] = {
                frame = 52
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 5
            }
        }
    }
}