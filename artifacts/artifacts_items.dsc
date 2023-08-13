#auto smelt
auto_smelt_artifact:
  type: item
  flags:
    artifact: auto_smelt
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Auto Smelt Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#telepathy
telepathy_artifact:
  type: item
  flags:
    artifact: telepathy
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Telepathy Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#withering
withering_artifact:
  type: item
  flags:
    artifact: withering
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Withering Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#allure
allure_artifact:
  type: item
  flags:
    artifact: allure
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Allure Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#lightweight
lightweight_artifact:
  type: item
  flags:
    artifact: lightweight
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lightweight Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#overlord
overlord_artifact:
  type: item
  flags:
    artifact: overlord
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Overlord Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#reforged
reforged_artifact:
  type: item
  flags:
    artifact: reforged
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Reforged Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#lavawalker
lavawalker_artifact:
  type: item
  flags:
    artifact: lavawalker
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lava Walker Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#unforged
unforged_artifact:
  type: item
  flags:
    artifact: unforged
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lava Walker Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#lifesteal
lifesteal_artifact:
  type: item
  flags:
    artifact: lifesteal
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lifesteal Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#replant
replant_artifact:
  type: item
  flags:
    artifact: replant
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Replant Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#bleed
bleed_artifact:
  type: item
  flags:
    artifact: bleed
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Bleed Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#lightning
lightning_artifact:
  type: item
  flags:
    artifact: lightning
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Lightning Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#explosion
explosion_artifact:
  type: item
  flags:
    artifact: explosion
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Explosion Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#scanner
scanner_artifact:
  type: item
  flags:
    artifact: scanner
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Scanner Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>

#slowness
slowness_artifact:
  type: item
  flags:
    artifact: slowness
  data:
    tools: <script[artifact_data].data_key[artifacts.<script.data_key[flags.artifact]>.tools].proc[artifacts_tool]>
    lore: <script[artifact_data].parsed_key[artifacts.<script.data_key[flags.artifact]>.lore]>
  material: <script[artifact_data].data_key[settings.material]>
  display name: <&a>Slowness Artifact
  mechanisms:
    custom_model_data: <script[artifact_data].data_key[settings.custom_model]>
    lore: <script.parsed_key[data.lore].include[<script.parsed_key[data.tools]>]>