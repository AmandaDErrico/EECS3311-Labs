note
	description: "[
			Evaluator for arithmetic expressions involving
			+, -, *, / in REAL_32 arithmetic
			Use Dijsktra's two stack algorithm
			https://algs4.cs.princeton.edu/13stacks/Evaluate.java.html
			
			TBD -- features marked with this are To Be Done
		]"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	EVALUATOR

create
	make

feature {NONE} -- Constructor


	make(stack_type: STRING)
			-- initialize
		require
			stack_type ~ "array" OR stack_type ~ "list"
		do
			if stack_type ~ "array" then
				create {STACK_ARRAY[STRING]}ops.make
				create {STACK_ARRAY[REAL]}vals.make
			else
				check stack_type ~ "list"  end
				create {STACK_LIST[STRING]}ops.make
				create {STACK_LIST[REAL]}vals.make
			end

			error := True
			expression := "None"
		end

feature -- Queries
	ops: ABSTRACT_STACK[STRING]
		-- operations stack
	vals: ABSTRACT_STACK[REAL]
		-- values stack

	expression: STRING
		-- string espression to be evaluated

	value: REAL
		-- value if no error
		require
			not error
		attribute

		end

	error: BOOLEAN
		-- Is there a syntax error in `expression'

	error_string(s:STRING): STRING
			-- Error message if any
		local
			tokenizer: TOKENIZER
		do
			create tokenizer.make
			Result := tokenizer.error_string (s)
		end

	is_valid(s:STRING): BOOLEAN
			-- Is string `s' a valid arithmetic expression?
		local
			tokenizer: TOKENIZER
		do
			create tokenizer.make
			Result := tokenizer.is_arithmetic_expression (s)
		end

	evaluated (s: STRING): REAL
			-- Evaluated arithmetic expression `s'
		require
			valid_expression: is_valid(s)
			--TBD missing precondition
		local
			tokenizer: TOKENIZER;
			token: STRING;
			arr: ARRAY[STRING];
			op: STACK_ARRAY[STRING];
			val: STACK_LIST[REAL];
			l_ops: STRING;
			l_val: REAL
			i: INTEGER
		do
			-- TBD
			-- parse the string into an array, and use that array for tokens
			-- ops and vals are abstract so you cannot make them bc its undefined, but you can make local stacklists and arrays
			-- You cannot label the stack array and list ops and vals bc that is already defined


			-- Command query separation principle: Cannot use class variables vals and tops in a query bc it manipulates
			-- the class vaariables which you don't want -- change commands only in evaluate, your final answer
			create op.make
			create val.make
			create tokenizer.make
			-- parser creates brackets if expression doesn't have any
			arr := tokenizer.get_tokens (s)
			from i := 1
			until i > arr.upper
			loop
				token := arr[i]
				if token ~ "(" then -- do nothing
				elseif token ~ "+" or else token ~ "-" or else token ~ "*" or else token ~ "/" then
					op.push (token)
				elseif token ~ ")" then
					-- You CANNOT do op.pop bc pop is a command (procedure call used as expression). You MUST do op.top bc top is a query that RETURNS
					-- something					
					l_ops := op.top
					op.pop
					l_val := val.top
					val.pop
					if l_ops ~ "+" then
						l_val :=  l_val + val.top
					elseif l_ops ~ "-" then
						l_val := val.top - l_val
					elseif l_ops ~ "*" then
						l_val := l_val * val.top
					elseif l_ops ~ "/" then
						l_val := val.top / l_val
					end
					val.pop
				    -- push new computed REAL value on stack. We finished evaluating an expression within a bracket
				    val.push (l_val)
				else
					-- this is reading through the parsed string and pushing the value and converting it to real
					val.push (token.to_real)
				end
				i := i + 1
			end
			Result := val.top
		end


feature -- Commands
	evaluate (s: STRING)
			-- Evaluate arithmetic expression `s'
		require
			valid_expression: is_valid(s)
			-- TBD proper precondition needed
		local
			tokenizer: TOKENIZER; val: REAL
		do
			-- TBD
			-- Use Dijsktra's two stack algorithm
			expression := s
			error := False
			value := evaluated(expression)
		end


feature {NONE} -- implementation
	-- put your implementation features here

invariant
	consistency1:
		(expression /~ "None") implies (value = evaluated(expression))
		-- not the other way because?
	consistency2:
		(expression /~ "None") = (not error)

end

