#command [queues you up] => queue listener task [checks available arenas and number of queued players] => team assembly task [assembles the teams, dequeues and teleports to arena]

hm_queue_command:
  type: command
  name: queue
  debug: true
  usage: /queue [game]
  description: Queues you up for a game
  tab completions:
    1: dodgeball
  script:
  - define game <context.args.first||null>
  - if <[game]> != dodgeball:
    - narrate "<&[error]>That's not a valid gamemode."
    - stop

  - if <player.has_flag[queued]>:
    - narrate "<&[error]>You're already queued!"
    - stop

  - if <player.has_flag[party]>:
    - define party <player.flag[party.name]>
    - if <server.flag[hm_parties.<[party]>.owner]> != <player>:
      - narrate "<&[error]>You're not your party's owner."
      - stop
    - define to_queue <server.flag[hm_parties.<[party]>.members]>

  - flag <[to_queue]||<player>> queued.<[game]>:<util.time_now>
  - narrate "<&[emphasis]>You've queued up for <[game].to_titlecase>." targets:<[to_queue]||<player>>

  ##need to keep track of available arenas, listen to games when they end
  - run queue_listener def:<[game]>

hm_dequeue_command:
  type: command
  name: dequeue
  debug: true
  usage: /dequeue
  description: Dequeues you from a game
  script:
  - if !<player.has_flag[queued]>:
    - narrate "<&[error]>You're not queued for a game."
    - stop

  - if <player.has_flag[party]>:
    - define party <player.flag[party.name]>
    - if <server.flag[hm_parties.<[party]>.owner]> != <player>:
      - narrate "<&[error]>You're not your party's owner."
      - stop
    - define to_dequeue <server.flag[hm_parties.<[party]>.members]>

  - flag <[to_dequeue]||<player>> queued:!
  - narrate "<&[emphasis]>You've been removed from the queue." targets:<[to_dequeue]||<player>>

queue_listener:
  type: task
  definitions: game
  script:
  - define arenas <server.flag[hm.<[game]>.available_arenas]||<list>>
  - define queued <server.online_players_flagged[queued.<[game]>]>

  - if !<[arenas].is_truthy> || <[queued].size> < 6:
    - stop

  - run queue_team_game_handler def:<[game]>|<[arenas].first>|<[queued]>

queue_team_game_handler:
  type: task
  definitions: game|arena|queued
  debug: true
  script:
  - define team_1 <list>
  - define team_2 <list>

  #need to test this
  - foreach <[queued]> as:p:

    - define combine <[team_1].include[<[team_2]>]>
    #stop if limit reached or player already in team
    - if <[combine].size> == 6:
      - foreach stop
    - foreach next if:<[combine].contains[<[p]>]>

    - if <[p].has_flag[party]>:
      - define party <[p].flag[party.name]>
      - define members <server.flag[hm_parties.<[party]>.members]>
    - else:
      - define members:->:<[p]>

    - definemap teams team_1:<[team_1]> team_2:<[team_2]>
    - foreach <[teams]> key:team:
      #if looped team size + member(s) count is less or = to 3
      - if <[value].size.add[<[members].size>]> <= 3:
        #add members to the looped team
        - define <[team]>:|:<[members]>
        #stop team foreach
        - foreach stop
    - define members:!

  - define combined <[team_1].include[<[team_2]>]>
  - if <[combined].size> < 6:
    - stop
  - flag <[combined]> queued:!

  - title "title: <&f><&l><[game].to_titlecase> Match Found..." targets:<[combined]> stay:2s
  - wait 3s
  ##available arena code needed in queue_listener task
  - foreach <[combined]> as:p:
    - define n <[loop_index].is_less_than[3].if_true[1].if_false[2]>

    - teleport <[p]> <server.flag[hm.dodgeball.<[arena]>.playerspawn<[loop_index]>]>
    - adjust <[p]> bed_spawn_location:<server.flag[hm.dodgeball.<[arena]>.respawn<[n]>]>
    - adjust <[p]> gamemode:adventrue

  ##mark the arena as busy here
  ##placeholders for now
  - flag server hm.dodgeball.available_arenas:<-:<[arena]>

hm_queue_timer:
  type: world
  debug: false
  events:
    on delta time secondly priority:-5:
    - foreach <server.online_players_flagged[queued]> as:__player:
      - define game <player.flag[queued].keys.first>
      ##??? idk what dis
      - flag <player> hm.minigames.dodgeball.charge:!
      - actionbar "<&9><&l>[  <&f><&l><[game].to_titlecase>    <&a><player.flag[queued.<[game]>].from_now.formatted><&9><&l>  ]"

    on player quit flagged:queued:
    - if <player.has_flag[party]>:
      - define party <player.flag[party.name]>
      - define members <server.flag[hm_parties.<[party]>.members]>
      - flag <[members]> queued:!
      - narrate "<&[emphasis]>Your whole party has been dequeued due to <player.name> disconnecting."
      - stop
    - flag <player> queued:!