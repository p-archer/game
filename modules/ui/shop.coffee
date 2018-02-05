{ log, err } = require '../general'
{ states, shops } = require '../constants'

Shop = require '../shop.coffee'
Hero = require '../hero.coffee'

outputter = (state, hero, map) ->
    shop = map.current.shops[0]
    Shop.showInventory shop
    return

mutator = (state, input, hero, map) ->
    num = parseInt input
    shop = map.current.shops[0]
    if not isNaN(num) and num < shop.inventory.length
        switch shop.type
            when shops.skills
                [ shop, skill ] = Shop.remove shop, num
                hero = Hero.buySkill hero, skill
            when shops.weapons
                [ shop, weapon ] = Shop.remove shop, num
                hero = Hero.buyWeapon hero, weapon
        map.current.shops = [ shop ]
        return [ true, { state: state.state }, hero, map ]
    return [ false, state, hero, map ]

register = (processors, outputProcessors) ->
    return [
        [
            processors...
            { state: states.shop, fn: mutator }
        ]
        [
            outputProcessors...
            { state: states.shop, fn: outputter }
        ]
    ]

module.exports =
    register: register
