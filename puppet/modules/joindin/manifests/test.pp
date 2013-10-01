class joindin::test ($tests = false) {

    # only include the test suite if required
    if $tests == true {
        include joindin::test::test
    }

}
