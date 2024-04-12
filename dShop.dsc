#@ Vault and an economy provider is needed for this script to work
#If there are any issues feel free to reach out on discord => tek7_

dShop_data:
  type: data
  #The items that will appear in the shop go here
  items:
    #Every item must have at least a buy or a sell price (or both!)
    coal:
      buy: 5
      sell: 2.5
    charcoal:
      buy: 4
      sell: 2
      #You can add a permission requirement, if the player doesn't have the permission the item will not appear in their shop
      permission: sell.charcoal
    raw_iron:
      buy: 7
      sell: 5
    raw_copper:
      buy: 6
      sell: 5
    raw_gold:
      buy: 9
      sell: 7
    emerald:
      buy: 15
      sell: 10
    lapis_lazuli:
      buy: 8.5
      sell: 7
    iron_ingot:
      buy: 12
      sell: 10
    gold_ingot:
      buy: 14
      sell: 12
    copper_ingot:
      buy: 10
      sell: 8
    netherite_ingot:
      buy: 20
      sell: 16.5
    apple:
      buy: 5
    golden_apple:
      buy: 15
    carrot:
      buy: 4
    golden_carrot:
      buy: 12.5
    oak_log:
      sell: 10
    spruce_log:
      sell: 10
    birch_log:
      sell: 10
    jungle_log:
      sell: 10
    acacia_log:
      sell: 10
    dark_oak_log:
      sell: 10
    mangrove_log:
      sell: 10
    cherry_log:
      sell: 10
    my_item:
      buy: 100
    my_smelt:
      buy: 100

#@ Convert the data into a list of items
dShop_convert_to_item:
  type: procedure
  debug: false
  script:
  - define shop_data <script[dShop_data].data_key[items]>

  - foreach <[shop_data]> key:item as:item_data:
    - define name <[item]>
    #/Validity Check
    - if !<[item].as[item].exists>:
      - debug error "dShop | Invalid item input specified (<[name]>)! Must be a valid material or item script name! Skipping."
      - foreach next
    #Parse as item
    - define item <[item].as[item]>
    #Check for permission requirement
    - if <[item_data].contains[permission]> && !<player.has_permission[<[item_data.permission]>]>:
      - foreach next

    #Valid option input check
    - define options <[item_data].keys.filter[is_in[buy|sell]]>
    - if !<[options].any>:
      - debug error "dShop | Item (<[name]>) must contain sell or buy price. Skipping."
      - foreach next

    - foreach <[options]>:
      #Valid input check
      - if !<[item_data.<[value]>].is_decimal>:
        - debug error "dShop | Invalid <[value]> price for <[name]>! Must be a number. Skipping."
        - define item <[item].with_flag[price:!]>
        - foreach stop
      - define item <[item].with_flag[price.<[value]>:<[item_data.<[value]>]>]>
      #Adjust price into lore
      - adjust def:item lore:<[item].lore.if_null[<list>].include[<&e><[value].to_titlecase> price per item: <&a><[item_data.<[value]>]><server.economy.currency_name[<[item_data.<[value]>]>]>]>
    #Skip item if no valid option
    - foreach next if:!<[item].has_flag[price]>
    - adjust def:item lore:<[item].lore.include[<&c>Click to buy or sell.]>
    - define items:->:<[item]>
  - determine <[items]>

#@Inventories
dShop_inventory:
  type: inventory
  inventory: chest
  size: 45
  debug: false
  title: <&e>dShop
  gui: true
  definitions:
    filler: black_stained_glass_pane[display=<&r>]
  slots:
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
  - [filler] [] [] [] [] [] [] [] [filler]
  - [filler] [] [] [] [] [] [] [] [filler]
  - [filler] [] [] [] [] [] [] [] [filler]
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
dShop_confirm_menu:
  type: inventory
  inventory: chest
  size: 27
  debug: false
  gui: true
  procedural items:
  #Filler
  - determine <item[black_stained_glass_pane].with[display=<&r>].repeat_as_list[27]>
  slots:
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [dShop_confirm_purchase] [dShop_cancel_purchase] [] []
  - [] [] [] [] [] [] [] [] []

#@Item Scripts
dShop_confirm_purchase:
  type: item
  material: green_stained_glass_pane
  display name: <&a>Confirm
