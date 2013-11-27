requirejs.config {
    paths: {
        'jquery': '/lib/jquery/jquery'
    }
}

define ['jquery'], ($) ->
	class GameState
	  health: 0
	  level: 0
	  experience: 0
	  money: 0
	  limit: 0
	  encounter: null
	  playerState: null
	  timerId: 0
	  nextLevelAt: 0
	  bounty: 0
	  godMode: false

	  setHealth: (value) ->
	    @health = value
	    $('#health').html(value)

	  setLevel: (value) ->
	    @level = value
	    $('#level').html(value)
	    @maxHealth = @getMaxHealth()
	    $('#maxHealth').html(@maxHealth)

	  setExperience: (value) ->
	    @experience = value
	    $('#experience').html(value)

	  setMoney: (value) ->
	    @money = value
	    $('#money').html(value)

	  setLimit: (value) ->
	    @limit = value
	    $('#limit').html(value)

	  setEncounter: (value) ->
	    @encounter?.teardown()
	    @encounter = value
	    @encounter.setup()

	  setPlayerState: (value) ->
	    @playerState?.teardown()
	    @playerState = value
	    @playerState.setup()

	  getMaxHealth: ->
	    Math.round(173.5*Math.exp(0.0339*@level)-147)

	  setNextLevelAt: (value) ->
	    @nextLevelAt = value

	  setGodMode: (value) ->
	    @godMode = value

	    if @godMode
	      $("html").addClass "godMode"
	    else
	      $("html").removeClass "godMode"

	  setBounty: (value) ->
	    @bounty = value

	  save: ->
	    stopGame()

	    state =
	      h: @health
	      l: @level
	      e: @experience
	      m: @money
	      li: @limit
	      n: @nextLevelAt
	      b: @bounty
	      en: @encounter.id
	      p: @playerState.id

	    stateJson = JSON.stringify state

	    localStorage["minventure.state"] = stateJson

	    startGame()

	  load: ->
	    stopGame()

	    stateJson = localStorage["minventure.state"]
	    state = JSON.parse stateJson
	    @setEncounter encounters[state.en]
	    @setPlayerState playerStates[state.p]
	    @setHealth state.h
	    @setLevel state.l
	    @setExperience state.e
	    @setMoney state.m
	    @setLimit state.li
	    @setNextLevelAt state.n
	    @setBounty state.b

	    startGame()

	moveToNextEncounter = ->
	  next = Math.random()

	  for ec in encounterChance
	    if next >= ec.value
	      nextId = ec.id
	    else
	      break

	  nextEncounter = encounters[nextId]

	  gameState.setEncounter nextEncounter

	gameOver = ->
	  gameState.setHealth 0
	  updateStatus "You are dead."
	  stopGame()

	updateStatus = (status) ->

	  statusLines[0].text(statusLines[1].text())
	  statusLines[1].text(statusLines[2].text())
	  statusLines[2].text(statusLines[3].text())
	  statusLines[3].text(status)

	class PlayerState
	  constructor: (@id,@potential,@kinetic) ->

	  action: ->

	  setup: ->
	    $button = $('#' + @id)
	    $button.addClass("selected")
	    $button.html(@kinetic)

	  teardown: ->
	    $button = $('#' + @id)
	    $button.removeClass()
	    $button.html(@potential)

	class Moving extends PlayerState
	  constructor: ->
	    super "move", "Move!", "Moving!"

	  action: ->
	    limit = gameState.limit - 1
	    if gameState.encounter instanceof Monster
	      if (Math.random() < 0.10)
	        updateStatus "You run away!"
	        moveToNextEncounter()
	    else if limit == 0
	      moveToNextEncounter()
	    else
	      gameState.setLimit limit

	class Fighting extends PlayerState
	  constructor: ->
	    super "fight", "Fight!", "Fighting!"

	  action: ->
	    if gameState.encounter instanceof Monster
	      damage = Math.floor(gameState.maxHealth*(0.3 + (Math.random() * 0.10)))
	      newLimit = gameState.limit - damage

	      if newLimit <= 0
	        @monsterDefeated()
	      else
	        gameState.setLimit newLimit

	  monsterDefeated: ->
	    updateStatus "You defeated the monster!"
	    @addExperience(gameState.encounter)
	    @addBounty(gameState.encounter)
	    @addLoot(gameState.encounter)
	    moveToNextEncounter()

	  addExperience: (monster) ->
	    exp = gameState.experience + monster.experience
	    gameState.setExperience exp

	    if exp >= gameState.nextLevelAt
	      gameState.setLevel gameState.level + 1
	      gameState.setHealth gameState.getMaxHealth()
	      updateStatus "You gained a level!"
	      expMultiplier = Math.floor(gameState.level / 24 + 4)
	      maxExpEarned = Math.floor(monster.getMaxLimit() / 2)
	      nextLevelAt = Math.floor(gameState.nextLevelAt + (maxExpEarned * expMultiplier))
	      updateStatus "Next level at #{nextLevelAt} experience."
	      gameState.setNextLevelAt nextLevelAt

	  addLoot: (monster) ->

	  addBounty: (monster) ->
	    gameState.setBounty gameState.bounty + Math.floor(monster.maxHealth / 10)


	class Resting extends PlayerState
	  constructor: ->
	    super "rest", "Rest!", "Resting!"

	  action: ->
	    if gameState.encounter instanceof Monster
	      return

	    if (gameState.health < gameState.getMaxHealth())
	      healRate = Math.floor(gameState.getMaxHealth() * 0.08)
	      expMultiplier = 1
	      lootMultiplier = 1
	      addHealth = healRate * expMultiplier * lootMultiplier
	      newHealth = gameState.health + addHealth
	      if (newHealth > gameState.maxHealth)
	        newHealth = gameState.maxHealth
	      gameState.setHealth newHealth

	class Encounter
	  constructor:(@id,@name,@minLimit,@maxLimit) ->

	  setup: ->
	    $('#encounter').removeClass();
	    $('#encounter').addClass(@id)
	    $('#description').html(@name)
	    gameState.setLimit @nextLimit()

	  action: ->

	  teardown: ->

	  getMinLimit: ->
	    @minLimit

	  getMaxLimit: ->
	    @maxLimit

	  nextLimit: ->
	    delta = @getMaxLimit() - @getMinLimit()
	    Math.floor(Math.random()*delta) + @getMinLimit()

	class Location extends Encounter
	  setup: ->
	    super

	class Monster extends Encounter
	  constructor: ->
	    super "monster", "Monster!", 0, 0
	    @maxHealth = 0
	    @experience = 0

	  setup: ->
	    super
	    @maxHealth = @nextLimit()

	    @experience = Math.floor(@maxHealth/2)
	    gameState.setLimit @maxHealth

	    if gameState.godMode
	      gameState.setPlayerState playerStates.fight

	  action: ->
	    percent = (Math.random()*0.08 + 0.02)
	    damage = Math.floor(@maxHealth * percent)

	    if !gameState.godMode && damage > 0
	      updateStatus "You take #{damage} damage!"
	      newHealth = gameState.health - damage

	      if newHealth <= 0
	        gameOver()
	      else
	        gameState.setHealth newHealth

	  teardown: ->
	    super

	    if gameState.godMode
	      gameState.setPlayerState playerStates.move

	  getMinLimit: ->
	    Math.floor((gameState.maxHealth/1.1)-(gameState.maxHealth/2))

	  getMaxLimit: ->
	    Math.floor((gameState.maxHealth/1.5)+(gameState.maxHealth/2))

	class Ruins extends Encounter
	  constructor: ->
	    super "ruins", "Ruins!", 2, 4

	  setup: ->
	    super
	    loot = lootFactory.create()
	    description = loot.description()
	    updateStatus "You found #{description}!"

	class City extends Encounter
	  constructor: ->
	    super "city", "City!", 4, 6

	  setup: ->
	    super
	    tribute = gameState.bounty;

	    if tribute > 0
	      updateStatus "The magistrate gives you #{tribute} gold."
	      newMoney = gameState.money + tribute
	      gameState.setMoney newMoney

	      gameState.setBounty 0

	class Town extends Encounter
	  constructor: ->
	    super "town", "Town!", 2, 4

	  setup: ->
	    super
	    tribute = gameState.limit;
	    updateStatus "The villagers give you #{tribute} gold."
	    newMoney = gameState.money + tribute
	    gameState.setMoney newMoney

	gameTick = ->
	  gameState.playerState.action()
	  gameState.encounter.action()

	startGame = ->
	  gameState.timerId = window.setInterval gameTick, 800

	stopGame = ->
	  window.clearInterval gameState.timerId

	encounters =
	  swamp: new Location "swamp", "Swamp!", 2, 8
	  prarie: new Location "prarie", "Prarie!", 2, 7
	  hills: new Location "hills", "Hills!", 2, 8
	  mountains: new Location "mountains", "Mountains!", 2, 5
	  desert: new Location "desert", "Desert!", 2, 8
	  coastline: new Location "coastline", "Coastline!", 2, 5
	  jungle: new Location "jungle", "Jungle!", 2, 8
	  tundra: new Location "tundra", "Tundra!", 2, 6
	  forest: new Location "forest", "Forest!", 2, 8
	  savana: new Location "savana", "Savana!", 2, 8
	  ruins: new Ruins
	  town: new Town
	  city: new City
	  monster: new Monster

	encounterChance=[
	  {value:0.00, id:"ruins"},
	  {value:0.05, id:"town"},
	  {value:0.10, id:"city"},
	  {value:0.20, id:"swamp"},
	  {value:0.25, id:"savana"},
	  {value:0.30, id:"desert"},
	  {value:0.35, id:"jungle"},
	  {value:0.40, id:"forest"},
	  {value:0.60, id:"hills"},
	  {value:0.65, id:"prarie"},
	  {value:0.70, id:"mountains"},
	  {value:0.75, id:"tundra"},
	  {value:0.80, id:"coastline"},
	  {value:0.85, id:"monster"}
	]

	statusLines=[]

	playerStates =
	  move: new Moving
	  fight: new Fighting
	  rest: new Resting

	# lootFactory = new LootFactory

	gameState = new GameState

	gameState.setLevel 1
	gameState.setHealth 25
	gameState.setExperience 0
	gameState.setMoney 0
	gameState.setNextLevelAt 72
	gameState.setEncounter encounters.forest
	gameState.setPlayerState playerStates.rest

	$ ->
	  statusLines=[
	    $('#line1'),
	    $('#line2'),
	    $('#line3'),
	    $('#line4')
	  ]

	  startGame()

	$('#move').click ->
	  gameState.setPlayerState playerStates.move

	$('#fight').click ->
	  gameState.setPlayerState playerStates.fight

	$('#buy').click ->
	  gameState.setPlayerState playerStates.buy

	$('#sell').click ->
	  gameState.setPlayerState playerStates.sell

	$('#rest').click ->
	  gameState.setPlayerState playerStates.rest

	$('#save').click ->
	  gameState.save()

	$('#load').click ->
	  gameState.load()

	$(document.documentElement).keypress (e) ->
	  if e.keyCode == 109 # m
	    gameState.setEncounter encounters.monster
	  else if e.keyCode == 103 # g
	    gameState.setGodMode !gameState.godMode

	# Hero's Journey
	# 1. Call to Adventure
	# 2. Refusal of the Call
	# 3. Meeting the Mentor
	# 4. Crossing the Threshold
	# 5. Road Of Trials
	# 6. Meeting Of The Goddess
	# 7. Atonement With The Father
	# 8. Apotheosis
	# 9. The Return




