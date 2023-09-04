##hyper showcase post inspired => https://discord.com/channels/315163488085475337/843302108001468446/1147314557212184656
##TO DO:
##Add Range and Area options in settings menu
##Add blacklist option for solid materials in data script

build_wand_data:
  type: data
  properties:
    Type:
    - TOP
    - BOTTOM
    Direction:
    - NORTH
    - SOUTH
    - WEST
    - EAST
    Half:
    - TOP
    - BOTTOM
    Shape:
    - STRAIGHT
    - INNER_LEFT
    - INNER_RIGHT
    - OUTER_LEFT
    - OUTER_RIGHT

build_wand:
  type: item
  material: stick
  display name: <&b>Build Wand
  lore:
  - <&a>Right Click <&7>- Place Block
  - <&a>Left Click <&7>- Open Settings Menu

wand_settings_inventory:
  type: inventory
  inventory: chest
  size: 9
  title: <&a>Build Wand Settings
  gui: true
  procedural items:
  - define settings <player.flag[wand.settings]>
  #generating info for each property item
  - foreach <[settings]>:
    #skip to next property if the material doesnt support the current one
    - foreach next if:!<player.item_in_offhand.material.supports[<[key]>]>
    - define display "<&a>Current <[key]><&co> <&7><[value]>"
    - define lore "<&7><&o>Click to cycle through options"
    - define indicator_lore:->:<[display]>
    - define items:->:<item[paper].with[display=<[display]>;lore=<[lore]>].with_flag[setting:<[key]>]>

  #indicator item with all the current info
  - define indicator <player.item_in_offhand.with[quantity=1;lore=<[indicator_lore]>]>
  - determine <[items].include[air|<[indicator]>]>
  slots:
  - [] [] [] [] [] [] [] [] []

wand_properties:
  type: procedure
  definitions: material
  script:
  - define data <script[build_wand_data].data_key[properties]>
  - define properties <map>
  - foreach <[data]>:
    #next if material doesnt support property
    - foreach next if:!<[material].supports[<[key]>]>
    - define val <player.flag[wand.settings.<[key]>]||<[value].first>>
    - define properties <[properties].with[<[key]>].as[<[val]>]>
  - determine <[properties]>

build_wand_world:
  type: world
  events:
    #open settings menu
    after player left clicks block with:build_wand:
    - define mat <player.item_in_offhand.material>
    - define data <script[build_wand_data].data_key[properties]>
    #find all properties that are supported for the held material
    - define properties <[data].keys.filter_tag[<[mat].supports[<[filter_value]>]>]>
    #stop if none are found
    - stop if:!<[properties].is_truthy>

    - foreach <[properties]>:
      #skip to next property if already set
      - foreach next if:<player.has_flag[wand.settings.<[value]>]>
      #current property, if unset fallsback to first in the data script
      - define current <player.flag[wand.settings.<[value]>]||<[data.<[value]>].first>>
      - flag <player> wand.settings.<[value]>:<[current]>
    - inventory open d:wand_settings_inventory

    #change a property of the material you're placing (stairs + slabs support so far)
    ##TO DO??: Properties flag and settings reset when the player switches to an unsupported material
    after player clicks item_flagged:setting in wand_settings_inventory:
    - define property <context.item.flag[setting]>
    - define data <script[build_wand_data].data_key[properties]>

    #current set property, if unset fallsback to first property in the data
    - define current <player.flag[wand.settings.<[property]>]||<[data.<[property]>].first>>
    #index of current property
    - define index <[data.<[property]>].find[<[current]>].add[1]>
    - define new <[data.<[property]>].get[<[index]>]||<[data.<[property]>].first>>

    #flag the player with the new property
    - flag <player> wand.settings.<[property]>:<[new]>
    #reopen inventory to adjust the item values
    - inventory open d:wand_settings_inventory

    #remove blocks with old properties and spawn new ones
    - if <player.has_flag[wand.blocks]>:
      - remove <player.flag[wand.blocks].parse[flag[wand_entity]].filter[is_spawned]>
      - flag player wand.blocks:!
    - run wand_find_blocks

    on player walks:
    - ratelimit <player> 1t
    - run wand_find_blocks

    #place hologram blocks
    on player right clicks block with:build_wand flagged:wand.blocks:
    - ratelimit <player> 1t
    #quantity (used if gamemode is not creative)
    - define quantity <player.flag[wand.blocks].size>

    #stop if the material isn't solid
    ##TO DO: Add option to blacklist solid blocks through data script
    - if !<player.item_in_offhand.material.is_solid>:
      - narrate "<&c>Build Wand: <&7>Disallowed material!"
      - playsound <player> sound:BLOCK_NOTE_BLOCK_BASS pitch:0.1
      - stop

    #quantity check if not in creative
    - if <player.gamemode> != CREATIVE && <player.item_in_offhand.quantity> < <[quantity]>:
      - narrate "<&c>Build Wand: <&7>Not enough quantity!"
      - playsound <player> sound:BLOCK_NOTE_BLOCK_BASS pitch:0.1
      - stop

    - define material <player.item_in_offhand.material>
    - define properties <[material].proc[wand_properties]>

    - modifyblock <player.flag[wand.blocks]> <[material].with_map[<[properties]>]> source:<player>
    #remove the holograms
    - remove <player.flag[wand.blocks].parse[flag[wand_entity]].filter[is_spawned]>
    - take slot:offhand quantity:<[quantity]> if:<player.gamemode.equals[CREATIVE].not>
    - playsound <player> sound:BLOCK_WOOD_STEP pitch:4
    #remove blok flag after block entities are cleared
    - flag player wand.blocks:!

    on player places block using:off_hand:
    - if <player.item_in_hand> matches build_wand:
      - determine cancelled

    on player breaks block with:build_wand:
    - determine cancelled

wand_find_blocks:
  type: task
  script:
  #target block and 3x3 area
  - define block <player.cursor_on_solid[7]||null>
  - define blocks <[block].to_cuboid[<[block]>].expand[1,0,1].blocks.filter[advanced_matches[air]]||null>
  #stop if the 3x3 area isn't valid or the current holographic blocks are the same (event fires very rapidly)
  - if <player.has_flag[wand.blocks]>:
    - if <player.flag[wand.blocks]> == <[blocks]>:
      - stop
    - remove <player.flag[wand.blocks].parse[flag[wand_entity]].filter[is_spawned]>
    - flag player wand.blocks:!

  - stop if:!<[block].is_truthy>

  - if <player.item_in_hand> !matches build_wand || !<player.item_in_offhand.material.is_solid>:
    - stop
  - define material <player.item_in_offhand.material>
  - define properties <[material].proc[wand_properties]>
  - flag <player> wand.blocks:<[blocks]>

  - foreach <[blocks]>:
    #spawn a block display with the material and properties applied
    - spawn <[value]> block_display[material=<[material].with_map[<[properties]>]>;glowing=true] save:block
    #flag the block with the spawned block entity
    - flag <[value]> wand_entity:<entry[block].spawned_entity>
    #make it invisible for everyone but the player
    - adjust <server.online_players.exclude[<player>]> hide_entity:<entry[block].spawned_entity>