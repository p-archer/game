{ err, log, random } = require '../general'
{ heroStates, WEAPON_GAIN_FACTOR, attackTypes, speed } = require '../constants'

# melee: swords (med damage, 1 range, fast), axes (high damage, 1 range, slow), spears (med damage, 2-3 range, med speed), great sword (high damage, 2 range, slow)
# ranged: bows (med range, fast, med damage), crossbows (high range, slow, high damage), javelins (low range, med speed, med damage, no melee penalty)
# magic: wand (all, low damage, fast), tome (arcane, med damage, med speed), staff (high damage, slow speed), relics (divination, med damage, med speed)
# magic needs to be worked out (magic types, bonuses) - priest (light, lightning, blessings, some combat abilities), wizard (arcane, elemental), sorcerer (curses, dark, fire/ice)

# bows critical, crossbows piercing, spears maiming
# swords critical, axes bleeding, hammers stunning
# wands ?, tomes ?, staves ?

bows = require './bows.coffee'
spears = require './spears.coffee'
swords = require './swords.coffee'
tomes = require './tomes.coffee'
wands = require './wands.coffee'

weaponList = Object.assign {}, swords, bows, spears, wands, tomes

getAll = () ->
    return weaponList

getAvailable = (hero) ->
    weapons = {}
    for own key, weapon of weaponList when not monsterOnly and weapon.requirements? and weapon.requirements.level <= hero.level and weapon.name isnt hero.weapon.name and weapon.quality >= hero.weapon.quality
        weapons[key] = weapon
    return weapons

getByQuality = (quality) ->
    weapons = {}
    for own key, weapon of weaponList when weapon.quality is quality
        weapons[key] = weapon
    return weapons

isAvailable = (hero, weapon) ->
    if hero.level < weapon.requirements.level
        err ' > required level not reached (you have: ' + hero.level + ', required: ' + weapon.requirements.level + ')'
        return false

    if weapon.requirements.skills?
        for req in weapon.requirements.skills
            target = hero.skills[req.skill.key]
            if not target? or target.level < req.level
                err '> required skill ' + req.skill.name + ' of level ' + req.level + ' missing'
                return false

    if hero.gold < weapon.cost
        err '> not enough gold to buy weapon'
        return false

    return true

create = (weapon) ->
    newWeapon =
        attackType: weapon.attackType
        cost: weapon.cost
        description: weapon.description
        manaAdjustment: weapon.manaAdjustment
        max: weapon.max
        min: weapon.min
        modifier: weapon.modifier
        name: weapon.name
        prefix: weapon.prefix
        quality: weapon.quality
        range: weapon.range
        requirements: Object.assign {}, weapon.requirements
        showCombat: weapon.showCombat
        speed: weapon.speed || speed.normal
        spell: weapon.spell
        spellAmplification: weapon.spellAmplification
        spells: weapon.spells
        suffix: weapon.suffix
        type: weapon.type

        getDamage: weapon.getDamage

    # if weapon.init? and not weapon.spell # don't init weapon if spell is already selected
    if weapon.init?
        newWeapon = weapon.init newWeapon
        newWeapon.init = null
        if weapon.spell then newWeapon.spell = weapon.spell
    return Object.freeze newWeapon

getSkillBonus = (skills, weaponType) ->
    skillMultiplier = 1
    for own key, skill of skills
        if skill.weaponType? and weaponType in skill.weaponType and skill.damageBonus?
            skillMultiplier += skill.damageBonus()

    return skillMultiplier

getMasteryBonus = (masteries, type) ->
    if masteries[type]?
        return 1 + (WEAPON_GAIN_FACTOR-1) * (masteries[type].level-1)
    else
        return 1

getDamage = (actor, enemy) ->
    masteryBonus = getMasteryBonus actor.masteries, actor.weapon.type
    skillBonus = getSkillBonus actor.skills, actor.weapon.type

    [ damages, effects ] = actor.weapon.getDamage actor, Math.abs actor.combatPos - enemy.combatPos

    for entry in damages # not really smart
        entry.amount *= masteryBonus * skillBonus

    effects = [
        effects...
        (if actor.weapon.modifier? then actor.weapon.modifier() else [])...
        (if actor.weapon.suffix? then actor.weapon.suffix.apply() else [])...
    ]

    return [ damages, effects ]

module.exports =
    create: create
    getAll: getAll
    getAvailable: getAvailable
    getByQuality: getByQuality
    getDamage: getDamage
    getMasteryBonus: getMasteryBonus
    getSkillBonus: getSkillBonus
    isAvailable: isAvailable
