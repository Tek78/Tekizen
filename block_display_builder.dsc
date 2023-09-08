#fuck around and find out kind of script
#actual blocks => block displays
##TODO:
#sub-commands => help, groups
#figure out the rotation messing up with multiple axis rotation (probably angle fuckery)

holobuild_command:
  type: command
  name: holobuild
  usage: /holobuild myargs
  aliases:
  - hb
  description: Holo Builds main command
  permission: holobuild.use
  permission message: <&c>Sorry!
  debug: false
  script:
  - define valid <list[pos|groups|convert|revert|rotate|destroy|help]>
  - if <context.args.first||null> !in <[valid]>:
    - inject <script> path:help
  - else:
    - inject <script> path:<context.args.first>

  help:
  - narrate later

  pos:
  - define pos <context.args.get[2]||null>
  - if <[pos]> !in 1|2:
    - narrate "<&c>Invalid argument! <&7>Valid: <&a>1<&7>, <&a>2<&7>."
    - stop

  - flag <player> holobuild.pos.<[pos]>:<player.location>
  - narrate "<&7>Position <&a><[pos]> <&7>set at <&a><player.location.simple>"

  convert:
  - define group <context.args.get[2]||null>
  - if !<[group].is_truthy> or <server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Unprovided or duplicate group name!"
    - stop

  - define positions <player.flag[holobuild.pos]||null>
  - if !<[positions].is_truthy> || <[positions].keys.size||1> < 2:
    - narrate "<&c>Error! <&7>You must select <&a>2 <&7>positions to do this!"
    - stop

  - define blocks <[positions.1].to_cuboid[<[positions.2]>].blocks.filter[advanced_matches[!air]]>
  - if !<[blocks].any>:
    - narrate "<&c>Error! <&7>There are no block in the selected area!"
    - stop

  - foreach <[blocks]> as:block:
    - spawn block_display[material=<[block].material>] <[block]> save:block
    - flag <entry[block].spawned_entity> hb.original_location:<[block]>
    - flag <entry[block].spawned_entity> hb.group:<[group]>
    - flag server hb.groups.<[group]>.entities:->:<entry[block].spawned_entity>
    - wait 1t

  #origin point for rotations
  - define locations <server.flag[hb.groups.<[group]>.entities].parse[location]>
  - define origin <location[<[locations].parse[x].average>,<[locations].parse[y].average>,<[locations].parse[z].average>].with_world[<player.world>].center>
  - flag server hb.groups.<[group]>.origin:<[origin]>

  - ~modifyblock <[blocks]> air no_physics
  - flag <player> holobuild.pos:!
  - narrate "<&7>Conversion finished! <&a><[blocks].size> <&7>blocks replaced under group name <&a><[group]>"

  destroy:
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  - foreach <server.flag[hb.groups.<[group]>.entities]>:
    - remove <[value]>
  - flag server hb.groups.<[group]>:!
  - narrate "<&7>Group <&a><[group]> <&7>removed."

  revert:
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  - foreach <server.flag[hb.groups.<[group]>.entities]>:
    - modifyblock <[value].flag[hb.original_location]> <[value].material> no_physics
    - remove <[value]>
    - wait 1t
  - flag server hb.groups.<[group]>:!
  - narrate "<&7>Group <&a><[group]> <&7>reverted and removed."

  rotate:
  #implement the rotation on only one axis at a time (wee)
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  - define angle <context.args.get[3]||-361]>
  - if <[angle]> < -360 || <[angle]> > 360:
    - narrate "<&c>Error! <&7>Invalid angle specified."
    - stop

  - define axis <context.args.get[4]||y>
  - define displays <server.flag[hb.groups.<[group]>.entities]>
  - define locations <[displays].parse[location]>
  - define origin <server.flag[hb.groups.<[group]>.origin]>
  - define origin_vector <location[<[origin].xyz>]>
  - define quat <location[<[axis].proc[left_rot]>].to_axis_angle_quaternion[<[angle].to_radians>].normalize>

  - foreach <[displays]> as:display:
    - define offset <[display].flag[display_offset].if_null[<location[<[display].location.xyz>].sub[<[origin_vector]>]>]>
    - define new_offset <[quat].transform[<[offset]>]>

    - teleport <[display]> <[origin].add[<[new_offset]>]>
    - define q_o <[display].left_rotation> if:!<[q_o].exists>
    - flag <[display]> display_offset:<[offset]>

  - define duration 40
  - repeat <[duration]> as:t:
    - define time <[t].div[<[duration]>]>
    - foreach <[displays]> as:display:
      - define offset <[display].flag[display_offset]>
      - define q_s <[q_o].slerp[end=<[quat].mul[<[q_o].normalize>]>;amount=<[time]>]>
      - define new_offset <[q_s].transform[<[offset]>]>
      - adjust <[display]> left_rotation:<[q_s]>
      - teleport <[display]> <[origin].add[<[new_offset]>]>
    - wait 0.1t

  - narrate "<&7>Rotated group <&a><[group]> <&7>by <&a><[angle]> <&7>degrees on the <&a><[axis]> <&7>axis."

left_rot:
  type: procedure
  definitions: axis
  script:
  - if <[axis]> == x:
    - determine 1,0,0
  - if <[axis]> == z:
    - determine 0,0,1
  - determine 0,1,0