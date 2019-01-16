note
	description: "Deferred class for Operation."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATION

feature
	execute
	deferred
	end

	undo
	deferred
	end

	redo
	deferred
	end

feature -- helper functions

	set_old_gmsg(msg: STRING)
		do
			old_msg := msg
		end

	set_old_sts(msg: STRING)
		do
			old_status := msg
		end

feature -- attributes
	old_status, old_msg: STRING

end
