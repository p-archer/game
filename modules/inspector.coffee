chalk = require 'chalk'
{ log, err } = require './general'

mHero = null
mMonster = null

# TODO refactor this

init = (hero, monster) ->
    if hero?
        mHero = hero
    if monster?
        mMonster = monster

display = (hero, monster, damages, hp, mana) ->
    init hero, monster

    damage = damages.reduce(((acc, x) -> return acc + x.amount), 0)
    if damage <= 0 then return

    # damages SUM + (each damage type grouped and color coded)

    if not hero? and mHero? and mHero.skills.inspection?
        switch mHero.skills.inspection.level
            when 0 then log '> ' + mHero.name + ' damaged ' + monster.name
            when 1 then log '> ' + mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp')
            when 2 then log '> ' + mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + (monster.hp/monster.maxhp*100).toFixed(0) + '%)'
            when 3 then log '> ' + mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + (monster.hp/monster.maxhp*100).toFixed(0) + '%)'
            when 4 then log '> ' + mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + monster.hp.toFixed(2)+ '/' + monster.maxhp.toFixed(2) + ')'
            when 5
                log '> ' + mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + monster.hp.toFixed(2)+ '/' + monster.maxhp.toFixed(2) + ')'
                str = '\tdamage profile'
                profile = damages.reduce (acc, x) ->
                    if not acc[x.type]? then acc[x.type] = 0
                    acc[x.type] += x.amount
                    return acc
                , {}
                for own type, damage of profile
                    str += ' ' + type + ': ' + damage.toFixed(2)
                log str

        if hp > 0 or mana > 0
            str = '> ' + mHero.name + ' leeched '
            if hp > 0 then str += hp.toFixed(2) + ' hp'
            if hp > 0 and mana > 0 then str += ' and '
            if mana > 0 then str += mana.toFixed(2) + ' mana'
            log chalk.cyan str

    if not monster? and hero?
        log '> ' + mMonster.name + ' damaged ' + hero.name + ' ' + chalk.redBright(damage.toFixed(2) + 'hp') + ' (' + chalk.green('hp left: ' + hero.hp.toFixed(2) + '/' + hero.maxhp.toFixed(2)) + ')'

        str = '\tdamage profile'
        profile = damages.reduce (acc, x) ->
            if not acc[x.type]? then acc[x.type] = 0
            acc[x.type] += x.amount
            return acc
        , {}
        for own type, damage of profile
            str += ' ' + type + ': ' + damage.toFixed(2)
        log str

        if hp > 0 or mana > 0
            str = '> ' + mMonster.name + ' leeched '
            if hp > 0 then str += hp.toFixed(2) + ' hp'
            if hp > 0 and mana > 0 then str += ' and '
            if mana > 0 then str += mana.toFixed(2) + ' mana'
            log chalk.cyan str

    return

module.exports =
    display: display
    init: init
