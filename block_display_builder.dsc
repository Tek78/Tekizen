#fuck around and find out kind of script
#actual blocks => block displays

test_this_world:
  type: world
  events:
    on testthis command:
    - define blocks <player.location.find_blocks[!air|glass].within[7]>
    - flag <player> testthis:!
    - foreach <[blocks]> as:block:
      - spawn block_display[material=<[block].material>] <[block]> save:block
      - flag <player> testthis:->:<entry[block].spawned_entity>
      - wait 1t
    - modifyblock <[blocks]> air
    - narrate "<&a>Conversion finished! <&e><player.flag[testthis].size> <&7>blocks replaced in <&e><queue.time_ran.in_milliseconds.round_to[2]><&7>ms..."

    on rotatethis command flagged:testthis:
    #kind of got it???? at leaast a snippet (works with 20)
    - define angle <context.args.first||45>
    - define displays <player.flag[testthis]>

    - define vectorized <[displays].parse[location].proc[rotate_list_around_y].context[<[angle]>]>
    - foreach <[displays]> as:display:
      - define rotation <[display].left_rotation.represented_angle.to_degrees.add[<[angle]>].to_radians>
      - teleport <[display]> <[vectorized].get[<[loop_index]>]>,<[display].world.name>
      - adjust <[display]> left_rotation:<location[0,1,0].to_axis_angle_quaternion[<[rotation]>]>
      - wait 1t

    - narrate "<&a>Finished! <&7>Rotated build by <&e><[angle]> <&7>degrees in <&e><queue.time_ran.in_milliseconds.round_to[2]><&7>ms..."

rotate_list_around_y:
    type: procedure
    definitions: list|angle
    debug: false
    script:
    - define list <[list].as[list]>
    - define centroid <location[<[list].parse[x].average>,<[list].parse[y].average>,<[list].parse[z].average>,<[list].first.world>]>
    - define list <[list].parse[sub[<[centroid]>]].parse_tag[<location[<[parse_value].xyz>]>]>
    - define list <[list].parse[rotate_around_y[<[angle].to_radians>]]>
    - determine <[list].parse[add[<[centroid]>]]>