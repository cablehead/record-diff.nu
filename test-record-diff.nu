#!/usr/bin/env nu

use std assert
source record-diff.nu

# Load fixture records
let fixture_records = (open fixture-records.json)

# Run tests
def main [] {
  print "Running record-diff tests..."

  test_record_diff

  print "All tests passed!"
}

def test_record_diff [] {
  # Get the two records from fixtures
  let record1 = $fixture_records.0
  let record2 = $fixture_records.1

  # Run record-diff
  let diff_result = record-diff $record1 $record2

  # Expected results
  let expected = [
    {
      key: "ResponderResponseMessageIds"
      action: "added"
      value_before: null
      value_after: ["13234727056#573148067388#2025-04-11T18:07:10.260Z"]
    }
    {
      key: "UpdatedAt"
      action: "modified"
      value_before: "2025-04-11T18:07:10.309Z"
      value_after: "2025-04-11T18:07:33.244Z"
    }
  ]

  # Assert the results match our expectations
  assert equal ($diff_result | length) 2 "Should have 2 differences (1 added, 1 modified)"

  # Check that we have the added field
  let added_field = $diff_result | where action == "added" | get 0?
  assert ($added_field != null) "Should have an added field"
  assert equal $added_field.key "ResponderResponseMessageIds" "Should add ResponderResponseMessageIds"

  # Check that we have the modified field
  let modified_field = $diff_result | where action == "modified" | get 0?
  assert ($modified_field != null) "Should have a modified field"
  assert equal $modified_field.key "UpdatedAt" "Should modify UpdatedAt"
}

# Always run the tests when executed
main
