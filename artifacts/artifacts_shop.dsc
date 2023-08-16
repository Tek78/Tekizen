artifact_unreavealed_item:
  type: item
  material: paper
  display name: <&color[#6c2cf5]>Click to Reveal
  mechanisms:
    custom_model_data: 10149

artifacts_shop:
  type: inventory
  inventory: chest
  size: 9
  definitions:
    pane: black_stained_glass_pane
  gui: true
  procedural items:
  - if !<player.has_flag[artifacts_shop]>:
    - determine <item[artifact_unreavealed_item].repeat_as_list[3]>
  - if <player.flag[artifacts_shop].size> < 4:
    - define revealed <player.flag[artifacts_shop].size>
    - define unrevealed <element[3].sub[<[revealed]>]>
    - determine <player.flag[artifacts_shop].include[<item[artifact_unreavealed_item].repeat_as_list[<[unrevealed]>]>]>
  - determine <player.flag[artifacts_shop]>
  slots:
  - [pane] [] [] [] [pane] [pane] [pane] [pane] [pane]

artifacts_shop_handler:
  type: world
  events:
    on player clicks artifact_unreavealed_item in artifacts_shop:
    - define random <script[artifact_data].data_key[artifacts].keys.filter_tag[<player.flag[artifacts_shop].if_null[<list>].contains[<[filter_value].proc[artifact_constructor]>].not>].random>
    - define item <[random].proc[artifact_constructor]>
    - flag player artifacts_shop:->:<[item]>
    - inventory set d:<context.inventory> slot:<context.slot> o:<[item]>