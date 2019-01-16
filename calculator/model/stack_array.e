note
	description: "[
		STACK_ARRAY inherits complete contracts from ABTSRACT_STACK
		implemented with an ARRAY testable via ES_TEST
		  implementation: ARRAY [G]
		top of the stack is last element of the array
		
		TBD marks the places to be done
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STACK_ARRAY [G -> attached ANY]

inherit

	ANY
		undefine
			is_equal
		end

	ABSTRACT_STACK [G]
		redefine
			count
		end

create
	make

feature {NONE, ES_TEST} -- creation

	implementation: ARRAY [G]
			-- implementation of stack as array

	make
			-- create an empty stack
		do
			create implementation.make_empty
			--TBD
			implementation.compare_objects
		end

feature -- model

	model: SEQ [G]
			-- abstraction function
		local
			i: INTEGER
		do
			create Result.make_empty
			-- TBD
			across
				implementation as index
			loop
				-- index.item is token
				Result.prepend (index.item)
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
			--Result := implementation [1]
			-- the above may not be correct

			--TBD
			Result := implementation [implementation.upper]
		end

feature -- Commands

	-- these operate on the implementation, adding to the last like an array (force and remove_tail only in array)
	push (x: G)
			-- push `x' on to the stack
		do
			-- TBD
			implementation.force(x, count+1)

		end

	pop
		do
			-- TBD
			implementation.remove_tail (1)
		end

invariant
	same_count:
		model.count = implementation.count
	equality:
		across 1 |..| count as i all model [i.item] ~ implementation [count + 1 - i.item] end
	comment ("top of stack is model[1] and implementation[count]")

end
