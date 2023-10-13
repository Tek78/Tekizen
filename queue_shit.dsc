##Needs testing => just rewrite and cleanup from looking at old code
#old code => https://paste.denizenscript.com/View/116411

#not fully tested
p_tab_complete:
    type: procedure
    definitions: first_arg
    debug: false
    script:

    - define party <player.flag[party]||null>
    - define is_owner <server.flag[hm_parties.<[party]>.owner].if_null[null].equals[<player>]>

    - choose <[first_arg]>:
      - case invite:
        - if !<[party].is_truthy> || !<[is_owner]>:
          - determine <empty>
        - determine <server.online_players_flagged[!party].parse[name]>

      - case kick:
        - if !<[party].is_truthy> || !<[is_owner]>:
          - determine <empty>
        - determine <server.flag[hm_parties.<[party]>.members].exclude[<player>].parse[name]>

      - case info:
        - determine <server.flag[hm_parties].keys||<empty>>

      - default:
        - determine <empty>

#just copy pasted
trim_alphanumeric:
    type: procedure
    definitions: def
    debug: false
    script:
    - determine <[def].trim_to_character_set[AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz123456789_-<&sq><&dq> ]>

p_command:
  type: command
  name: party
  description: Manages parties.
  usage: /party create <&lt>name<&gt> | disband | leave | invite <&lt>player<&gt> | kick <&lt>player<&gt> | chat | info (name)
  permission: hm.party
  aliases:
  - p
  #i left out the data thing cus?? idk brain isnt braining
  tab completions:
    1: create|disband|leave|invite|kick|chat|info
    2: <context.args.first.proc[p_tab_complete]>
  #disable later
  debug: true
  #tested
  script:
  - if <context.source_type> != player:
    - narrate "<&[error]>This command can only be run by players!"
    - stop

  - define valid <script.data_key[tab completions.1]>
  - if <context.args.first||null> !in <[valid]>:
    - narrate <&[error]>Invalid<&sp>usage!
    - narrate <&[base]><script.parsed_key[usage]>
    - stop
  - inject <script> path:<context.args.first>

  #tested
  create:
  - if <player.has_flag[party]>:
    - narrate "<&[error]>You're already in a party!"
    - stop
  - if <context.args.size> > 2:
    - narrate "<&[error]>Too many arguments! Did you forget <&7><&dq><&[error]>quotes<&7><&dq> <&[error]>around your party's name?"
    - stop
  - define party <context.args.get[2].if_null[<player.name><&sq>s<&sp>Party].proc[trim_alphanumeric]>
  - if <server.has_flag[hm_parties.<[party]>]>:
    - narrate "<&[error]>This party already exists!"
    - stop

  - flag server hm_parties.<[party]>.owner:<player>
  - flag server hm_parties.<[party]>.members:->:<player>
  - flag server hm_parties.<[party]>.creation:<util.time_now>
  - flag <player> party:<[party]>
  - narrate "<&[emphasis]>The party <&dq><[party]><&dq> has been created!"