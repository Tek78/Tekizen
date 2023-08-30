artifacts_cooldown:
  type: procedure
  definitions: day
  script:
  - define midday <util.time_now.start_of_day.add[12h]>
  - if <util.time_now.day_of_week_name> == <[day]> && <util.time_now.is_before[<[midday]>]>:
    - determine <[midday].from_now.formatted>
  - determine <util.time_now.next_day_of_week[<[day]>].add[12h].from_now.formatted>

artifact_unreavealed_item:
  type: item
  material: paper
  display name: <&color[#6c2cf5]>Click to Reveal
  flags:
    artifact: unset
  mechanisms:
    custom_model_data: 10777

artifact_reset_item:
  type: item
  material: recovery_compass
  display name: <&color[#6c2cf5]>Resets in: <&a><proc[artifacts_cooldown].context[sunday]>

artifacts_shop:
  type: inventory
  inventory: chest
  size: 9
  title: <&f>
  definitions:
    pane: black_stained_glass_pane
  gui: true
  procedural items:
  - if !<player.has_flag[artifacts_shop]>:
    - determine <item[artifact_unreavealed_item].repeat_as_list[3]>
  - determine <player.flag[artifacts_shop]>
  slots:
  - [air] [] [air] [] [air] [] [air] [artifact_reset_item] [air]

artifacts_shop_handler:
  type: world
  events:

    #click handlers for shop
    on player clicks item_flagged:artifact in artifacts_shop:

    #make sure they're clicking the shop GUI
    - if <context.clicked_inventory> != <context.inventory>:
      - stop

    #unset artifact handler
    - if <context.item.flag[artifact]> == unset:
      #if already rolling; stop
      - if <player.has_flag[artifact_rolling]>:
        - narrate "Finish rolling first.."
        - stop
      - define random <script[artifact_data].data_key[artifacts].keys.filter_tag[<player.flag[artifacts_shop].parse[flag[artifact]].if_null[<list>].contains[<[filter_value]>].not>].random>
      - define item <[random].proc[artifact_constructor]>
      - define price <script[artifact_data].parsed_key[settings.price]>
      - define lore "<n><&6>Price: <&7><[price]>"
      - define lore <[item].lore.include[<[lore]>]>
      - define cmd <script[artifact_data].data_key[settings.rolling_textures]>
      - flag player artifact_rolling
      - inventory adjust slot:<context.slot> d:<context.inventory> display:<&e>Rolling...
      #rolling code
      - repeat 10:
        - if <player.open_inventory> != <context.inventory>:
          - stop
        - define cmd <[cmd].reverse>
        - inventory adjust slot:<context.slot> d:<context.inventory> custom_model_data:<[cmd].first>
        - playsound <player> sound:item_trident_hit pitch:1.65 volume:1.25
        - wait 5t
      #set the artifact
      - inventory set d:<context.inventory> slot:<context.slot> o:<[item].with[lore=<[lore]>].with_flag[artifact:<[random]>].with_flag[price:<[price]>]>
      - flag player artifact_rolling:!
      - flag player artifacts_shop:<context.inventory.list_contents.filter[has_flag[artifact]]>
      - stop

    #buying handler
    - if !<context.item.has_flag[purchased]>:
      - define price <context.item.flag[price]>
      #if no money; stop
      - if <player.money> < <[price]>:
        - narrate "Not enough money."
        - stop
      - money take quantity:<[price]>
      - give item:<context.item.flag[artifact].proc[artifact_constructor]>
      - inventory flag slot:<context.slot> d:<context.inventory> purchased
      - inventory adjust slot:<context.slot> d:<context.inventory> lore:<n><element[<&c><&l>Purchased].proc[center_text]><n>
      - flag player artifacts_shop:<context.inventory.list_contents.filter[has_flag[artifact]]>
      - stop

    #already bought
    - narrate "You've already bough this! Come back after reset."

    #remove rolling flag if closed
    on player closes artifacts_shop flagged:artifact_rolling:
    - flag player artifact_rolling:!

    #reset code weekly
    on system time 12:00:
    - if <util.time_now.day_of_week_name> != Sunday:
      - stop
    - flag <server.players_flagged[artifacts_shop]> artifacts_shop:!
    - announce <script[artifact_data].parsed_key[settings.shop_reset_message]>

center_text:
  type: procedure
  debug: false
  definitions: text
  script:
  - define char <&sp>
  - determine <[char].repeat[6]><[text]><[char].repeat[6]>

#shop assignment
artifact_shop_assignment:
  type: assignment
  actions:
    on click:
    - narrate "<&7>Welcome to the Artifacts Market..."
    - playeffect at:<npc.location.above[1.25]> effect:SOUL quantity:5 offset:0.65
    - wait 1s
    - inventory open d:artifacts_shop