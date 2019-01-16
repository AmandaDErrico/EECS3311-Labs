note
	description: "Summary description for {STUDENT_TESTS}."
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

			--violation cases
			add_violation_case_with_tag ("valid_expression", agent t8)
			add_violation_case_with_tag ("valid_expression", agent t9)
			add_violation_case_with_tag ("valid_expression", agent t10)
			add_violation_case_with_tag ("valid_expression", agent t11)
		end

feature -- tests
	t1: BOOLEAN
	-- the parser puts brackets around negative real numbers and gives priority for operators. This is why evaluate doesn't give
	-- error for bad syntax.
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t1: Evaluate %"( -3 - 2 )%" and %"( 2 - -3 )%" with list")
			l_exp := "( -3 - 2 )"
			create e.make("list")
			e.evaluate(l_exp)
			Result := e.value = -5 and not e.error
			check Result end

			l_exp := "( 2 - -3 )"
			e.evaluate(l_exp)
			assert_equal ("e.value is 5", "5", e.value.out)
		end


	t2: BOOLEAN
		local
			l_exp: STRING
			e: EVALUATOR

		do
			comment("t2: Evaluate %"( ( 2 - -3 ) - ( -3 - 2 ) )%" with array")
			l_exp := "( ( 2 - -3 ) - ( -3 - 2 ) )"
			create e.make("array")
			e.evaluate(l_exp)
			Result := e.value = 10 and not e.error
			check Result end
		end


	t3: BOOLEAN
		local
			l_exp: STRING
			e: EVALUATOR

		do
			comment("t3: Evaluate %"( 9 + (- 7) )%" with array")
			l_exp := "( 9 + (- 7) )"
			create e.make("array")
			e.evaluate(l_exp)
			Result := e.value = 2 and not e.error
			check Result end
		end


	t4: BOOLEAN
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t4: Evaluate %"( 9 -- 7 )%" with array")
			l_exp := "( 9 -- 7 )"
			create e.make("array")
			e.evaluate(l_exp)
			Result := e.value = 16 and not e.error
			check Result end
		end


	t5: BOOLEAN
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t5: Evaluate %"9 -- 7%" and %"9 -- 2 * 2%" with list: Parser puts brackets around values and gives priority for operators")

			l_exp := "9 -- 7"
			create e.make("list")
			e.evaluate(l_exp)
			Result := e.value = 16 and not e.error
			check Result end

			l_exp := "9 -- 2 * 2"
			e.evaluate(l_exp)
			Result := e.value = 13 and not e.error
			check Result end
		end


	t6: BOOLEAN
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t6: Evaluate %"( ( 3 + 5 ) * ( 2 - 1 ) ) + 6%" with array")
			l_exp := "( ( 3 + 5 ) * ( 2 - 1 ) ) + 6"
			create e.make("array")
			e.evaluate(l_exp)
			Result := e.value = 14 and not e.error
			check Result end
		end


	t7: BOOLEAN -- parser doesn't need to add brackets, its an array of size 1
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t7: Evaluate %"16.2%" with list: Only one token in its array")

			l_exp := "16.2"
			create e.make("list")
			e.evaluate(l_exp)
			Result := e.value = 16.2 and not e.error
			check Result end

		end


feature -- violations
	t8
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t8: Evaluate %"3 ( 2 + 5 )%" with list. Bad syntax: no operator between 3 and (")
			l_exp := "3 ( 2 + 5 )"
			create e.make("list")
			e.evaluate(l_exp)
		end


	t9
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t9: Evaluate %"( 3 * ( 2 ! 5 ) )%" with array. Bad syntax: %"!%" does not exist in the calculator")
			l_exp := "( 3 * ( 2 ! 5 ) )"
			create e.make("array")
			e.evaluate(l_exp)
		end


	t10
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t10: Evaluate %"( 3 3 - )%" with array. Bad syntax: Not a rpn calculator, operates like a regular calculator.")
			l_exp := "( 3 3 - )"
			create e.make("array")
			e.evaluate(l_exp)
		end


	t11 -- bc not mathematically correct in parsing to add positive 7 as +7, you would have to convert it back to 7
		local
			l_exp: STRING
			e: EVALUATOR
		do
			comment("t11: Evaluate %"( 9 ++ 7 )%" with list. Precondition of `evaluate' violated due to '++'.")
			l_exp := "( 9 ++ 7 )"
			create e.make("list")
			e.evaluate(l_exp)
		end


end
