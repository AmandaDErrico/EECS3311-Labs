note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	TIC_TAC_TOE_ACCESS

feature
	m: TIC_TAC_TOE
		once
			create Result.make
		end

invariant
	m = m
end




