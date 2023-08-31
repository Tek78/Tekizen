#<locationtag.proc[grief_prevention_check]> <-- if the player owns/is trusted at that location
grief_prevention_check:
  type: procedure
  definitions: loc
  script:
  - define claim <[loc].griefprevention.claim||null>
  - determine true if:!<[claim].is_truthy>
  - if <[claim].owner> != <player>:
    - if <player> in <[claim].trusted>:
      - determine true
    - determine false

apply_task:
  type: task
  debug: false
  script:
  - define applied <context.item.flag[artifacts].keys.size||0>
  - if <[applied]> >= <script[artifact_data].data_key[settings.max_per_item]>:
    - narrate "<&7>You can't apply more artifacts to this item."
    - stop
  - define artifact <context.cursor_item.flag[artifact]>
  - if <context.item.has_flag[artifacts.<[artifact]>]>:
    - narrate "<&7>This item already has this artifact applied."
    - stop
  - define tools <script[artifact_data].data_key[artifacts.<[artifact]>.tools]>
  - if <[tools].filter_tag[<context.item.advanced_matches[<[filter_value]>|*_<[filter_value]>]>].is_empty>:
    - narrate "<&7>This artifact can't be applied to <&a><context.item.formatted.to_titlecase><&7>."
    - stop
  - define lore <script[artifact_data].parsed_key[artifacts.<[artifact]>.apply_lore]>
  - define lore <context.item.lore.if_null[<list>].insert[<[lore]>].at[1]>
  - take cursoritem
  - inventory adjust d:<context.clicked_inventory> slot:<context.slot> lore:<[lore]>
  - inventory flag d:<context.clicked_inventory> slot:<context.slot> artifacts.<[artifact]>

