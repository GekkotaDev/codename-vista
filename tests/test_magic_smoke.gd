extends GdUnitTestSuite

func test_example():
	assert_str("Fail on purpose") \
	.starts_with("Fail")
