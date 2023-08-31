#DO NOT change/remove 'apply_flag: true' option
#Any message/lore/text can be changed
#As well as chances, multipliers or durations
#All mulitpliers have info on what happens if you change them

artifact_data:
  type: data
  settings:
    #the maximum amount of artifacts applied on items
    max_per_item: 5
    #the artifact item material
    material: paper
    #price range for artifacts
    price: <util.random.int[2000].to[5000]>
    #shop reset announce message
    shop_reset_message: <&a>The Arifacts Shop has been reset!
    rolling_textures:
    #dim
    - 10777
    #bright
    - 10776
    #fallback mocel data if there's no `model:`
    generic_model: 10152
  artifacts:
    auto_smelt:
      display: <&a>Auto Smelt Artifact
      model: 10779
      apply_lore:
      - <&a>☼ Auto Smelt
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Smelts the ores you mine
      tools:
      - Pickaxe
      ores:
        iron_ore: iron_ingot
        deepslate_iron_ore: iron_ingot
        copper_ore: copper_ingot
        deepslate_copper_ore: copper_ingot
        gold_ore: gold_ingot
        deepslate_gold_ore: gold_ingot
        nether_gold_ore: gold_ingot
    telekinesis:
      display: <&a>Telekinesis Artifact
      model: 10792
      apply_lore:
      - <&a>☼ Telekinesis
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Transfers broken items to
      - <&7>your inventory automatically
      tools:
      - Pickaxe
      - Axe
      - Hoe
      - Shovel
    withering:
      display: <&a>Withering Artifact
      model: 10804
      apply_lore:
      - <&a>☼ Withering
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Applies Wither effect to enemy
      tools:
      - Sword
      - Axe
      - Bow
      duration: 5s
      chance: 20
    allure:
      display: <&a>Allure Artifact
      model: 10796
      apply_lore:
      - <&a>☼ Allure
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Pulls enemies towards you
      tools:
      - Sword
      - Axe
    lightweight:
      display: <&a>Lightweight Artifact
      model: 10801
      apply_lore:
      - <&a>☼ Lightweight
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Grants Snow Falling while equipped
      tools:
      - Boots
    overload:
      display: <&a>Overload Artifact
      model: 10788
      apply_lore:
      - <&a>☼ Overload
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Grants an extra heart of health
      tools:
      - Helmet
      - Chestplate
      - Leggings
      - Boots
    reforged:
      display: <&a>Reforged Artifact
      model: 10789
      apply_lore:
      - <&a>☼ Reforged
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Restores durability and removes
      - <&7>artifact when item breaks
      tools:
      - Pickaxe
      - Hoe
      - Sword
      - Axe
      - Shovel
    lavawalker:
      display: <&a>Lavawalker Artifact
      model: 10800
      apply_lore:
      - <&a>☼ Lava Walker
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Walk over lava
      tools:
      - Boots
      apply_flag: true
    unforged:
      display: <&a>Unforged Artifact
      model: 10793
      apply_lore:
      - <&a>☼ Unforged
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to retain durability
      tools:
      - Pickaxe
      - Hoe
      - Sword
      - Axe
      - Shovel
      chance: 15
    lifesteal:
      display: <&a>Lifesteal
      model: 10785
      apply_lore:
      - <&a>☼ Lifesteal
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to heal when attacking
      tools:
      - Sword
      - Axe
      chance: 15
    replant:
      display: <&a>Replant Artifact
      model: 10778
      apply_lore:
      - <&a>☼ Replant
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Replants crops by right clicking them
      - <&7>if you have seeds in your inventory
      tools:
      - Hoe
      crops:
        carrots: carrot
        wheat: wheat_seeds
        potatoes: potato
        beetroots: beetroot_seeds
    bleed:
      display: <&a>Bleed Artifact
      model: 10780
      apply_lore:
      - <&a>☼ Bleed
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Makes the enemy bleed and hurt
      tools:
      - Axe
      - Sword
      - Bow
      chance: 35
      duration: 6s
    lightning:
      display: <&a>Lightining Artifact
      model: 101786
      apply_lore:
      - <&a>☼ Lightning
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to strike lightning on hit
      tools:
      - Bow
      - Crossbow
      chance: 100
    explosion:
      display: <&a>Explosion Artifact
      model: 10783
      apply_lore:
      - <&a>☼ Explosion
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to cause explosion on hit
      tools:
      - Bow
      - Crossbow
      chance: 15
    scanner:
      display: <&a>Scanner Artifact
      model: 10802
      apply_lore:
      - <&a>☼ Scanner
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Makes entities around the shot
      - <&7>arrow glow after it hits
      tools:
      - Bow
      - Crossbow
      range: 15
      duration: 12s
    slowness:
      display: <&a>Slowness Artifact
      model: 10803
      apply_lore:
      - <&a>☼ Slowness
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Gives enemy slowness
      tools:
      - Bow
      - Crossbow
      - Axe
      - Sword
      chance: 30
      duration: 10s
    soulless:
      display: <&a>Soulless Artifact
      model: 10791
      apply_lore:
      - <&a>☼ Soulless
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Deals extra damage to hostile mobs
      tools:
      - Axe
      - Sword
      chance: 65
      multiplier: 1.25
    hunter:
      display: <&a>Hunter Artifact
      model: 10798
      apply_lore:
      - <&a>☼ Hunter
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Deals extra damage to animals
      tools:
      - Axe
      - Sword
      chance: 65
      multiplier: 1.25
    critical:
      display: <&a>Critical Artifact
      model: 10781
      apply_lore:
      - <&a>☼ Critical
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to critically injure enemy
      tools:
      - Axe
      - Sword
      chance: 7.5
      #higher mul => higher damage
      multiplier: 1.45
    headhunter:
      display: <&a>Head Hunter Artifact
      model: 10784
      apply_lore:
      - <&a>☼ Head Hunter
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to drop enemy head item
      tools:
      - Axe
      - Sword
      chance: 12
      mobs:
        zombie: zombie_head
        creeper: creeper_head
        piglin: piglin_head
        skeleton: skeleton_skull
        wither_skeleton: wither_skeleton_skull
    regen:
      display: <&a>Regen Artifact
      model: 10790
      apply_lore:
      - <&a>☼ Regen
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to heal when attacked
      tools:
      - Helmet
      - Chestplate
      - Leggings
      - Boots
      chance: 45
      heal: 4.5
      apply_flag: true
    mitigation:
      display: <&a>Mitigation Artifact
      model: 10787
      apply_lore:
      - <&a>☼ Mitigation
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to mitigate damage
      tools:
      - Helmet
      - Chestplate
      - Leggings
      - Boots
      chance: 45
      #higher mul => less mitigation
      multiplier: 0.75
      apply_flag: true
    anti_knockback:
      display: <&a>Anti Knockback Artifact
      model: 10797
      apply_lore:
      - <&a>☼ Anti Knockback
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to lessen knockback when attacked
      tools:
      - Helmet
      - Chestplate
      - Leggings
      - Boots
      chance: 45
      #lesser mul => less knockback
      multiplier: 0.75
      apply_flag: true
    knockback:
      display: <&a>Knockback Artifact
      model: 10799
      apply_lore:
      - <&a>☼ Knockback
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Knockback entities when attacked
      tools:
      - Helmet
      - Chestplate
      - Leggings
      - Boots
      chance: 45
      apply_flag: true
    experience:
      display: <&a>Experience Artifact
      model: 10782
      apply_lore:
      - <&a>☼ Experience
      lore:
      - <&7>Drag and drop on an item to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Gain more experience from mining
      tools:
      - Pickaxe
      #higher mul => more exp
      multiplier: 1.5