// Generated by CoffeeScript 1.6.2
(function() {
  var Buying, City, Encounter, EncounterChance, Fighting, GameState, Location, Monster, Moving, PlayerState, Resting, Selling, Town, encounterChance, encounters, gameState, playerStates, setInterval, timerId, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  GameState = (function() {
    function GameState() {}

    GameState.prototype.time = 0;

    GameState.prototype.health = 0;

    GameState.prototype.maxHealth = 0;

    GameState.prototype.level = 0;

    GameState.prototype.experience = 0;

    GameState.prototype.money = 0;

    GameState.prototype.loot = 0;

    GameState.prototype.buy = 0;

    GameState.prototype.sell = 0;

    GameState.prototype.limit = 0;

    GameState.prototype.encounter = null;

    GameState.prototype.playerState = null;

    GameState.prototype.setHealth = function(value) {
      this.health = value;
      return $('#health').html(value);
    };

    GameState.prototype.setLevel = function(value) {
      this.level = value;
      $('#level').html(value);
      this.maxHealth = Math.round(173.5 * Math.exp(0.0339 * value) - 147);
      return $('#maxHealth').html(this.maxHealth);
    };

    GameState.prototype.setExperience = function(value) {
      this.experience = value;
      return $('#experience').html(value);
    };

    GameState.prototype.setMoney = function(value) {
      this.money = value;
      return $('#money').html(value);
    };

    GameState.prototype.setLoot = function(value) {
      this.loot = value;
      return $('#loot').html(value);
    };

    GameState.prototype.setEncounter = function(value) {
      var _ref;

      if ((_ref = this.encounter) != null) {
        _ref.teardown();
      }
      this.encounter = value;
      return this.encounter.setup();
    };

    GameState.prototype.setPlayerState = function(value) {
      var _ref;

      if ((_ref = this.playerState) != null) {
        _ref.teardown();
      }
      this.playerState = value;
      return this.playerState.setup();
    };

    return GameState;

  })();

  Encounter = (function() {
    function Encounter(id, name) {
      this.id = id;
      this.name = name;
    }

    Encounter.prototype.setup = function() {
      $('#encounter').removeClass();
      $('#encounter').addClass(this.id);
      return $('#description').html(this.name);
    };

    Encounter.prototype.action = function() {};

    Encounter.prototype.teardown = function() {};

    return Encounter;

  })();

  Location = (function(_super) {
    __extends(Location, _super);

    function Location() {
      _ref = Location.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    return Location;

  })(Encounter);

  Monster = (function(_super) {
    __extends(Monster, _super);

    function Monster() {
      Monster.__super__.constructor.call(this, "monster", "Monster!");
    }

    return Monster;

  })(Encounter);

  City = (function(_super) {
    __extends(City, _super);

    function City() {
      City.__super__.constructor.call(this, "city", "City!");
    }

    return City;

  })(Encounter);

  Town = (function(_super) {
    __extends(Town, _super);

    function Town() {
      Town.__super__.constructor.call(this, "town", "Town!");
    }

    return Town;

  })(Encounter);

  PlayerState = (function() {
    function PlayerState(id, potential, kinetic) {
      this.id = id;
      this.potential = potential;
      this.kinetic = kinetic;
    }

    PlayerState.prototype.action = function() {};

    PlayerState.prototype.setup = function() {
      var $button;

      $button = $('#' + this.id);
      $button.addClass("selected");
      return $button.html(this.kinetic);
    };

    PlayerState.prototype.teardown = function() {
      var $button;

      $button = $('#' + this.id);
      $button.removeClass();
      return $button.html(this.potential);
    };

    return PlayerState;

  })();

  Moving = (function(_super) {
    __extends(Moving, _super);

    function Moving() {
      Moving.__super__.constructor.call(this, "move", "Move!", "Moving!");
    }

    Moving.prototype.action = function() {
      var ec, next, nextEncounter, nextId, _i, _len;

      next = Math.random();
      for (_i = 0, _len = encounterChance.length; _i < _len; _i++) {
        ec = encounterChance[_i];
        if (next >= ec.value) {
          nextId = ec.id;
        } else {
          break;
        }
      }
      nextEncounter = encounters[nextId];
      return gameState.setEncounter(nextEncounter);
    };

    return Moving;

  })(PlayerState);

  Fighting = (function(_super) {
    __extends(Fighting, _super);

    function Fighting() {
      Fighting.__super__.constructor.call(this, "fight", "Fight!", "Fighting!");
    }

    return Fighting;

  })(PlayerState);

  Buying = (function(_super) {
    __extends(Buying, _super);

    function Buying() {
      Buying.__super__.constructor.call(this, "buy", "Buy!", "Buying!");
    }

    return Buying;

  })(PlayerState);

  Selling = (function(_super) {
    __extends(Selling, _super);

    function Selling() {
      Selling.__super__.constructor.call(this, "sell", "Sell!", "Selling!");
    }

    return Selling;

  })(PlayerState);

  Resting = (function(_super) {
    __extends(Resting, _super);

    function Resting() {
      Resting.__super__.constructor.call(this, "rest", "Rest!", "Resting!");
    }

    Resting.prototype.action = function() {
      var addHealth, expMultiplier, lootMultiplier, newHealth;

      if (gameState.health < gameState.maxHealth) {
        expMultiplier = 1;
        lootMultiplier = 1;
        addHealth = expMultiplier * lootMultiplier;
        newHealth = gameState.health + addHealth;
        if (newHealth > gameState.maxHealth) {
          newHealth = gameState.maxHealth;
        }
        return gameState.setHealth(newHealth);
      }
    };

    return Resting;

  })(PlayerState);

  encounters = {
    swamp: new Location("swamp", "Swamp!"),
    prarie: new Location("prarie", "Prarie!"),
    hills: new Location("hills", "Hills!"),
    mountains: new Location("mountains", "Mountains!"),
    desert: new Location("desert", "Desert!"),
    coastline: new Location("coastline", "Coastline!"),
    jungle: new Location("jungle", "Jungle!"),
    ruins: new Location("ruins", "Ruins!"),
    tundra: new Location("tundra", "Tundra!"),
    forest: new Location("forest", "Forest!"),
    savana: new Location("savana", "Savana!"),
    town: new Town,
    city: new City,
    monster: new Monster
  };

  EncounterChance = (function() {
    function EncounterChance(encounter, chance) {
      this.encounter = encounter;
      this.chance = chance;
    }

    return EncounterChance;

  })();

  encounterChance = [
    {
      value: 0.00,
      id: "ruins"
    }, {
      value: 0.05,
      id: "city"
    }, {
      value: 0.10,
      id: "town"
    }, {
      value: 0.20,
      id: "swamp"
    }, {
      value: 0.25,
      id: "savana"
    }, {
      value: 0.30,
      id: "desert"
    }, {
      value: 0.35,
      id: "jungle"
    }, {
      value: 0.40,
      id: "forest"
    }, {
      value: 0.60,
      id: "hills"
    }, {
      value: 0.70,
      id: "prarie"
    }, {
      value: 0.75,
      id: "mountains"
    }, {
      value: 0.80,
      id: "tundra"
    }, {
      value: 0.85,
      id: "coastline"
    }, {
      value: 0.9,
      id: "monster"
    }
  ];

  playerStates = {
    move: new Moving,
    fight: new Fighting,
    buy: new Buying,
    sell: new Selling,
    rest: new Resting
  };

  gameState = new GameState;

  gameState.setLevel(1);

  gameState.setHealth(25);

  gameState.setExperience(0);

  gameState.setMoney(0);

  gameState.setLoot(0);

  gameState.setEncounter(encounters.monster);

  gameState.setPlayerState(playerStates.rest);

  timerId = 0;

  setInterval = function(delay, exp) {
    return timerId = window.setInterval(exp, delay);
  };

  setInterval(1000, function() {
    return gameState.playerState.action();
  });

  $('#move').click(function() {
    return gameState.setPlayerState(playerStates.move);
  });

  $('#fight').click(function() {
    return gameState.setPlayerState(playerStates.fight);
  });

  $('#buy').click(function() {
    return gameState.setPlayerState(playerStates.buy);
  });

  $('#sell').click(function() {
    return gameState.setPlayerState(playerStates.sell);
  });

  $('#rest').click(function() {
    return gameState.setPlayerState(playerStates.rest);
  });

  $(document.documentElement).keypress(function(e) {
    if (e.keyCode === 109) {
      gameState.setEncounter(encounters.monster);
    }
    if (e.keyCode === 108) {
      return gameState.setEncounter(encounters.prarie);
    }
  });

}).call(this);

/*
//@ sourceMappingURL=minventure.map
*/
