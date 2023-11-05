hm_level_system_data:
  type: data
  professions:
    combat:
      settings:
        #the xp it'd take to go from lvl 1 to lvl 2
        base_threshold: 20
        #how much the threshold increases with each level (in %)
        threshold_percentage: 12.5
        #how much the xp intake increaces with each level (in %)
        xp_percentage: 0.1
      #mobs that reward xp
      allowed_mobs:
        zombie: 3
        skeleton: 7.5
        creeper: 3
        cow: 1
        pig: 1
        chicken: 1
        wither: 7.5