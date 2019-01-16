note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY_AGAIN
inherit
	ETF_PLAY_AGAIN_INTERFACE
		redefine play_again end
create
	make
feature 
	play_again
		local
			pa: PLAY_AGAIN_OPER
    	do
    		if not model.is_game_finished then
    			if model.undo_stk.is_empty then
    				-- play_again is the first command
     				model.set_sts_str(model.status_m.default_message)
    			else
    				model.set_sts_str(model.status_m.finish_game)
    			end

    		else
    			model.play_again
    		end
			-- perform some update on the model state
			model.clear_undo
			model.clear_redo

			create pa.make_again (model, model.status_m.default_message, model.msg_str)
			model.set_undo (pa)

			etf_cmd_container.on_change.notify ([Current])
    	end

end
