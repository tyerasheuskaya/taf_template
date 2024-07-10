from hamcrest import assert_that, equal_to, greater_than


def assert_lists_are_equal(list1, list2):
    assert_that(list1, equal_to(list2),
                f'The lists difference is: {str(set(list1) - set(list2))}, {str(set(list2) - set(list1))}')


def assert_greater_than(actual, expected):
    assert_that(actual, greater_than(expected))
