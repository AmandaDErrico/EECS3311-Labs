note
	description: "Summary description for {STUDENT_TESTS}. Amanda D'Errico's unittests"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS
inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
			add_boolean_case (agent t9)
		--	add_boolean_case (agent t10)

			--violation cases
		--	add_violation_case (agent t8)
		--	add_violation_case (agent t10)
		--	add_violation_case (agent t11)
		--	add_violation_case_with_tag ("valid_expression", agent t10)
		--	add_violation_case_with_tag ("valid_expression", agent t11)
		end

feature -- tests
	t1: BOOLEAN
	-- Checks if a Player is created appropriately
		local
			p1, p2: PLAYER
		do
			comment("t1: Create Player with name and letter")
			create p1.make_player
			create p2.make_player
			Result := p1.get_pname ~ "" and p2.get_pname ~ ""
--			Result := p1.get_pletter = "X" and p2.get_pletter = "O"
--			Result := p1.get_pscore = 0 and p2.get_pscore = 0
			check Result end
		end


	t2: BOOLEAN
	-- Checks if a board is created appropriately with its bsize
		local
			b: BOARD
		do
			comment("t2: Create board with its size and check if bsize matches")
			create b.make_board (3)
			Result := b.get_bsize = 3
			check Result end
		end


	t3: BOOLEAN
	-- Checks if a board is created with appropriate string rep
		local
			b: BOARD
		do
			comment("t3: Create board with its string representation")
			create b.make_board (3)
			Result := b.out ~ "  ___%N  ___%N  ___%N  "
			check Result end
		end


	t4: BOOLEAN
	-- Checks if a Player is created appropriately with empty string and "Amanda"
		local
			p1: PLAYER
			s: STRING
		do
			comment("t4: Create Player with name and letter and check its exact name. Also check if it reads name as %"Amanda%".")
			create p1.make_player
			create s.make_empty
			Result := p1.get_pname = s --reference type
			p1.update_pname ("Amanda")
			Result := p1.get_pname ~ "Amanda"
			check Result end
		end

	t5: BOOLEAN
	-- Checks if a game is created appropriately with its empty string and "Amanda" and "pname2"
		local
			g: TIC_TAC_TOE
		do
			comment("t5: Create Player with name and letter and check its exact name, and %"Amanda%". Also check if the game message reads correctly.")
			create g.make
			Result := g.player_out (g.player1) ~ "0: score for %"%" (as X)"
			g.set_pnames ("Amanda", "pname2")
			Result := g.player_out (g.player1) ~ "0: score for %"Amanda%" (as X)"
			Result := g.player_out (g.player2) ~ "0: score for %"pname2%" (as O)"
			check Result end
		end


	t6: BOOLEAN
	-- Checks all queries made in TIC_TAC_TOE
		local
			g: TIC_TAC_TOE
		do
			comment("t6: Check all queries made in tictactoe")
			create g.make
			Result := g.is_valid_name_start ("Amanda") and g.is_diff_names ("Amanda", "Mike")
			check Result end
		end


	t7: BOOLEAN
	-- Checks twowaylist players and player which is its turn
		local
			g: TIC_TAC_TOE
		do
			comment("t7: Check initial game initialization")
			create g.make
			Result := g.player_turn ~ g.player1 and g.player_turn = g.player1
			check Result end
		end


--	t8: BOOLEAN
--	-- Checks initialization for new game oper
--		local
--			ng: NEW_GAME_OPER
--			g: TIC_TAC_TOE
--		do
--			comment("t8: Check if initialization is correct in new_game_oper class")
--			create g.make
--			create ng.make_ng (g, "Amanda", "Mike")
--			g.player1.update_pname ("Amanda")
--			Result := ng.get_player1.get_pname ~ "Amanda" and g.player1.get_pname ~ "Amanda" and ng.get_player1 = g.player1
--			check Result end
--		end


