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
  - define displays <server.flag[hb.groups.<[group]>]>
  - define locations <[displays].parse[location]>
  - define origin <location[<[locations].parse[x].average>,<[locations].parse[y].average>,<[locations].parse[z].average>].with_world[<[displays].first.world>].center>
  - define origin_vec <location[<[origin].xyz>]>

  - define dummy <[displays].first>
  - define q_x <location[1,0,0].to_axis_angle_quaternion[<[angle].to_radians>]>
  - define q_y <location[0,1,0].to_axis_angle_quaternion[<[angle].to_radians>]>
  - define q_z <location[0,0,1].to_axis_angle_quaternion[<[angle].to_radians>]>
  - define quat <[q_x].mul[<[q_y]>].mul[<[q_z]>].normalize>

  - foreach <[displays]> as:display:
    - define offset <location[<[display].location.xyz>].sub[<[origin_vec]>]>
    - define new_offset <[quat].transform[<[offset]>]>

    - teleport <[display]> <[origin].add[<[new_offset]>]>
    - adjust <[display]> left_rotation:<[display].left_rotation.mul[<[quat]>].normalize>


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