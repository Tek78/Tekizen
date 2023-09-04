##hyper showcase post inspired => https://discord.com/channels/315163488085475337/843302108001468446/1147314557212184656
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
  settings:
    formats:
      horizontal: x,0,x
      vertical_x: x,x,0
      vertical_z: 0,x,x
    blacklisted_materials:
    - door
    range:
      max: 20
      default: 10
    area:
      max: 5
      default: 1

build_wand:
  type: item
  material: stick
  display name: <&b>Build Wand
  lore:
  - <&a>Right Click <&7>- Place Block
  - <&a>Left Click <&7>- Open Settings Menu

range_item:
  type: item
  material: ender_eye
  display name: <&a>Current Range<&co> <&7><player.flag[wand.range]||<script[build_wand_data].data_key[settings.range.default]>>
  lore:
  - <&7><&o> Left click » <&e><&o>Increase
  - <&7><&o> Right Click » <&e><&o>Decrease
  - <empty>
  - <&a>Max Range<&co> <&7><script[build_wand_data].data_key[settings.range.max]>
  flags:
    data: range

area_item:
  type: item
  material: ender_pearl
  display name: <&a>Current Area Range<&co> <&7><player.flag[wand.area]||<script[build_wand_data].data_key[settings.area.default]>>
  lore:
  - <&7><&o> Left click » <&e><&o>Increase
  - <&7><&o> Right Click » <&e><&o>Decrease
  - <empty>
  - <&a>Max Range<&co> <&7><script[build_wand_data].data_key[settings.area.max]>
  flags:
    data: area

format_item:
  type: item
  material: nether_star
  display name: <&a>Current format<&co> <&7><player.flag[wand.format]||<script[build_wand_data].data_key[settings.formats].keys.first>>
  lore:
  - <&7><&o>Click to cycle through options

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
  - [] [] [] [] [] [] [format_item] [range_item] [area_item]

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

wand_is_valid:
  type: procedure
  definitions: item
  script:
  - define data <script[build_wand_data].data_key[settings.blacklisted_materials]>
  - if <[item].material.is_solid>:
    - if <[data].filter_tag[<[item].advanced_matches[*_<[filter_value]>]>].is_truthy>:
      - determine false
    - determine true
  - determine false

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
    - if !<[properties].is_truthy>:
      - inventory open d:wand_settings_inventory
      - stop

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
    after player right clicks block with:build_wand flagged:wand.blocks:
    - ratelimit <player> 5t
    #quantity (used if gamemode is not creative)
    - define quantity <player.flag[wand.blocks].size>

    #stop if the material isn't solid
    - if !<player.item_in_offhand.proc[wand_is_valid]>:
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

    after player clicks range_item|area_item in wand_settings_inventory:
    - define value <context.item.flag[data]>
    - define settings <script[build_wand_data].data_key[settings]>
    - define range <player.flag[wand.<[value]>]||<[settings.<[value]>.default]>>
    - define max_range <[settings.<[value]>.max]>

    - if <context.click> == LEFT:
      - if <[range]> == <[max_range]>:
        - narrate "<&c>Build Wand: <&7>Max Range already applied!"
        - stop
      - flag player wand.<[value]>:<[range].add[1]>
      - inventory set slot:<context.slot> d:<context.inventory> o:<context.item.script.name>

    - if <context.click> == RIGHT:
      - if <[range]> == 1:
        - narrate "<&c>Build Wand: <&7>Lowest Range already applied!"
        - stop
      - flag player wand.<[value]>:<[range].sub[1]>
      - inventory set slot:<context.slot> d:<context.inventory> o:<context.item.script.name>

    after player clicks format_item in wand_settings_inventory:
    - define data <script[build_wand_data].data_key[settings.formats]>
    - define format <player.flag[wand.format]||<[data].keys.first>>
    - define index <[data].keys.find[<[format]>].add[1]>
    - define new_format <[data].keys.get[<[index]>]||<[data].keys.first>>

    - flag <player> wand.format:<[new_format]>
    - inventory set slot:<context.slot> d:<context.inventory> o:<context.item.script.name>

wand_find_blocks:
  type: task
  script:
  - define settings <script[build_wand_data].data_key[settings]>
  - define area <player.flag[wand.area]||<[settings.area.default]>>
  - define range <player.flag[wand.range]||<[settings.range.default]>>
  - define mode <player.flag[wand.mode]||free_build>
  - define format <player.flag[wand.format]||<[settings.formats].keys.first>>

  #target block and area
  - define block <player.cursor_on_solid[<[range]>]||null>
  - if <[format]> != horizontal:
    - define block <[block].above[<[area]>]>

  - define format <[settings.formats.<[format]>].replace[x].with[<[area]>]>
  - define blocks <[block].to_cuboid[<[block]>].expand[<[format]>].blocks.filter[advanced_matches[air]]||null>
  #stop if the area isn't valid or the current holographic blocks are the same (event fires very rapidly)
  - if <player.has_flag[wand.blocks]>:
    - if <player.flag[wand.blocks]> == <[blocks]>:
      - stop
    - remove <player.flag[wand.blocks].parse[flag[wand_entity]].filter[is_spawned]>
    - flag player wand.blocks:!

  - stop if:!<[block].is_truthy>

  - if <player.item_in_hand> !matches build_wand || !<player.item_in_offhand.proc[wand_is_valid]>:
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