dShop_cancel_purchase:
  type: item
  material: red_stained_glass_pane
  display name: <&c>Cancel
  flags:
    page: 1
dShop_toggle_option:
  type: item
  material: nether_star
  display name: <&e>Click to toggle options
dShop_next_page:
  type: item
  material: arrow
  debug: false
  display name: <&a>Next Page
dShop_previous_page:
  type: item
  material: arrow
  debug: false
  display name: <&a>Previous Page

#@Paged inventory task
dShop_paged_inventory:
  type: task
  definitions: page
  debug: false
  script:
  #Default to page 1
  - define page 1 if:!<[page].exists>
  #Inventory, items & paged items
  - define inventory <inventory[dShop_inventory]>
  - define items <proc[dShop_convert_to_item]>
  - define sub_lists <[items].sub_lists[<[inventory].empty_slots>]>

  - give <[sub_lists].get[<[page]>]> to:<[inventory]>

  #Previous and next page buttons
  - if <[page]> > 1:
    - define previous_page <item[dShop_previous_page].with_flag[page:<[page].sub[1]>]>
    - inventory set d:<[inventory]> slot:37 o:<[previous_page]>
  - if <[page]> < <[sub_lists].size>:
    - define next_page <item[dShop_next_page].with_flag[page:<[page].add[1]>]>
    - inventory set d:<[inventory]> slot:45 o:<[next_page]>

  - adjust <[inventory]> "title:<[inventory].title> | Page <[page]>"
  - inventory open d:<[inventory]>

