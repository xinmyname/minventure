class GameState
	time: 0
	health: 25
	maxHealth: 25
	level: 1
	experience: 0
	money: 0
	loot: 0
	buy: 0
	sell: 0
	limit: 3
	encounter: 'swamp'
	playerState: 'resting'

class Encounter
	constructor:(@name) ->
	setup: ->
	action: ->
	teardown: ->

class Location extends Encounter

class Monster extends Encounter

class City extends Encounter

class Town extends Encounter

class PlayerState
	constructor:(@name) ->
	setup: ->
	action: ->
	teardown: ->

class Moving extends PlayerState

class Fighting extends PlayerState

class Buying extends PlayerState

class Selling extends PlayerState

class Resting extends PlayerState
	action: ->
		console.log "Resting..."

encounters = 
	swamp: new Location "Swamp!"
	prarie: new Location "Prarie!"

playerStates =
	moving: new Moving
	fighting: new Fighting
	buying: new Buying
	selling: new Selling
	resting: new Resting

gameState = new GameState




