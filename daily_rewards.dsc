##Daily Rewards
#Drop in both this script and the config script into your scripts folder and reload.
#Configurate your rewards and give your players the daily_rewards.use permission and you're ready to go.
#Can @ me (tek7_) on the Denizen Discord https://forum.denizenscript.com/ if you run into any problems/think of cool features to add onto this script :)

daily_rewards_menu:
  type: inventory
  inventory: chest
  size: 9
  gui: true
  debug: false
  title: <&e><&l>        Daily Rewards
  #Filler items
  definitions:
    1: white_stained_glass_pane[display=<&r>]
    2: black_stained_glass_pane[display=<&r>]
  slots:
  - [2] [1] [2] [] [] [] [2] [1] [2]

daily_rewards_generate_lore:
  type: procedure
  debug: false
  definitions: day
  script:
  #Rewards data
  - define rewards <script[daily_rewards_data].parsed_key[settings.rewards.<[day]>]>
  - define lore:->:<n><&a>Rewards<&co>
  - foreach <[rewards]> key:type as:reward:
    - if <[type]> == items:
      - define "lore:->: <&8><[type].to_titlecase><&co>"
      - foreach <[reward]> as:item:
        - define item <[item].as[item]>
        #Displays the item's display first, if none displays the item's translated name
        - define "lore:->: <&7>• <[item].display.if_null[<[item].material.translated_name>]> x<[item].quantity>"
    - else if <[type]> == money:
      #Display money reward
      - define "lore:->: <&8><[type].to_titlecase><&co> <&7><[reward]><server.economy.currency_name[<[reward]>]>"
    - else:
      #Skip if command rewards should be hidden from lore
      - foreach next if:<script[daily_rewards_data].data_key[settings.gui.hide_commands]>
      - define "lore:->: <&8><[type].to_titlecase><&co>"
      - foreach <[reward]> as:command:
        - define "lore:->: <&7>• /<[command]>"
  - determine <[lore]>

daily_rewards_set_items:
  type: task
  debug: false
  script:
  #Define all needed data
  - define inventory <inventory[daily_rewards_menu]>
  - define daily_data <script[daily_rewards_data].parsed_key[settings]>
  - define day <player.flag[daily_rewards.day]||1>

  #Generate item for previous (claimed) day (if any)
  - if <[daily_data.rewards].keys.find[<[day]>]> != <[daily_data.rewards].keys.first>:
    - define previous_day <item[<[daily_data.gui.item_previous_day]>]>
    - define previous_day <[previous_day].with_single[display=<&7>Day <[day].sub[1]> <&8>| <&a>Claimed]>
    - inventory set d:<[inventory]> slot:4 o:<[previous_day]>

  #Generate item for current day
  - define current_day <item[<[daily_data.gui.item_current_day]>]>
  #When the player doesn't have a claim cooldown
  - if !<player.has_flag[daily_rewards.claim_cooldown]>:
    - define current_day <[current_day].with_single[display=<&7>Day <[day]> <&8>| <&a>Click to claim]>
    #Flag for event listener
    - define current_day <[current_day].with_flag[daily_can_claim]>
  - else:
    #Preview claim cooldown
    - define timer <player.flag_expiration[daily_rewards.claim_cooldown].from_now.formatted>
    - define current_day <[current_day].with_single[display=<&7>Day <[day]> <&8>| <&a>Available in <&c><[timer]>]>
    - define current_day <[current_day]>
  - inventory set d:<[inventory]> slot:5 o:<[current_day].with_single[lore=<[day].proc[daily_rewards_generate_lore]>]>

  #Generate item for next day (if any)
  - if <[daily_data.rewards].keys.find[<[day]>]> != <[daily_data.rewards].keys.last>:
    - define next_day <item[<[daily_data.gui.item_next_day]>]>
    - define next_day <[next_day].with_single[display=<&7>Day <[day].add[1]> <&8>| <&c>Can't claim yet]>
  - inventory set d:<[inventory]> slot:6 o:<[next_day].with_single[lore=<[day].add[1].proc[daily_rewards_generate_lore]>]>

  #Open the inventory after setting all the items
  - inventory open d:<[inventory]>

daily_rewards_handlers:
  type: world
  debug: false
  events:
    #When the player claims a reward
    after player clicks item_flagged:daily_can_claim in daily_rewards_menu:
    #Define all data needed
    - define day <player.flag[daily_rewards.day]||1>
    - define daily_data <script[daily_rewards_data].parsed_key[settings]>
    - define rewards <[daily_data.rewards.<[day]>]>

    #Give the rewards
    - give <[rewards.items]> if:<[rewards.items].exists>
    - money give quantity:<[rewards.money]> if:<[rewards.money].exists>
    - if <[rewards.commands].exists>:
      - foreach <[rewards.commands]> as:command:
        - execute as_server <[command]>

    - inventory close
    - narrate "<&7>You've claimed your daily rewards! Current streak: <&a><[day]>"
    - narrate "<&7>You can claim your next reward in: <&a><duration[<[daily_data.claim_cooldown]>].formatted>"
    - playsound <player> sound:block_note_block_bell pitch:2

    #If the claimed reward is for the last day, reset their streak
    - if <[daily_data.rewards].keys.find[<[day]>]> == <[daily_data.rewards].keys.last>:
      - flag <player> daily_rewards.day:!
    - else:
      - flag <player> daily_rewards.day:<[day].add[1]> expire:<[daily_data.streak_expire]>
    #Apply the claim cooldown
    - flag <player> daily_rewards.claim_cooldown expire:<[daily_data.claim_cooldown].as[duration]>

    #Sound when they can't claim the reward
    after player clicks !air in daily_rewards_menu slot:4|5|6:
    - playsound <player> sound:block_note_block_bass pitch:2 if:!<context.item.has_flag[daily_can_claim]>

daily_rewards_command:
  type: command
  name: daily
  usage: /daily
  description: Opens the Daily Rewards menu.
  permission: daily_rewards.use
  permission message: <&c>No permission!
  script:
  #Stop if the command isn't being ran by a player
  - if <context.source_type> != PLAYER:
    - debug error "<&r>This command can only be run by players."
    - stop
  #Run the inventory task (player: argument to ensure that there's always a linked player)
  - run daily_rewards_set_items player:<player>

##Daily Rewards Config Script
daily_rewards_data:
  type: data
  debug: false
  settings:
    #How long before they can claim the next reward
    claim_cooldown: 24h
    #How long the streak lasts after claiming a reward
    streak_expire: 36h
    gui:
      #items representing previous, current and next day in the menu
      item_previous_day: glass_bottle
      item_current_day: experience_bottle
      item_next_day: dragon_breath
      #Set to false to not preview command rewards in the item lore
      hide_commands: false
    #The rewards for each day
    rewards:
      ##The rewards have to start at 1, and be in order (eg. 1, 2, 3 etc.)
      #You can list however many days you want (There can be 3, 30, even 300!)
      1:
        ##The rewards can be three types: Items, Money (requires Vault!) and Commands
        #You can list any valid itemtags in here, can be vanilla items, item scripts, a tag that returns an item etc.
        items:
        - iron_nugget[quantity=10]
        - cooked_porkchop[quantity=6]
        #Simply imput the amount of money you want to reward the player
        money: 75
        #List any commands you'd like to execute when the player claims the reward
        ##The commands are executed as the server
        commands:
        - give <player.name> diamond 5
      2:
        items:
        - gold_nugget[quantity=8]
        - shulker_box
      3:
        items:
        - iron_ingot[quantity=8]
        - diamond[quantity=2]
        - iron_shovel
        money: 100