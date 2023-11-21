p "97204 chargé"
module BattleUI
    class PlayerChoice < GenericChoice
      include UI
      include PlayerChoiceAbstraction
      
      btnX = 16
      btnY = 190
      btnSpace = 3

      BUTTON_COORDINATE = [[btnX-btnSpace*2, btnY], [btnX+72-btnSpace, btnY], [btnX+72*2+btnSpace, btnY], [btnX+72*3+btnSpace*2, btnY]]

      def update_key_index
        if Input.trigger?(:LEFT)
          @index = (@index - 1).clamp(0, 3)
        elsif Input.trigger?(:RIGHT)
          @index = (@index + 1).clamp(0, 3)
        end
      end

      # Creates the go_in animation
      # @return [Yuki::Animation::TimedAnimation]
      def go_in_animation
        ya = Yuki::Animation
        root = ya.move_discreet(0.1, self, -@viewport.rect.width, y, 0, y)
        root.play_before(ya.send_command_to(@cursor, :register_positions))
        root.play_before(ya.send_command_to(@cursor, :start_animation))
        return root
      end
  
      # Creates the go_out animation
      # @return [Yuki::Animation::TimedAnimation]
      def go_out_animation
        ya = Yuki::Animation
        root = ya.send_command_to(@cursor, :stop_animation)
        root.play_before(ya.move_discreet(0.1, self, 0, y, @viewport.rect.width, y))
        return root
      end

        def cursor_offset_x
            return super if @buttons[@index].x != (BUTTON_COORDINATE[@index].first + @x)
    
            super + 39
        end

        def cursor_offset_y
            return super - 11
        end

    end


end