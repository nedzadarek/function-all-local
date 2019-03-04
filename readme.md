# function-all-local
Function constructor that "makes most words local".
Includes:
- things covered by the `function` (`set-words` and 3 exceptions)
- `set X 'value`
- `parse`'s `copy` and `set`

Excludes:
- words in the extern group (`function [/extern ...]`)

# Usage:

Same as with the `function` (`function-all-local [a b /local c d /extern e f][...]`). See [tests](/tests/main.red)  for more.

# License:

See [license.md](license.md).
