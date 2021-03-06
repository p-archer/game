chalk = require 'chalk'

{ attackTypes, species, mapTypes, MAP_SIZE, heroClass, states, LEVEL_GAIN_FACTOR, MAX_SKILL_LEVEL, HP_GAIN_FACTOR, MANA_GAIN_FACTOR, XP_GAIN_FACTOR, WEAPON_GAIN_FACTOR, weaponStates, weaponTypes } = require './constants'
{ log, err, warn, random, getPercent } = require './general'
{ directions } = require './constants'

inspector = require './inspector.coffee'
Point = require './point'
Weapon = require './weapons/weapons.coffee'
Armour = require './armours/armours.coffee'
Skills = require './skills/skills.coffee'
Broadheads = require './weapons/broadheads.coffee'
Arrows = require './weapons/arrows.coffee'
Abilities = require './abilities/abilities.coffee'

getDamageStr = (hero) ->
    masteryBonus = Weapon.getMasteryBonus hero.masteries, hero.weapon.type
    skillBonus = Weapon.getSkillBonus hero.skills, hero.weapon.type

    if hero.quiver? and hero.broadheads?
        arrow = hero.quiver[hero.arrow]
        broadhead = hero.broadheads[hero.broadhead]
        bonus = masteryBonus * skillBonus * arrow.damage * broadhead.damage.reduce (a, x) ->
            return a + x.ratio
        , 0
        return (hero.weapon.min * bonus).toFixed(2) + ' - ' + (hero.weapon.max * bonus).toFixed(2)
    else
        return (hero.weapon.min * masteryBonus * skillBonus).toFixed(2) + ' - ' + (hero.weapon.max * masteryBonus * skillBonus).toFixed(2)
