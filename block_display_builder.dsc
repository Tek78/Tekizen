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
    - flag player origin:<player.flag[testthis].first.location>
    - modifyblock <[blocks]> air

    on rotatethis command flagged:testthis:
    #kind of got it???? at leaast a snippet (works with 20)
    - define angle <context.args.first||45>
    - define displays <player.flag[testthis]>
    - define origin <[displays].first.location.with_yaw[0].with_pitch[0]>

    - foreach <[displays]> as:display:
      - define pos <[origin].sub[<[display].location.round_down>]>
      - define loc <[origin].add[<location[<[pos].x>,0,<[pos].z>].rotate_around_y[<[angle].to_radians>]>]>

      - teleport <[display]> <[loc]>
      - adjust <[display]> left_rotation:<location[0,1,0].to_axis_angle_quaternion[<[angle].to_radians>]>
      - wait 1t