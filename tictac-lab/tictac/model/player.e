note
	description: "Summary description for {PLAYER} and their letter and score."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER
	inherit ANY
		redefine out
	end

create
	make_player

feature {NONE} -- Implementation
	make_player
	do
		set_new_pname
	end


feature -- constants
	player_name: STRING


feature -- setters
	set_new_pname
	do
		create player_name.make_empty
	end


	update_pname(name: STRING)
	do
		player_name := name

	end


feature -- getters
	get_pname: STRING
	do
		Result := player_name
	end


feature -- String representation
	out: STRING
		-- New string representation of player
		local
			p: PLAYER
		do
			create Result.make_empty
			check attached p as player then
				Result := player.get_pname
			end
		end
end
