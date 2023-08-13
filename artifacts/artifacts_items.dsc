#auto smelt
auto_smelt_artifact:
  type: item
  flags:
    artifact: auto_smelt
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Auto Smelt Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#telepathy
telepathy_artifact:
  type: item
  flags:
    artifact: telepathy
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Telepathy Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#withering
withering_artifact:
  type: item
  flags:
    artifact: withering
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Withering Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#allure
allure_artifact:
  type: item
  flags:
    artifact: allure
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Allure Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#lightweight
lightweight_artifact:
  type: item
  flags:
    artifact: lightweight
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lightweight Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#overlord
overlord_artifact:
  type: item
  flags:
    artifact: overlord
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Overlord Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#reforged
reforged_artifact:
  type: item
  flags:
    artifact: reforged
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Reforged Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#lavawalker
lavawalker_artifact:
  type: item
  flags:
    artifact: lavawalker
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lava Walker Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#unforged
unforged_artifact:
  type: item
  flags:
    artifact: unforged
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lava Walker Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#lifesteal
lifesteal_artifact:
  type: item
  flags:
    artifact: lifesteal
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lifesteal Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#replant
replant_artifact:
  type: item
  flags:
    artifact: replant
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Replant Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#bleed
bleed_artifact:
  type: item
  flags:
    artifact: bleed
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Bleed Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#lightning
lightning_artifact:
  type: item
  flags:
    artifact: lightning
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lightning Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#explosion
explosion_artifact:
  type: item
  flags:
    artifact: explosion
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Explosion Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#scanner
scanner_artifact:
  type: item
  flags:
    artifact: scanner
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Scanner Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>

#slowness
slowness_artifact:
  type: item
  flags:
    artifact: slowness
  data:
    artifact_data: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Slowness Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.artifact_data]>]>