#proc for tool apply lore
artifacts_tool:
  type: procedure
  definitions: tools
  script:
  - define lore "<&6>Applies to: <&e><[tools].separated_by[<&7>, <&e>].split_lines_by_width[100]>"
  - determine <[lore]>

apply_task:
  type: task
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
  - foreach <[tools]>:
    - if <context.item.advanced_matches[*<[value]>]>:
      - define match <[value]>
      - foreach stop
  - if !<[match].exists>:
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

    #telepathy + auto smelt handler
    on player breaks block with:item_flagged:artifacts:
    - ratelimit <player> 1t
    - if <player.item_in_hand.has_flag[artifacts.auto_smelt]>:
      - define drop <script[artifact_data].data_key[artifacts.auto_smelt.ores.<context.material.name>]||null>
    - if <[drop]||null> == null:
      - define drop <context.location.drops[<player.item_in_hand>]>
    - if <player.item_in_hand.has_flag[artifacts.telepathy]>:
      - give <[drop]>
      - determine NOTHING
    - determine <[drop]>

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

    #overlord handler
    on player equips item_flagged:artifacts.overlord:
    - adjust <player> max_health:<player.health_max.add[2]>
    on player unequips item_flagged:artifacts.overlord:
    - adjust <player> max_health:<player.health_max.sub[2]>

    #reforged
    after player breaks held item_flagged:artifacts.reforged:
    - define lore <context.item.lore.exclude[<script[artifact_data].parsed_key[artifacts.reforged.lore]>]>
    - give item:<context.item.with_flag[artifacts.reforged:!].with[lore=<[lore]>;durability=0]> slot:hand

    #lavawalker
    on player equips item_flagged:artifacts.lavawalker:
    - flag player lavawalk
    on player unequips item_flagged:artifacts.lavawalker:
    - flag player lavawalk:!
    on player steps on lava flagged:lavawalk:
    - define blocks <context.new_location.find_blocks[lava].within[2]>
    - modifyblock <[blocks]> obsidian
    - wait 5s
    - modifyblock <[blocks]> lava

    #unforged
    on player item_flagged:artifacts.unforged takes damage:
    - define chance <script[artifact_data].data_key[artifacts.unforged.chance]>
    - if <util.random_chance[<[chance]>]>:
      - determine cancelled

    #lifesteal
    on entity damaged by player with:item_flagged:artifacts.lifesteal:
    - if <player.health> == <player.health_max>:
      - stop
    - define chance <script[artifact_data].data_key[artifacts.lifesteal.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define heal <context.damage.div[2.5].round_down>
    - heal <[heal]> <player>

    #replant
    on player right clicks vanilla_tagged:crops with:item_flagged:artifacts.replant:
    - ratelimit <player> 1t
    - if <context.location.material.name> !in <script[artifact_data].data_key[artifacts.replant.crops].keys>:
      - stop
    - if <context.location.material.age> != <context.location.material.maximum_age>:
      - stop
    - define seed <script[artifact_data].data_key[artifacts.replant.crops.<context.location.material.name>]>
    - stop if:!<player.inventory.contains_item[<[seed]>]>
    - define drops <context.location.drops[<player.item_in_hand>]>
    - take item:<[seed]>
    - adjustblock <context.location> age:0
    - if <player.item_in_hand.has_flag[artifacts.telepathy]>:
      - give <[drops]>
      - stop
    - drop <[drops]> <context.location.above[0.35]>

    #bleed
    after entity damaged by player with:item_flagged:artifacts.bleed:
    - stop if:!<context.entity.is_spawned>
    - define chance <script[artifact_data].data_key[artifacts.bleed.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - flag <context.entity> bleeding expire:6s
    - while <context.entity.has_flag[bleeding]>:
      - stop if:!<context.entity.is_spawned>
      - playeffect at:<context.entity.location.above[1.2]> effect:RED_DUST special_data:1.4|red offset:0.25 quantity:8
      - hurt 0.25 <context.entity>
      - wait 1s

    #lightning
    on player shoots item_flagged:artifacts.lightning:
    - define chance <script[artifact_data].data_key[artifacts.lightning.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - flag <context.projectile> lightning
    after entity_flagged:lightning hits:
    - strike <context.projectile.location>
    - remove <context.projectile>

    #explosion
    on player shoots item_flagged:artifacts.explosion:
    - define chance <script[artifact_data].data_key[artifacts.explosion.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - flag <context.projectile> explosion
    after entity_flagged:explosion hits:
    - explode power:1.45 <context.projectile.location> fire breakblocks
    - remove <context.projectile>

    #scanner
    on player shoots item_flagged:artifacts.scanner:
    - flag <context.projectile> scanner
    on entity_flagged:scanner hits:
    - define range <script[artifact_data].data_key[artifacts.scanner.range]>
    - define entities <context.projectile.location.find.living_entities.within[<[range]>].filter[glowing.not]>
    - stop if:<[entities].is_empty>
    - define duration <script[artifact_data].data_key[artifacts.scanner.glow_duration]>
    - cast glowing <[entities]> hide_particles duration:<[duration]>

    #slowness
    after entity damaged by player with:item_flagged:artifacts.slowness:
    - stop if:!<context.entity.is_spawned>
    - define chance <script[artifact_data].data_key[artifacts.slowness.chance]>
    - stop if:!<util.random_chance[<[chance]>]>
    - define duration <script[artifact_data].data_key[artifacts.slowness.duration]>
    - cast slow duration:<[duration]> <context.entity>