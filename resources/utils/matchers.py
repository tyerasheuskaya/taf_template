from datetime import datetime

from hamcrest import assert_that, equal_to, greater_than, has_length
import pandas


def assert_lists_are_equal(list1, list2):
    assert_that(list1, equal_to(list2),
                f'The lists difference is: {str(set(list1) - set(list2))}, {str(set(list2) - set(list1))}')


def assert_greater_than(actual, expected):
    assert_that(actual, greater_than(expected))


def read_csv_file(path):
    return pandas.read_csv(path)


def compare_data(actual, expected):
    actual = [[column.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3] if isinstance(column, datetime)
               else column for column in row] for row in actual]
    expected = expected.values.tolist()
    differences = []
    for row1, row2 in zip(actual, expected):
        if row1 != row2:
            differences.append((row1, row2))
    assert_that(differences, has_length(0))
