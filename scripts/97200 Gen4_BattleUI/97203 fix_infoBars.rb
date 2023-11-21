p "97203 chargé"

module Battle
    class Visual
        def show_hp_animations(targets, hps, effectiveness = [], &messages)
            lock do
                animations = targets.map.with_index do |target, index|
                show_info_bars
                if hps[index] && hps[index] == 0
                    next Battle::Visual::FakeHPAnimation.new(@scene, target, effectiveness[index])
                elsif hps[index]
                    next Battle::Visual::HPAnimation.new(@scene, target, hps[index], effectiveness[index])
                end
                end
                wait_for_animation
                scene_update_proc { animations.each(&:update) } until animations.all?(&:done?)
                messages&.call
                show_kos(targets)
            end
        end
        # Begining of the show_player_choice
        # @param pokemon_index [Integer] Index of the Pokemon in the party
        def show_player_choice_begin(pokemon_index)
            pokemon = @scene.logic.battler(0, pokemon_index)
            @locking = true
            @player_choice_ui.reset(@scene.logic.switch_handler.can_switch?(pokemon))
            if @player_choice_ui.out?
                @player_choice_ui.go_in
                @animations << @player_choice_ui
                wait_for_animation
            end
            show_info_bars
            spc_show_message(pokemon_index)
            spc_start_bouncing_animation(pokemon_index)
        end
    end
end


module BattleUI
    class PlayerChoice < GenericChoice
        include UI
        include PlayerChoiceAbstraction
        class SubChoice < UI::SpriteStack
            # Create the sub choice
            # @param viewport [Viewport]
            # @param scene [Battle::Scene]
            # @param choice [PlayerChoice]
            def initialize(viewport, scene, choice)
              super(viewport)
              @scene = scene
              @choice = choice
              create_sprites
            end
      
            # Update the button
            def update
              super
              @item_info.update
              done? ? update_done : update_not_done
            end
      
            # Tell if the choice is done
            def done?
              return !@item_info.visible # && !@bar_visibility
            end

            def reset
                #@item_info.visible = false
                #@bar_visibility = true
                #@last_item_button.refresh
                #@info_button.refresh
            end

            #Update the button when it's done letting the player choose
            def update_done
                #action_y if Input.trigger?(:Y)
                #action_x if Input.trigger?(:X) && !@bar_visibility
            end

            # Update the button when it's waiting for player actions
            def update_not_done
                #return action_y if @bar_visibility && (Input.trigger?(:Y) || Input.trigger?(:A) || Input.trigger?(:B))

                return unless @item_info.done?

                action_b if Input.trigger?(:B)
                action_a if Input.trigger?(:A) || Input.trigger?(:X)
            end

            def create_special_buttons
                @last_item_button = add_sprite(12, 214, NO_INITIAL_IMAGE, :last_item, type: SpecialButton)
                @last_item_button.visible=(false)
                @info_button = add_sprite(2, 188, NO_INITIAL_IMAGE, :info, type: SpecialButton)
                @info_button.visible=(false)
            end

        end
    end








    class SkillChoice < GenericChoice
        class SubChoice < UI::SpriteStack
            # Action triggered when pressing B
            def action_b
                @move_description.hide
                @choice.show
                $game_system.se_play($data_system.cancel_se)
            end

        end
    end
end