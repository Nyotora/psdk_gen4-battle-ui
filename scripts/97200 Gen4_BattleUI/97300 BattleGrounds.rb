module BattleUI
  class BattleGrounds < Sprite
    include UI
    include GoingInOut
    include MultiplePosition

    
    FADE_AWAY_PIXEL_COUNT = 160
    
    attr_reader :animation_handler
    attr_reader :scene

    GR_NAMES = %w[ground_building ground_grass ground_tall_grass ground_taller_grass ground_cave
                  ground_mount ground_sand ground_pond ground_sea ground_under_water ground_ice ground_snow]
    A_Pos = [nil, [94, 175 + 5], [99, 175 + 5], [99, 175 + 5]] # 1.5
    E_Pos = [nil, [242, 115-8], [233, 115-5], [233, 115-5]] # 1.3

    def initialize(viewport, scene, actors = true)
      super(viewport)
      @actors = actors
      @scene = scene
      @animation_handler = Yuki::Animation::Handler.new
      set_bitmap
      calibrate
    end

    def set_bitmap
      if $game_temp.battleback_name.to_s.empty?
        zone_type = $env.get_zone_type
        zone_type += 1 if zone_type > 0 || $env.grass?
        ground_name = @actors ? GR_NAMES[zone_type].to_s+'_back' : GR_NAMES[zone_type].to_s
      else
        ground_name = @actors ? $game_temp.battleback_name.sub('back_', 'ground_')+'_back' : $game_temp.battleback_name.sub('back_', 'ground_')
      end
      super(ground_name, :battleback)
      set_origin(bitmap.width / 2, @actors ? bitmap.height : bitmap.height / 2)
    end

    def calibrate
      arr = @actors ? A_Pos : E_Pos
      if $game_temp.vs_type == 2
        self.zoom = @actors ? 1.3 : 1.3
      #elsif @actors
        #self.zoom = 1.5 if $zoom_factor == 2
      end
      set_position(*arr[$game_temp.vs_type])
    end

    # Update the InfoBar
    def update
      @animation_handler.update
    end

    # Tell if the InfoBar animations are done
    # @return [Boolean]
    def done?
      return @animation_handler.done?
    end

        # Creates the go_in animation
    # @return [Yuki::Animation::TimedAnimation]
    def go_in_animation
      origin_x = sprite_position[0] + (enemy? ? FADE_AWAY_PIXEL_COUNT : -FADE_AWAY_PIXEL_COUNT)

      return Yuki::Animation.move_discreet(0.5, self, origin_x, y, *sprite_position)
    end


  end
end
