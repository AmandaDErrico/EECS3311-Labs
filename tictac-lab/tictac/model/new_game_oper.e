note
	description: "Summary description for {NEW_GAME_OPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_GAME_OPER

inherit
	OPERATION
	redefine
		execute,
		undo,
		redo
	end

create
	make_ng

feature {TIC_TAC_TOE} -- Initialization

	make_ng(new_game: TIC_TAC_TOE; pname1: STRING; pname2: STRING; sm: STRING; gm: STRING)
		do
			g := new_game
			p1name := pname1
			p2name := pname2

			-- for undo
			set_old_sts(sm)
			set_old_gmsg(gm)
		end


feature {NONE} -- Attributes
	p1name, p2name: STRING
	g: TIC_TAC_TOE

feature

	execute
		do
			g.set_pt_player (g.player1)
			g.set_first_player (g.player_turn) -- always player1
			g.set_pnames (p1name, p2name)

			g.game_board.board.fill_with ("_") -- replace with new board
			g.set_board_str (g.game_board.out) -- reset the board_str with empty spaces to play

			g.set_pscore (p1name, 0)
			g.set_pscore (p2name, 0)
			g.set_game_start (true) -- start the game
			g.set_game_over (false) -- set game over to false so we can undo
			g.set_sts_str (g.status_m.default_message)
			g.set_msg_str (g.game_m.player_next (g.player_turn))

			-- reset the old_status and game status so we can access them later in tictactoe
			set_old_sts(g.sts_str)
			set_old_gmsg(g.msg_str)

		end

	undo
		do
			execute
		end

	redo
		do
			execute
		end


end
