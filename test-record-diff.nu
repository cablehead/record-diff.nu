#!/usr/bin/env nu

use std assert
source record-diff.nu

# Function to run the test for record-diff
def test-record-diff [] {
  # Load input fixture records and expected output
  let fixture_records = (open fixture-records.json)
  let expected_diff = (open fixture-records-record-diff.json)

  # Get the two records from fixtures
  let record1 = $fixture_records.0
  let record2 = $fixture_records.1

  # Run record-diff
  let actual_diff = (record-diff $record1 $record2)

  # Sort both expected and actual by key and action for deterministic comparison
  let sorted_expected = ($expected_diff | sort-by key action)
  let sorted_actual = ($actual_diff | sort-by key action)

  # Convert to strings for comparison
  let expected_str = ($sorted_expected | to json)
  let actual_str = ($sorted_actual | to json)

  if $expected_str != $actual_str {
    # Only show output on failure
    print "❌ Test failed!"
    print "\nExpected:"
    print $expected_diff
    print "\nActual:"
    print $actual_diff

    # Exit with error code
    exit 1
  } else {
    # On success, just show the output with no additional text
    $actual_diff
  }
}

# Run the test
test-record-diff
