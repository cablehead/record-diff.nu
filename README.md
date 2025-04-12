# record-diff.nu

A Nushell module for comparing two records and identifying nested differences with detailed change information. Makes differences in records human comprehensible.

## Installation

```nushell
http get https://raw.githubusercontent.com/cablehead/record-diff.nu/main/record-diff.nu | save -f record-diff.nu
```

Then add it to your Nushell scripts with `use record-diff.nu`

## Usage

```nushell
use record-diff.nu

$ record-diff {user: {name: "Bob"}} {user: {name: "Bob" email: "bob@example.com"}}

─#─┬────key─────┬─action─┬─value_before─┬───value_after───
 0 │ user.email │ added  │              │ bob@example.com
───┴────────────┴────────┴──────────────┴─────────────────
```

## Testing

```
./test-record-diff.nu
```
