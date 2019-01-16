note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
		redefine play end
create
	make
feature 
	play(player: STRING ; press: INTEGER_64)
		require else
			play_precond(player, press)
		local
			p: PLAY_OPER
    	do
		-- here we do all error cases -> defensive programming
			if model.is_game_finished then
				model.set_sts_str (model.status_m.game_finished)
			elseif not model.is_pexists (player) then
				model.set_sts_str (model.status_m.no_player)
			elseif not model.is_pturn (player) then
				model.set_sts_str (model.status_m.not_turn)
			elseif model.is_btaken (press.as_integer_32) then
				model.set_sts_str (model.status_m.taken)
			else
				model.play (player, press.as_integer_32)
			end

			create p.make_play(model, press.as_integer_32, model.sts_str, model.msg_str)

			if not model.redo_stk.is_empty then
				if model.undo_stk.is_empty then -- indicates that new_game is in redo
					model.undo_stk.put (model.redo_stk.item)
					model.redo_stk.remove
				else
					model.clear_redo
				end
			end

			model.set_undo (p)

			etf_cmd_container.on_change.notify ([Current])
    	end

end
