{ attackTypes, species, mapTypes, MAP_SIZE, heroClass, states, MAX_SKILL_LEVEL, HP_GAIN_FACTOR, MANA_GAIN_FACTOR } = require './constants'

chalk = require 'chalk'
{ log, err, warn, random } = require './general'
{ directions } = require './constants'
inspector = require './inspector.coffee'
Point = require './point'
Weapon = require './weapons/weapons.coffee'
Armour = require './armours/armours.coffee'
Skills = require './skills/skills.coffee'
Broadheads = require './weapons/broadheads.coffee'
Arrows = require './weapons/arrows.coffee'

levelUp = (target) ->
    return create Object.assign {}, target, {
        level: target.level+1
        maxhp: target.maxhp * HP_GAIN_FACTOR
        maxMana: target.maxMana * MANA_GAIN_FACTOR
        hp: target.maxhp * HP_GAIN_FACTOR
        mana: target.maxMana * MANA_GAIN_FACTOR
        skillPoints: target.skillPoints+1
    }
showGraphs = (actor) ->
    showGraph actor.hp, actor.maxhp, 'hp', chalk.redBright
    showGraph actor.mana, actor.maxMana, 'mana', chalk.blueBright
    showGraph actor.xp, actor.nextLevel, 'xp'
showGraph = (current, max, name, colorFn = chalk.white) ->
    length = 10
    chunk = 100/length
    percentage = 100*current/max
    str = '['
    for i in [0...Math.floor(percentage/chunk)]
        str += '#'
    if percentage % chunk > length/2
        i++
        str += '+'
    while i++<10
        str += '_'
    str += '] ' + current.toFixed(2) + '/' + max.toFixed(2) + ' ' + name

    log colorFn str
    return

attack = (source, target) ->
    weaponDamage = Weapon.getDamage source, target
    effects = [
        (if source.weapon.modifier? then source.weapon.modifier() else [])...
        (if source.weapon.suffix? then source.weapon.suffix.use() else [])...
    ]

    if source.weapon.attackType is attackTypes.ranged
        effects = [ effects..., source.broadhead.use()... ]

    return [ weaponDamage, effects ]
buyArmour = (source, armour) ->
    return source
buySkill = (source, skill) ->
    skills = Object.assign {}, source.skills
    skills[skill.key] = skill
    skills[skill.key].level = 0
    log '> ' + source.name + ' bought skill ' + chalk.yellow(skill.name)
    return create Object.assign {}, source, { skills: skills }
buyWeapon = (source, weapon) ->
    item = Weapon.create weapon
    log '> ' + source.name + ' bought weapon ' + chalk.blueBright(item.name)
    return create Object.assign {}, source, { weapon: item }
