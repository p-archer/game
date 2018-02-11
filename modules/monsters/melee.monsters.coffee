{ attackTypes, armourTypes, species, mapTypes } = require '../constants'

skills = require '../skills/skills.coffee'
    .getNames()

monsters =
    bear:
        name: 'bear'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 10
        maxLevel: 80
        movement: 12
        attack:
            attackType: attackTypes.melee
            max: 5
            min: 2.5
        armour:
            type: armourTypes.light
            melee:
                max: 20
                min: 0
            ranged:
                max: 20
                min: 0
            magic:
                max: 20
                min: 0
        maxhp: 10
        gold:
            min: 2
            max: 5
        xp:
            min: 4
            max: 8
    centaurLancer:
        name: 'centaur lancer'
        land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 20
        maxLevel: 50
        movement: 20
        attack:
            attackType: attackTypes.melee
            max: 4
            min: 2
        armour:
            type: armourTypes.medium
            melee:
                max: 30
                min: 10
            ranged:
                max: 25
                min: 5
            magic:
                max: 0
                min: 0
        maxhp: 5
        gold:
            min: 3
            max: 7
        xp:
            min: 5
            max: 8
    demon:
        name: 'demon'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic, mapTypes.crypt, mapTypes.desert, mapTypes.enchanted, mapTypes.forest, mapTypes.inferno, mapTypes.magical, mapTypes.tower]
        species: [species.infernal]
        minLevel: 50
        maxLevel: 1000
        movement: 25
        attack:
            attackType: attackTypes.melee
            max: 10
            min: 5
            range: 1
        armour:
            type: armourTypes.medium
            melee:
                max: 50
                min: 30
            ranged:
                max: 50
                min: 30
            magic:
                max: 50
                min: 30
        maxhp: 8
        gold:
            min: 10
            max: 12
        xp:
            min: 10
            max: 12
    direWolf:
        name: 'dire wolf'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 15
        maxLevel: 65
        movement: 20
        attack:
            attackType: attackTypes.melee
            max: 4
            min: 3
        armour:
            type: armourTypes.light
            melee:
                max: 30
                min: 0
            ranged:
                max: 20
                min: 0
            magic:
                max: 20
                min: 0
        maxhp: 6
        gold:
            min: 3
            max: 5
        xp:
            min: 4
            max: 8
    fireElemental:
        name: 'fire elemental'
        land: [mapTypes.inferno, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 10
        maxLevel: 100
        movement: 12
        attack:
            attackType: attackTypes.melee
            max: 5
            min: 3
        armour:
            type: armourTypes.light
            melee:
                max: 35
                min: 20
            ranged:
                max: 35
                min: 20
            magic:
                max: 50
                min: 20
        maxhp: 5
        gold:
            min: 4
            max: 6
        xp:
            min: 6
            max: 8
    fox:
        name: 'fox'
        land: [mapTypes.forest, mapTypes.swamp, mapTypes.enchanted]
        species: [species.beast]
        minLevel: 0
        maxLevel: 40
        movement: 14
        attack:
            attackType: attackTypes.melee
            max: 0.6
            min: 1.0
        armour:
            type: armourTypes.light
            melee:
                max: 20
                min: 0
            ranged:
                max: 10
                min: 0
            magic:
                max: 0
                min: 0
        maxhp: 3
        gold:
            min: 2
            max: 3
        xp:
            min: 2
            max: 3
    giant:
        name: 'giant'
        land: [mapTypes.arctic, mapTypes.enchanted, mapTypes.desert]
        species: [species.giant]
        minLevel: 20
        maxLevel: 100
        movement: 6
        attack:
            attackType: attackTypes.melee
            max: 8
            min: 5
        armour:
            type: armourTypes.medium
            melee:
                max: 45
                min: 0
            ranged:
                max: 35
                min: 0
            magic:
                max: 25
                min: 0
        maxhp: 12
        gold:
            min: 3
            max: 5
        xp:
            min: 6
            max: 10
    goblin:
        name: 'goblin'
        land: [mapTypes.dungeon, mapTypes.inferno]
        species: [species.infernal]
        minLevel: 0
        maxLevel: 20
        movement: 10
        attack:
            attackType: attackTypes.melee
            max: 1
            min: 1
        armour:
            type: armourTypes.medium
            melee:
                max: 15
                min: 0
            ranged:
                max: 15
                min: 0
            magic:
                max: 15
                min: 0
        maxhp: 3
        gold:
            min: 1
            max: 2
        xp:
            min: 1
            max: 3
    highwayman:
        name: 'highwayman'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.forest]
        species: [species.humanoid]
        minLevel: 10
        maxLevel: 40
        movement: 10
        attack:
            attackType: attackTypes.melee
            max: 4
            min: 2
        armour:
            type: armourTypes.medium
            melee:
                max: 35
                min: 10
            ranged:
                max: 35
                min: 10
            magic:
                max: 25
                min: 10
        maxhp: 6
        gold:
            min: 5
            max: 7
        xp:
            min: 3
            max: 6
    jackal:
        name: 'jackal'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.desert]
        species: [species.mythological, species.beast]
        minLevel: 10
        maxLevel: 40
        movement: 15
        attack:
            attackType: attackTypes.melee
            max: 4
            min: 1
        armour:
            type: armourTypes.light
            melee:
                max: 35
                min: 20
            ranged:
                max: 25
                min: 0
            magic:
                max: 25
                min: 0
        maxhp: 4
        gold:
            min: 4
            max: 6
        xp:
            min: 3
            max: 6
    orc:
        name: 'orc'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic]
        species: [species.greenskin]
        minLevel: 20
        maxLevel: 50
        movement: 12
        attack:
            attackType: attackTypes.melee
            max: 6
            min: 4
        armour:
            type: armourTypes.heavy
            melee:
                max: 50
                min: 20
            ranged:
                max: 35
                min: 15
            magic:
                max: 25
                min: 10
        maxhp: 6
        gold:
            min: 2
            max: 4
        xp:
            min: 4
            max: 10
    skeletonKnight:
        name: 'skeleton knight'
        land: [mapTypes.dungeon, mapTypes.crypt]
        species: [species.undead]
        minLevel: 10
        maxLevel: 50
        movement: 10
        attack:
            attackType: attackTypes.melee
            max: 4
            min: 2
        armour:
            type: armourTypes.heavy
            melee:
                max: 40
                min: 20
            ranged:
                max: 60
                min: 50
            magic:
                max: 10
                min: 0
        maxhp: 6
        gold:
            min: 3
            max: 6
        xp:
            min: 4
            max: 6
    skeletonWarrior:
        name: 'skeleton warrior'
        land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.tower]
        species: [species.undead]
        minLevel: 0
        maxLevel: 50
        movement: 10
        attack:
            attackType: attackTypes.melee
            max: 1
            min: 1
        armour:
            type: armourTypes.medium
            melee:
                max: 20
                min: 0
            ranged:
                max: 60
                min: 50
            magic:
                max: 10
                min: 0
        maxhp: 5
        gold:
            min: 2
            max: 4
        xp:
            min: 3
            max: 5
    spider:
        name: 'spider'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.crypt]
        species: [species.beast]
        minLevel: 0
        maxLevel: 20
        movement: 12
        attack:
            attackType: attackTypes.melee
            max: 1
            min: 1
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 0
                min: 0
            magic:
                max: 30
                min: 0
        maxhp: 3
        gold:
            min: 2
            max: 3
        xp:
            min: 1
            max: 3
    troll:
        name: 'troll'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp]
        species: [species.greenskin]
        minLevel: 10
        maxLevel: 50
        movement: 12
        attack:
            attackType: attackTypes.melee
            max: 5
            min: 2
        armour:
            type: armourTypes.medium
            melee:
                max: 45
                min: 20
            ranged:
                max: 40
                min: 10
            magic:
                max: 30
                min: 10
        maxhp: 8
        gold:
            min: 4
            max: 6
        xp:
            min: 6
            max: 9
    wolf:
        name: 'wolf'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 0
        maxLevel: 50
        movement: 18
        attack:
            attackType: attackTypes.melee
            max: 0.8
            min: 1.2
        armour:
            type: armourTypes.light
            melee:
                max: 20
                min: 0
            ranged:
                max: 10
                min: 0
            magic:
                max: 0
                min: 0
        maxhp: 5
        gold:
            min: 2
            max: 4.5
        xp:
            min: 3
            max: 3.5
    wolverine:
        name: 'wolverine'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 0
        maxLevel: 30
        movement: 12
        attack:
            attackType: attackTypes.melee
            max: 1
            min: 1
        armour:
            type: armourTypes.light
            melee:
                max: 25
                min: 5
            ranged:
                max: 15
                min: 5
            magic:
                max: 10
                min: 0
        maxhp: 3
        gold:
            min: 1
            max: 3.5
        xp:
            min: 2
            max: 3
    zombie:
        name: 'zombie'
        land: [mapTypes.dungeon, mapTypes.crypt]
        species: [species.undead]
        minLevel: 5
        maxLevel: 30
        movement: 6
        attack:
            attackType: attackTypes.melee
            max: 2
            min: 1
        armour:
            type: armourTypes.light
            melee:
                max: 30
                min: 10
            ranged:
                max: 20
                min: 10
            magic:
                max: 20
                min: 0
        maxhp: 8
        gold:
            min: 2
            max: 6
        xp:
            min: 3
            max: 6

module.exports = (monster for own key, monster of monsters)
