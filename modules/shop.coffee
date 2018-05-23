chalk = require 'chalk'

{ log, debug, warn, err, random, getPercent } = require './general'
{ shops, QUALITY_RANGE } = require './constants'
{ getRandomPrefix } = require './weapons/prefixes.coffee'
{ getRandomSuffix } = require './weapons/suffixes.coffee'

Skills = require './skills/skills.coffee'
Weapons = require './weapons/weapons.coffee'

PAGE_SIZE = 5

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
        when shops.skills then inventory = getSkills hero
        when shops.weapons then inventory = generateWeapons hero
    return Object.assign {}, shop, { inventory: inventory }
showInventory = (shop, page) ->
    switch shop.type
        when shops.skills then showSkills shop.inventory, page
        when shops.weapons then showWeapons shop.inventory, page
remove = (shop, key) ->
    item = shop.inventory[key]
    newInventory = shop.inventory.filter((x) -> x isnt item)
    shop = create Object.assign {}, shop, { inventory: newInventory }
    return [ shop, item ]

getSkills = (hero) ->
    list = Skills.getAvailable Object.assign {}, hero, { level: hero.level + 10 }
    results = []
    for own key, skill of list
        results.push skill
        results[results.length-1].key = key
    return results

showSkills = (inventory) ->
    index = 1
    log()
    for skill in inventory
        log ''+index++ + '\t' + skill.name.toFixed(32) + '\tcost: ' + chalk.yellow skill.cost + ' gold'
    if inventory.length is 0
        warn 'no skills to sell yet, perhaps you need a few more levels'

getWeapons = (hero) ->
    quality = getQualityRange hero.level
    weapons = []
    for own key, weapon of Weapons.getByQuality quality
        weapons.push weapon
    return weapons

showWeapons = (inventory, page) ->
    start = page * PAGE_SIZE
    end = Math.min (page + 1) * PAGE_SIZE, inventory.length
    log()

    index = 1
    for weapon in inventory[start..end-1]
        name = weapon.name
        if weapon.prefix? then name = weapon.prefix.name + ' ' + weapon.name
        if weapon.suffix? then name = name + ' of ' + weapon.suffix.name
        log ''+index++ + '\t' + chalk.blueBright name.toFixed(32) + '\t' + chalk.green(weapon.min.toFixed(2) + ' - ' + weapon.max.toFixed(2)) + ' range: ' + weapon.range + ' speed: ' + weapon.speed

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
        melee = weapons.filter (x) -> return not x.range? and not x.spells?
        item = melee[random(melee.length)]
        if item?
            weaponBase = Weapons.create item
            weapon = Weapons.create(getRandomSuffix(getRandomPrefix(weaponBase, hero), hero))
            inventory.push weapon
    for i in [1..10]
        ranged = weapons.filter (x) -> return x.range?
        item = ranged[random(ranged.length)]
        if item?
            weaponBase = Weapons.create item
            weapon = Weapons.create(getRandomSuffix(getRandomPrefix(weaponBase, hero), hero))
            inventory.push weapon
    for i in [1..10]
        magic = weapons.filter (x) -> return x.spells?
        item = magic[random(magic.length)]
        if item?
            weaponBase = Weapons.create item
            weapon = Weapons.create(getRandomSuffix(getRandomPrefix(weaponBase, hero), hero))
            inventory.push weapon

    return inventory

module.exports =
    create: create
    showInventory: showInventory
    remove: remove
