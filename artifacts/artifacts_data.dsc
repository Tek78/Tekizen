artifact_data:
  type: data
  settings:
    #the maximum amount of artifacts applied on items
    max_per_item: 3
    #chance to drop from mobs
    chance_to_drop: 1
    #the artifact material
    material: paper
    #the custom model data for the material
    custom_model: 10001
    #lore for artifact
  artifacts:
    auto_smelt:
      script: auto_smelt_artifact
      apply_lore:
      - <&a>☼ Auto Smelt
      lore:
      - <&7>Drag and drop on a tool to
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
    telepathy:
      script: telepathy_artifact
      apply_lore:
      - <&a>☼ Telepathy
      lore:
      - <&7>Drag and drop on a tool to
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
      script: withering_artifact
      apply_lore:
      - <&a>☼ Withering
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Applies Wither effect to enemy
      tools:
      - Sword
      - Axe
      duration: 5s
    allure:
      script: allure_artifact
      apply_lore:
      - <&a>☼ Allure
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Pulls enemies towards you
      tools:
      - Sword
      - Axe
    lightweight:
      script: lightweight_artifact
      apply_lore:
      - <&a>☼ Lightweight
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Grants Snow Falling while equipped
      tools:
      - Boots
    overlord:
      script: overlord_artifact
      apply_lore:
      - <&a>☼ Overlord
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Grants an extra heart of health
      tools:
      - Helmet
      - Chestplate
      - Leggings
      - Boots
    reforged:
      script: reforged_artifact
      apply_lore:
      - <&a>☼ Reforged
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Restores durability and removes
      - <&7>artifact when item breaks
      tools:
      - Pickaxe
      - Hoe
      - Sword
      - Axe
      - Trident
      - Shovel
    lavawalker:
      script: lavawalker_artifact
      apply_lore:
      - <&a>☼ Lava Walker
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Walk over lava
      tools:
      - Boots
    unforged:
      script: unforged_artifact
      apply_lore:
      - <&a>☼ Unforged
      lore:
      - <&7>Drag and drop on a tool to
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
      script: lifesteal_artifact
      apply_lore:
      - <&a>☼ Unforged
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Chance to heal when attacking
      tools:
      - Sword
      - Axe
      chance: 15
    replant:
      script: replant_artifact
      apply_lore:
      - <&a>☼ Replant
      lore:
      - <&7>Drag and drop on a tool to
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
      script: bleed_artifact
      apply_lore:
      - <&a>☼ Bleed
      lore:
      - <&7>Drag and drop on a tool to
      - <&7>apply this artifact to it.
      - <empty>
      - <&7>Makes the enemy bleed and hurt
      tools:
      - Axe
      - Sword
      - Bow
      chance: 35