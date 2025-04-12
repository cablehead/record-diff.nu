def record-diff [
    record1: record  # First record to compare
    record2: record  # Second record to compare
] {
    # For top-level records, start with an empty prefix
    diff-records-deep $record1 $record2 ""
}

# Recursively compare records and find the deepest specific changes
def diff-records-deep [
    rec1: record      # First record to compare
    rec2: record      # Second record to compare
    prefix: string    # Current key path prefix (e.g., "customer.contact")
] {
    # Get all keys from both records
    let keys1 = ($rec1 | columns)
    let keys2 = ($rec2 | columns)
    
    # Initialize results collection
    mut results = []
    
    # Find keys that exist in both records and compare their values
    for key in ($keys1 | where {|k| $k in $keys2}) {
        let val1 = ($rec1 | get $key)
        let val2 = ($rec2 | get $key)
        
        # If values are different
        if $val1 != $val2 {
            # Form the key path for this comparison
            let key_path = if $prefix == "" { $key } else { $"($prefix).($key)" }
            
            # Check types of values to determine how to compare
            let type1 = ($val1 | describe -d | get type)
            let type2 = ($val2 | describe -d | get type)
            
            if $type1 == "record" and $type2 == "record" {
                # Both values are records - recursively compare them
                let nested_diffs = (diff-records-deep $val1 $val2 $key_path)
                
                # If there are nested diffs, append them
                # Otherwise report a change at this level
                if ($nested_diffs | length) > 0 {
                    $results = ($results | append $nested_diffs)
                } else {
                    # Records are different but no specific nested diffs found
                    $results = ($results | append {
                        key: $key_path
                        action: "modified"
                        value_before: $val1
                        value_after: $val2
                    })
                }
            } else {
                # For all other types, report as a direct modification
                $results = ($results | append {
                    key: $key_path
                    action: "modified"
                    value_before: $val1
                    value_after: $val2
                })
            }
        }
    }
    
    # Find keys that were removed (in rec1 but not in rec2)
    for key in ($keys1 | where {|k| $k not-in $keys2}) {
        let key_path = if $prefix == "" { $key } else { $"($prefix).($key)" }
        $results = ($results | append {
            key: $key_path
            action: "removed"
            value_before: ($rec1 | get $key)
            value_after: null
        })
    }
    
    # Find keys that were added (in rec2 but not in rec1)
    for key in ($keys2 | where {|k| $k not-in $keys1}) {
        let key_path = if $prefix == "" { $key } else { $"($prefix).($key)" }
        $results = ($results | append {
            key: $key_path
            action: "added"
            value_before: null
            value_after: ($rec2 | get $key)
        })
    }
    
    $results
}