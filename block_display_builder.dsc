#fuck around and find out kind of script
#actual blocks => block displays
##TODO:
#test chunkload crap when reverting
#groups sub command
#teleporting groups (kill me)

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
  - narrate "<&a>/hb pos 1<&7>/<&a>2 <&7> - select positions."
  ##TO DO!!!
  - narrate "<&a>/hb groups <&7>- list all groups, click on group name to teleport."
  - narrate "<&a>/hb convert groupname <&7>- convert a selected area."
  - narrate "<&a>/hb revert groupname <&7>- revert a group to its original state."
  - narrate "<&a>/hb destroy groupname <&7>- destroy a holographic build."
  - narrate "<&a>/hb rotate groupname angle axis <&7>- rotate a group around an axis, default axis is <&a>y<&7>."
  - narrate "<&a>/hb help <&7>- open this page."

  pos:
  #valid pose check
  - define pos <context.args.get[2]||null>
  - if <[pos]> !in 1|2:
    - narrate "<&c>Invalid argument! <&7>Valid: <&a>1<&7>, <&a>2<&7>."
    - stop

  - flag <player> holobuild.pos.<[pos]>:<player.location>
  - narrate "<&7>Position <&a><[pos]> <&7>set at <&a><player.location.simple>"

  convert:
  #valid group name check
  - define group <context.args.get[2]||null>
  - if !<[group].is_truthy> or <server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Unprovided or duplicate group name!"
    - stop

  #make sure they've selected 2 positions
  - define positions <player.flag[holobuild.pos]||null>
  - if !<[positions].is_truthy> || <[positions].keys.size||1> < 2:
    - narrate "<&c>Error! <&7>You must select <&a>2 <&7>positions to do this!"
    - stop

  #define all blocks that are not air
  - define blocks <[positions.1].to_cuboid[<[positions.2]>].blocks.filter[advanced_matches[!*air]]>
  #stop if no solid blocks
  - if !<[blocks].any>:
    - narrate "<&c>Error! <&7>There are no block in the selected area!"
    - stop

  #pivot point
  - define origin <location[<[blocks].parse[x].average>,<[blocks].parse[y].average>,<[blocks].parse[z].average>].with_world[<player.world>].center>

  - foreach <[blocks]> as:block:
    - spawn block_display[material=<[block].material>] <[block]> save:block
    #original location to revert to
    - flag <entry[block].spawned_entity> hb.original_location:<[block]>
    - flag <entry[block].spawned_entity> hb.group:<[group]>
    - flag server hb.groups.<[group]>.entities:->:<entry[block].spawned_entity>
    - wait 0.1t

  - flag server hb.groups.<[group]>.origin:<[origin]>

  #remove the actual blocks and selected positions
  - ~modifyblock <[blocks]> air no_physics
  - flag <player> holobuild.pos:!
  - narrate "<&7>Conversion finished! <&a><[blocks].size> <&7>blocks replaced under group name <&a><[group]>"

  destroy:
  #confirmation
  - if !<player.has_flag[hb_confirm_destroy]>:
    - narrate "<&c><&l>WARNING! <&7>This will destroy the holographic build, if you want to revert the actual blocks, use <&a>/hb revert<&7>!"
    - narrate "<&7>You have <&a>30<&7>s to repeat the command and confirm."
    - flag <player> hb_confirm_destroy expire:30s
    - stop
  - flag <player> hb_confirm_destroy:!

  #valid group check
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  #remove data and entities
  - remove <server.flag[hb.groups.<[group]>.entities]>
  - flag server hb.groups.<[group]>:!
  - narrate "<&7>Group <&a><[group]> <&7>removed."

  revert:
  #valid group check
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  - foreach <server.flag[hb.groups.<[group]>.entities]> as:display:
    #load chunk if unloaded
    ##NEED TO TEST!!
    - chunkload <[display].location.chunk> duration:1s if:!<[display].location.chunk.is_loaded>
    - modifyblock <[display].flag[hb.original_location]> <[display].material> no_physics
    - remove <[display]>
    - wait 0.1t
  - flag server hb.groups.<[group]>:!
  - narrate "<&7>Group <&a><[group]> <&7>reverted and removed."

  rotate:
  #make sure group is provided and valid
  - define group <context.args.get[2]||null>
  - if !<server.flag[hb.groups.<[group]>].exists>:
    - narrate "<&c>Error! <&7>Group doesn't exist!"
    - stop

  #all display entities
  - define displays <server.flag[hb.groups.<[group]>.entities]>

  - define angle <context.args.get[3]||null]>
  #if angle isn't an integer, check if they're resetting the roation
  - if !<[angle].is_integer>:
    - if <[angle]> == reset:
      - foreach <[displays]> as:display:
        - teleport <[display]> <[display].flag[hb.original_location]>
      - adjust <[displays]> left_rotation:<quaternion[identity]>
      - narrate "<&7>Rotation reset to default for group <&a><[group]>"
      - stop
    - narrate "<&c>Error! <&7>Invalid angle specified, must be an integer!"
    - stop

  #valid axis check
  - define axis <context.args.get[4]||y>
  - if <[axis]> !in x|y|z:
    - narrate "<&c>Error! <&7>Invalid axis specified, must be: <&a>x<&7>, <&a>y <&7>or <&a>z<&7>!"
    - stop

  #pivot point and vector
  - define origin <server.flag[hb.groups.<[group]>.origin]>
  - define origin_vector <location[<[origin].xyz>]>
  #new rotation
  - define quat <location[<[axis].proc[left_rot]>].to_axis_angle_quaternion[<[angle].to_radians>].normalize>

  - foreach <[displays]> as:display:
    - define offset <[display].flag[display_offset].if_null[<location[<[display].location.xyz>].sub[<[origin_vector]>]>]>
    - define new_offset <[quat].transform[<[offset]>]>

    - teleport <[display]> <[origin].add[<[new_offset]>]>
    #define the old rotation
    - define q_o <[display].left_rotation> if:!<[q_o].exists>
    #save the original offset for later use
    - flag <[display]> display_offset:<[offset]>

  #rotation duration
  - define duration 40
  - repeat <[duration]> as:t:
    - define time <[t].div[<[duration]>]>
    - foreach <[displays]> as:display:
      - define offset <[display].flag[display_offset]>
      #slerped quat starting and old, ending at new x old
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