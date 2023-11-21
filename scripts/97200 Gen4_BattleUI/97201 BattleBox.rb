p "97201 chargé"
module BattleUI
    # Object that show the Battle Bar of a Pokemon in Battle
    # @note Since .25 InfoBar completely ignore bank & position info about Pokemon to make thing easier regarding positionning
    class BattleBox < UI::SpriteStack
      include UI
      
      attr_reader :animation_handler
      attr_reader :scene
      attr_reader :sprite

      def initialize(viewport, scene)
        super(viewport)
        @animation_handler = Yuki::Animation::Handler.new
        @scene = scene
        create_box_sprite
      end

      def create_box_sprite()
        @sprite = add_sprite(0, 175, 'battle/battle_box')
        @sprite.visible=(false)
      end

      def show()
        @sprite.visible=(true)
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
      
    end
end