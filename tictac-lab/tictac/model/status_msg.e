note
	description: "Display the error or no error status of the tictactoe game state."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATUS_MSG

create
	make_str

feature

	make_str
	do
	end

feature -- status messages

	default_message: STRING = "ok"

	diff: STRING = "names of players must be different"

	name_start: STRING = "name must start with A-Z or a-z"

	not_turn: STRING = "not this player's turn"

	no_player: STRING = "no such player"

	taken: STRING = "button already taken"

	win: STRING = "there is a winner"

	finish_game: STRING = "finish this game first"

	game_finished: STRING = "game is finished"

	tie: STRING = "game ended in a tie"

end
