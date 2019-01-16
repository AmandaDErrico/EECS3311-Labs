note
	description: "[
		STACK_LIST inherits complete contracts from ABTSRACT_STACK
		implemented with an ARRAY testable via ES_TEST
		  implementation: LIST [G]
		top of the stack is first element of the list
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STACK_LIST [G -> attached ANY]
inherit
	ANY
		undefine is_equal end
	ABSTRACT_STACK[G]
		redefine count end


create
	make

feature {NONE,ES_TEST} -- creation
	implementation: LINKED_LIST [G]
		-- implementation of stack as list

	make
			-- create an empty stack
			-- require done in abstract class
		do
			create implementation.make
			-- TBD
			implementation.compare_objects

		end

feature -- model

	model: SEQ [G]
			-- abstraction function
			-- The model is responsible for how the stack will be perceived.
		do
			create Result.make_empty
			-- TBD
			-- Result.make_empty bc whatever type SEQ[G] is. Calling model.make_empty is recursive.

			across
				implementation as index
			loop
				-- index.item is token
				Result.append (index.item)
			end
		end

feature -- Queries

	count: INTEGER
			 -- number of items in stack
		do
			-- TBD
			Result := implementation.count
		end

	top: G
		do
			--Result := implementation [implementation.count]
			-- the above may not be correct

			-- TBD
			Result := implementation [implementation.lower]

		end

feature -- Commands

	-- these are exclusevely in Linked List, put_front as seen in invariant comment and remove and going to start is only in LL
	push (x: G)
			-- push `x' on to the stack
		do
			-- TBD
			implementation.put_front (x)
		end

	pop
		do
			-- TBD
			--go to first position and remove
			implementation.start
			implementation.remove
		end

invariant
	same_count:
		model.count = implementation.count
	equality: across 1 |..| count as i all
		model[i.item] ~ implementation[i.item]
	end
	comment("top of stack is model[1] and implementation[1]")
end
