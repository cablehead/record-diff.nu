# record-diff.nu

A Nushell module for comparing two records and identifying nested differences with detailed change information. Makes differences in records human comprehensible.

## Installation

```nushell
do {
  ($NU_LIB_DIRS | default []) ++ ($env.NU_LIB_DIRS? | default [])  | uniq | input list "Clone to" | cd $in
  git clone https://github.com/cablehead/record-diff.nu ./record-diff
}
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