#@Handlers
dShop_handlers:
  type: world
  debug: false
  data:
    #Confirmation item lore
    confirm_lore:
    - <&c>Left <&e>click to <[current]> <&a>1
    - <&c>Right <&e>click to <[current]> <&a><context.item.material.max_stack_size>
    - <&c>Shift <&e>click to <[current]> <&a>all
  events:
    #Pages handler
    after player clicks item_flagged:page in dShop_inventory:
    - run dShop_paged_inventory def:<context.item.flag[page]>

    #Confirmation menu open
    after player clicks item_flagged:price in dShop_inventory:
    - define inventory <inventory[dShop_confirm_menu]>
    - define price_data <context.item.flag[price]>

    #Remove last lore line (Redundant in confirmation menu)
    - define lore <context.item.lore>
    - define lore <[lore].remove[<[lore].size>]>

    #Set the item & title
    - inventory set d:<[inventory]> slot:11 o:<context.item.with[lore=<[lore]>]>
    - adjust <[inventory]> "title:<&e><context.item.display.if_null[<context.item.material.translated_name>]> <&7>| <&e>Bal: <&c><player.formatted_money>"
    #Current option
    - define current <[price_data].keys.first>
    #Set toggle item if there's more than 1 option
    - if <[price_data].keys.size> > 1:
      - define toggle <item[dShop_toggle_option].with_flag[current:<[current]>]>
      - adjust def:toggle "lore:<&7>Current option: <&a><[current]>"
      - inventory set d:<[inventory]> slot:13 o:<[toggle]>
    #Set confirmation item lore
    - inventory adjust d:<[inventory]> slot:15 lore:<script.parsed_key[data.confirm_lore]>

    #Find first page item
    - define page_item <context.inventory.slot[<context.inventory.find_item[item_flagged:page]>]>
    #Define current page
    - if <[page_item]> matches dShop_previous_page:
      - define page <[page_item].flag[page].add[1]>
    - else:
      - define page <[page_item].flag[page].sub[1]>
    #Set page flag to cancel purchase item & open
    - inventory flag d:<[inventory]> slot:<[inventory].find_item[dShop_cancel_purchase]> page:<[page]>
    - inventory open d:<[inventory]>

    #Toggle options handler
    after player clicks dShop_toggle_option in dShop_confirm_menu:
    #Current option & price data
    - define current <context.item.flag[current]>
    - define price_data <context.inventory.slot[<context.inventory.find_item[item_flagged:price]>].flag[price]>
    #Define new option
    - define pos <[price_data].keys.find[<[current]>]>
    - if <[pos]> == 2:
      - define current <[price_data].keys.first>
    - else:
      - define current <[price_data].keys.last>
    #Set lore & option flag
    - inventory adjust slot:<context.slot> d:<context.inventory> "lore:<&7>Current option: <&a><[current]>"
    - inventory flag slot:<context.slot> d:<context.inventory> current:<[current]>

    #Update confirmation item lore
    - inventory adjust d:<context.inventory> slot:15 lore:<script.parsed_key[data.confirm_lore]>

    #Purchase & sell handler
    after player clicks dShop_confirm_purchase in dShop_confirm_menu:
    #Valid click check
    - stop if:!<context.click.advanced_matches[RIGHT|LEFT|SHIFT_*]>
    #Find item being sold/bought & current option
    - define item <context.inventory.slot[<context.inventory.find_item[item_flagged:price]>]>
    - define option <context.inventory.slot[<context.inventory.find_item[item_flagged:current]>].flag[current].if_null[null]>
    - define option <[item].flag[price].keys.first> if:<[option].equals[null]>
    #Define quantity depending on click
    - if <context.click> == LEFT:
      - define quantity 1
    - else if <context.click> == RIGHT:
      - define quantity 64
    #Matchable
    - define matchable <[item].script.name.if_null[<[item].material.name>]>

    #Options
    - choose <[option]>:
      - case sell:
        #Shift click case
        - if !<[quantity].exists>:
          #Calc the sum of all matched items
          - define pos <player.inventory.find_all_items[<[matchable]>]>
          - define quantity <player.inventory.slot[<[pos]>].parse[quantity].sum.if_null[1]>

        #Check if player has enough items
        - if !<player.inventory.contains_item[<[matchable]>].quantity[<[quantity]>]>:
          - narrate "<&7>You don't have enough items to sell!" format:dShop_format
          - playsound <player> sound:block_note_block_bass
          - stop
        #Take item & give money
        - take item:<[matchable]> quantity:<[quantity]>
        - define gain <[quantity].mul[<[item].flag[price.sell]>]>
        - money give quantity:<[gain]>
        - narrate "<&7>You've sold <&e>x<[quantity]> <[item].display.if_null[<[item].material.translated_name>]> <&7>for <&a><[gain]><server.economy.currency_name[<[gain]>]><&7>." format:dShop_format
        - playsound <player> sound:entity_experience_orb_pickup
      - case buy:
        #Shift click case
        - define quantity <player.money.div[<[item].flag[price.buy]>].round_down> if:!<[quantity].exists>
        #Default to 1 (in case negative or 0 quantity)
        - define quantity 1 if:<[quantity].is_less_than[1]>
        - define price <[quantity].mul[<[item].flag[price.buy]>]>
        #Check if player has enough money
        - if <player.money> < <[price]>:
          - narrate "<&7>You don't have enough money!" format:dShop_format
          - playsound <player> sound:block_note_block_bass
          - stop
        #Check if item can fit in player's inventory
        - if !<player.inventory.can_fit[<[matchable]>].quantity[<[quantity]>]>:
          - narrate "<&7>Your inventory can't fit x<[quantity]> <[matchable]>!" format:dShop_format
          - playsound <player> sound:block_note_block_bass
          - stop
        #Give items & take money
        - give <[matchable]> quantity:<[quantity]>
        - money take quantity:<[price]>
        - narrate "<&7>You've bought <&e>x<[quantity]> <[item].display.if_null[<[item].material.translated_name>]> <&7>for <&a><[price]><server.economy.currency_name[<[price]>]><&7>." format:dShop_format
        - playsound <player> sound:entity_experience_orb_pickup
    #Update title
    - adjust <context.inventory> "title:<&e><[item].display.if_null[<[item].material.translated_name>]> <&7>| <&e>Bal: <&c><player.formatted_money>"
    - inventory open d:<context.inventory>

    #Cancel purchase handler
    after player clicks dShop_cancel_purchase in dShop_confirm_menu:
    - run dShop_paged_inventory def:<context.item.flag[page]>

#@Format
dShop_format:
  type: format
  debug: false
  format: <&e>dShops |<&r> <[text]>

#@Command
dShop_command:
  type: command
  name: shop
  debug: false
  usage: /shop
  description: Opens the shop menu
  permission: dshop.open
  permission message: <&c>No permission!
  script:
  #Stop if command isn't run by a player
  - if <context.source_type> != PLAYER:
    - debug error "dShop | This command can only be run by players!"
    - stop
  - narrate "<&c>Unused arguments: <&7><context.args.comma_separated>" format:dShop_format if:<context.args.any>
  - run dShop_paged_inventory
