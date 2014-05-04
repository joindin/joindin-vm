class joindin::test ($tests = true) {

    # only include the test suite if required
    if $tests == true {
        include joindin::test::test
    }

}