artifact_world:
  type: world
  events:

    #apply logic
    on player clicks vanilla_tagged:tools|trimmable_armor in inventory with:item_flagged:artifact:
    - determine cancelled passively
    - inject apply_task
    on player clicks bow|crossbow in inventory with:item_flagged:artifact:
    - determine cancelled passively
    - inject apply_task

    #equip + unequip flag handler
    after player equips item_flagged:artifacts:
    - foreach <context.new_item.flag[artifacts]>:
      - foreach next if:!<script[artifact_data].data_key[artifacts.<[key]>].contains[apply_flag]>
      - flag player artifacts.<[key]>
      - wait 1t
    after player unequips item_flagged:artifacts:
    - foreach <context.old_item.flag[artifacts]>:
      - foreach next if:!<script[artifact_data].data_key[artifacts.<[key]>].contains[apply_flag]>
      - flag player artifacts.<[key]>:! if:!<player.equipment.filter[has_flag[artifacts.<[key]>]].any>
      - wait 1t
    - flag player artifacts:! if:!<player.flag[artifacts].any||true>

    #telekinesis + auto smelt + experience handler
    on player breaks block with:item_flagged:artifacts:
    #stop if they have none of the below enchants
    - define enchants <list[auto_smelt|experience|telekinesis]>
    - if !<player.item_in_hand.flag[artifacts].keys.contains_any[<[enchants]>]>:
      - stop

    - define data <script[artifact_data].data_key[artifacts]>
    - define mat <context.material>

    #define the drops
    - if <player.item_in_hand.has_flag[artifacts.auto_smelt]> && <[data.auto_smelt.ores].keys> contains <[mat].name>:
      - define drops <[data.auto_smelt.ores.<[mat].name>]>
    - else:
      - define drops <context.location.drops[<player.item_in_hand>]>

    #experience handler
    - define xp <context.xp>
    - if <player.item_in_hand.has_flag[artifacts.experience]> && <[xp].is_truthy>:
      - define mul <[data.experience.multiplier]>
      - define xp <[xp].add[<[xp].mul[<[mul]>]>].round>
      - determine <[xp]> passively

    #drop handler
    - if <player.item_in_hand.has_flag[artifacts.telekinesis]>:
      - give <[drops]>
      - determine air
    - determine <[drops]>

    #replant handler
    after player breaks block with:item_flagged:artifacts.replant:
    - define data <script[artifact_data].data_key[artifacts]>
    - define mat <context.material>

    - if <[mat].name> in <[data.replant.crops].keys> && <[mat].age> == <[mat].maximum_age>:
      - define seed <[data.replant.crops.<[mat].name>]>
      - if <player.inventory.contains_item[<[seed]>]>:
        - take item:<[seed]>
        - modifyblock <context.location> <[mat].with[age=0]>

    #withering handler
    after entity damaged by player with:item_flagged:artifacts.withering:
    - stop if:!<context.entity.is_spawned>
    - define chance <script[artifact_data].data_key[artifacts.withering.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define duration <script[artifact_data].data_key[artifacts.withering.duration]>
    - cast wither duration:<[duration]> <context.entity>

    #allure handler
    after entity damaged by player with:item_flagged:artifacts.allure:
    - stop if:!<context.entity.is_spawned>
    - push <context.entity> origin:<context.entity.location> destination:<context.damager.location.forward[0.25]> speed:0.85

    #lightweight handler
    on player equips item_flagged:artifacts.lightweight:
    - cast slow_falling duration:infinite
    on player unequips item_flagged:artifacts.lightweight:
    - cast slow_falling remove

    #overload handler
    on player equips item_flagged:artifacts.overload:
    - define hearts <player.equipment.filter[has_flag[artifacts.overload]].size.mul[2].add[20]>
    - if <player.health_max> == <[hearts]>:
      - stop
    - adjust <player> max_health:<player.health_max.add[2]>
    on player unequips item_flagged:artifacts.overload:
    - adjust <player> max_health:<player.health_max.sub[2]>

    #reforged
    after player breaks held item_flagged:artifacts.reforged:
    - define lore <context.item.lore.exclude[<script[artifact_data].parsed_key[artifacts.reforged.lore]>]>
    - give item:<context.item.with_flag[artifacts.reforged:!].with[lore=<[lore]>;durability=0]> slot:hand

    on player steps on lava flagged:artifacts.lavawalker:
    - define blocks <context.new_location.find_blocks[lava].within[2]>
    - modifyblock <[blocks]> obsidian
    - wait 5s
    - modifyblock <[blocks]> lava

    #unforged
    on player item_flagged:artifacts.unforged takes damage:
    - define chance <script[artifact_data].data_key[artifacts.unforged.chance]>
    - determine cancelled if:<util.random_chance[<[chance]>]>

    #lifesteal
    after entity damaged by player with:item_flagged:artifacts.lifesteal:
    - if <player.health> == <player.health_max>:
      - stop
    - define chance <script[artifact_data].data_key[artifacts.lifesteal.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define heal <context.damage.div[2.5].round_down>
    - heal <[heal]> <player>

    #bleed
    after entity damaged by player with:item_flagged:artifacts.bleed:
    - stop if:!<context.entity.is_spawned>
    - define chance <script[artifact_data].data_key[artifacts.bleed.chance]>
    - stop if:!<util.random_chance[<[chance]>]>

    - define duration <script[artifact_data].data_key[artifacts.bleed.duration]>
    - flag <context.entity> bleeding expire:<[duration]>
    - while <context.entity.has_flag[bleeding]>:
      - stop if:!<context.entity.is_spawned>
      - playeffect at:<context.entity.location.above[1.2]> effect:RED_DUST special_data:1.4|red offset:0.25 quantity:5
      - hurt 0.35 <context.entity> source:<player>
      - wait 1s

    #lightning
    after player shoots item_flagged:artifacts.lightning:
    - define chance <script[artifact_data].data_key[artifacts.lightning.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - flag <context.projectile> lightning
    after entity_flagged:lightning hits:
    - if !<context.projectile.location.proc[grief_prevention_check]> player:<context.shooter>:
      - stop
    - strike <context.projectile.location>
    - remove <context.projectile>

    #explosion
    after player shoots item_flagged:artifacts.explosion:
    - define chance <script[artifact_data].data_key[artifacts.explosion.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - flag <context.projectile> explosion
    after entity_flagged:explosion hits:
    #add breakblock arg???
    - explode power:1.5 <context.projectile.location> fire source:<player>
    - remove <context.projectile>

    #scanner
    after player shoots item_flagged:artifacts.scanner:
    - flag <context.projectile> scanner
    after entity_flagged:scanner hits:
    - define range <script[artifact_data].data_key[artifacts.scanner.range]>
    - define entities <context.projectile.location.find.living_entities.within[<[range]>].filter[glowing.not]>
    - stop if:<[entities].is_empty>
    - define duration <script[artifact_data].data_key[artifacts.scanner.duration]>
    - cast glowing <[entities]> hide_particles duration:<[duration]>

    #slowness
    after entity damaged by player with:item_flagged:artifacts.slowness:
    - stop if:!<context.entity.is_spawned>
    - define chance <script[artifact_data].data_key[artifacts.slowness.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define duration <script[artifact_data].data_key[artifacts.slowness.duration]>
    - cast slow duration:<[duration]> <context.entity>

    #soulless
    on monster damaged by player with:item_flagged:artifacts.soulless:
    - define chance <script[artifact_data].data_key[artifacts.soulless.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define mul <script[artifact_data].data_key[artifacts.soulless.multiplier]>
    - determine <context.damage.mul[<[mul]>]> passively

    #hunter
    on animal damaged by player with:item_flagged:artifacts.hunter:
    - define chance <script[artifact_data].data_key[artifacts.hunter.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define mul <script[artifact_data].data_key[artifacts.hunter.multiplier]>
    - determine <context.damage.mul[<[mul]>]>

    #critical
    on entity damaged by player with:item_flagged:artifacts.critical:
    - define chance <script[artifact_data].data_key[artifacts.critical.chance]>
    - if !<util.random_chance[<[chance]>]>:
      - stop
    - define mul <script[artifact_data].data_key[artifacts.critical.multiplier]>
    - determine <context.damage.mul[<[mul]>]> passively

    #headhunter
    on entity dies by:player:
    - if <context.entity.entity_type> !in <script[artifact_data].data_key[artifacts.headhunter.mobs].keys>:
      - stop
    - stop if:!<context.damager.item_in_hand.has_flag[artifacts.headhunter]>
    - define chance <script[artifact_data].data_key[artifacts.headhunter.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define head <script[artifact_data].data_key[artifacts.headhunter.mobs.<context.entity.entity_type>].as[item]>
    - determine <context.drops.include[<[head]>]> if:!<context.drops.contains[<[head]>]>

    #regen
    after player damaged by monster flagged:artifacts.regen:
    - ratelimit <player> 1s
    - define chance <script[artifact_data].data_key[artifacts.regen.chance]>
    - if !<util.random_chance[<[chance]>]> || <player.health> == <player.health_max>:
      - stop
    - heal <script[artifact_data].data_key[artifacts.regen.heal]>

    #mitigation
    on player damaged by monster flagged:artifacts.mitigation:
    - ratelimit <player> 1s
    - define chance <script[artifact_data].data_key[artifacts.mitigation.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define mul <script[artifact_data].data_key[artifacts.mitigation.multiplier]>
    - determine <context.damage.mul[<[mul]>]>

    #anti knockback
    on monster knocks back player flagged:artifacts.anti_knockback:
    - ratelimit <player> 1s
    - define chance <script[artifact_data].data_key[artifacts.anti_knockback.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define mul <script[artifact_data].data_key[artifacts.anti_knockback.multiplier]>
    - determine <context.acceleration.mul[<[mul]>]>

    #knockback armor
    after player damaged by monster flagged:artifacts.knockback:
    - ratelimit <player> 1s
    - define chance <script[artifact_data].data_key[artifacts.knockback.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - shoot <context.damager> speed:0.75