note
	description: "An board with size bsize x bsize."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOARD
	inherit ANY
		redefine out
	end

create
	make_board

feature {NONE}
	make_board (size: INTEGER)
	do
		set_bsize(size)
		create board.make_filled("_", bsize, bsize)
	end


feature -- atttributes
	board: ARRAY2[STRING]
	bsize: INTEGER

feature -- setters
	set_bsize (size: INTEGER)
		do
			bsize := size
		end


feature -- getters
	get_bsize: INTEGER
		do
			Result := bsize
		end

feature {PLAY_OPER, TIC_TAC_TOE, ETF_PLAY} -- helpers for the PLAY_OPER class
	almost_cap: BOOLEAN
		-- only one space available
		local
			cap, i: INTEGER
		do
			from
				i := 1
			until
				i = bsize * bsize
			loop
				if board.at (i) /~ "_" then
					cap := cap + 1
				end
				i := i + 1
			end
			Result := cap = bsize*bsize - 1
		end


	update_board(b: STRING)
		-- performed after an redo so the board resets to the current state. Change string b to board b
		local
			s: STRING
			i, j: INTEGER
		do
			-- s will be string without newlines
			create s.make_empty
			from
				j := b.lower
			until
				j > b.count
			loop
				if b.at (j) ~ '_' or b.at (j) ~ 'X' or b.at (j) ~ 'O' then
					s.append (b.at (j).out)
				end
				j := j + 1
			end

			-- check if the item in board isn't equal to the new board's item (character in string s)
			from
				i := board.lower
			until
				i > board.upper
			loop
				if board.at (i) /~ s.at (i).out then
					-- update the board
					board.enter (s.at (i).out, i)
				end
				i := i + 1
			end
		end

feature -- String representation
	out: STRING
			-- New string representing 3x3 board with "_" or "X" or "O" in its place
		local
			i: INTEGER
		do
			create Result.make_empty
			Result.append ("  ")
			from
				i := board.lower
			until
				i > board.upper
			loop
				if (i\\bsize = 0) then
					Result.append(board.at (i) + "%N")
					Result.append ("  ")
				else
					Result.append(board.at (i))
				end
				i := i + 1
			end
		end
end