create = (hero) ->
    newHero =
        arrow: hero.arrow
        broadhead: hero.broadhead
        broadheads: hero.broadheads
        combatPos: hero.combatPos
        gold: hero.gold || 0
        heroClass: hero.heroClass
        hp: hero.hp
        level: hero.level || 1
        mana: hero.mana
        maxhp: hero.maxhp
        maxMana: hero.maxMana
        movement: hero.movement
        name: hero.name || 'hero'
        nextLevel: hero.nextLevel || 10
        position: new Point(hero.position.x, hero.position.y)
        quiver: hero.quiver
        skillPoints: hero.skillPoints || 0
        state: hero.state || []
        xp: hero.xp || 0

    if not hero.maxhp?
        switch hero.heroClass
            when heroClass.warrior
                newHero.movement = 10
                newHero.maxhp = 10
                newHero.maxMana = 6
            when heroClass.archer
                newHero.movement = 8
                newHero.maxhp = 8
                newHero.maxMana = 10
                newHero.broadheads = [ Broadheads.normal, Broadheads.bleeding, Broadheads.burning ]
                newHero.quiver = [ Arrows.normal, Arrows.sniper, Arrows.steel ]
                newHero.broadhead = newHero.broadheads[0]
                newHero.arrow = newHero.quiver[0]
            when heroClass.mage
                newHero.movement = 6
                newHero.maxhp = 6
                newHero.maxMana = 16
        newHero.hp = newHero.maxhp
        newHero.mana = newHero.maxMana

    # copy masteries
    newHero.masteries = {}
    for key, attackType of attackTypes
        newHero.masteries[attackType] =
            level: if hero.masteries? and hero.masteries[attackType] then hero.masteries[attackType].level else 1
            xp: if hero.masteries? and hero.masteries[attackType] then hero.masteries[attackType].xp else 0
            nextLevel: if hero.masteries? and hero.masteries[attackType] then hero.masteries[attackType].nextLevel else 10

    # copy weapon
    if hero.weapon?
        newHero.weapon = Weapon.create hero.weapon
    else
        switch hero.heroClass
            when heroClass.warrior then newHero.weapon = Weapon.create Weapon.getAll().shortSword
            when heroClass.archer then newHero.weapon = Weapon.create Weapon.getAll().shortBow
            when heroClass.mage then newHero.weapon = Weapon.create Weapon.getAll().shortWand

    # copy armour
    if hero.armour?
        newHero.armour = Armour.create hero.armour
    else
        switch hero.heroClass
            when heroClass.warrior then newHero.armour = Armour.create Armour.getAll().breastPlate
            when heroClass.archer then newHero.armour = Armour.create Armour.getAll().leather
            when heroClass.mage then newHero.armour = Armour.create Armour.getAll().robe

    # copy skills
    if hero.skills?
        # TODO deep copy
        newHero.skills = Object.assign {}, hero.skills
    else
        skills =
            inspection: Skills.getAll().inspection
            lockpick: Skills.getAll().lockpick
        switch hero.heroClass
            when heroClass.warrior then skills.melee = Skills.getAll().melee
            when heroClass.archer then skills.ranged = Skills.getAll().ranged
            when heroClass.mage then skills.magic = Skills.getAll().magic
        for own key, skill of skills
            skill.level = 0
        newHero.skills = skills

    # copy abilities
    if hero.abilities?
        # TODO deep copy
        newHero.abilities = Object.assign {}, hero.abilities
    else
        newHero.abilities = {}

    return Object.freeze newHero
gainXP = (target, gained) ->
    level = target.level
    hero = Object.assign {}, target, { xp: target.xp + gained }
    while hero.xp >= hero.nextLevel
        hero.xp -= hero.nextLevel
        hero = Object.assign {}, levelUp hero

    return create hero
giveGold = (target, gold) ->
    return create Object.assign {}, target, { gold: target.gold + gold }
move = (hero, level, direction) ->
    result = null

    switch direction
        when directions.north
            if level.isValid hero.position.x, hero.position.y-1
                result = create Object.assign {}, hero, { position: { x: hero.position.x, y: hero.position.y-1 } }
        when directions.south
            if level.isValid hero.position.x, hero.position.y+1
                result = create Object.assign {}, hero, { position: { x: hero.position.x, y: hero.position.y+1 } }
        when directions.east
            if level.isValid hero.position.x+1, hero.position.y
                result = create Object.assign {}, hero, { position: { x: hero.position.x+1, y: hero.position.y } }
        when directions.west
            if level.isValid hero.position.x-1, hero.position.y
                result = create Object.assign {}, hero, { position: { x: hero.position.x-1, y: hero.position.y } }

    if result?
        # map.show hero
        # level.showCellData hero
        return result
    return hero
restoreHealth = (target) ->
    diff = target.maxhp - target.hp
    if diff is 0
        log chalk.yellow '> already at full hp'
        return target

    if target.gold > diff
        hero = create Object.assign {}, target, { gold: target.gold - diff, hp: target.maxhp }
        log chalk.green '> ' + target.name + ' healed'
        return hero
    else
        log chalk.red '> you do not have enough gold'
        return target
