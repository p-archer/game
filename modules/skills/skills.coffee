{ weaponTypes, heroClass } = require '../constants'
{ err } = require '../general'
Abilities = require '../abilities/abilities.coffee'
    .getNames()

getNames = () ->
    names = {}
    for own key, value of skillList
        names[key] = { key: key, name: value.name }
    return names

skillList =
    # lockpick:
    #     name: 'lockpick'
    #     core: [heroClass.warrior, heroClass.archer, heroClass.mage]
    #     requirements:
    #         level: 0
    #     cost: 0
    #     description: 'Skill for opening locks'
    inspection:
        name: 'inspection'
        core: [heroClass.warrior, heroClass.archer, heroClass.mage, heroClass.crusader, heroClass.knight, heroClass.arbalist, heroClass.bandit, heroClass.sorcerer, heroClass.wizard]
        requirements:
            level: 0
        description: 'This skill allows you to inspect enemies before battle. The higher the skill the more information you can gather.'
    melee:
        name: 'melee skill'
        core: [heroClass.warrior, heroClass.crusader, heroClass.knight]
        requirements:
            level: 0
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.axe, weaponTypes.sword, weaponTypes.hammer]
        description: 'Basic skill for using melee weapons (+10% damage per level).'
        cost: 200
    ranged:
        name: 'ranged skill'
        core: [heroClass.archer, heroClass.bandit, heroClass.arbalist]
        requirements:
            level: 0
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.bow, weaponTypes.crossbow, weaponTypes.spear]
        description: 'Basic skill for using ranged weapons (+10% damage per level).'
        cost: 200
    magic:
        name: 'magic skill'
        core: [heroClass.mage, heroClass.wizard, heroClass.sorcerer]
        requirements:
            level: 0
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.wand, weaponTypes.staff, weaponTypes.tome]
        description: 'Basic skill for using magic weapons (+10% damage per level).'
        cost: 200
        ability: [Abilities.arcaneBolt, Abilities.arcaneTorrent]
    improvedMelee:
        name: 'improved melee skill'
        requirements:
            level: 10
            skills: () -> [{skill: skills.melee, level: 5}]
        cost: 500
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.axe, weaponTypes.sword, weaponTypes.hammer]
        description: 'Improved skill for using melee weapons (+10% damage per level).'
    improvedRanged:
        name: 'improved ranged skill'
        requirements:
            level: 10
            skills: () -> [{skill: skills.ranged, level: 5}]
        cost: 500
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.bow, weaponTypes.crossbow, weaponTypes.spear]
        description: 'Improved skill for using ranged weapons (+10% damage per level).'
        ability: [Abilities.powerShot]
    improvedMagic:
        name: 'improved magic skill'
        requirements:
            level: 10
            skills: () -> [{skill: skills.magic, level: 5}]
        cost: 500
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.wand, weaponTypes.staff, weaponTypes.tome]
        description: 'Improved skill for using magic weapons (+10% damage per level).'
        ability: [Abilities.fireArrow, Abilities.iceArrow, Abilities.soulArrow]
    advancedMelee:
        name: 'advanced melee skill'
        requirements:
            level: 25
            skills: () -> [{skill: skills.improvedMelee, level: 5}]
        cost: 2500
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.axe, weaponTypes.sword, weaponTypes.hammer]
        description: 'Advanced skill for using melee weapons (+10% damage per level).'
    advancedRanged:
        name: 'advanced ranged skill'
        requirements:
            level: 25
            skills: () -> [{skill: skills.improvedRanged, level: 5}]
        cost: 2500
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.bow, weaponTypes.crossbow, weaponTypes.spear]
        description: 'Advanced skill for using ranged weapons (+10% damage per level).'
        ability: [Abilities.rapidFire]
    advancedMagic:
        name: 'advanced magic skill'
        requirements:
            level: 25
            skills: () -> [{skill: skills.improvedMagic, level: 5}]
        cost: 2500
        damageBonus: () -> (this.level * 0.1)
        weaponType: [weaponTypes.wand, weaponTypes.staff, weaponTypes.tome]
        description: 'Advanced skill for using magic weapons (+10% damage per level).'
        ability: [Abilities.fireBall, Abilities.iceShards]
    skinning:
        name: 'skinning'
        requirements:
            level: 0
        bonus: 0.20
        cost: 100
        description: 'Gain extra gold from beasts by skinning them and selling their hides (20% more gold per level).'
    # dodge:
    #     name: 'dodge'
    #     requirements:
    #         level: 10
    #     bonus: 0.03
    #     cost: 500
    #     description: 'Dodge incoming ranged attacks (3% to dodge per level).'
    # stunningHit:
    #     name: 'stunning hit'
    #     requirements:
    #         level: 25
    #         skills: () -> [{skill: skills.advancedMelee, level: 1}]
    #     bonus: 0.03
    #     cost: 2500
    #     description: 'Chance to stun enemy with melee attack (3% per level).'
    # criticalShot:
    #     name: 'critical shot'
    #     requirements:
    #         level: 25
    #         skills: () -> [{skill: skills.advancedRanged, level: 1}]
    #     bonus: 0.03
    #     cost: 2500
    #     description: 'Chance to inflict double damage with ranged attack (3% per level).'
    # disintegrate:
    #     name: 'disintegrate'
    #     requirements:
    #         level: 25
    #         skills: () -> [{skill: skills.advancedMagic, level: 1}]
    #     bonus: 0.02
    #     cost: 2500
    #     description: 'Instant kill under a certain percentage of hp (2% per level).'
    # reflect:
    #     name: 'reflect'
    #     requirements:
    #         level: 10
    #     bonus: 0.03
    #     cost: 1000
    #     description: 'Reflect magic damage to origin (3% chance per level).'
    # parrying:
    #     name: 'parrying'
    #     requirements:
    #         level: 10
    #     bonus: 0.03
    #     cost: 1000
    #     description: 'Parry incoming melee attacks (-50% damage) and retaliate with bonus (+50%) damage (3% chance per level).'
    # blocking:
    #     name: 'blocking'
    #     requirements:
    #         level: 0
    #     bonus: 0.05
    #     cost: 250
    #     description: 'Increase damage resistance while blocking (5% more damage block per level).'
    # pointBlankShot:
    #     name: 'point-blank shot'
    #     requirements:
    #         level: 5
    #         skills: () -> [{skill: skills.ranged, level: 1}]
    #     bonus: 0.05
    #     cost: 500
    #     description: 'Increases ranged damage at melee range (5% per level).'
    # combatCasting:
    #     name: 'combat casting'
    #     requirements:
    #         level: 5
    #         skills: () -> [{skill: skills.magic, level: 1}]
    #     bonus: 0.05
    #     cost: 500
    #     description: 'Decreases chance of failure for melee range magic attacks (5% per level).'
    tactics:
        name: 'tactics'
        requirements:
            level: 10
        cost: 500
        description: 'Increase the distance from the enemy at the start of combat (+1 distance per level).'

# presence: 0, //lowers enemy damage and resistances
# regeneration: 0
# sneak: 0, //can walk past enemies
# alchemy: 0, //potions
# hunter: 0, //dmg bonus against beasts

getAvailable = (hero) ->
    skills = {}
    for own key, value of skillList when value.requirements? and value.requirements.level <= hero.level and not hero.skills[key]
        if not value.core?
            skills[key] = value
    return skills

getCoreSkills = (heroClass) ->
    skills = {}
    for own key, value of skillList when value.core? and value.core.has heroClass
        skills[key] = value
    return skills

getAll = () ->
    return skillList

isAvailable = (hero, skill) ->
    if hero.level < skill.requirements.level then return false

    if skill.requirements.skills?
        for req in skill.requirements.skills()
            target = hero.skills[req.skill.key]
            if not target? or target.level < req.level
                err '> required skill ' + req.skill.name + ' of level ' + req.level + ' missing'
                return false

    if hero.gold < skill.cost
        err '> not enough gold to buy skill'
        return false

    return true

skills = getNames()

module.exports =
    getAvailable: getAvailable
    getCoreSkills: getCoreSkills
    getAll: getAll
    getNames: getNames
    isAvailable: isAvailable
