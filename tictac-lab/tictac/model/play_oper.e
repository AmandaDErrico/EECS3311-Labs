note
	description: "Plays a game or a new move."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY_OPER

inherit
	OPERATION
	redefine
		execute,
		undo,
		redo
	end


create
	make_play

feature {TIC_TAC_TOE} -- Initialization

	make_play(play_game: TIC_TAC_TOE; b: INTEGER; sm: STRING; gm: STRING)
			-- Initialization for `Current'.
		do
			g := play_game
			play_button := b
			g.set_play_button (play_button)

			-- for undo
			set_old_sts(sm)
			set_old_gmsg(gm)

			-- set for undo and redo, save the button played associated with the state, save player to redo it
			set_old_button(g.button_played)
			set_old_board(g.board_str)


		end

feature -- atrributes
	g: TIC_TAC_TOE
	play_button: INTEGER
	old_board: STRING
	old_button: INTEGER


feature

	execute
		do
			-- checks if the button the player plays will guarantee a win
			if g.possible_win (g.get_pt_letter, g.button_played) then
				-- place the letter in winning spot
				g.game_board.board.enter(g.get_pt_letter, g.button_played)
				-- set the status and game messages
				g.set_sts_str (g.status_m.win)
				g.set_msg_str (g.game_m.new_or_again)
				-- set new board string
				g.set_board_str (g.game_board.out)
				-- increase that player's score
				g.increase_pscore (g.player_turn)
				-- game is now over and now new game is started
				g.set_game_over (true)
				g.set_game_start (false)
			-- after checking if there's no possible win state, and the board is full, must be a tie 	
			elseif g.game_board.almost_cap then
				-- place the letter in tie spot
				g.game_board.board.enter(g.get_pt_letter, g.button_played)
				-- set the status and game messages		
				g.set_sts_str (g.status_m.tie)
				g.set_msg_str (g.game_m.new_or_again)
				-- set new board string
				g.set_board_str (g.game_board.out)
				-- swap the players for the next time a game is played	
				g.swap_players
				-- game is now over and now new game is started
				g.set_game_over (true)
				g.set_game_start (false)
			-- the board is not full, and you can place your letter in the appropriate spot of your choice
			else
				-- place letter in empty spot
				g.game_board.board.enter(g.get_pt_letter, g.button_played)
				-- swap players and set the next player to go next
				g.swap_players
				g.set_sts_str (g.status_m.default_message)
				g.set_msg_str (g.game_m.player_next (g.player_turn))
				-- set new board string
				g.set_board_str (g.game_board.out)
			end
			-- reset the old_status, game message and button associated with state so we can access them later in tictactoe
			set_old_sts(g.sts_str)
			set_old_gmsg(g.msg_str)
			set_old_board(g.board_str)
		end

	undo
		do
			g.game_board.board.enter ("_", old_button)
		end

	redo
		do
			g.game_board.update_board (old_board)
		end

feature -- helper functions

	set_old_board(b: STRING)
		do
			old_board := b
		end

	set_old_button(b: INTEGER)
		do
			old_button := b
		end

end
