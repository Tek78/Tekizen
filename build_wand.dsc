#hyper showcase post inspired:
build_wand:
  type: item
  material: stick
  display name: <&a>Build Wand

wand_world:
  type: world
  events:
    on player walks:

    - if <player.has_flag[wand_blocks]>:
      - flag player wand_blocks:!
      - debugblock clear

    - define block <player.cursor_on_solid[7]||null>
    - stop if:!<[block].is_truthy>
    - if <player.item_in_hand> !matches build_wand || !<player.item_in_offhand.material.is_solid>:
      - stop

    - define blocks <[block].to_cuboid[<[block]>].expand[1,0,1].blocks.filter[advanced_matches[air]]>
    - stop if:!<[blocks].is_truthy>
    - flag <player> wand_blocks:<[blocks]>
    - debugblock <[blocks]> color:blue d:15s

    on player right clicks block with:build_wand flagged:wand_blocks:
    - ratelimit <player> 1t

    - define quantity <player.flag[wand_blocks].size>
    - if !<player.item_in_offhand.material.is_solid>:
      - narrate "<&c>Build Wand: <&7>Disallowed material!"
      - playsound <player> sound:BLOCK_NOTE_BLOCK_BASS pitch:0.1
      - stop

    - if <player.gamemode> != CREATIVE && <player.item_in_offhand.quantity> < <[quantity]>:
      - narrate "<&c>Build Wand: <&7>Not enough quantity!"
      - stop

    - debugblock clear
    - modifyblock <player.flag[wand_blocks]> <player.item_in_offhand.material> source:<player>

    #slab support
    - if <player.item_in_offhand> matches *_slab:
      - if <player.eye_location.ray_trace.y> > <context.location.y.add[0.5]>:
        - define type TOP
      - else:
        - define type BOTTOM
    - adjustblock <player.flag[wand_blocks]> type:<[type]>

    - take slot:offhand quantity:<[quantity]> if:<player.gamemode.equals[CREATIVE].not>
    - playsound <player> sound:BLOCK_WOOD_STEP pitch:4

    on player places block using:off_hand:
    - if <player.item_in_hand> matches build_wand:
      - determine cancelled