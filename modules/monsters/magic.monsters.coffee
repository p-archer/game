{ attackTypes, armourTypes, species, mapTypes, actions } = require '../constants'
{ err } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()
spells = require '../abilities/abilities.coffee'
    .getSpells()

monsters =
    fairy:
        name: 'fairy'
        land: [mapTypes.forest, mapTypes.enchanted, mapTypes.magical]
        species: [species.fairy, species.magical]
        minLevel: 10
        maxLevel: 40
        movement: 12
        attack:
            attackType: attackTypes.magic
            max: 1.2
            min: 1
        spell: spells.soulArrow
        maxMana: 6
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 10
                min: 0
            magic:
                max: 30
                min: 5
        maxhp: 3
        gold:
            min: 2
            max: 5
        xp:
            min: 2
            max: 5
    genie:
        name: 'genie'
        land: [mapTypes.enchanted, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 10
        maxLevel: 40
        movement: 15
        attack:
            attackType: attackTypes.magic
            max: 3
            min: 2
        spell: spells.iceShards
        maxMana: 10
        armour:
            type: armourTypes.light
            melee:
                max: 15
                min: 0
            ranged:
                max: 15
                min: 0
            magic:
                max: 40
                min: 20
        maxhp: 4
        gold:
            min: 4
            max: 6
        xp:
            min: 4
            max: 6
    ghost:
        name: 'ghost'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.crypt, mapTypes.dungeon]
        species: [species.undead]
        minLevel: 5
        maxLevel: 50
        movement: 12
        attack:
            attackType: attackTypes.magic
            max: 1.4
            min: 1.6
        spell: spells.arcaneBolt
        maxMana: 12
        armour:
            type: armourTypes.light
            melee:
                max: 50
                min: 0
            ranged:
                max: 50
                min: 0
            magic:
                max: 15
                min: 0
        maxhp: 3
        gold:
            min: 2
            max: 5
        xp:
            min: 3
            max: 6
        getAction: (monster, hero) ->
            distance = Math.abs monster.combatPos - hero.combatPos
            if hero.weapon.attackType isnt attackTypes.magic and monster.combatPos < Math.min(40 + monster.movement, 50)
                return actions.retreat
            if monster.mana > monster.spell.mana
                return actions.useSpell
            return actions.approach
    imp:
        name: 'imp'
        land: [mapTypes.dungeon, mapTypes.inferno, mapTypes.magical, mapTypes.desert]
        species: [species.infernal, species.magical]
        minLevel: 0
        maxLevel: 30
        movement: 10
        attack:
            attackType: attackTypes.magic
            max: 0.5
            min: 0.4
        spell: spells.arcaneTorrent
        maxMana: 8
        armour:
            type: armourTypes.light
            melee:
                max: 25
                min: 0
            ranged:
                max: 20
                min: 0
            magic:
                max: 25
                min: 10
        maxhp: 2
        gold:
            min: 1
            max: 4
        xp:
            min: 2
            max: 4
    lich:
        name: 'lich'
        land: [ mapTypes.crypt, mapTypes.inferno, mapTypes.magical, mapTypes.tower, mapTypes.arctic, mapTypes.dungeon  ]
        species: [species.undead, species.magical]
        minLevel: 20
        maxLevel: 100
        movement: 6
        attack:
            attackType: attackTypes.magic
            max: 2.5
            min: 4.0
        spell: spells.lifeDrain
        maxMana: 16
        armour:
            type: armourTypes.light
            melee:
                max: 25
                min: 10
            ranged:
                max: 20
                min: 10
            magic:
                max: 45
                min: 20
        maxhp: 6
        gold:
            min: 6
            max: 10
        xp:
            min: 8
            max: 10
    skeletonMagi:
        name: 'skeleton magi'
        land: [mapTypes.magical, mapTypes.tower]
        species: [species.undead]
        minLevel: 5
        maxLevel: 50
        movement: 6
        attack:
            attackType: attackTypes.magic
            max: 1.4
            min: 1
        spell: spells.fireArrow
        maxMana: 8
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 60
                min: 50
            magic:
                max: 20
                min: 0
        maxhp: 4
        gold:
            min: 2
            max: 4
        xp:
            min: 3
            max: 6
    succubus:
        name: 'succubus'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.tower, mapTypes.magical]
        species: [species.infernal]
        minLevel: 20
        maxLevel: 50
        movement: 15
        attack:
            attackType: attackTypes.magic
            max: 3
            min: 2
        spell: spells.fireBall
        maxMana: 20
        armour:
            type: armourTypes.medium
            melee:
                max: 45
                min: 0
            ranged:
                max: 45
                min: 0
            magic:
                max: 45
                min: 0
        maxhp: 4
        gold:
            min: 6
            max: 10
        xp:
            min: 4
            max: 6
    wisp:
        name: 'wisp'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.desert]
        species: [species.magical]
        minLevel: 0
        maxLevel: 20
        movement: 12
        attack:
            attackType: attackTypes.magic
            max: 0.6
            min: 0.5
        spell: spells.soulArrow
        maxMana: 8
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 10
                min: 0
            magic:
                max: 10
                min: 0
        maxhp: 1.6
        gold:
            min: 1
            max: 3
        xp:
            min: 2
            max: 4
        getAction: (monster, hero) ->
            distance = Math.abs monster.combatPos - hero.combatPos
            if hero.weapon.attackType isnt attackTypes.magic and monster.combatPos < Math.min(40 + monster.movement, 50)
                return actions.retreat
            if monster.mana > monster.spell.mana
                return actions.useSpell
            return actions.approach
    wraith:
        name: 'wraith'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.crypt, mapTypes.dungeon]
        species: [species.undead]
        minLevel: 5
        maxLevel: 50
        movement: 6
        attack:
            attackType: attackTypes.magic
            max: 1.6
            min: 2.2
        spell: spells.arcaneTorrent
        maxMana: 12
        armour:
            type: armourTypes.light
            melee:
                max: 50
                min: 0
            ranged:
                max: 50
                min: 0
            magic:
                max: 15
                min: 0
        maxhp: 4
        gold:
            min: 3
            max: 6
        xp:
            min: 4
            max: 7
        getAction: (monster, hero) ->
            distance = Math.abs monster.combatPos - hero.combatPos
            if hero.weapon.attackType isnt attackTypes.magic and monster.combatPos < Math.min(40 + monster.movement, 50)
                return actions.retreat
            if monster.mana > monster.spell.mana
                return actions.useSpell
            return actions.approach

module.exports = (monster for own key, monster of monsters)
