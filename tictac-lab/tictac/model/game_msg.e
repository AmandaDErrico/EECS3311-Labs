note
	description: "Summary description for {GAME_MSG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MSG

create
	make_g

feature

	make_g
	do
	end

feature

	new_game: STRING = "start new game"

	new_or_again: STRING = "play again or start new game"

	player_next (p: PLAYER): STRING
		do
			create Result.make_empty
			Result := p.get_pname + " plays next"
		end

end


