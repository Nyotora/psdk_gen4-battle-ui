p '97207 chargé'
module Battle
    class Scene
      # Message Window of the Battle
      class Message < UI::Message::Window
        WINDOW_SKIN = 'battle_box'
        # Return the default vertical margin
        # @return [Integer]
        def default_vertical_margin
            return 7
        end
      end
    end
end