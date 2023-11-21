module Battle
    class Move
        Move.register_single_type_multiplier_overwrite_hook('JUMP Pistol/Clone Punch/ Getsuga Tensho') do |_, target_type, _, move|
            next 1 if move.db_symbol == :pistol || move.db_symbol == :clone_punch || move.db_symbol == :getsuga_tensho
      
            next nil
          end
    end
end