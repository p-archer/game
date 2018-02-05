{ attackTypes, actions, heroStates, species, mapTypes, armourTypes, WEAPON_GAIN_FACTOR, XP_GAIN_FACTOR, weaponStates } = require '../constants'
{ random, log, err, warn } = require '../general'

chalk = require 'chalk'
Weapon = require '../weapons/weapons.coffee'
Armour = require '../armours/armours.coffee'
inspector = require '../inspector.coffee'

meleeMonsters = require './melee.monsters.coffee'
rangedMonsters = require './ranged.monsters.coffee'
magicMonsters = require './magic.monsters.coffee'

Entity = require '../entity.coffee'

monsters = [meleeMonsters..., rangedMonsters..., magicMonsters...]

getAll = () -> return monsters

create = (monster) ->
    newMonster =
        arrow: monster.arrow
        broadhead: monster.broadhead
        combatPos: monster.combatPos
        level: monster.level
        movement: monster.movement
        name: monster.name
        position: monster.position
        gold: monster.gold
        xp: monster.xp
        maxhp: monster.maxhp
        maxMana: monster.maxMana
        species: monster.species
        land: monster.land
        state: [monster.state...]

    if not monster.hp then newMonster.hp = monster.maxhp else newMonster.hp = monster.hp
    if not monster.mana then newMonster.mana = monster.maxMana else newMonster.mana = monster.mana

    # masteries
    newMonster.masteries = Object.assign {}, monster.masteries

    # create weapon
    newMonster.weapon = Object.assign {}, monster.weapon

    # create armour
    newMonster.armour = Object.assign {}, monster.armour

    # create skills
    newMonster.skills = Object.assign {}, monster.skills

    return Object.freeze newMonster
createFromTemplate = (monster, level) ->
    newMonster =
        arrow: monster.arrow
        broadhead: monster.broadhead
        combatPos: null
        level: level
        movement: monster.movement
        name: monster.name
        position: monster.position
        maxhp: monster.maxhp
        maxMana: monster.maxMana
        hp: monster.maxhp
        mana: monster.maxMana
        xp: (monster.xp.min + random(monster.xp.max - monster.xp.min)) * Math.pow(XP_GAIN_FACTOR, level)
        gold: (monster.gold.min + random(monster.gold.max - monster.xp.min)) * Math.pow(XP_GAIN_FACTOR, level)
        species: monster.species
        land: monster.land
        state: []

    # masteries
    masteryLevel = level/2 + random level/2
    newMonster.masteries = {}
    newMonster.masteries[monster.attack.attackType] =
        level: masteryLevel
        xp: 0

    # TODO skills and skills bonus damage
    newMonster.skills = {}

    # create weapon
    weapons = Weapon.getAll()
    armours = Armour.getAll()
    options =
        min: monster.attack.min * Math.pow WEAPON_GAIN_FACTOR, masteryLevel
        max: monster.attack.max * Math.pow WEAPON_GAIN_FACTOR, masteryLevel
        range: monster.attack.range || 1
        spell: monster.attack.spell
    switch monster.attack.attackType
        when attackTypes.melee then newMonster.weapon = Weapon.create Object.assign {}, weapons.shortSword, options
        when attackTypes.ranged then newMonster.weapon = Weapon.create Object.assign {}, weapons.shortBow, options
        when attackTypes.magic then newMonster.weapon = Weapon.create Object.assign {}, weapons.shortWand, options

    # create armour
    armourOptions =
        resistance:
            melee: monster.armour.melee.min + random(monster.armour.melee.max - monster.armour.melee.min)
            ranged: monster.armour.ranged.min + random(monster.armour.ranged.max - monster.armour.ranged.min)
            magic: monster.armour.magic.min + random(monster.armour.magic.max - monster.armour.magic.min)
    switch monster.armour.type
        when armourTypes.light then newMonster.armour = Armour.create Object.assign {}, armours.robe, armourOptions
        when armourTypes.medium then newMonster.armour = Armour.create Object.assign {}, armours.leather, armourOptions
        when armourTypes.heavy then newMonster.armour = Armour.create Object.assign {}, armours.breastPlate, armourOptions

    return Object.freeze newMonster
dead = (monster, hero) ->
    bonusGold = getBonusGold monster, hero
    log()
    log chalk.green '> ' + monster.name + ' is dead'
    log chalk.green('> looted ') + chalk.yellow(monster.gold.toFixed(2) + ' + ' + bonusGold.toFixed(2) + ' gold')
    log chalk.green('> gained ') + chalk.yellow(monster.xp.toFixed(2) + ' xp')

    return [ monster.gold + bonusGold, monster.xp ]
getBonusGold = (monster, hero) ->
    types = monster.species
    if types.has species.beast and hero.skills.skinning?
        return monster.gold * hero.skills.skinning.level * hero.skills.skinning.bonus
    return 0
getRandomType = (level, mapType) ->
    available = monsters.filter (x) ->
        return x.land.has(mapType) and x.minLevel <= level and x.maxLevel >= level
    return available[random available.length]
attack = (monster, hero) ->
    distance = monster.combatPos - hero.combatPos
    damage = Weapon.getDamage monster, hero

    effects = [
        (if monster.weapon.modifier? then monster.weapon.modifier() else [])...
        (if monster.weapon.suffix? then monster.weapon.suffix.use() else [])...
    ]

    # TODO deal with leeching
    # TODO deal with reflect

    return [ monster, damage, effects ]
