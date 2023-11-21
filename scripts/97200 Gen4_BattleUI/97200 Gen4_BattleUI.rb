p "97200 chargé"
module Battle
    class Visual
        def initialize(scene)
            @scene = scene
            @screenshot = take_snapshot
            # All the battler by bank
            @battlers = {}
            # All the bars by bank
            @info_bars = {}
            # All the team info bar by bank
            @team_info = {}
            # All the ability bar by bank
            # @type [Hash{ Integer => Array<BattleUI::AbilityBar> }]
            @ability_bars = {}
            # All the item bar by bank
            # @type [Hash{ Integer => Array<BattleUI::ItemBar> }]
            @item_bars = {}
            # All the animation currently being processed (automatically removed)
            @animations = []
            # All the animatable object
            @animatable = []
            # All the parallel animations (manually removed)
            @parallel_animations = {}
            # All the thing to dispose on #dispose
            @to_dispose = []
            # Is the visual locking the update of the battle
            @locking = false
            # Create all the sprites
            
            # CUSTOM : message box bg   
            @box = {}

            @a_battleground = {}
            @e_battleground = {}

            create_graphics
            create_battle_animation_handler
            @viewport&.sort_z
        end

        # Create all the graphics for the visuals
        def create_graphics
            create_viewport
            create_background
            create_battlegrounds
            create_battlers
            create_box
            create_player_choice
            create_skill_choice
        end

        # Update the visuals
        def update
            @animations.each(&:update)
            @animations.delete_if(&:done?)
            @parallel_animations.each_value(&:update)
            @gif_container&.update(@background.bitmap)
            update_battlers
            update_info_bars
            update_team_info
            update_ability_bars
            update_item_bars
            update_box
        end

        def create_battlegrounds()
            @a_battleground = Sprite.new(viewport)
            @a_battleground = sprite = BattleUI::BattleGrounds.new(@viewport, @scene, true)
            @animatable << sprite

            @e_battleground = Sprite.new(viewport)
            @e_battleground = sprite = BattleUI::BattleGrounds.new(@viewport, @scene, false)
            @animatable << sprite
        end

        def get_enemy_battleground()
            return @e_battleground
        end

        def get_actor_battleground()
            return @a_battleground
        end

        def create_box()
            @box = Sprite.new(viewport_sub)
            @box = sprite = BattleUI::BattleBox.new(@viewport_sub, @scene)
            @animatable << sprite
        end

        def update_box()
            @box.update
        end

        def show_box_sprite()
            @box.show
        end

        # Show KO animations
        # @param targets [Array<PFM::PokemonBattler>]
        def show_kos(targets)
            targets = targets.select(&:dead?)
            return if targets.empty?
    
            
            # Start all animations
            targets.each do |target|
                battler_sprite(target.bank, target.position).go_out
                wait_for_animation
                play_ko_se
                hide_info_bar(target)
            end
            # Show messages
            targets.each do |target|
                @scene.display_message_and_wait(parse_text_with_pokemon(19, 0, target, PFM::Text::PKNICK[0] => target.given_name))
                target.status = 0
            end
        end
        
        # TRANSITION

        module Transition
            class Base
                def transition
                    @animations.clear
                    @visual.show_box_sprite
                    @scene.message_window.visible = true
                    @scene.message_window.blocking = true
                    @scene.message_window.stay_visible = true
                    @scene.message_window.wait_input = true
                    ya = Yuki::Animation
                    main = create_fade_out_animation
                    main.play_before(create_sprite_move_animation)
                    @animations << main
                    @animations << create_background_animation
                    @animations << create_paralax_animation
                    # Appearing section
                    main.play_before(ya.message_locked_animation)
                        .play_before(ya.send_command_to(@scene.visual, :show_team_info))
                        .play_before(ya.send_command_to(self, :show_appearing_message))
                        .play_before(ya.send_command_to(self, :start_enemy_send_animation))
                    @animations.each(&:start)
                  end
            end
        end


    end
end