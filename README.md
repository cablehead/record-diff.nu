# record-diff.nu

A Nushell module for comparing two records and identifying nested differences with detailed change information. Makes differences in records human comprehensible.

## Installation

```nushell
do { $NU_LIB_DIRS | input list "Select module directory" | cd $in ; git clone https://github.com/cablehead/record-diff.nu }
```

## Update

```nushell
cd to module directory ; git pull
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
