class Loot
  constructor: (@singular,@plural,@quantity) ->

  incrementQuantity: ->
    @quantity = @quantity + 1

  description: ->
    if @quantity > 1
      @plural
    else
      @singular

class Fragment
  constructor: ->
    @subfragments = []

  render: (plural) ->

  addFragment: (fragment) ->
    @subfragments.push fragment

class OptionalFragment extends Fragment

class LookupFragment extends Fragment

class PluralFragment extends Fragment

class TextFragment extends Fragment

class ListFragment extends Fragment

class SelectFragment extends Fragment

  ###


    new ListFragment
      new OptionalFragment
        new LookupFragment "Weight"
      new OptionalFragment
        new SelectFragment
          new LookupFragment "Race"
          new LookupFragment "Material"
      new SelectFragment
        new PluralFragment "Dagger"
        new PluralFragment "Knife"
        new PluralFragment "Axe"
        new PluralFragment "Short Sword"
        new PluralFragment "Broadsword"


    new ListFragment
      new PluralFragment "Scroll"
      new TextFragment "of"
      new LookupFragment "Characteristic"

    new ListFragment
      new TextFragment "Amulet"
      new TextFragment "of"
      new TextFragment "Yendor"
  ###


class LootFactory

  _templates = [
    "?{Weight} ?[{Race}|{Material}] [^Dagger|^Knife|^Axe|^Short Sword|^Broadsword|^Long Sword|^Katana|^Saber|^Club|^Mace|^Morning Star|^Flail|^Quarterstaff|^Polearm|^Spear|^Bow|^Crossbow]",
    "?{Aspect} ?{Race} {Mail} [^Armor|Pair of Gauntlets|^Helm|Pair of Boots]",
    "?{Aspect} ?{Race} {Material} ^Shield",
    "{Color} Monster [^Hide|^Fur|^Tusk|^Horns|Teeth|Bones]",
    "?{Weight} {Metal} [^Saw|^Axe|Scissors|^Hammer|^Wrench|Pliers]",
    "^Scroll of {Characteristic}",
    "{Metal} ^Wand of {Characteristic}",
    "{Color} ^Potion of {Characteristic}",
    "{Metal} ^Amulet",
    "?{Metal} ^Amulet of {Characteristic}",
    "{Gem} ^Amulet",
    "{Gem} ^Amulet of {Characteristic}",
    "Amulet of Yendor",
    "{Metal} ^Ring",
    "?{Metal} ^Ring of {Characteristic}",
    "{Gem} ^Ring",
    "{Gem} ^Ring of {Characteristic}",
    "?{Gem} Encrusted {Metal} ^Ring",
    "?{Gem} Encrusted ?{Metal} ^Ring of {Characteristic}",
    "?{Weight} {Metal} ^Bracelet",
    "?{Weight} ?{Metal} ^Bracelet of {Characteristic}",
    "?{Gem} Encrusted {Metal} ^Bracelet",
    "?{Gem} Encrusted ?{Metal} ^Bracelet of {Characteristic}",
    "?{Weight} {Metal} ^Necklace",
    "?{Weight} ?{Metal} ^Necklace of {Characteristic}",
    "?{Gem} Encrusted {Metal} ^Necklace",
    "?{Gem} Encrusted ?{Metal} ^Necklace of {Characteristic}",
    "{Material} ^Rod",
    "{Material} ^Staff",
    "{Gem} Encrusted {Material} ^Rod",
    "{Gem} Encrusted {Material} ^Staff",
    "?{Aspect} {Material} ^Key",
    "?{Aspect} {Material} ^Arrow",
    "?{Aspect} {Material} ^Bolt",
    "{Size} ?{Aspect} {Color} ^Gem",
    "{MetalElement} Ore",
    "?{Size} ?{Aspect} {Color} [^Shirt|Trousers|Shorts|Capris|^Skirt|^Robe|^Hood|Gloves|^Dress|^Jacket|^Vest|Pajamas|^Scarf|^Coat|^Cap|^Cape|^Mask|^Headband]",
    "?{Size} ?{Color} ^Book of {Topic}",
    "?{Length} ?{Color} ^Book of {Topic}",
    "?{Weight} ?{Color} ^Book of {Topic}",
    "?{Aspect} {Material} [^Fork|^Spoon|^Knife]",
  ]

  create: ->
    template = _templates[Math.floor(Math.random() * _templates.length)]
    fragmentList = @parseTemplate template

    singular = fragmentList.render false
    plural = fragmentList.render true

    new Loot(singular, plural, 1)

  parseTemplate: (template) ->
    master = new ListFragment()
    parent = master

    p = 0

    while p < template.length
      c = template.charAt p

      switch c
        when '?' then parent.addFragment new OptionalFragment()
        when '{' then p = @parseLookup parent, template, p
        when '[' then p = @parseSelect parent, template, p
        when '^' then p = @parsePlural parent, template, p
        when ' ' then p = p + 1
        else p = @parseText parent, template, p

      console.log c

      p++

    master

  parseLookup: (parent, template, p) ->
  parseSelect: (parent, template, p) ->
  parsePlural: (parent, template, p) ->
  parseText: (parent, template, p) ->

factory = new LootFactory()

loot = factory.create()

console.log loot.description

