##Needs testing => just rewrite and cleanup from looking at old code
#old code => https://paste.denizenscript.com/View/116411

##changed
#storing uuid -> storing object
#no need for "" around name if it contains spaces (feel like it's more convinient for players)
#general cleanup
#p chat is also toggleable

##cool addons?:
#a /p list command to list parties (can be clickable and pull up /p info for each)

#not fully tested
p_tab_complete:
    type: procedure
    definitions: first_arg
    debug: false
    script:

    - define party <player.flag[party.name]||null>
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
    - define party <player.flag[party.name]||null>
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
  - if <context.args.size> < 2:
    - define party <player.name><&sq>s<&sp>Party
  - else:
    - define party <context.raw_args.after[create ]>

  - if <[party]> == null:
    - narrate "<&[error]>Party name cannot be null!"
    - stop
  - run p_create def:<[party]>

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

  - if <context.args.get[2]||null> == null:
    - if !<player.has_flag[party.chat]>:
      - flag <player> party.chat
      - narrate "<&[emphasis]>Party chat enabled."
      - stop
    - flag <player> party.chat:!
    - narrate "<&[emphasis]>Party chat disabled."
    - stop
  - inject <script> path:data.define_party
  - narrate <context.raw_args.after[<context.args.first>]> format:party_chat_format targets:<server.flag[hm_parties.<[party]>.members]>

  #tested (solo)
  info:
  - if <context.args.size> < 2:
    - if <player.has_flag[party]>:
      - define party <player.flag[party.name]>
    - else:
      - narrate "<&[error]>Too few arguments! You must provide a party name."
      - stop

  - define party <context.raw_args.after[info ]> if:!<[party].exists>
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

  - define target <server.match_player[<context.args.get[2]||null>]||null>
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

  invite:
  - if <context.args.size> > 2:
    - narrate "<&[error]>Too many arguments!"
    - narrate "<&[error]>Usage<&co> /party invite <&lt>player<&gt>"
    - stop
  - define target <server.match_player[<context.args.get[2]||null>]||null>
  - if !<[target].is_truthy>:
    - narrate "<&[error]>Player not found! Are you sure you typed their name correctly?"
    - stop
  - if <[target]> == <player>:
    - narrate "<&[error]>You can't invite yourself!"
    - stop
  - if <[target].has_flag[party]>:
    - narrate "<&[error]>This player is already in a party!"
    - stop

  - if !<player.has_flag[party]>:
    - define name <player.name><&sq>s<&sp>Party
    - run p_create def:<[name]>
  - inject <script> path:data.define_party

  - if !<[is_owner]>:
    - narrate "<&[error]>You're not your party's owner!"
    - stop
  - if <server.flag[hm_parties.<[party]>.members].size> == 3:
    - narrate "<&[error]>Your party is full!"
    - stop
  - if <player.has_flag[party_invites.<[target].uuid>]>:
    - narrate "<&[error]>You've already invited this player recently! Try again later."
    - stop

  - define owner <player>
  - clickable for:<[target]> usages:1 until:1m save:accept_invite:
    - if <player.has_flag[party]>:
      - narrate "<&[error]>You're already in a party!"
      - stop
    - if <server.flag[hm.parties.<[party]>.members].size> >= 3:
      - narrate "<&[error]>This party is full!"
      - stop
    - narrate "<&[emphasis]>Invite accepted." targets:<[target]>
    - narrate "<&[emphasis]><[target].name> accepted the invite to your party." targets:<[owner]>
    - narrate targets:<server.flag[hm_parties.<[party]>.members]> "<&[emphasis]><[target].name> has joined the party."
    - flag <[target]> party.name:<[party]>
    - flag server hm_parties.<[party]>.members:->:<[target]>
    - flag <[owner]> party_invites.<player.uuid>:!

  - clickable for:<[target]> usages:1 until:1m save:deny_invite:
    - narrate "<&[emphasis]>Invite denied." targets:<[target]>
    - narrate "<&[emphasis]><[target].name> denied the invite to your party." targets:<[owner]>

  - flag <player> party_invites.<[target].uuid> expire:1m
  - narrate "<&[warning]>You have invited <[target].name> to your party!"
  - narrate "<&[warning]><player.name> has invited you to join their party!" targets:<[target]>
  - narrate <&sp.repeat[13]><&2><element[Accept].on_hover[Click here to accept the invite.].on_click[<entry[accept_invite].command>]><&sp.repeat[27]><&4><element[Deny].on_hover[Click here to deny the invite.].on_click[<entry[deny_invite].command>]> targets:<[target]>

party_chat_format:
    type: format
    debug: false
    format: <&7><&l>[<&f><player.flag[party.name]><&7><&l>] <&f><player.name><&co><[text]>

p_create:
  type: task
  definitions: party
  script:
  - if <server.has_flag[hm_parties.<[party]>]>:
    - narrate "<&[error]>This party already exists!"
    - stop

  - flag server hm_parties.<[party]>.owner:<player>
  - flag server hm_parties.<[party]>.members:->:<player>
  - flag server hm_parties.<[party]>.creation:<util.time_now>
  - flag <player> party.name:<[party]>
  - narrate "<&[emphasis]>The party <&dq><[party]><&dq> has been created!"

party_handlers:
  type: world
  debug: false
  events:
    on player chats flagged:party.chat:
    - determine cancelled passively
    - define members <server.flag[hm_parties.<player.flag[party.name]>.members]>

    - narrate " <context.message>" format:party_chat_format targets:<[members]>

    on player tries to attack player_flagged:party:
    - if <context.entity.flag[party.name]> == <player.flag[party.name]||null>:
      - determine cancelled

    on player quit flagged:party:
    - define party <player.flag[party.name]>
    - define members <server.flag[hm_parties.<[party]>.members]>
    - if <server.flag[hm_parties.<[party]>.owner]> == <player>:
      - flag <[members]> party:!
      - flag server hm_parties.<[party]>:!
      - narrate "<&[warning]>The party has been disbanded due to leader disconnecting." targets:<[members]>
      - stop
    - flag <player> party:!
    - flag server hm_parties.<[party]>.members:<-:<player>
    - narrate "<&[warning]><player.name> has been removed from the party." targets:<[members]>