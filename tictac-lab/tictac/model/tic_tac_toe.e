note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	TIC_TAC_TOE

inherit
	ANY
		redefine
			out
		end

create {TIC_TAC_TOE_ACCESS, ES_TEST, ROOT}
	make

feature {ES_TEST, ROOT} -- Initialization
	make
	do
		create game_board.make_board (3)

		create player1.make_player
		create player2.make_player
		set_pt_player(player1)
		set_first_player(player_turn)

		create p1_letter.make_empty
		create p2_letter.make_empty
		set_pletter(player1, "X")
		set_pletter(player2, "O")

		set_pscore(player1.get_pname, 0)
		set_pscore(player2.get_pname, 0)

		create undo_stk.make (100)
		create redo_stk.make (100)

		create game_m.make_g
		set_msg_str(game_m.new_game)
		create status_m.make_str
		set_sts_str(status_m.default_message)


		set_board_str(game_board.out)

		set_game_start(false)
		set_game_over(false)
	end


feature -- model attributes
	game_board: BOARD
	player1, player2, player_turn, first_player: PLAYER
	p1_letter, p2_letter: STRING
	p1_score, p2_score: INTEGER
	button_played: INTEGER
	game_m: GAME_MSG
	status_m: STATUS_MSG
	msg_str, sts_str, board_str: STRING
	is_game_start, is_game_over: BOOLEAN
	undo_stk: ARRAYED_STACK[OPERATION]
	redo_stk: ARRAYED_STACK[OPERATION]

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
		--	i := i + 1
		end

	new_game(playname1: STRING; playname2: STRING)
		local
			ng: NEW_GAME_OPER
		do
			-- sts_str, msg_str, game_board.out are just initializers, will be manipulateed later and changed
			create ng.make_ng (Current, playname1, playname2, sts_str, msg_str)
			ng.execute
		ensure
			is_game_start = true and player1.get_pname /~ "" and player2.get_pname /~ "" and player_turn.get_pname /~ ""
		end


	play(pturn: STRING; button: INTEGER)
		require
			is_game_start and player_turn.get_pname ~ pturn and game_board.board.at (button) ~ "_"
		local
			pl: PLAY_OPER
		do
			-- sts_str, msg_str, game_board.out are just initializers, will be manipulateed later and changed
			create pl.make_play (Current, button, sts_str, msg_str)
			pl.execute
		ensure
			(is_game_start = true or is_game_over = true) and player1.get_pname /~ ""
			and player2.get_pname /~ "" and player_turn.get_pname /~ ""
		end


	play_again
		local
			pa: PLAY_AGAIN_OPER
		do
			-- sts_str, msg_str, game_board.out are just initializers, will be manipulateed later and changed
			create pa.make_again (Current, sts_str, msg_str)
			pa.execute
		ensure
			(is_game_start = true or is_game_over = true) and player1.get_pname /~ ""
			and player2.get_pname /~ "" and player_turn.get_pname /~ ""
		end


	reset
			-- Reset model state.
		do
			make
		end


	undo
		local
			op: OPERATION
			old_sts: STRING
		do
			if is_game_start and then not is_game_over then

				if not undo_stk.is_empty then
					-- call undo to the operation op! If it's play_oper class, will eliminate
					-- last played from no errors. If new_game_oper, then it just executes.
					-- Status message in new_game, regardless if it's "ok" or error message
					-- will place '_' in button associated with state, won't matter.
					-- Note: If we didnt put any operations, then it would bypass these if
					-- statements and just return blanks and start new game, etc
					if undo_stk.item.old_status ~ status_m.default_message then
						undo_stk.item.undo
					end
					-- pop off the operation and move it to the redo stack
					op := undo_stk.item
					undo_stk.remove
					redo_stk.put (op)
				end

				if attached op as oper then
					if not undo_stk.is_empty then
						-- retrieve the messages from game state at prev play command
						if (oper.old_status ~ status_m.default_message) then
							swap_players
						end

						set_msg_str(game_m.player_next (player_turn))
						set_sts_str(undo_stk.item.old_status)
					else
						-- call for undo on new_game
						set_msg_str(oper.old_msg)
						set_sts_str(oper.old_status)
					end
					-- call for all operations	
					set_board_str(game_board.out)
				end

			else
				-- set the statuses for winners, ties, and new games -- ok
				if not undo_stk.is_empty then
					old_sts := undo_stk.item.old_status
					set_sts_str(old_sts)
					undo_stk.remove -- undo_stk should now be empty					
				end
			end
		end


	redo
		local
			op: OPERATION
		do
			if not redo_stk.is_empty then
				-- pop off the operation and move it to the undo stack
				op := redo_stk.item

				redo_stk.remove
				undo_stk.put (op)
				op.redo

				if attached op as oper then
					-- redo the entire state again

					set_msg_str(oper.old_msg)
					set_sts_str(oper.old_status)
					set_board_str(game_board.out)

					if oper.old_status ~ status_m.default_message then
						swap_players
					end
				end
			end
		end


