chalk = require 'chalk'

{ log, debug, warn, err, random, getPercent } = require './general'
{ shops, QUALITY_RANGE } = require './constants'
{ getRandomPrefix } = require './weapons/prefixes.coffee'
{ getRandomSuffix } = require './weapons/suffixes.coffee'

Skills = require './skills/skills.coffee'
Weapons = require './weapons/weapons.coffee'

create = (shop, hero) ->
    newShop =
        type: shop.type
        position: shop.position
        inventory: shop.inventory

    if hero?
        newShop = createInventory shop, hero
    return Object.freeze newShop
createInventory = (shop, hero) ->
    switch shop.type
        when shops.skills then inventory = getSkills()
        when shops.weapons then inventory = generateWeapons hero
    return Object.assign {}, shop, { inventory: inventory }
showInventory = (shop, hero) ->
    switch shop.type
        when shops.skills then showSkills shop.inventory, hero
        when shops.weapons then showWeapons shop.inventory, hero
remove = (shop, key) ->
    # TODO shop inventory needs refactoring
    if shop.type is shops.skills
        return

    item = shop.inventory()[key]
    newInventory = shop.inventory().filter((x) -> x isnt item)
    shop = create Object.assign {}, shop, { inventory: () -> return newInventory }
    return [ shop, item ]

getSkills = () ->
    return (hero) ->
        list = Skills.getAvailable hero
        results = []
        for own key, skill of list
            results.push skill
            results[results.length-1].key = key
        return results

showSkills = (inventory, hero) ->
    index = 0
    shopSkills = inventory(hero)
    for skill in shopSkills
        log ''+index++ + '\t' + skill.name.toFixed(32) + '\tcost: ' + chalk.yellow skill.cost + ' gold'
    if shopSkills.length is 0
        warn 'no skills to sell yet, perhaps you need a few more levels'

getWeapons = (hero) ->
    quality = getQualityRange hero.level
    weapons = {}
    for key, weapon of Weapons.getByQuality quality when weapon.attackType is hero.weapon.attackType
        weapons[key] = weapon
    return weapons

showWeapons = (inventory) ->
    index = 0
    for weapon in inventory()
        name = weapon.name
        if weapon.prefix? then name = weapon.prefix.name + ' ' + weapon.name
        if weapon.suffix? then name = name + ' of ' + weapon.suffix.name
        log ''+index++ + '\t' + chalk.blueBright name.toFixed(32) + '\t' + chalk.green(weapon.min.toFixed(2) + ' - ' + weapon.max.toFixed(2)) + ' range: ' + weapon.range

        log '\tcost'.toFixed(32) + '\t' + chalk.yellow weapon.cost + ' gold'
        log '\t' + weapon.description
        if weapon.prefix then log '\t' + chalk.yellow(weapon.prefix.name).toFixed(32) + '\t' + weapon.prefix.description
        if weapon.suffix then log '\t' + chalk.yellow(weapon.suffix.name).toFixed(32) + '\t' + weapon.suffix.description
        if weapon.spell then log '\t' + chalk.yellow(weapon.spell.name).toFixed(32) + '\t' + weapon.spell.description
        if weapon.spellAmplification then log '\t' + chalk.yellow('spell amplification ' + getPercent(weapon.spellAmplification))
        if weapon.manaAdjustment then log '\t' + chalk.yellow('mana cost adjustment ' + getPercent(weapon.manaAdjustment, true))
        log()

getQualityRange = (level) ->
    index = 0
    for range in QUALITY_RANGE
        if range > level then return index else index++
    return index

generateWeapons = (hero) ->
    weapons = getWeapons hero
    inventory = []
    for i in [1..10]
        keys = weapons.keys
        key = random keys.length
        item = weapons[keys[key]]
        weaponBase = Weapons.create item
        weapon = Weapons.create(getRandomSuffix(getRandomPrefix(weaponBase, hero), hero))
        inventory.push weapon

    return () ->
        return inventory

module.exports =
    create: create
    showInventory: showInventory
    remove: remove
