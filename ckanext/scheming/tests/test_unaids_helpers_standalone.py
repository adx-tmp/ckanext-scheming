"""
Standalone unit tests for UNAIDS helpers
These tests can run without CKAN installation
"""
import pytest


def comma_swap_formatter(input):
    """
    Swaps the parts of a string around a single comma.
    Use to format e.g. "Tanzania, Republic of" as "Republic of Tanzania"
    """
    if input.count(',') == 1:
        parts = input.split(',')
        stripped_parts = list(map(lambda x: x.strip(), parts))
        reversed_parts = reversed(stripped_parts)
        joined_parts = " ".join(reversed_parts)
        return joined_parts
    else:
        return input


def lower_formatter(input):
    return input.lower()


@pytest.mark.parametrize("input_str,expected", [
    ("no_commas", "no_commas"),
    ("comma,split", "split comma"),
    ("Tanzania, Republic of", "Republic of Tanzania"),
    ("Multiple, commas, here", "Multiple, commas, here"),  # More than one comma
    ("", ""),  # Empty string
])
def test_comma_swap_formatter(input_str, expected):
    """Test comma swap formatter with various inputs"""
    actual = comma_swap_formatter(input_str)
    assert actual == expected


@pytest.mark.parametrize("input_str,expected", [
    ("HELLO", "hello"),
    ("MixedCase", "mixedcase"),
    ("already_lower", "already_lower"),
])
def test_lower_formatter(input_str, expected):
    """Test lower formatter"""
    actual = lower_formatter(input_str)
    assert actual == expected
