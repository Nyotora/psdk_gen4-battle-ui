p '97210 chargé'
module BattleUI
  # Sprite of a Pokemon in the battle
  class PokemonSprite < ShaderedSprite
    # Get the base position of the Pokemon in 1v1
    # @return [Array(Integer, Integer)]
    def base_position_v1
      return 242, 109 if enemy?

      return 90, 181
    end

    # Get the base position of the Pokemon in 2v2+
    # @return [Array(Integer, Integer)]
    def base_position_v2
      return 202, 106 if enemy?

      return 58, 179
    end
	
  end

  
  class TrainerSprite < ShaderedSprite

    # Get the base position of the Trainer in 1v1
    # @return [Array(Integer, Integer)]
    def base_position_v1
      return 242, 107 if enemy?

      return 90, 181
    end

    # Get the base position of the Trainer in 2v2+
    # @return [Array(Integer, Integer)]
    def base_position_v2
      if enemy?
        return 202, 103 if @scene.battle_info.battlers[1].size >= 2

        return 242, 108
      end

      return 58, 180
    end
  end

end
