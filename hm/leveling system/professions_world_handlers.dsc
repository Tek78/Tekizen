hm_level_system_world_handler:
  type: world
  events:
    on entity death by:player:
    - define data <script[hm_level_system_data].data_key[professions.combat]>
    - if <context.entity.entity_type> !in <[data.allowed_mobs]>:
      - stop
    - define xp <[data.allowed_mobs.<context.entity.entity_type>]>
    - run hm_level_xp_handler def:<[xp]>|combat|true|<context.entity.location> player:<context.damager>

###################################################################### CUSTOM FISHING ######################################################################

    on player fishes item:
    #prevent double firing for click event listener
    - flag <player> prevent_fire expire:5t
    - determine cancelled passively

    #to be changed later (idk loot tables)
    - define item <context.item>
    - define loc <context.entity.location>
    #need to test this
    - adjust <context.hook> fish_hook_bite_time:1m
    - adjust <context.hook> fish_hook_apply_lure:false

    #the fishing box pop up
    - fakespawn "text_display[text=<&a><&l>Reel in your catch!;pivot=center;translation=0,-0.65,0]" <[loc].up[3.5]> duration:1m save:f
    - fakespawn dropped_item[item=<server.flag[qm_i]>] <[loc]> duration:infinite save:d
    - mount <entry[d].faked_entity>|<entry[f].faked_entity>

    #listener flag, text + n loops (need to change loops depending on rarity)
    - flag <player> f_mg
    - define text <entry[f].faked_entity.text>
    - define loops <util.random.int[2].to[4]>

    - repeat <[loops]>:
      #remove previous color + click for current loop
      - define color:!
      - define click <list[Left|Right].random>
      #add click text and duration they need to click within
      - adjust <entry[f].faked_entity> "text:<[text]><n><&7><[click]> Click"
      - define duration <util.random.decimal[0.85].to[1.25]>s
      - waituntil <player.has_flag[f_mg.click]> max:<[duration]>
      #define color
      - define click_value <player.flag[f_mg.click]||null>
      - if <[click_value]> == <[click]>:
        - define color <&a>
      - define color <&c> if:!<[color].exists>

      #adjust color and reset click status
      - adjust <entry[f].faked_entity> "text:<[text]><n><[color]><[click]> Click"
      - flag <player> f_mg.click:!
      - wait 0.3s
      #stop loop if they failed
      - repeat stop if:<[color].equals[<&c>]>

    #if they've succesfully reeled in
    - if <[color]> == <&a>:
      #showcase the item + success sound
      - adjust <entry[d].faked_entity> item:<[item]>
      - playsound <player> sound:entity_experience_orb_pickup volume:1.5

      #bubble particles
      - repeat 3 as:n:
        - playeffect effect:water_bubble at:<context.hook.location.points_around_y[radius=<[n].mul[0.75]>;points=<[n].add[10]>]> offset:0.1 quantity:2 visibility:100
        - wait 0.75t

      #replicate vanilla catch mechanic
      - drop <[item]> <[loc].up[3]> save:l
      - adjust <context.hook> fish_hook_hooked_entity:<entry[l].dropped_entity>
      - wait 5t
      - adjust <context.hook> fish_hook_pull
      - remove <context.hook>

      #spiral particles and xp (need to generate xp based on loot table)
      - foreach <entry[f].faked_entity.location.points_around_y[radius=1;points=15]> as:n:
        - playeffect effect:electric_spark at:<[n].up[<[loop_index].div[25]>]> visibility:100 quantity:2 offset:0
        - wait 0.1t
      - run hm_level_xp_handler def:<util.random.decimal[2.5].to[6]>|fishing|true|<[loc].up[0.5]>

    #if they failed to reel in
    - else:
      #remove hook + fail sound
      - remove <context.hook>
      - repeat 3 as:n:
        - playsound <player> sound:block_note_block_bass volume:3 pitch:<element[4].sub[<[n]>]>
        - wait 5t

    #remove pop up box + flag
    - fakespawn <entry[f].faked_entity> cancel
    - fakespawn <entry[d].faked_entity> cancel
    - flag <player> f_mg:!

    #click listener
    on player clicks block with:fishing_rod flagged:f_mg|!prevent_fire:
    - ratelimit <player> 1t
    - determine cancelled passively

    #click sound + store click value
    - playsound <player> sound:block_wooden_button_click_on pitch:3 volume:3 if:<player.fish_hook.is_truthy>
    - flag <player> f_mg.click:<context.click_type.before[_]>

##################################################################################################################################################################