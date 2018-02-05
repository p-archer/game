chalk = require 'chalk'
{ log, err } = require './general'

mHero = null
mMonster = null

init = (hero, monster) ->
    if hero?
        mHero = hero
    if monster?
        mMonster = monster

display = (hero, monster, damage) ->
    init hero, monster
    if damage <= 0
        return

    if not hero? and mHero? and mHero.skills.inspection?
        monsterHp = monster.hp - damage
        switch mHero.skills.inspection.level
            when 0 then log mHero.name + ' damaged ' + monster.name
            when 1 then log mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp')
            when 2 then log mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + (monsterHp/monster.maxhp*100).toFixed(0) + '%)'
            when 3 then log mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + (monsterHp/monster.maxhp*100).toFixed(0) + '%)'
            when 4 then log mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + monsterHp.toFixed(2)+ '/' + monster.maxhp.toFixed(2) + ')'
            when 5 then log mHero.name + ' damaged ' + monster.name + ' ' + chalk.green(damage.toFixed(2) + 'hp') + ' (hp left: ' + monsterHp.toFixed(2)+ '/' + monster.maxhp.toFixed(2) + ')'
    if not monster? and hero?
        heroHp = hero.hp - damage
        log mMonster.name + ' damaged ' + hero.name + ' ' + chalk.redBright(damage.toFixed(2) + 'hp') + ' (' + chalk.green('hp left: ' + heroHp.toFixed(2) + '/' + hero.maxhp.toFixed(2)) + ')'

    return

module.exports =
    display: display
    init: init
