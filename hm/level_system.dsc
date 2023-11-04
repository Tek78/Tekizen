hm_level_system_data:
  type: data
  settings:
    #the xp it'd take to go from lvl 1 to lvl 2
    base_threshold: 20
    #how much the threshold increases with each level (in %)
    threshold_percentage: 12.5
    #how much the xp intake increaces with each level (in %)
    xp_percentage: 0.1
  professions:
    combat:
      allowed_mobs:
        zombie: 3
        skeleton: 3
        creeper: 3
        cow: 1
        pig: 1
        chicken: 1
        wither: 7.5

hm_level_system_world_handler:
  type: world
  events:
    on entity death by:player:
    - define data <script[hm_level_system_data].data_key[professions.combat]>
    - if <context.entity.entity_type> !in <[data.allowed_mobs]>:
      - stop
    - define xp <[data.allowed_mobs.<context.entity.entity_type>]>
    - run hm_level_xp_handler def:<[xp]>|combat player:<context.damager>

hm_level_set_default:
  type: task
  script:
  - define settings_data <script[hm_level_system_data].data_key[settings]>

  - flag <player> hm.level_system.<[profession]>.xp.current:0
  - flag <player> hm.level_system.<[profession]>.xp.needed:<[settings_data.base_threshold]>
  - flag <player> hm.level_system.<[profession]>.xp.multiplier:0
  - flag <player> hm.level_system.<[profession]>.level:1

hm_level_xp_handler:
  type: task
  definitions: xp|profession
  script:
  - inject hm_level_set_default if:!<player.has_flag[hm.level_system.<[profession]>]>

  - define level_data <player.flag[hm.level_system.<[profession]>]>
  - define settings_data <script[hm_level_system_data].data_key[settings]>

  - define xp_% <[xp].div[100].mul[<[level_data.xp.multiplier]>]>
  - define xp <[xp].add[<[xp_%]>].round_to[2]>
  - define xp_new <[level_data.xp.current].add[<[xp]>].round_to[2]>

  - if <[xp_new]> >= <[level_data.xp.needed]>:
    - define xp_left <[xp_new].sub[<[level_data.xp.needed]>].round_to[2]>
    - flag <player> hm.level_system.<[profession]>.level:++
    - flag <player> hm.level_system.<[profession]>.xp.current:<[xp_left]>
    - flag <player> hm.level_system.<[profession]>.xp.multiplier:+:<[settings_data.xp_percentage]>

    - define t_p <[settings_data.threshold_percentage]>
    - define % <[level_data.xp.needed].div[100].mul[<[t_p]>]>
    - define new_threshold <[level_data.xp.needed].add[<[%]>].round_to[2]>
    - flag <player> hm.level_system.<[profession]>.xp.needed:<[new_threshold]>
    - stop

  - flag <player> hm.level_system.<[profession]>.xp.current:+:<[xp]>