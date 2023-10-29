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

  - if <player.flag[queued]||null> == <[game]>:
    - narrate "<&[error]>You're already queued for this game."
    - stop

  - if <player.has_flag[party]>:
    - define party <player.flag[party.name]>
    - if <server.flag[hm_parties.<[party]>.owner]> != <player>:
      - narrate "<&[error]>You're not your party's owner."
      - stop
    - define to_queue <server.flag[hm_parties.<[party]>.members]>
  - define to_queue <player> if:!<[to_queue].exists>

  - flag <[to_queue]> queued:<[game]>
  - narrate "<&[emphasis]>You've queued up for <[game]>." targets:<[to_queue]>

  ##need to keep track of available arenas, listen to games when they end
  - run queue_listener def:<[game]>

queue_team_game_handler:
  type: task
  definitions: game|arena
  debug: true
  script:
  - define queued <server.online_players_flagged[queued.<[game]>]>
  - define team_1 <list>
  - define team_2 <list>

  #baked asf rn need to check if this works
  - foreach <[queued]> as:p:

    - if <[team_1].include[<[team_2]>].size> == 6:
      - foreach stop

    - if <[p].has_flag[party]>:
      - define party <[p].flag[party.name]>
      - define members:|:<server.flag[hm_parties.<[party]>.members]>
    - else:
      - define members:->:<[p]>

    - foreach <[team_1]>|<[team_2]> as:team:
      - if <[team].size.add[<[members].size>]> <= 3:
        - define team_<[loop_index]>:|:<[members].filter[is_in[<[team_<[loop_index]>]>].not]>
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
      - if <[loop_index]> < 3:
        - define n 1
      - else:
        - define n 2

      - teleport <[p]> <server.flag[hm.dodgeball.<[arena]>.playerspawn<[loop_index]>]>
      - adjust <[p]> bed_spawn_location:<server.flag[hm.dodgeball.<[arena]>.respawn<[n]>]>

    ##mark the arena as busy here