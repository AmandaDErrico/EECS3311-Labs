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
			add_violation_case_with_tag ("valid_index_ra", agent t3)
			add_violation_case_with_tag ("node_exists", agent t4)
			add_violation_case_with_tag ("node_exists", agent t5)
			add_violation_case_with_tag ("node_exists", agent t6)
		end

feature -- test out, remove_last and their expected outputs
	t1: BOOLEAN
		local
			list1, arr1: DOUBLY_LINKED_LIST[INTEGER]
		do
			comment("t1: Test add_first, add, add_after by having 8->7->10, respectively")
			create list1.make_empty
			list1.add_first (7)
			list1.add(8, 1)
			list1.add_after (list1.node(2), 10)
			-- should now have 8->7->10
			create arr1.make_from_array (<<8, 7, 10>>)
			Result := list1 ~ arr1
			check Result end
			assert_equal ("list ~ {8,7,10}", list1, arr1)
		end

	t2: BOOLEAN
		local
			list2, arr2: DOUBLY_LINKED_LIST[INTEGER]
		do
			comment("t2: Test remove last node 10")
			create list2.make_empty
			list2.add_last (8)
			list2.add_last (7)
			list2.add_last (10)
			list2.remove_last
			create arr2.make_from_array (<<8, 7>>)
			Result := list2.count = 2
			check Result end
			Result := list2 ~ arr2
			check Result end
			assert_equal("list2 count = 2", list2.count, 2)
			assert_equal("list2 ~ {8,7}", list2, arr2)
		end

feature -- violation cases

	t3 -- testing remove_at valid_index_ra
		local
			list3: DOUBLY_LINKED_LIST[INTEGER]
		do
			comment("t3: remove_at index 4 valid_index precondition violation")
			create list3.make_empty
			list3.add_last (8)
			list3.add_last (7)
			list3.add_last (10)
			list3.remove_at(4)
		end


	t4 -- testing add_before node_exists (header doesn't exist as a node)
		local
			list4: DOUBLY_LINKED_LIST[INTEGER]
		do
			comment("t4: add_before header precondition violation")
			create list4.make_empty
			list4.add_last (8)
			list4.add_before (list4.header, 5)
		end


	t5 -- testing remove node with value 5 for empty list node_exists
		local
			list5: DOUBLY_LINKED_LIST[INTEGER]
			node5: NODE[INTEGER]
		do
			comment("t5: remove node with value 11 node_exists precondition violation")
			create list5.make_empty
			create node5.make (5, Void, Void)
			list5.remove(node5)
		end


	t6 -- testing remove node with value 6 node_exists
		local
			list6: DOUBLY_LINKED_LIST[INTEGER]
			node6: NODE[INTEGER]
		do
			comment("t6: remove node with value 11 node_exists precondition violation")
			create list6.make_empty
			list6.add_last (8)
			list6.add_last (7)
			list6.add_last (10)
			create node6.make (6, Void, Void)
			list6.remove(node6)
		end

end
