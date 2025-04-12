def record-diff [
    record1: record  # First record to compare
    record2: record  # Second record to compare
] -> table {
    # Convert both records to tables of key-value pairs
    let keys1 = ($record1 | columns)
    let keys2 = ($record2 | columns)
                                                                                                                                                                                                                                 
    # Find all unique keys across both records
    let all_keys = (($keys1 | append $keys2) | uniq)
                                                                                                                                                                                                                                 
    # Initialize our results table
    mut results = []
                                                                                                                                                                                                                                 
    # Check for modified values
    for key in ($keys1 | where {|k| $k in $keys2}) {
        if $record1 | get $key != $record2 | get $key {
            $results = ($results | append {
                key: $key
                action: "modified"
                value_before: ($record1 | get $key)
                value_after: ($record2 | get $key)
            })
        }
    }
                                                                                                                                                                                                                                 
    # Check for removed keys
    for key in ($keys1 | where {|k| $k not-in $keys2}) {
        $results = ($results | append {
            key: $key
            action: "removed"
            value_before: ($record1 | get $key)
            value_after: null
        })
    }
                                                                                                                                                                                                                                 
    # Check for added keys
    for key in ($keys2 | where {|k| $k not-in $keys1}) {
        $results = ($results | append {
            key: $key
            action: "added"
            value_before: null
            value_after: ($record2 | get $key)
        })
    }
                                                                                                                                                                                                                                 
    $results
}
