note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make
feature
	redo
    	do
    		if model.is_game_finished then
				-- reset the undo and redo
				model.clear_undo
				model.clear_redo
    		end
			-- perform some update on the model state
			model.redo
			etf_cmd_container.on_change.notify ([Current])
    	end

end
