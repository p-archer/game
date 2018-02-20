{ log, err } = require '../general'
{ states, shops } = require '../constants'
chalk = require 'chalk'

Shop = require '../shop.coffee'
Hero = require '../hero.coffee'
Skills = require '../skills/skills.coffee'
Weapons = require '../weapons/weapons.coffee'

outputter = (state, hero, map) ->
    shop = map.current.shops[0]
    Shop.showInventory shop

    log()
    log ' - hero level: '.toFixed(24) + chalk.green hero.level
    log ' - mastery level: '.toFixed(24) + chalk.green hero.masteries[hero.weapon.type].level
    log ' - gold:'.toFixed(24) + chalk.yellow hero.gold.toFixed(2)
    log()
    log 'f\t\tfull heal'
    log 'r\t\trestore mana'
    log()
    log 'q\t\tback'
    return

mutator = (state, input, hero, map) ->
    switch input
        when 'f' then return [ true, state, Hero.restoreHealth(hero), map ]
        when 'r' then return [ true, state, Hero.restoreMana(hero), map ]

    num = parseInt input
    shop = map.current.shops[0]
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