feature --  Queries
	possible_win(letter: STRING; button: INTEGER): BOOLEAN
	do
		if button = 1 then
			if (game_board.board.at (4) ~ letter and game_board.board.at (7) ~ letter) or
				(game_board.board.at (2) ~ letter and game_board.board.at (3) ~ letter) or
				(game_board.board.at (5) ~ letter and game_board.board.at (9) ~ letter)
			then
				Result := true
			end
		elseif button = 2 then
			if (game_board.board.at (1) ~ letter and game_board.board.at (3) ~ letter) or
				(game_board.board.at (5) ~ letter and game_board.board.at (8) ~ letter)
			then
				Result := true
			end
		elseif button = 3 then
			if (game_board.board.at (1) ~ letter and game_board.board.at (2) ~ letter) or
				(game_board.board.at (6) ~ letter and game_board.board.at (9) ~ letter) or
				(game_board.board.at (5) ~ letter and game_board.board.at (7) ~ letter)
			then
				Result := true
			end
		elseif button = 4 then
			if (game_board.board.at (1) ~ letter and game_board.board.at (7) ~ letter) or
				(game_board.board.at (5) ~ letter and game_board.board.at (6) ~ letter)
			then
				Result := true
			end
		elseif button = 5 then
			if (game_board.board.at (2) ~ letter and game_board.board.at (8) ~ letter) or
				(game_board.board.at (4) ~ letter and game_board.board.at (6) ~ letter) or
				(game_board.board.at (1) ~ letter and game_board.board.at (9) ~ letter)
			then
				Result := true
			end
		elseif button = 6 then
			if (game_board.board.at (3) ~ letter and game_board.board.at (9) ~ letter) or
				(game_board.board.at (4) ~ letter and game_board.board.at (5) ~ letter)
			then
				Result := true
			end
		elseif button = 7 then
			if (game_board.board.at (1) ~ letter and game_board.board.at (4) ~ letter) or
				(game_board.board.at (8) ~ letter and game_board.board.at (9) ~ letter) or
				(game_board.board.at (3) ~ letter and game_board.board.at (5) ~ letter)
			then
				Result := true
			end
		elseif button = 8 then
			if (game_board.board.at (2) ~ letter and game_board.board.at (5) ~ letter) or
				(game_board.board.at (7) ~ letter and game_board.board.at (9) ~ letter)
			then
				Result := true
			end
		elseif button = 9 then
			if (game_board.board.at (3) ~ letter and game_board.board.at (6) ~ letter) or
				(game_board.board.at (7) ~ letter and game_board.board.at (8) ~ letter) or
				(game_board.board.at (1) ~ letter and game_board.board.at (5) ~ letter)
			then
				Result := true
			end
		else
			Result := false
		end
	end