levelUp = (target) ->
    log chalk.greenBright '# ' + target.name + ' has levelled up (unspent skillpoints: ' + (target.skillPoints+1) + ')'
    return create Object.assign {}, target, {
        xp: target.xp - target.nextLevel
        nextLevel: target.nextLevel * LEVEL_GAIN_FACTOR
        level: target.level+1
        maxhp: target.maxhp + target.hpGain
        maxMana: target.maxMana * MANA_GAIN_FACTOR
        hp: target.maxhp + target.hpGain
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
    if percentage % chunk > length/2 and current isnt max
        i++
        str += '+'
    while i++<10
        str += '_'
    str += '] ' + current.toFixed(2) + '/' + max.toFixed(2) + ' ' + name

    log colorFn str
    return

attack = (source, target) ->
    return Weapon.getDamage source, target
buyArmour = (source, armour) ->
    return source
buySkill = (source, skill) ->
    skills = Object.assign {}, source.skills
    skills[skill.key] = skill
    skills[skill.key].level = 0
    log '> ' + source.name + ' bought skill ' + chalk.yellow(skill.name)
    if skill.ability?
        abilities = []
        for ability in skill.ability
            abilities.push Abilities.getAll()[ability.key]
        return create Object.assign {}, source, { skills: skills, gold: source.gold - skill.cost, abilities: [ source.abilities..., abilities... ] }
    return create Object.assign {}, source, { skills: skills, gold: source.gold - skill.cost }
buyWeapon = (source, weapon) ->
    item = Weapon.create weapon
    log '> ' + source.name + ' bought weapon ' + chalk.blueBright(item.name)
    return create Object.assign {}, source, { weapon: item, gold: source.gold - item.cost }
create = (hero) ->
    newHero =
        arrow: hero.arrow || 0
        broadhead: hero.broadhead || 0
        broadheads: hero.broadheads
        combatPos: hero.combatPos
        gold: hero.gold || 0
        free: hero.free || 0
        heroClass: hero.heroClass
        hp: hero.hp
        hpGain: hero.hpGain
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
            when heroClass.warrior, heroClass.crusader, heroClass.knight
                newHero.movement = 6
                newHero.maxhp = 12
                newHero.hpGain = 10
                newHero.maxMana = 6
            when heroClass.archer, heroClass.arbalist, heroClass.bandit
                arrows = Arrows.getAll()
                broadheads = Broadheads.getAll()
                newHero.movement = 5
                newHero.maxhp = 8
                newHero.hpGain = 6
                newHero.maxMana = 6
                newHero.broadheads = [ Broadheads.create(broadheads.normal) ]
                newHero.quiver = [ Arrows.create arrows.normal ]
                newHero.broadhead = 0
                newHero.arrow = 0
            when heroClass.mage, heroClass.wizard, heroClass.sorcerer
                newHero.movement = 4
                newHero.maxhp = 6
                newHero.hpGain = 4
                newHero.maxMana = 12
        newHero.hp = newHero.maxhp
        newHero.mana = newHero.maxMana

    # copy masteries
    if not hero.masteries?
        newHero.masteries = {}
        for own key, type of weaponTypes
            newHero.masteries[type] = initMastery()
    else
        newHero.masteries = Object.assign {}, hero.masteries

    # copy weapon
    if hero.weapon?
        newHero.weapon = Weapon.create hero.weapon
    else
        switch hero.heroClass
            when heroClass.warrior then newHero.weapon = Weapon.create Weapon.getAll().shortSword # update
            when heroClass.crusader then newHero.weapon = Weapon.create Weapon.getAll().shortSword # update
            when heroClass.knight then newHero.weapon = Weapon.create Weapon.getAll().shortSword
            when heroClass.archer then newHero.weapon = Weapon.create Weapon.getAll().shortBow
            when heroClass.arbalist then newHero.weapon = Weapon.create Weapon.getAll().shortBow # update
            when heroClass.bandit then newHero.weapon = Weapon.create Weapon.getAll().shortSpear
            when heroClass.mage then newHero.weapon = Weapon.create Weapon.getAll().shortWand # update
            when heroClass.sorcerer then newHero.weapon = Weapon.create Weapon.getAll().tomeFragment
            when heroClass.wizard then newHero.weapon = Weapon.create Weapon.getAll().shortWand

    # copy armour
    if hero.armour?
        newHero.armour = Armour.create hero.armour
    else
        switch hero.heroClass
            when heroClass.warrior, heroClass.knight, heroClass.crusader then newHero.armour = Armour.create Armour.getAll().breastPlate
            when heroClass.archer, heroClass.arbalist, heroClass.bandit then newHero.armour = Armour.create Armour.getAll().leather
            when heroClass.mage, heroClass.sorcerer, heroClass.wizard then newHero.armour = Armour.create Armour.getAll().robe

    # copy abilities
    if hero.abilities?
        newHero.abilities = [ hero.abilities... ]
    else
        newHero.abilities = []

    # copy skills
    if hero.skills?
        # TODO deep copy
        newHero.skills = Object.assign {}, hero.skills
    else
        newHero.skills = Skills.getCoreSkills hero.heroClass
        for own key, skill of newHero.skills
            skill.level = 0
            if skill.ability?
                for ability in skill.ability
                    newHero.abilities = [ newHero.abilities..., Abilities.getAll()[ability.key] ]

    return Object.freeze newHero
gainXP = (target, gained) ->
    level = target.level
    hero = Object.assign {}, target, { xp: target.xp + gained * 1 }
    while hero.xp >= hero.nextLevel
        hero = Object.assign {}, levelUp hero

    return create hero
giveGold = (target, gold) ->
    return create Object.assign {}, target, { gold: target.gold + gold * 1 }
initMastery = () ->
    return {
        level: 1
        xp: 0
        nextLevel: 25
    }
learn = (actor, damages) ->
    damage = damages.reduce (a, x) ->
        return a + x.amount
    , 0
    if damage <= 0
        return actor

    hero = Object.assign {}, actor
    masteries = Object.assign {}, actor.masteries
    mastery = masteries[actor.weapon.type]
    mastery.xp += damage
    while mastery.xp > mastery.nextLevel
        mastery.level++
        mastery.xp -= mastery.nextLevel
        mastery.nextLevel *= WEAPON_GAIN_FACTOR
        log chalk.green '# ' + actor.weapon.type + ' mastery has levelled up'

    if actor.quiver?
        quiver = Arrows.gainXP hero.quiver, hero.arrow, 1
        hero = Object.assign {}, hero, { quiver: [ quiver... ] }
    if actor.broadheads?
        broadheads = Broadheads.gainXP hero.broadheads, hero.broadhead, 1
        hero = Object.assign {}, hero, { broadheads: [ broadheads... ] }

    return create Object.assign {}, hero, { masteries: masteries }
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
        return result
    return hero
restoreHealth = (target) ->
    diff = target.maxhp - target.hp
    if diff is 0
        err '> already at full hp'
        return target

    if target.gold > diff
        hero = create Object.assign {}, target, { gold: target.gold - diff, hp: target.maxhp }
        log chalk.green '> ' + target.name + ' healed'
        return create hero
    else
        err '> you do not have enough gold'
        return target
restoreMana = (target) ->
    diff = target.maxMana - target.mana
    if diff is 0
        err '> already at full mana'
        return target

    if target.gold > diff
        hero = create Object.assign {}, target, { gold: target.gold - diff, mana: target.maxMana }
        log chalk.green '> ' + target.name + ' restored mana'
        return create hero
    else
        err '> you do not have enough gold'
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
            log 'hp:\t\t' + chalk.greenBright(hero.hp.toFixed(2) + '/' + hero.maxhp.toFixed(2))
            log 'mana:\t\t' + chalk.blueBright(hero.mana.toFixed(2) + '/' + hero.maxMana.toFixed(2))
            log 'movement:\t' + chalk.greenBright(hero.movement)
            log 'level:\t\t' + chalk.whiteBright(hero.level)
            log 'xp:\t\t' + hero.xp.toFixed(2) + '/' + hero.nextLevel.toFixed(2)
            log 'gold:\t\t' + chalk.yellow(hero.gold.toFixed(2))
            log()
            log 'unspent skillpoints\t' + chalk.greenBright(hero.skillPoints)
        when states.characterSheet.weapons
            masteryBonus = Weapon.getMasteryBonus hero.masteries, hero.weapon.type
            skillBonus = Weapon.getSkillBonus hero.skills, hero.weapon.type
            name = hero.weapon.name
            if hero.weapon.prefix? then name = hero.weapon.prefix.name + ' ' + hero.weapon.name
            if hero.weapon.suffix? then name = name + ' of ' + hero.weapon.suffix.name
            log 'name:\t\t' + chalk.blueBright(name)
            log 'description:\t\t' + hero.weapon.description
            log 'base damage:\t\t' + chalk.greenBright(hero.weapon.min.toFixed(2) + ' - ' + hero.weapon.max.toFixed(2))
            log 'actual damage:\t\t' + chalk.greenBright(getDamageStr(hero))
            log 'bonus damage from mastery:\t' + getPercent(masteryBonus)
            log 'bonus damage from skills:\t' + getPercent(skillBonus)
            log 'range:\t\t' + chalk.yellow(hero.weapon.range)
            log 'speed:\t\t' + chalk.yellow(hero.weapon.speed)
            if hero.quiver?
                arrow = hero.quiver[hero.arrow]
                log 'arrow:\t\t' + chalk.blueBright(arrow.name) + ' ' + arrow.description()
                log '\t\tlevel: ' + arrow.level + ' (' + arrow.xp.toFixed(0) + '/' + arrow.nextLevel.toFixed(0) + ')'
            if hero.broadheads?
                broadhead = hero.broadheads[hero.broadhead]
                log 'broadhead:\t' + chalk.blueBright(broadhead.name) + ' ' + broadhead.description()
                log '\t\tlevel: ' + broadhead.level + ' (' + broadhead.xp.toFixed(0) + '/' + broadhead.nextLevel.toFixed(0) + ')'
            if hero.quiver?
                log()
                log 'available arrows:\t' + hero.quiver.map((x) -> return x.name + ' level: ' + x.level).join('\n\t\t\t')
            if hero.broadheads?
                log()
                log 'available broadheads:\t' + hero.broadheads.map((x) -> return x.name + ' level: ' + x.level).join('\n\t\t\t')
        when states.characterSheet.armour
            log 'name:\t\t' + chalk.blueBright(hero.armour.name)
            log ' -- to be done --'
        when states.characterSheet.masteries
            for own key, mastery of hero.masteries
                bonus = WEAPON_GAIN_FACTOR * (mastery.level-1)
                log chalk.yellow(key.toFixed(16)) + chalk.green(('level: ' + mastery.level).toFixed(12)) + ' ' + mastery.xp.toFixed(2) + '/' + mastery.nextLevel.toFixed(2) + '\t' + 'damage bonus: ' + ((bonus-1)*100).toFixed(2) + '%'
        when states.characterSheet.skills
            index = 1
            for own key, skill of hero.skills
                log index++ + '\t' + chalk.yellow(skill.name.toFixed(32)) + skill.level + '/' + MAX_SKILL_LEVEL
        when states.characterSheet.abilities
            if hero.abilities.length is 0
                warn 'you have no abilities yet'
                warn()
            else
                for ability in hero.abilities
                    requiredMana = ability.mana * (if hero.weapon.manaAdjustment? then hero.weapon.manaAdjustment else 1)
                    log chalk.yellow(ability.name) + '\t' + chalk.blueBright(requiredMana.toFixed(2) + ' mana') + '\t' + ability.description
                log()
            if hero.weapon.spell
                requiredMana = hero.weapon.spell.mana * (if hero.weapon.manaAdjustment? then hero.weapon.manaAdjustment else 1)
                log 'weapon spell:'
                log chalk.yellow(hero.weapon.spell.name) + '\t' + chalk.blueBright(requiredMana.toFixed(2) + ' mana') + '\t' + hero.weapon.spell.description
        else showGraphs hero
    return
takeDamage = (hero, damages, effects) ->
    damage = damages.reduce (a, x) ->
        return a + x.amount
    , 0
    if damage <= 0
        return [ hero, true, 0, 0 ]

    if effects.has { effect: weaponStates.critical }
        log chalk.blueBright '> critical hit'
        damage.amount *= 2 for damage in damages

    adjustedDamages = Armour.soakDamage hero.armour, damages
    sumDmg = adjustedDamages.reduce ((acc, x) -> return acc + x.amount), 0
    hero = Object.assign {}, hero, { hp: hero.hp - sumDmg, state: [ hero.state..., effects... ] }

    hp = 0
    mana = 0
    for state in effects
        switch state.effect
            when weaponStates.leeching
                hp += sumDmg * 0.1
            when weaponStates.manaLeeching
                mana += sumDmg * 0.1
            when weaponStates.lifeDrain
                hp += sumDmg
            when weaponStates.manaDrain
                mana += sumDmg

    inspector.display hero, null, adjustedDamages, hp, mana

    if hero.hp <= 0
        err()
        err '> ' + hero.name + ' has been killed'
        err '> good bye'
        err()
        process.exit 0

    return [ create(hero), true, hp, mana ]
upgradeSkill = (hero, skillKey) ->
    skill = hero.skills[skillKey]
    if skill.level is MAX_SKILL_LEVEL
        err '> already at max level'
        return hero
    if hero.skillPoints is 0
        err '> not enough skillpoints'
        return hero

    skills = Object.assign {}, hero.skills
    skills[skillKey].level++

    adjusted = Object.assign {}, hero
    adjusted.skills = Object.assign {}, skills
    adjusted.skillPoints--
    log chalk.green '> skill upgraded (you have ' + adjusted.skillPoints + ' skillpoints left)'
    return create adjusted
useSpell = (spell, hero, monster, takeDmg) ->
    getDamage = () -> return Weapon.getDamage(hero, monster)
    return spell.use getDamage, takeDmg

module.exports =
    attack: attack
    buyArmour: buyArmour
    buySkill: buySkill
    buyWeapon: buyWeapon
    create: create
    gainXP: gainXP
    getDamageStr: getDamageStr
    giveGold: giveGold
    learn: learn
    move: move
    restoreHealth: restoreHealth
    restoreMana: restoreMana
    showSkill: showSkill
    showStats: showStats
    takeDamage: takeDamage
    upgradeSkill: upgradeSkill
    useSpell: useSpell
