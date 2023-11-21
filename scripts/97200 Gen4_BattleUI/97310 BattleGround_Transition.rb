module Battle
    class Visual
      module Transition
        # Trainer transition of Red/Blue/Yellow games
        class RBYTrainer < Base

          SPEED = 1.1
            
            # Function that creates all the sprites
            def create_all_sprites
                super
                create_top_sprite
                create_ground_enemy_sprite
                create_ground_actors_sprite
                create_enemy_sprites
                create_actors_sprites
            end
            
            # Function that creates the enemy sprites
            def create_ground_enemy_sprite
              @ground_enemy_sprite = @scene.visual.get_enemy_battleground
              @ground_enemy_sprite.x -= DISPLACEMENT_X
            end
    
            # Function that creates the actor sprites
            def create_ground_actors_sprite
              @ground_actors_sprite = @scene.visual.get_actor_battleground
              @ground_actors_sprite.x += DISPLACEMENT_X
            end

            # Function that create the sprite movement animation
            # @return [Yuki::Animation::TimedAnimation]
            def create_sprite_move_animation
                ya = Yuki::Animation
                animations = @enemy_sprites.map do |sp|
                    ya.move(SPEED, sp, sp.x, sp.y, sp.x + DISPLACEMENT_X, sp.y)
                end
                # @type [Yuki::Animation::TimedAnimation]
                animation = animations.pop
                animations.each { |a| animation.parallel_add(a) }
                #Move enemy ground
                animation.parallel_add(ya.move(SPEED, @ground_enemy_sprite, @ground_enemy_sprite.x, @ground_enemy_sprite.y, @ground_enemy_sprite.x + DISPLACEMENT_X, @ground_enemy_sprite.y))
                
                @actor_sprites.each do |sp|
                    animation.parallel_add(ya.move(SPEED, sp, sp.x, sp.y, sp.x - DISPLACEMENT_X, sp.y))
                end
                #Move actor ground
                animation.parallel_add(ya.move(SPEED, @ground_actors_sprite, @ground_actors_sprite.x, @ground_actors_sprite.y, @ground_actors_sprite.x - DISPLACEMENT_X, @ground_actors_sprite.y))
                
                @enemy_sprites.each { |sp| animation.play_before(ya.send_command_to(sp, :shader=, nil)) }
                cries = @enemy_sprites.select { |sp| sp.respond_to?(:cry) }
                cries.each { |sp| animation.play_before(ya.send_command_to(sp, :cry)) }
                return animation
            end

        end

        class RBYWild < Base

          SPEED = 1.1
            
            # Function that creates all the sprites
            def create_all_sprites
                super
                create_top_sprite
                create_ground_enemy_sprite
                create_ground_actors_sprite
                create_enemy_sprites
                create_actors_sprites
            end
            
            # Function that creates the enemy sprites
            def create_ground_enemy_sprite
              @ground_enemy_sprite = @scene.visual.get_enemy_battleground
              @ground_enemy_sprite.x -= DISPLACEMENT_X
            end
    
            # Function that creates the actor sprites
            def create_ground_actors_sprite
              @ground_actors_sprite = @scene.visual.get_actor_battleground
              @ground_actors_sprite.x += DISPLACEMENT_X
            end

            # Function that create the sprite movement animation
            # @return [Yuki::Animation::TimedAnimation]
            def create_sprite_move_animation
                ya = Yuki::Animation
                animations = @enemy_sprites.map do |sp|
                    ya.move(SPEED, sp, sp.x, sp.y, sp.x + DISPLACEMENT_X, sp.y)
                end
                # @type [Yuki::Animation::TimedAnimation]
                animation = animations.pop
                animations.each { |a| animation.parallel_add(a) }
                #Move enemy ground
                animation.parallel_add(ya.move(SPEED, @ground_enemy_sprite, @ground_enemy_sprite.x, @ground_enemy_sprite.y, @ground_enemy_sprite.x + DISPLACEMENT_X, @ground_enemy_sprite.y))
                
                @actor_sprites.each do |sp|
                    animation.parallel_add(ya.move(SPEED, sp, sp.x, sp.y, sp.x - DISPLACEMENT_X, sp.y))
                end
                #Move actor ground
                animation.parallel_add(ya.move(SPEED, @ground_actors_sprite, @ground_actors_sprite.x, @ground_actors_sprite.y, @ground_actors_sprite.x - DISPLACEMENT_X, @ground_actors_sprite.y))
                
                @enemy_sprites.each { |sp| animation.play_before(ya.send_command_to(sp, :shader=, nil)) }
                cries = @enemy_sprites.select { |sp| sp.respond_to?(:cry) }
                cries.each { |sp| animation.play_before(ya.send_command_to(sp, :cry)) }
                return animation
            end

        end

      end
    end
end