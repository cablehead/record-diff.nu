# record-diff.nu

A Nushell module for comparing two records and identifying nested differences
with detailed change information. Makes differences in records human
comprehensible.

## Installation

```nushell
do {
  # Select one of your module paths to install the module
  ($NU_LIB_DIRS | default []) ++ ($env.NU_LIB_DIRS? | default []) | uniq | input list "Clone to" | cd $in
  git clone https://github.com/cablehead/record-diff.nu ./record-diff
  "ready:\nuse record-diff"
}
```

## Update

```nushell
do {
  # Locate the current install
  ($NU_LIB_DIRS | default []) ++ ($env.NU_LIB_DIRS? | default []) | each { path join "record-diff" } | where { path exists } | first | cd $in
  # And update
  git pull
}
```

## Usage

```nushell
use record-diff

$ record-diff {user: {name: "Bob"}} {user: {name: "Bob" email: "bob@example.com"}}

─#─┬────key─────┬─action─┬─value_before─┬───value_after───
 0 │ user.email │ added  │              │ bob@example.com
───┴────────────┴────────┴──────────────┴─────────────────
```

## Testing

```
./test.nu
```
