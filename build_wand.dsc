#hyper showcase post inspired:
#to do:
#have builder mode instead of right clicking each time
#have the type thing be a menu with multiple settings (type, stairs support, range and area etc.)
#block displays w glowing instead of debug blocks?
build_wand:
  type: item
  material: stick
  display name: <&a>Build Wand

wand_find_blocks:
  type: task
  script:
  - define block <player.cursor_on_solid[7]||null>
  - define blocks <[block].to_cuboid[<[block]>].expand[1,0,1].blocks.filter[advanced_matches[air]]>
  - if !<[blocks].is_truthy> or <player.flag[wand.blocks]||null> == <[blocks]>:
    - stop

  - if <player.has_flag[wand.blocks]>:
    - flag player wand.blocks:!
  - if <player.has_flag[wand.entities]>:
    - remove <player.flag[wand.entities].filter[is_spawned]>
    - flag player wand.entities:!

  - if <player.item_in_hand> !matches build_wand || !<player.item_in_offhand.material.is_solid>:
    - stop

  - flag <player> wand.blocks:<[blocks]>
  - define material <player.item_in_offhand.material>
  - define material <[material].with[type=<player.flag[wand.settings.type]||TOP>]> if:<[material].supports[type]>
  - foreach <[blocks]>:
    - spawn <[value]> block_display[material=<[material]>;glowing=true] save:block
    - flag player wand.entities:->:<entry[block].spawned_entity>
    - adjust <server.online_players.exclude[<player>]> hide_entity:<entry[block].spawned_entity>

wand_world:
  type: world
  events:
    on player walks:
    - run wand_find_blocks

    on player left clicks block with:build_wand flagged:wand.blocks:
    - ratelimit <player> 1t
    - if <player.item_in_offhand> matches *_slab:
      - define types <list[TOP|BOTTOM]>
      - if <player.flag[wand.settings.type]||null> == BOTTOM:
        - define type TOP
      - else:
        - define type BOTTOM

    - narrate "<&c>Build Wand: <&7>Slab placement toggled: <&a><[type]>"
    - remove <player.flag[wand.entities].filter[is_spawned]> if:<player.has_flag[wand.entities]>
    - flag <player> wand:!
    - flag <player> wand.settings.type:<[type]>
    - run wand_find_blocks

    on player right clicks block with:build_wand flagged:wand.blocks:
    - ratelimit <player> 1t

    - define quantity <player.flag[wand.blocks].size>
    - if !<player.item_in_offhand.material.is_solid>:
      - narrate "<&c>Build Wand: <&7>Disallowed material!"
      - playsound <player> sound:BLOCK_NOTE_BLOCK_BASS pitch:0.1
      - stop

    - if <player.gamemode> != CREATIVE && <player.item_in_offhand.quantity> < <[quantity]>:
      - narrate "<&c>Build Wand: <&7>Not enough quantity!"
      - stop

      - remove <player.flag[wand.entities]>
      - flag player wand.entities:!
    - modifyblock <player.flag[wand.blocks]> <player.item_in_offhand.material> source:<player>

     #slab support
    - if <player.item_in_offhand> matches *_slab:
      - define type <player.flag[wand.settings.type]||TOP>
    - adjustblock <player.flag[wand.blocks]> type:<[type]>

    - remove <player.flag[wand.entities].filter[is_spawned]> if:<player.has_flag[wand.entities]>
    - take slot:offhand quantity:<[quantity]> if:<player.gamemode.equals[CREATIVE].not>
    - playsound <player> sound:BLOCK_WOOD_STEP pitch:4

    on player places block using:off_hand:
    - if <player.item_in_hand> matches build_wand:
      - determine cancelled

    on player breaks block with:build_wand:
    - determine cancelled

    after player scrolls their hotbar:
    - if <player.inventory.slot[<context.previous_slot>]> matches build_wand:
      - remove <player.flag[wand.entities].filter[is_spawned]> if:<player.has_flag[wand.entities]>
      - flag player wand:!