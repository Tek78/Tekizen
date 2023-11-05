hm_level_system_world_handler:
  type: world
  events:
    on entity death by:player:
    - define data <script[hm_level_system_data].data_key[professions.combat]>
    - if <context.entity.entity_type> !in <[data.allowed_mobs]>:
      - stop
    - define xp <[data.allowed_mobs.<context.entity.entity_type>]>
    - run hm_level_xp_handler def:<[xp]>|combat|true|<context.entity.location> player:<context.damager>