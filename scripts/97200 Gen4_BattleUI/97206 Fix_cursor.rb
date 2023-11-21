p "97206 chargé"
module BattleUI
    class Cursor < ShaderedSprite
      # Register the positions so the cursor can animate itself
      def register_positions
        @origin_x = x
        @origin_y = y
        @target_x = x
        @target_y = y - 5
      end
    end
end