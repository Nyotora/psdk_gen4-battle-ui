p "97205 chargé"
module BattleUI
    class SkillChoice < GenericChoice
      include SkillChoiceAbstraction
      # Coordinate of each buttons
      btn_x = 5
      btn_y = 181

      BUTTON_COORDINATE = [[btn_x, btn_y], [btn_x+121, btn_y], [btn_x, btn_y+26], [btn_x+121, btn_y+26]]

      def update_key_index
        if Input.repeat?(:UP)
            if !(@index == 1 && @buttons.count(&:visible) == 3)
                if @buttons.count(&:visible) == 3 && @index == 0
                    @index = 2
                else
                    @index = (@index - 2) % @buttons.count(&:visible)
                end
            end
        elsif Input.repeat?(:DOWN)
            if !(@index == 1 && @buttons.count(&:visible) == 3)
                if @buttons.count(&:visible) == 3 && @index == 2
                    @index = 0
                else
                    @index = (@index + 2) % @buttons.count(&:visible)
                end
            end
        elsif Input.repeat?(:LEFT) || Input.repeat?(:RIGHT) 
            if !(@index == 2 && @buttons.count(&:visible) == 3)
                @index = (@index.even? ? @index + 1 : @index - 1 ) % @buttons.count(&:visible)
            end
        end
      end
      
      # Set the button opacity
        def update_button_opacity
            base_index = 0
            buttons.each_with_index do |button, index|
            next unless button.visible
    
                button.opacity = index == @index ? 255 : 204
                x, y = *BUTTON_COORDINATE[base_index + index]
                button.set_position(x + @x, y + @y)
            end
        end

        def cursor_offset_x
            return super if @buttons[@index].x != (BUTTON_COORDINATE[@index].first + @x)
      
            super + 19
        end

        def cursor_offset_y
            return super - 9
        end

        class MoveInfo < UI::SpriteStack

            def create_sprites
                pp_x = 261
                pp_y = 210
                @pp_background = add_sprite(pp_x, pp_y, 'battle/pp_box', 1, 3, type: SpriteSheet)
                @pp_text = add_text(pp_x+24, pp_y+4, 0, 16, :pp_text, 1, color: 10, type: UI::SymText)
            end
        end

        class SpecialButton < UI::SpriteStack
            # Update the special button content
            # @param mega [Boolean]
            def refresh(mega = false)
            @text.text = 'Info' if @type == :descr
            @background.set_bitmap(mega ? 'battle/button_mega_activated' : 'battle/button_mega', :interface) if @type == :mega
            end

            def create_sprites
                # TODO: separate in methods
                @background = add_background(@type == :descr ? 'battle/button_x' : 'battle/button_mega')
                @text = add_text(23, @type == :descr ? 4 : 9, 0, 16, nil.to_s, color: 10)
                add_sprite(3, @type == :descr ? 3 : 9, NO_INITIAL_IMAGE, @type == :descr ? :X : :Y, type: UI::KeyShortcut)
            end
        end

        class SubChoice < UI::SpriteStack
            def create_special_buttons
                @descr_button = add_sprite(249, 183, NO_INITIAL_IMAGE, @scene, :descr, type: SpecialButton)
                @mega_button = add_sprite(2, 183, NO_INITIAL_IMAGE, @scene, :mega, type: SpecialButton)
            end
        end
    end
end  