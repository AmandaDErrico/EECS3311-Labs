note
	description: "Summary description for {PLAY_AGAIN_OPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY_AGAIN_OPER

inherit

	OPERATION
		redefine
			execute,
			undo,
			redo
		end

create
	make_again

feature {TIC_TAC_TOE}

	make_again (playagain_game: TIC_TAC_TOE; sm: STRING; gm: STRING)
		do
			g := playagain_game

			-- for undo
			set_old_sts(sm)
			set_old_gmsg(gm)
		end

feature -- Attributes
	g: TIC_TAC_TOE

feature
	execute
		do
			g.game_board.board.fill_with ("_") -- replace with new board
			g.set_board_str (g.game_board.out) -- reset the board_str with empty spaces to play

			g.set_game_over (false) -- starting a new game
			g.set_game_start(true)


			if g.sts_str ~ g.status_m.win then
				-- Check if someone won. If so swap the players depending on whoever played first.
				g.set_pt_player (g.first_player)
				g.swap_players
			end
			g.set_first_player (g.player_turn)

			g.set_sts_str (g.status_m.default_message)
			g.set_msg_str (g.game_m.player_next (g.player_turn))

			-- reset the old_status and game status so we can access them later in tictactoe
			set_old_sts(g.sts_str)
			set_old_gmsg(g.msg_str)
		end

	undo
		do
			-- does nothing!
		end

	redo
		do
			execute -- similar to new_game
		end



end