feature --setters
	set_game_start (b: BOOLEAN)
	do
		is_game_start := b
	end


	set_game_over (b: BOOLEAN)
	do
		is_game_over := b
	end


	set_msg_str(new_msg: STRING)
	do
		msg_str := new_msg
	end


	set_sts_str(new_msg: STRING)
	do
		sts_str := new_msg
	end

	set_board_str(board: STRING)
	do
		board_str := board
	end

	set_pnames(pname1: STRING; pname2: STRING)
	do
		player1.update_pname (pname1)
		player2.update_pname (pname2)
	end

	set_pt_player(p: PLAYER)
	require
		p = player1 or p = player2
	do
		player_turn := p
	end

	set_first_player(p: PLAYER)
	require
		p = player_turn
	do
		first_player := player_turn
	end

	set_pscore(p: STRING; score: INTEGER)
		require
			p = player1.get_pname or p = player2.get_pname
		do
			if (p = player1.get_pname) then
				p1_score := score
			else
				p2_score := score
			end
		end


	set_pletter(p: PLAYER; letter: STRING)
		require
			(p = player1 or p = player2) and (letter ~ "X" or letter ~ "O")
		do
			if (p = player1) then
				p1_letter := letter
			else
				p2_letter := letter
			end
		ensure
			p1_letter ~ "X" or p2_letter ~ "O"
		end


	increase_pscore(p: PLAYER)
		require
			p = player1 or p = player2
		do
			if (p = player1) then
				set_pscore(player1.get_pname, p1_score + 1)
			else
				set_pscore(player2.get_pname, p2_score + 1)
			end
		ensure
			p1_score = old p1_score + 1 or p2_score = old p2_score + 1
		end


	set_play_button(b: INTEGER)
		require
			game_board.board.valid_index (b)
		do
			button_played := b
		end

	set_undo(op: OPERATION)
		do
			undo_stk.put (op)
		end

	clear_undo
	do
		undo_stk.wipe_out
	ensure
		undo_stk.is_empty
	end


	clear_redo
	do
		redo_stk.wipe_out
	ensure
		redo_stk.is_empty
	end

feature -- getters

	get_pt_letter: STRING
	require
		player_turn = player1 or player_turn = player2
	do
		if (player_turn = player1) then
			Result := p1_letter
		else
			Result := p2_letter
		end
	end


	get_p1_letter: STRING
	require
		player_turn = player1
	do
		Result := p1_letter
	end


	get_p2_letter: STRING
	require
		player_turn = player2
	do
		Result := p2_letter
	end


	get_ptscore: INTEGER
	require
		Current.player_turn = player1 or Current.player_turn = player2
	do
		if (Current.player_turn = player1) then
			Result := p1_score
		else
			Result := p2_score
		end
	end


feature -- Boolean Queries for etf errors

	-- for new_game
	is_valid_name_start(pname: STRING): BOOLEAN
		do
			Result := not pname.is_empty and pname.at (1).is_alpha
		end

	is_diff_names(pname1, pname2: STRING): BOOLEAN
		do
			Result := pname1 /~ pname2 and pname1 /= pname2
		end

	-- for play
	is_pturn(pname: STRING): BOOLEAN
		do
			Result := player_turn.get_pname ~ pname
		end

	is_pexists(pname: STRING): BOOLEAN
		do
			Result := pname ~ player1.get_pname or pname ~ player2.get_pname
		end

	is_btaken(b: INTEGER): BOOLEAN
		do
			Result := game_board.board.at (b) ~ "X" or game_board.board.at (b) ~ "O"
		end

	-- for play_again, redo, undo
	is_game_finished: BOOLEAN
		do
			Result := not is_game_start and then is_game_over
		end

feature -- Commands
	swap_players
	do
		if player_turn = player1 then
			set_pt_player(player2)
		else
			set_pt_player(player1)
		end
	end


feature -- queries
	player_out(p: PLAYER): STRING
		-- New string representation of player's state of the game
		do
			create Result.make_empty
			if (p = player1) then
				Result := p1_score.out + ": score for " + "%"" + player1.get_pname + "%" " + "(as " + p1_letter + ")"
			else
				Result := p2_score.out + ": score for " + "%"" + player2.get_pname + "%" " + "(as " + p2_letter + ")"
			end
		end


	out : STRING
		do
			create Result.make_empty
			Result.append ("  ")
			Result.append (sts_str)
			if (is_game_start = true or is_game_over = true) then
				Result.append(": => ")
			else
				Result.append (":  => ")
			end

			Result.append (msg_str)
			Result.append ("%N")
			Result.append (board_str)
			Result.append (player_out (player1))
			Result.append ("%N")
			Result.append ("  ")
			Result.append (player_out (player2))
		end

end




