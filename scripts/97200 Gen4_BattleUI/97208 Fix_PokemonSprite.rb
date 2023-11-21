module BattleUI
    # Sprite of a Pokemon in the battle
    class PokemonSprite < ShaderedSprite
        # Create the go_out animation of a KO pokemon
        # @return [Yuki::Animation::TimedAnimation]
        def ko_go_out_animation
            # ya = Yuki::Animation
            # animation = ya.send_command_to(self, :cry, true)
            # going_down = ya.opacity_change(0.1, self, opacity, 0)
            # animation.play_before(going_down)
            # going_down.parallel_add(ya.move(0.1, self, x, y, x, y + DELTA_DEATH_Y))

            ya = Yuki::Animation

            # Créer une animation pour le cri du Pokémon
            #cry_animation = ya.send_command_to(self, :cry, true)
            cry_animation = ya.send_command_to(self, :cry)

            # Créer une animation pour le mouvement vers le bas
            ko_animation = ya.opacity_change(0.1, self, opacity, 0)
            ko_animation.parallel_add(ya.move(0.1, self, x, y, x, y + DELTA_DEATH_Y))

            # Ajouter un temps de pause (par exemple, 1 seconde)
            pause_duration = 1.5
            pause_animation = ya.wait(pause_duration)

            # Utiliser play_before pour spécifier l'ordre des animations
            pause_animation.play_before(ko_animation)#.play_before(cry_animation)
            cry_animation.play_before(pause_animation)

            return cry_animation
        end

    end
end