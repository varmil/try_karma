describe 'TestSample>', ->
    describe 'Logic>', ->
        it 'multiNumber', ->
            target = new Logic()
            num = 3
            expected = 9

            result = target.squaredNumber(num)

            expect(expected).toEqual(result)