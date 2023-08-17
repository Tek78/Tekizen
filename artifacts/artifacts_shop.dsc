artifact_unreavealed_item:
  type: item
  material: paper
  display name: <&color[#6c2cf5]>Click to Reveal
  flags:
    artifact:
      artifact: unset
  mechanisms:
    custom_model_data: 10149

artifact_rolling_item:
  type: item
  material: paper
  display name: <&a>Rolling...
  mechanisms:
    custom_model_data: 10001

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
  - determine <player.flag[artifacts_shop]>
  slots:
  - [pane] [pane] [] [pane] [] [pane] [] [pane] [pane]

artifacts_shop_handler:
  type: world
  events:
    on player clicks item_flagged:artifact in artifacts_shop:
    - if <context.item.flag[artifact.artifact]> == unset:
      - if <player.has_flag[artifact_rolling]>:
        - narrate "Finish rolling first.."
        - stop
      - define random <script[artifact_data].data_key[artifacts].keys.filter_tag[<player.flag[artifacts_shop].parse[flag[artifact.artifact]].if_null[<list>].contains[<[filter_value]>].not>].random>
      - define item <[random].proc[artifact_constructor]>
      - define price <util.random.int[1000].to[2500]>
      - define lore "<n><&6>Price: <&7><[price]>"
      - define lore <[item].lore.include[<[lore]>]>
      - define cmd <list[10002|100001]>
      - flag player artifact_rolling
      - repeat 5:
        - foreach <[cmd]> as:model:
          - if <player.open_inventory> != <context.inventory>:
            - stop
          - inventory set d:<context.inventory> slot:<context.slot> o:<item[artifact_rolling_item].with[custom_model_data=<[model]>]>
          - playsound <player> sound:item_trident_hit pitch:1.65 volume:1.25
          - wait 5t
      - inventory set d:<context.inventory> slot:<context.slot> o:<[item].with[lore=<[lore]>].with_flag[artifact.artifact:<[random]>].with_flag[artifact.price:<[price]>]>
      - flag player artifact_rolling:!
      - flag player artifacts_shop:<context.inventory.list_contents.filter[has_flag[artifact]]>
      - stop
    - if !<context.item.flag[artifact].contains[purchased]>:
      - define price <context.item.flag[artifact.price]>
      - if <player.money> < <[price]>:
        - narrate "Not enough money."
        - stop
      - money take quantity:<[price]>
      - give item:<context.item.flag[artifact.artifact].proc[artifact_constructor]>
      - inventory flag slot:<context.slot> d:<context.inventory> artifact.purchased:true
      - inventory adjust slot:<context.slot> d:<context.inventory> "lore:<n>   <proc[purshased_proc]>   <n>"
      - flag player artifacts_shop:<context.inventory.list_contents.filter[has_flag[artifact]]>
      - stop
    - narrate "You've already bough this! Come back after reset."
    on player closes artifacts_shop flagged:artifact_rolling:
    - flag player artifact_rolling:!

purshased_proc:
    type: procedure
    debug: true
    script:
    - define border <&7><&sp.strikethrough.repeat[18]>
    - define char <&sp>
    - define max_width <[border].text_width>

    - define sentence <&c><&l>Purshased
    - define sentence_width <[sentence].text_width>
    - define letters <list>
    - repeat <[max_width]>:
      - repeat stop if:<element[<[letters].unseparated><[sentence]><[letters].unseparated>].text_width.is_more_than[<[max_width]>]>
      - define letters:->:<[char]>
    - determine <[sentence]> if:<[letters].is_empty>
    - determine <[letters].unseparated><[sentence]><[letters].unseparated>