--	t8: BOOLEAN
--	-- Checks execute for new game oper
--		local
--			ng: NEW_GAME_OPER
--			g: TIC_TAC_TOE
--		do
--			comment("t8: Check if execute method is correct in new_game_oper class")
--			create g.make
--			create ng.make_ng (g, "Amanda", "Mike")
--			ng.execute
--			Result := ng ~ "Amanda" --and g.player1.get_pname = "Amanda" and g.player2.get_pname ~ "Mike"
--			check Result end
--		end

	t8: BOOLEAN
	-- Checks new_game in tictactoe
		local
			g: TIC_TAC_TOE
			m: GAME_MSG
		do
			comment("t8: Check string output for tictactoe class after new_game")
			create g.make
			g.new_game ("Amanda", "Mike")
			Result := g.is_game_start = true
				and g.player1.get_pname ~ "Amanda" and g.player_turn ~ g.player1 and g.player2.get_pname ~ "Mike" and g.sts_str ~ "ok"
			Result := g.player_turn.get_pname ~ "Amanda"
			Result := g.msg_str ~ "Amanda plays next"
			Result := g.undo_stk.is_empty and g.redo_stk.is_empty
			Result := g.game_board.out ~ "___%N  ___%N  ___%N"
			Result := g.out ~ "  ok: => Amanda plays next%N  ___%N  ___%N  ___%N  0: score for %"Amanda%" (as X)%N  0: score for %"Mike%" (as O)"
			check Result end
		end

	t9: BOOLEAN
	-- Checks player_turn's letter and score, and checks again after swap
		local
			g: TIC_TAC_TOE
		do
			comment("Checks player_turn's letter and score, and checks again after swap")
			create g.make
			g.increase_pscore (g.player_turn)
			Result := g.get_pt_letter ~ "X" and g.get_ptscore = 1
			g.swap_players
			g.increase_pscore (g.player_turn)
			g.increase_pscore (g.player_turn)
			Result := g.get_pt_letter ~ "O" and g.get_ptscore = 2
			check Result end
		end


--	t10: BOOLEAN
--	-- Checks get_coords in board class
--		local
--			b: BOARD
--		do
--			comment("t10: Check get_coords in board class")
--			create b.make_board (3)
--			b.board.enter ("X", 4)
--			Result := b.get_coords (2)
--			check Result end
--		end

--	t9: BOOLEAN
--	-- Checks error for new_game
--		local
--			g: TIC_TAC_TOE
--		do
--			comment("t9: Check error message for initializing with same name")
--			create g.make
--			g.new_game ("Amanda", "Amanda")
--			Result := g.sts_str ~ g.status_m.diff --g.sts_str ~ "names of players must be different"

--			check Result end
--		end

--	t10: BOOLEAN
--	-- Checks new_game in tictactoe
--		local
--			p: PLAYER
--		do
--			comment("t10: Check string output for tictactoe class after new_game")
--			create
--			g.new_game ("Amanda", "Mike")
--			Result := g.is_game_start = true and g.player1.get_pname = "Amanda" --and g.player_turn = "Amanda" --and g.player2.get_pname ~ "Mike" and g.sts_str ~ "ok" and g.msg_str ~ "Amanda plays next"
--			--	and g.out ~ "  ok: => Amanda plays next%N  ___%N  ___%N  ___%N  0: score for %"Amanda%" (as X)%N  0: score for %"Mike%" (as O)%N"
--			check Result end
--		end


feature -- violations
--	t11
--		local
--			p1: PLAYER
--			g: TICTACTOE
--		do
--			comment("t11: Create player with empty string name and letter %"Y%". Bad syntax: letter must be %"X%" or %"O%"")
--			create p1.make_player
--			create g.make
--			
--			
--		end


--	t9
--		local
--			p1: PLAYER
--		do
--			comment("t9: Create player with invalid name: Invalid name, must not start with non alpha character")
--			create p1.make_player("X", 0)
--		end

end
