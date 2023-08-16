artifacts_cooldown_item:
  type: item
  material: paper
  display name: <&a>Shop resets in<&co>
  lore:
  - <&7><player.flag_expiration[artifacts_shop].from_now.formatted||0s>

artifacts_shop:
  type: inventory
  inventory: chest
  size: 9
  definitions:
    pane: black_stained_glass_pane
  procedural items:
  - determine air if:!<player.has_flag[artifacts_shop]>
  - determine <player.flag[artifacts_shop].parse[proc[artifact_constructor]]>
  slots:
  - [pane] [] [] [] [pane] [pane] [pane] [artifacts_cooldown_item] [pane]

artifacts_shop_handler:
  type: world
  events:
    on player opens artifacts_shop flagged:!artifacts_shop:
    - determine cancelled passively
    - flag player artifacts_shop:<script[artifact_data].data_key[artifacts].keys.random[3]> expire:1w
    - inventory open d:artifacts_shop