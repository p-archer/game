{ attackTypes, armourTypes, species, mapTypes, speed } = require '../constants'

skills = require '../skills/skills.coffee'
    .getNames()
Weapons = require '../weapons/weapons.coffee'
    .getAll()

monsters =
    bear:
        name: 'bear'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 10
        maxLevel: 80
        movement: 12
        weapon: Weapons.shortSword
        attack:
            max: 5
            min: 2.5
        armour:
            type: armourTypes.light
            amount: 10
        maxhp: 10
        gold: 6
        xp: 6
    centaurLancer:
        name: 'centaur lancer'
        land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 20
        maxLevel: 50
        movement: 20
        weapon: Weapons.shortSword
        attack:
            max: 4
            min: 2
        armour:
            type: armourTypes.medium
            amount: 50
        maxhp: 5
        gold: 7
        xp: 7
    demon:
        name: 'demon'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic, mapTypes.crypt, mapTypes.desert, mapTypes.enchanted, mapTypes.forest, mapTypes.inferno, mapTypes.magical, mapTypes.tower]
        species: [species.infernal]
        minLevel: 50
        maxLevel: 1000
        movement: 25
        weapon: Weapons.shortSword
        attack:
            max: 10
            min: 5
        armour:
            type: armourTypes.medium
            amount: 75
        maxhp: 8
        gold: 12
        xp: 12
    direWolf:
        name: 'dire wolf'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 15
        maxLevel: 65
        movement: 20
        weapon: Weapons.shortSword
        attack:
            max: 4
            min: 3
        armour:
            type: armourTypes.light
            amount: 20
        maxhp: 6
        gold: 6
        xp: 6
    fireElemental:
        name: 'fire elemental'
        land: [mapTypes.inferno, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 10
        maxLevel: 100
        movement: 12
        weapon: Weapons.shortSword
        attack:
            max: 5
            min: 3
        armour:
            type: armourTypes.light
            amount: 25
        maxhp: 5
        gold: 5
        xp: 6
    fox:
        name: 'fox'
        land: [mapTypes.forest, mapTypes.swamp, mapTypes.enchanted]
        species: [species.beast]
        minLevel: 0
        maxLevel: 40
        movement: 14
        weapon: Weapons.shortSword
        attack:
            max: 0.6
            min: 1.0
            speed: speed.fast
        armour:
            type: armourTypes.light
            amount: 5
        maxhp: 3
        gold: 3
        xp: 2
    giant:
        name: 'giant'
        land: [mapTypes.arctic, mapTypes.enchanted, mapTypes.desert]
        species: [species.giant]
        minLevel: 20
        maxLevel: 100
        movement: 6
        weapon: Weapons.shortSword
        attack:
            max: 8
            min: 5
        armour:
            type: armourTypes.medium
            amount: 60
        maxhp: 13
        gold: 6
        xp: 8
    goblin:
        name: 'goblin'
        land: [mapTypes.dungeon, mapTypes.inferno]
        species: [species.infernal]
        minLevel: 0
        maxLevel: 20
        movement: 10
        weapon: Weapons.shortSword
        attack:
            max: 1
            min: 1
        armour:
            type: armourTypes.medium
            amount: 35
        maxhp: 3
        gold: 3
        xp: 3
    highwayman:
        name: 'highwayman'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.forest]
        species: [species.humanoid]
        minLevel: 10
        maxLevel: 40
        movement: 10
        weapon: Weapons.shortSword
        attack:
            max: 4
            min: 2
        armour:
            type: armourTypes.medium
            amount: 50
        maxhp: 6
        gold: 6
        xp: 5
    jackal:
        name: 'jackal'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.desert]
        species: [species.mythological, species.beast]
        minLevel: 10
        maxLevel: 40
        movement: 15
        weapon: Weapons.shortSword
        attack:
            max: 4
            min: 1
        armour:
            type: armourTypes.light
            amount: 20
        maxhp: 4
        gold: 3
        xp: 3
    orc:
        name: 'orc'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic]
        species: [species.greenskin]
        minLevel: 20
        maxLevel: 100
        movement: 12
        weapon: Weapons.shortSword
        attack:
            max: 6
            min: 4
        armour:
            type: armourTypes.heavy
            amount: 100
        maxhp: 6
        gold: 6
        xp: 8
    orcWarrior:
        name: 'orc warrior'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic]
        species: [species.greenskin]
        minLevel: 30
        maxLevel: 100
        movement: 12
        weapon: Weapons.shortSword
        attack:
            max: 8
            min: 6
        armour:
            type: armourTypes.heavy
            amount: 160
        maxhp: 8
        gold: 10
        xp: 10
    orcChieftain:
        name: 'orc chieftain'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic]
        species: [species.greenskin]
        minLevel: 50
        maxLevel: 1000
        movement: 10
        weapon: Weapons.shortSword
        attack:
            max: 10
            min: 8
        armour:
            type: armourTypes.heavy
            amount: 250
        maxhp: 10
        gold: 12
        xp: 14
    skeletonKnight:
        name: 'skeleton knight'
        land: [mapTypes.dungeon, mapTypes.crypt]
        species: [species.undead]
        minLevel: 10
        maxLevel: 50
        movement: 10
        weapon: Weapons.shortSword
        attack:
            max: 4
            min: 2
        armour:
            type: armourTypes.heavy
            amount: 90
        maxhp: 7
        gold: 7
        xp: 7
    skeletonWarrior:
        name: 'skeleton warrior'
        land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.tower]
        species: [species.undead]
        minLevel: 0
        maxLevel: 100
        movement: 10
        weapon: Weapons.shortSword
        attack:
            max: 1
            min: 1
        armour:
            type: armourTypes.medium
            amount: 50
        maxhp: 5
        gold: 3
        xp: 4
    spider:
        name: 'spider'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.crypt]
        species: [species.beast]
        minLevel: 0
        maxLevel: 20
        movement: 12
        weapon: Weapons.shortSword
        attack:
            max: 1
            min: 1
        armour:
            type: armourTypes.light
            amount: 5
        maxhp: 3
        gold: 2
        xp: 2
    troll:
        name: 'troll'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp]
        species: [species.greenskin]
        minLevel: 10
        maxLevel: 100
        movement: 16
        weapon: Weapons.shortSword
        attack:
            max: 5
            min: 3
        armour:
            type: armourTypes.medium
            amount: 55
        maxhp: 8
        gold: 5
        xp: 10
    trollWarlord:
        name: 'troll warlord'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp]
        species: [species.greenskin]
        minLevel: 30
        maxLevel: 1000
        movement: 12
        weapon: Weapons.shortSword
        attack:
            max: 10
            min: 6
        armour:
            type: armourTypes.medium
            amount: 120
        maxhp: 8
        gold: 12
        xp: 14
    wolf:
        name: 'wolf'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 0
        maxLevel: 50
        movement: 18
        weapon: Weapons.shortSword
        attack:
            max: 0.8
            min: 1.2
        armour:
            type: armourTypes.light
            amount: 10
        maxhp: 5
        gold: 4
        xp: 4
    wolverine:
        name: 'wolverine'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 0
        maxLevel: 30
        movement: 12
        weapon: Weapons.shortSword
        attack:
            max: 1
            min: 1
        armour:
            type: armourTypes.light
            amount: 15
        maxhp: 3
        gold: 2
        xp: 2
    zombie:
        name: 'zombie'
        land: [mapTypes.dungeon, mapTypes.crypt]
        species: [species.undead]
        minLevel: 5
        maxLevel: 30
        movement: 6
        weapon: Weapons.shortSword
        attack:
            max: 2
            min: 1
        armour:
            type: armourTypes.light
            amount: 10
        maxhp: 10
        gold: 5
        xp: 6

module.exports = (monster for own key, monster of monsters)
