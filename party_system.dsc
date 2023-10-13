##Needs testing => just rewrite and cleanup from looking at old code
#old code => https://paste.denizenscript.com/View/116411

##to do when rewrite fully (fancy stuff not needed really):
#option to just toggle /p chat and type in normally
#a /p list command to list parties (can be clickable and pull up /p info for each)
#spaces can be used instead of "" around everything? seems more practical (at least from a player's perspective)

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
  data:
    define_party:
    - define party <player.flag[party]>
    - if !<server.has_flag[hm_parties.<[party]>]>:
      - narrate "<&4>Uh Oh! Your party doesn't exist! This shouldn't happen.. Contact developers."
      - stop
    - define is_owner <server.flag[hm_parties.<[party]>.owner].equals[<player>]>

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

  #tested (solo)
  disband:
  - if !<player.has_flag[party]>:
    - narrate "<&[error]>You're not in a party!"
    - stop
  - if <context.args.size> != 1:
    - narrate "<&[error]>Invalid usage!"
    - narrate "<&[error]>Usage<&co> /party disband"
    - stop
  - inject <script> path:data.define_party

  - if !<[is_owner]>:
    - narrate "<&[error]>You're not your party's owner!"
    - stop
  - narrate targets:<server.flag[hm_parties.<[party]>.members]> "<&[warning]>The party has been disbanded."
  - flag <server.flag[hm_parties.<[party]>.members]> party:!
  - flag server hm_parties.<[party]>:!

  #tested (solo)
  chat:
  - if !<player.has_flag[party]>:
    - narrate "<&[error]>You're not in a party!"
    - stop
  - if <context.args.size> == 1:
    - narrate "<&[error]>Your message cannot be empty!"
    - stop
  - inject <script> path:data.define_party
  - narrate <context.raw_args.after[<context.args.first>]> format:party_chat_format targets:<server.flag[hm_parties.<[party]>.members]>

  #tested (solo)
  info:
  - if !<player.has_flag[party]>:
    - narrate "<&[error]>You're not in a party!"
    - stop
  - if <context.args.size> > 2:
    - narrate "<&[error]>Too many arguments! Did you forget <&7><&dq><&[error]>quotes<&7><&dq> <&[error]>around your party's name?"
    - stop

  - define party <context.args.get[2]||<player.flag[party]>>
  - if !<server.has_flag[hm_parties.<[party]>]>:
    - narrate "<&[error]>This party doesn't exist!"
    - stop

  - define p_data <server.flag[hm_parties.<[party]>]>
  - narrate "<&7><&m><&sp.repeat[12]>[<&f> <[party]> <&7><&m>]<&sp.repeat[12]>"
  - narrate "<&7>Leader<&co> <&f><[p_data.owner].name>"
  - narrate "<&7>Members<&co> <&f><[p_data.members].size.on_hover[<[p_data.members].parse[name].separated_by[<n>]>]>"

  #tested (solo)
  leave:
  - if !<player.has_flag[party]>:
    - narrate "<&[error]>You're not in a party!"
    - stop
  - inject <script> path:data.define_party
  - define members <server.flag[hm_parties.<[party]>.members]>

  - if <[is_owner]>:
    - narrate targets:<[members]> "<&[warning]>The party has been disbanded."
    - flag <[members]> party:!
    - flag server hm_parties.<[party]>:!
    - stop
  - flag <player> party:!
  - narrate "<&[warning]><player.name> has left the party." targets:<[members]>
  - narrate "<&[warning]>You have left the party."
  - flag server hm_parties.<[party]>.members:<-:<player>

  #untested
  kick:
  - if !<player.has_flag[party]>:
    - narrate "<&[error]>You're not in a party!"
    - stop
  - inject <script> path:data.define_party
  - if !<[is_owner]>:
    - narrate "<&[error]>You're not the party's owner!"
    - stop
  - if <context.args.size> > 2:
    - narrate "<&[error]>Too many arguments!"
    - narrate "<&[error]>Usage<&co> /party kick <&lt>player<&gt>"
    - stop

  - define target <server.match_player[<context.args.get[2]>]||null>
  - if !<[target].is_truthy>:
    - narrate "<&[error]>Player not found! Are you sure you typed their name correctly?"
    - stop
  - if <[target]> == <player>:
    - narrate "<&[error]>You cannot kick yourself from the party!"
    - narrate "<&[error]>Consider <&dq>/party disband<&dq> instead."
    - stop

  - flag <[target]> party:!
  - flag server hm_parties.<[party]>.members:<-:<[target]>
  - narrate targets:<server.flag[hm_parties.<[party]>.members]> "<&[warning]><[target].name> has been kicked from the party."
  - narrate targets:<[target]> "<&c>You have been kicked from the party."

party_chat_format:
    type: format
    debug: false
    format: <&7><&l>[<&f><player.flag[party]><&7><&l>] <&f><player.name><&co><[text]>