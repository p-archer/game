{ err, log, random } = require '../general'
{ heroStates, WEAPON_GAIN_FACTOR, attackTypes } = require '../constants'

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
    for key, weapon of weaponList when weapon.requirements? and weapon.requirements.level <= hero.level and weapon.name isnt hero.weapon.name and weapon.quality >= hero.weapon.quality
        weapons[key] = weapon
    return weapons

getByQuality = (quality) ->
    weapons = {}
    for key, weapon of weaponList when weapon.quality is quality
        weapons[key] = weapon
    return weapons

isAvailable = (hero, weapon) ->
    if hero.level < weapon.requirements.level
        err ' > required level not reached (you have: ' + hero.level + ', required: ' + weapon.requirements.level + ')'
        return false
    if weapon.requirements.mastery? and weapon.requirements.mastery > hero.mastery.level
        err ' > mastery requirement not reached (you have: ' + hero.mastery.level + ', required: ' + weapon.requirements.mastery + ')'
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
        spell: weapon.spell
        spellAmplification: weapon.spellAmplification
        spells: weapon.spells
        suffix: weapon.suffix
        type: weapon.type

        getDamage: weapon.getDamage

    if weapon.init? and not weapon.spell?
        newWeapon = weapon.init newWeapon
    return Object.freeze newWeapon

getSkillBonus = (skills, attackType) ->
    skillMultiplier = 1
    for own key, skill of skills
        if skill? and skill.attackType is attackType and skill.damageBonus?
            skillMultiplier += skill.damageBonus()

    return skillMultiplier

getMasteryBonus = (mastery) ->
    return Math.pow WEAPON_GAIN_FACTOR, mastery.level-1

getDamage = (actor, enemy) ->
    if enemy? and actor.quiver? and actor.broadheads?
        damage = actor.weapon.getDamage actor, Math.abs actor.combatPos - enemy.combatPos
    else
        damage = actor.weapon.getDamage actor, 1

    masteryBonus = getMasteryBonus actor.mastery
    skillBonus = getSkillBonus actor.skills, actor.weapon.attackType

    return damage * masteryBonus * skillBonus
getEffects = (source) ->
    effects = [
        (if source.weapon.modifier? then source.weapon.modifier() else [])...
        (if source.weapon.suffix? then source.weapon.suffix.apply() else [])...
    ]

    if source.broadheads?
        broadhead = source.broadheads[source.broadhead]
        effects = [ effects..., broadhead.use()... ]
    return effects

module.exports =
    create: create
    getAll: getAll
    getAvailable: getAvailable
    getByQuality: getByQuality
    getDamage: getDamage
    getEffects: getEffects
    getMasteryBonus: getMasteryBonus
    getSkillBonus: getSkillBonus
    isAvailable: isAvailable
