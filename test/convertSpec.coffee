define ['convert'], (Convert) ->
	describe 'Convert', ->
		it 'converts numbers to string', ->
			c = new Convert()
			n = 42
			s = c.numberToString n
			expect(s).toEqual "2.625"

			