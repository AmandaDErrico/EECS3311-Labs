note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
feature
	undo
    	do
    		if model.is_game_finished then
				-- reset the undo and redo
				if not model.undo_stk.is_empty then -- finished a game, tie or win
					-- cannot undo more when game is finished, so clear the item below current item
					model.redo_stk.put (model.undo_stk.item)
					model.undo_stk.remove
					model.clear_undo
					model.undo_stk.put (model.redo_stk.item)
					model.clear_redo
				end
    		end
			-- perform some update on the model state
			model.undo
			etf_cmd_container.on_change.notify ([Current])
    	end

end