restoreMana = (target) ->
    diff = target.maxMana - target.mana
    if diff is 0
        log chalk.yellow '> already at full mana'
        return target

    if target.gold > diff
        hero = create Object.assign {}, target, { gold: target.gold - diff, mana: target.maxMana }
        log chalk.green '> ' + target.name + ' restored mana'
        return hero
    else
        log chalk.red '> you do not have enough gold'
        return target
showSkill = (hero, skillKey) ->
    skill = hero.skills[skillKey]
    log ' --- ' + skill.name + ' --- '
    log 'level: ' + skill.level
    log skill.description
    return
showStats = (hero, state) ->
    switch state
        when states.characterSheet.main
            log 'hp:\t\t' + hero.hp + '/' + hero.maxhp
            log 'mana:\t\t' + hero.mana + '/' + hero.maxMana
            log 'movement:\t' + hero.movement
            log 'level:\t\t' + hero.level
            log 'xp:\t\t' + hero.xp + '/' + hero.nextLevel
            log 'gold:\t\t' + hero.gold
            log()
            log 'unspent skillpoints\t' + hero.skillPoints
        when states.characterSheet.weapons
            log 'name:\t\t' + hero.weapon.name
            log 'damage:\t\t' + hero.weapon.min.toFixed(2) + ' - ' + hero.weapon.max.toFixed(2)
            log 'range:\t\t' + hero.weapon.range
        when states.characterSheet.armour
            log 'name:\t\t' + hero.armour.name
        when states.characterSheet.skills
            index = 0
            for own key, skill of hero.skills
                log index++ + ' ' + skill.name + '\t' + skill.level + '/' + MAX_SKILL_LEVEL
        when states.characterSheet.abilities
            for own key, ability of hero.abilities
                log ability.name + '\t' + ability.description
            if hero.weapon.spell
                log 'weapon spell: ' + hero.weapon.spell.name + '\t' + hero.weapon.spell.description
        else showGraphs hero
    return
takeDamage = (hero, attackType, damage, effects) ->
    adjustedDamage = Armour.soakDamage hero.armour, damage, attackType
    hero = Object.assign {}, hero, { hp: hero.hp - adjustedDamage, state: [ hero.state..., effects... ] }

    inspector.display hero, null, adjustedDamage

    if hero.hp <= 0
        err()
        err '> ' + hero.name + ' has been killed'
        err '> good bye'
        err()
        process.exit 0

    return [ create(hero), true ]
upgradeSkill = (hero, skillKey) ->
    skill = hero.skills[skillKey]
    if skill.level is MAX_SKILL_LEVEL
        log chalk.yellow '> already at max level'
        return hero
    if hero.skillPoints is 0
        log chalk.yellow '> not enough skillpoints'
        return hero

    skills = Object.assign {}, hero.skills
    skills[skillKey].level++

    adjusted = Object.assign {}, hero
    adjusted.skills = Object.assign {}, skills
    adjusted.skillPoints--
    log '> skill upgraded (you have ' + adjusted.skillPoints + ' skillpoints left)'
    return create adjusted
useSpell = (spell, hero, map) ->
    # TODO mana adjustment based on weapon and skills
    # TODO damage adjustment based on weapon and skills
    if spell.mana * hero.weapon.manaAdjustment > hero.mana
        warn '> not enough mana'
        return [ false ]

    hero = create Object.assign {}, hero, { mana: hero.mana - spell.mana * hero.weapon.manaAdjustment }
    monster = map.current.isMonster hero.position

    weaponDamage = Weapon.getDamage hero
    [ damage, effects ] = spell.use hero.weapon, weaponDamage

    return [ true, hero, damage, effects ]

module.exports =
    attack: attack
    buyArmour: buyArmour
    buySkill: buySkill
    buyWeapon: buyWeapon
    create: create
    gainXP: gainXP
    giveGold: giveGold
    move: move
    restoreHealth: restoreHealth
    restoreMana: restoreMana
    showSkill: showSkill
    showStats: showStats
    takeDamage: takeDamage
    upgradeSkill: upgradeSkill
    useSpell: useSpell
