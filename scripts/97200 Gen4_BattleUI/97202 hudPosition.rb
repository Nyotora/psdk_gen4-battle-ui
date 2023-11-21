p '97202 chargé'
module BattleUI
  # Sprite of a Pokemon in the battle
  class InfoBar < UI::SpriteStack
    # Get the base position of the Pokemon in 1v1
    # @return [Array(Integer, Integer)]
    def hp_background_coordinates
    #                            18, 12
      return enemy? ? [8, 12] : [18, 12]
    end
	  def hp_bar_coordinates
				#                         x + 33,   y + 13
      return enemy? ? [x + 23, y + 13] : [x + 33, y + 13]
    end
	
	  # Get the base position of the Pokemon in 1v1
    # @return [Array(Integer, Integer)]
    def base_position_v1
      return 2, 20 if enemy?

      return 184, 128
    end
	
	  # Get the base position of the Pokemon in 2v2+
    # @return [Array(Integer, Integer)]
    def base_position_v2
      return 2, 9 if enemy?

      return 184, 125
    end
	
	  # Get the offset position of the Pokemon in 2v2+
    # @return [Array(Integer, Integer)]
    def offset_position_v2
      return 5, 30 if enemy?

      return -5, 30
    end
  end


  class TrainerPartyBalls < UI::SpriteStack
    # Get the base position of the Pokemon in 1v1
    # @return [Array(Integer, Integer)]
    def base_position_v1
      return 0, -100 if enemy? && !@scene.battle_info.trainer_battle?  #PKMN Sauvage
      return 0, 48+5 if enemy?

      return 227, 173-8
    end
    alias base_position_v2 base_position_v1


    # Creates the go_in animation
    # @return [Yuki::Animation::TimedAnimation]
    def go_in_animation
      origin_x = enemy? ? -@background.width : @viewport.rect.width

      return Yuki::Animation.move_discreet(0.2, self, origin_x, y, *sprite_position)
    end

    # Creates the go_out animation
    # @return [Yuki::Animation::TimedAnimation]
    def go_out_animation
      target_x = enemy? ? -@background.width : @viewport.rect.width

      return Yuki::Animation.move_discreet(0.2, self, *sprite_position, target_x, y)
    end
  end

end
