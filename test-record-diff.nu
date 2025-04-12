#!/usr/bin/env nu

use std assert
use record-diff.nu

# Function to load all the fixture directories and their input/output files
def get-fixtures [] {
  ls -d fixtures/* | each {|dir|
    let slug = ($dir.name | path basename)
    let input_path = ($dir.name | path join "input.json")
    let output_path = ($dir.name | path join "output.json")
    
    {
      slug: $slug
      input: (open $input_path)
      output: (open $output_path)
    }
  }
}

# Function to run all fixture tests
def test-record-diff-fixtures [] {
  let fixtures = (get-fixtures)
  
  mut failures = 0
  
  for fixture in $fixtures {
    print $"Running test: ($fixture.slug)"
    
    # Get the two records from the fixture
    let record1 = $fixture.input.0
    let record2 = $fixture.input.1
    
    # Run record-diff
    let actual_diff = (record-diff $record1 $record2)
    
    # Sort both expected and actual by key and action for deterministic comparison
    let sorted_expected = ($fixture.output | sort-by key action)
    let sorted_actual = ($actual_diff | sort-by key action)
    
    # Convert to strings for comparison
    let expected_str = ($sorted_expected | to json)
    let actual_str = ($sorted_actual | to json)
    
    if $expected_str != $actual_str {
      # Only show output on failure
      print $"  ❌ Test ($fixture.slug) failed!"
      print "\n  Expected:"
      print $fixture.output
      print "\n  Actual:"
      print $actual_diff
      
      $failures = $failures + 1
    } else {
      print $"  ✓ Test ($fixture.slug) passed!"
    }
  }
  
  if $failures > 0 {
    print $"\n($failures) fixture tests failed!"
    exit 1
  } else {
    print "\nAll fixture tests passed!"
  }
}

# Run the tests
test-record-diff-fixtures