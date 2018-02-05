{ random, err } = require '../general'
{ heroStates, weaponStates } = require '../constants'

broadheads =
    bleeding:
        name: 'lacerating broadhead'
        description: '+5% chance for bleeding'
        use: () -> if random() < 100 then return [ { effect: heroStates.bleeding, ticks: 3 } ] else return []
    burning:
        name: 'flaming broadhead'
        description: '+5% chance for burning'
        use: () -> if random() < 5 then return [ { effect: heroStates.burning, ticks: 3 } ] else return []
    freezing:
        name: 'freezing broadhead'
        description: '+5% chance for freezing'
        use: () -> if random() < 5 then return [ { effect: heroStates.frozen, ticks: 1 } ] else return []
    normal:
        name: 'normal broadhead'
        description: 'none'
        use: () -> return []
    piercing:
        name: 'piercing broadhead'
        description: '+5% chance for piercing'
        use: () -> if random() < 5 then return [ weaponStates.piercing ] else return []
    poisoning:
        name: 'poisoned broadhead'
        description: '+5% chance for poisoning'
        use: () -> if random() < 5 then return [ { effect: heroStates.poison, ticks: 3 } ] else return []
    vampiric:
        name: 'vampiric broadhead'
        description: '+2.5% life steal'
        use: () -> return [ weaponStates.leeching ]

module.exports = broadheads
