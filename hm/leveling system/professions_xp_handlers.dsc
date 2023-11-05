##Pop up xp base entity
pop_up_entity:
  type: entity
  entity_type: text_display
  mechanisms:
    pivot: vertical
    background_color: transparent
    text_shadowed: true
    interpolation_start: 0
    interpolation_duration: 1.5s

##Adds base stats for profession
hm_level_set_default:
  type: task
  debug: false
  script:
  - flag <player> hm.level_system.<[profession]>.xp.current:0
  - flag <player> hm.level_system.<[profession]>.xp.needed:<[settings_data.base_threshold]>
  - flag <player> hm.level_system.<[profession]>.xp.multiplier:0
  - flag <player> hm.level_system.<[profession]>.level:1

##Level and xp handling
hm_level_xp_handler:
  type: task
  definitions: xp|profession|apply_mul|location
  script:
  ##Add profession fallback
  - define settings_data <script[hm_level_system_data].data_key[professions.<[profession]||null>.settings]||null>
  #Invalid input handler
  - if <[settings_data]> == null:
    - debug error "Could not load config, did you provide a valid profession?"
    - stop
  - if !<[xp].is_decimal>:
    - debug error "Xp must be a decimal input."
    - stop
  - if !<[apply_mul].is_boolean>:
    - debug error "Must provide a boolean input for the third definition."
    - stop
  #Apply base stats if player doesn't have them
  - inject hm_level_set_default if:!<player.has_flag[hm.level_system.<[profession]>]>

  #level data
  - define level_data <player.flag[hm.level_system.<[profession]>]>
  #if applying mul is enabled
  - if <[apply_mul]>:
    # xp / 100 * mul%
    - define xp_% <[xp].div[100].mul[<[level_data.xp.multiplier]>]>
    #xp + xp_mul%
    - define xp <[xp].add[<[xp_%]>].round_to[2]>
  #current xp + xp to be added
  - define xp_new <[level_data.xp.current].add[<[xp]>].round_to[2]>

  #xp gain entity
  - if <[location].exists>:
    - if !<[location].as[location].is_truthy>:
      - debug error "Invalid location input."
      - stop
    #spawn entity with xp as text
    - fakespawn "pop_up_entity[text=<&e>+<[xp]> xp]" <[location].up> duration:1.5s save:pop_up
    #need to wait 3t to interpolate translation (internal thing)
    - wait 3t
    - adjust <entry[pop_up].faked_entity> translation:0,2,0

  # if the new xp reaches the level threshold
  - if <[xp_new]> >= <[level_data.xp.needed]>:
    #leftover xp after level up
    - define xp_left <[xp_new].sub[<[level_data.xp.needed]>].round_to[2]>
    - flag <player> hm.level_system.<[profession]>.level:++
    - narrate "<&9>[<&3><[profession].to_titlecase><&9>] <&7>You've leveled up to level <&9><player.flag[hm.level_system.<[profession]>.level]>"
    #set the xp left and add per level multiplier
    - flag <player> hm.level_system.<[profession]>.xp.current:<[xp_left]>
    - flag <player> hm.level_system.<[profession]>.xp.multiplier:+:<[settings_data.xp_percentage]>

    #define the new threshold (same way as xp multiplier)
    - define t_p <[settings_data.threshold_percentage]>
    - define % <[level_data.xp.needed].div[100].mul[<[t_p]>]>
    - define new_threshold <[level_data.xp.needed].add[<[%]>].round_to[2]>
    #apply new threshold
    - flag <player> hm.level_system.<[profession]>.xp.needed:<[new_threshold]>
    #if the xp left reaches the new level threshold
    - if <[xp_left]> >= <[new_threshold]>:
      #set the current xp to 0 and run the task again (without applying a level multiplier)
      - flag <player> hm.level_system.<[profession]>.xp.current:0
      - run hm_level_xp_handler def:<[xp_left]>|<[profession]>|false
    - stop

  #if xp doesn't reach threshold, add to current xp
  - flag <player> hm.level_system.<[profession]>.xp.current:+:<[xp]>

##Command and utilities
#Icecapade's script thingy
progressbar:
    type: procedure
    definitions: progressbar
    script:
    - if <[progressbar.currentValue]> > <[progressbar.maxValue]>:
        - debug error "<&[error]>currentValue may not be larger than maxValue."
        - stop
    - define percentage <[progressbar.currentValue].div[<[progressbar.maxValue]>]>
    - define progressBarProgress <[progressbar.size].mul[<[percentage]>]>
    - define progressBarEmpty <[progressbar.size].sub[<[progressBarProgress]>]>
    - define progressBar <[progressbar.color]><[progressbar.element].repeat[<[progressBarProgress]>]><[progressbar.barColor]><[progressbar.element].repeat[<[progressBarEmpty]>]>
    - determine <[progressBar]>

professions_command:
  type: command
  name: profession
  usage: /profession [profession name]
  description: Check profession information
  aliases:
  - professions
  - prof
  tab completions:
    1: <script[hm_level_system_data].data_key[professions].keys>
  script:
  - define profession <context.args.first||null>
  - if !<player.has_flag[hm.level_system.<[profession]>]>:
    - define settings_data <script[hm_level_system_data].data_key[professions.<[profession]>.settings]||null>
    - if <[settings_data]> == null:
      - narrate "<&[error]>Invalid profession specified!"
      - stop
    - inject hm_level_set_default
  - define profession_data <player.flag[hm.level_system.<[profession]>]>
  - definemap progress element:| color:<green> barColor:<gray> size:20 currentValue:<[profession_data.xp.current]> maxValue:<[profession_data.xp.needed]>

  - narrate "<&e>Information for profession <&6><[profession].to_titlecase><&7>:"
  - narrate "<&7>Current Level: <&a><[profession_data.level]>"
  - narrate "<&7>Xp Progress: <[progress].proc[progressbar]>"
  - narrate "<&7>Xp Multiplier: <&a><[profession_data.xp.multiplier]>%"

