module Battle
    class Visual
        def show_switch_form_animation(target)

            anim = form_animation(target, battler_sprite(target.bank, target.position))
            anim.start
            @animations << anim
            #visual.animations.concat(animations)
            #@animations.each(&:start)
            wait_for_animation

        end

        def cry(target)
            Audio.se_play(target.cry, 100, 100)
        end

        def change_pkmn_sprite(target)
            battler_sprite(target.bank, target.position)&.pokemon = target
        end

        def form_animation(target, target_spr)
            ya = Yuki::Animation
            sprite = Sprite
            #animation_user = ya.wait(0.1)
            # animation_target = ya.create_sprite(@viewport, sprite, Sprite, nil, [:load, 'MV/light', :animation], [:set_rect, 0, 0, 192, 192], [:zoom=, 0.7], [:set_origin, 96, 96])
            implosion = Sprite.new(@viewport).set_bitmap('MV/implosion_upscale', :animation).set_origin(96*2,110*2).set_rect(0, 0, 192*2, 192*2)
            #p target.bank.to_s
            implosion.zoom=(target.bank == 1 ? 1.2 : 1.5)
            main_t_anim = ya.resolved
            # animation_target.play_before(main_t_anim)
            main_t_anim.play_before(ya.move_sprite_position(0, implosion, target_spr, target_spr))
            
            for i in 0..3 do
                for j in 0..4 do
                    main_t_anim.play_before(ya.wait(0.07))
                    main_t_anim.play_before(ya.send_command_to(implosion, :set_rect, 192*2*j, 192*2*i, 192*2, 192*2))
                end
            end

            main_t_anim.play_before(ya.opacity_change(0.1, implosion, 255, 0))


            explosion = Sprite.new(@viewport).set_bitmap('MV/light2-transformed', :animation).set_origin(96*2,110*2).set_rect(0, 0, 192*2, 192*2)
            #p target.bank.to_s
            explosion.zoom=(target.bank == 1 ? 1.2 : 1.5)
            #main_t_anim = ya.resolved
            # animation_target.play_before(main_t_anim)
            main_t_anim.play_before(ya.move_sprite_position(0, explosion, target_spr, target_spr))
            
            for i in 0..7 do
                for j in 0..4 do
                    main_t_anim.play_before(ya.wait(0.02))
                    main_t_anim.play_before(ya.send_command_to(explosion, :set_rect, 192*2*j, 192*2*i, 192*2, 192*2))
                    if i == 5 && j == 0
                        main_t_anim.play_before(ya.send_command_to(self, :change_pkmn_sprite, target))
                    end
                end
            end
            main_t_anim.play_before(ya.wait(0.5))
            main_t_anim.play_before(ya.dispose_sprite(implosion))
            main_t_anim.play_before(ya.dispose_sprite(explosion))
            cry_animation = ya.send_command_to(self, :cry, target)
            main_t_anim.play_before(cry_animation)
            main_t_anim.play_before(ya.wait(1.5))

            return main_t_anim
        end
    end
end