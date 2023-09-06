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
    - flag server hb.groups.<[group]>:->:<entry[block].spawned_entity>
    - wait 1t

  - ~modifyblock <[blocks]> air no_physics
  - flag <player> holobuild.pos:!
  - narrate "<&7>Conversion finished! <&a><[blocks].size> <&7>blocks replaced under group name <&a><[group]>"

  destroy:
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  - foreach <server.flag[hb.groups.<[group]>]>:
    - remove <[value]>
  - flag server hb.groups.<[group]>:!
  - narrate "<&7>Group <&a><[group]> <&7>removed."

  revert:
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  - foreach <server.flag[hb.groups.<[group]>]>:
    - modifyblock <[value].flag[hb.original_location]> <[value].material> no_physics
    - remove <[value]>
    - wait 1t
  - flag server hb.groups.<[group]>:!
  - narrate "<&7>Group <&a><[group]> <&7>reverted and removed."

  rotate:
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  - define angle <context.args.get[3]||-361]>
  - if <[angle]> < -360 || <[angle]> > 360:
    - narrate "<&c>Error! <&7>Invalid angle specified."
    - stop

  - define axis <context.args.get[4]||y>
  - define displays <server.flag[hb.groups.<[group]>]>
  - define vectorized <[displays].parse[location].proc[rotate_locations].context[<[angle]>|<[axis]>]>
  - adjust <[displays]> interpolation_start:0
  - adjust <[displays]> interpolation_duration:10t

  - foreach <[displays]> as:display:
    - define rotation <[display].left_rotation.represented_angle.to_degrees.add[<[angle]>].to_radians>
    - define position <[vectorized].get[<[loop_index]>].with_world[<[display].world>]>

    - teleport <[display]> <[position]>
    - adjust <[display]> left_rotation:<location[<[axis].proc[left_rot]>].to_axis_angle_quaternion[<[rotation]>]>

  - narrate "<&7>Rotated group <&a><[group]> <&7>by <&a><[angle]> <&7>degrees."


##thank you krilliant :)
rotate_locations:
    type: procedure
    definitions: list|angle|axis
    debug: false
    script:
    - define list <[list].as[list]>
    - define centroid <location[<[list].parse[x].average>,<[list].parse[y].average>,<[list].parse[z].average>,<[list].first.world>]>
    - define list <[list].parse[sub[<[centroid]>]].parse_tag[<location[<[parse_value].xyz>]>]>
    - define list <[list].proc[rotate_axis].context[<[axis]>|<[angle]>]>
    - determine <[list].parse[add[<[centroid]>]]>

rotate_axis:
  type: procedure
  definitions: locations|axis|angle
  script:
  - if <[axis]> == x:
    - determine <[locations].parse[rotate_around_x[<[angle].to_radians>]]>
  - else if <[axis]> == z:
    - determine <[locations].parse[rotate_around_z[<[angle].to_radians>]]>
  - determine <[locations].parse[rotate_around_y[<[angle].to_radians>]]>

#absolutely ugly need to look into shit more i cannot stand to look at this
left_rot:
  type: procedure
  definitions: axis
  script:
  - if <[axis]> == x:
    - determine 1,0,0
  - if <[axis]> == z:
    - determine 0,0,1
  - determine 0,1,0