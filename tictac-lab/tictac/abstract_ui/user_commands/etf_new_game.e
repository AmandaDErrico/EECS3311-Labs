note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_GAME
inherit
	ETF_NEW_GAME_INTERFACE
		redefine new_game end
create
	make
feature 
	new_game(player1: STRING ; player2: STRING)
		require else
			new_game_precond(player1, player2)
		local
			ng: NEW_GAME_OPER
    	do
		-- here we do if player1 ~ player2 (i.e all error cases) -> defensive programming
			if not model.is_diff_names (player1, player2) then
				model.set_sts_str (model.status_m.diff)
			elseif not model.is_valid_name_start (player1) or not model.is_valid_name_start (player2) then
				model.set_sts_str (model.status_m.name_start)
			else
				model.new_game (player1, player2)
			end

			create ng.make_ng(model, player1, player2, model.status_m.default_message, model.msg_str)
			model.clear_undo
			model.clear_redo
			model.set_undo (ng)

			etf_cmd_container.on_change.notify ([Current])
    	end

end
