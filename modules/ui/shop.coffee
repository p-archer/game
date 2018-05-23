{ log, err } = require '../general'
{ states, shops } = require '../constants'
chalk = require 'chalk'

Shop = require '../shop.coffee'
Hero = require '../hero.coffee'
Skills = require '../skills/skills.coffee'
Weapons = require '../weapons/weapons.coffee'

outputter = (state, hero, map) ->
    page = state.param || 0
    shop = map.current.shops[0]
    Shop.showInventory shop, page

    log()
    log chalk.magenta ' + page #' + (page+1)
    log ' - hero level: '.toFixed(24) + chalk.green hero.level
    log ' - mastery level: '.toFixed(24) + chalk.green hero.masteries[hero.weapon.type].level
    log ' - gold:'.toFixed(24) + chalk.yellow hero.gold.toFixed(2)
    log()
    log 'f\t\tfull heal'
    log 'r\t\trestore mana'
    log()
    log 'p/n\t\tprevious/next page'
    log 'q\t\tback'
    return

mutator = (state, input, hero, map) ->
    page = state.param || 0
    shop = map.current.shops[0]
    maxpage = Math.ceil(shop.inventory.length / 5)-1

    switch input
        when 'f' then return [ true, state, Hero.restoreHealth(hero), map ]
        when 'r' then return [ true, state, Hero.restoreMana(hero), map ]
        when 'p' then return [ true, { state: state.state, param: if page is 0 then maxpage else page-1 }, hero, map ]
        when 'n' then return [ true, { state: state.state, param: if page is maxpage then 0 else page+1 }, hero, map ]
        when 'q' then return [ true, { state: states.normal }, hero, map ]

    num = page * 5 + (parseInt(input)-1)
    if not isNaN(num) and num < shop.inventory.length
        switch shop.type
            when shops.skills
                if Skills.isAvailable hero, shop.inventory[num]
                    [ shop, skill ] = Shop.remove shop, num
                    hero = Hero.buySkill hero, skill
            when shops.weapons
                if Weapons.isAvailable hero, shop.inventory[num]
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
