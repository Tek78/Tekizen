artifact_constructor:
  type: procedure
  debug: false
  definitions: artifact
  script:
  - define material <script[artifact_data].data_key[settings.material]>
  - define data <script[artifact_data].parsed_key[artifacts.<[artifact]>]>
  - define applicaple "<&6>Applies to: <&e><[data].get[tools].separated_by[<&7>, <&e>].split_lines_by_width[100]>"
  - define lore <[data].get[lore].include[<[applicaple]>]>
  - foreach Chance|Duration|Range:
    - foreach next if:!<[data].contains[<[value]>]>
    - define val "<&6><[value]>: <&7><[data].get[<[value]>]>"
    - define lore <[lore].include[<[val]>]>
  - define model <[data].get[model]||<script[artifact_data].data_key[settings.generic_model]>>
  - definemap properties custom_model_data:<[model]> display:<[data].get[display]> lore:<[lore]>
  - determine <item[<[material]>].with_map[<[properties]>].with_flag[artifact:<[artifact]>]>

artifact_command:
  type: command
  debug: false
  name: artifact
  usage: /artifact name
  description: Obtain an artifact
  permission: artifact.use
  permission message: <&c>Sorry!
  tab completions:
    1: <script[artifact_data].data_key[artifacts].keys>
  script:
  - if <context.args.first||null> !in <script[artifact_data].data_key[artifacts].keys>:
    - narrate "Invalid argument."
    - stop
  - give <context.args.first.proc[artifact_constructor]>