getAction = (source, target) ->
    if source.state.filter((x) -> x.effect is heroStates.frozen).length > 0
        log source.name + ' is frozen'
        return null

    distance = Math.abs source.combatPos - target.combatPos
    if distance is 1
        return actions.attack
    else
        switch source.weapon.attackType
            when attackTypes.magic
                if source.mana < source.weapon.spell.mana * source.weapon.manaAdjustment
                    return actions.move
                else
                    return actions.useSpell
            when attackTypes.melee
                if source.state.has heroStates.maimed
                    log '> ' + source.name + ' can not move'
                else
                    return actions.move
            when attackTypes.ranged
                if source.weapon.range >= distance
                    return actions.attack
                else
                    return actions.move
    return null
takeAction = (source, target) ->
    # 3 actions: move, attack, use ability
    action = getAction source, target
    switch action
        when actions.move
            combatPos = Math.max(source.combatPos - source.movement, target.combatPos + 1)
            monster = create Object.assign {}, source, { combatPos: combatPos }

            log '> ' + source.name + ' approaching ' + target.name
            return [ monster, 0, [] ]
        when actions.attack
            [ monster, damage, effects ] = attack source, target

            return [ monster, damage, effects ]
        when actions.useSpell
            spell = source.weapon.spell
            weaponDamage = Weapon.getDamage source
            [ damage, effects ] = spell.use source.weapon, weaponDamage
            monster = create Object.assign {}, source, { mana: source.mana - source.weapon.spell.mana }

            log monster.name + ' used ' + chalk.yellow(spell.name)
            return [ monster, damage, effects ]
        else
            log '> ' + source.name + ' passes turn'
            return [ source, 0, [] ]
getDamageStr = (source) ->
    skillsBonus = Entity.getDamageBonusFromSkills source.skills, source.weapon.attackType
    mastery = source.masteries[source.weapon.attackType]
    masteryBonus = Math.pow WEAPON_GAIN_FACTOR, mastery.level
    return '' + (source.weapon.min * masteryBonus * skillsBonus).toFixed(2) + ' - ' + (source.weapon.max * masteryBonus * skillsBonus).toFixed(2)
getArmourStr = (source) ->
    return source.armour.name + '\tresistances: ' + source.armour.resistance.melee + '/' + source.armour.resistance.ranged + '/' + source.armour.resistance.magic
showStats = (monster, inspectionLevel) ->
    log '> enemy type: ' + chalk.redBright monster.name
    switch inspectionLevel
        when 1 then log '> level: ' + monster.level
        when 2
            log '> level: ' + monster.level
            log '> hp: ' + ((monster.hp/monster.maxhp)*100).toFixed(2) + '%'
        when 3
            log '> level: ' + monster.level
            log '> hp: ' + monster.hp.toFixed(2)/monster.maxhp.toFixed(2)
        when 4
            log '> level: ' + monster.level
            log '> hp: ' + monster.hp.toFixed(2)/monster.maxhp.toFixed(2)
            log '> weapon: ' + monster.weapon.attackType
            log '> damage: ' + chalk.redBright getDamageStr(monster)
        when 5
            log '> level: ' + monster.level
            log '> hp: ' + monster.hp.toFixed(2)/monster.maxhp.toFixed(2)
            log '> movement: ' + monster.movement
            log '> weapon: ' + monster.weapon.attackType + ' range: ' + monster.weapon.range
            log '> damage: ' + chalk.redBright getDamageStr monster
            log '> armour: ' + chalk.yellow getArmourStr monster
            if monster.skills.size > 0
                log '> skills: '
                for own key, skill of monster.skills
                    log '>\t' + skill.name + ' ' + skill.level
    return
adjust = (map, pos, changes...) ->
    # TODO mutates map
    monsterList = [ map.current.monsters... ]
    newArray = monsterList.filter (x) ->
        return x.position.x isnt pos.x or x.position.y isnt pos.y
    current = monsterList.filter (x) ->
        return x.position.x is pos.x and x.position.y is pos.y
    monster = create Object.assign {}, current[0], changes...
    map.current.monsters = [newArray..., monster]

    return monster

takeDamage = (monster, attackType, damage, effects) ->
    if damage > 0 and effects.has weaponStates.critical
        log '> critical hit'
        damage *= 2
        effects.remove weaponStates.critical
    if damage > 0 and effects.has weaponStates.piercing
        log '> piercing hit'
        attackType = attackTypes.pure
        effects.remove weaponStates.piercing

    adjustedDamage = Armour.soakDamage monster.armour, damage, attackType
    newMonster = Object.assign {}, monster, { hp: monster.hp - adjustedDamage, state: [ monster.state..., effects... ] }

    inspector.display null, monster, adjustedDamage

    if newMonster.hp <= 0
        return [ create(newMonster), false ]

    return [ create(newMonster), true ]

remove = (map, pos) ->
    # TODO mutates map
    map.current.monsters = map.current.monsters.filter (x) ->
        return x.position.x isnt pos.x or x.position.y isnt pos.y

    return map

module.exports =
    adjust: adjust
    attack: attack
    create: create
    createFromTemplate: createFromTemplate
    dead: dead
    getAll: getAll
    getRandomType: getRandomType
    remove: remove
    showStats: showStats
    takeAction: takeAction
    takeDamage: takeDamage
