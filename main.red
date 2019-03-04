Red [
    author: "Nędza Darek"
    license: %license.md
    version: 0.0.1
]
do %tidy-spec.red

function-all-local: function [spec body][
    ; extern/local groups:
    m: tidy-spec spec
    ; #(
        ; extern-place: [/extern c d /local]
        ; extern-lenth: 2
        ; local-place: [/local]
        ; local-lenth: 0
        ; spec: [a b /extern c d /local]
    ; )
    local-group: copy/part (next m/local-place) m/local-length
    extern-group: copy/part (next m/extern-place) m/extern-length
    local-place: next m/local-place
    extern-place: next m/extern-place
    ; PARSE RULES: 
    parse-block-rule: [
        [ ahead block! into parse-block-rule ]
        | any [['set | 'copy] keep word! skip]
        | skip
    ]
    parse-rule: [
        'parse
        skip
        ahead block! into [any parse-block-rule]
    ]
    set-rule: [
        'set
        set l lit-word! keep (to-word l)
        skip ; value
    ]
    complex-rule: [
        any [
            parse-rule 
            | set-rule
            | ahead block! into complex-rule
            | skip
        ]
    ]  
    
    ; collecting local words:
    local-words-candidates: parse body [collect complex-rule]
    ; remove words that are...
    remove-each word local-words-candidates [
        case [
            ; duplicated local words:
            f: find local-group word   [true]
            ; words that shouldn't be local - in an extern group
            find extern-group word  [true]
        ] 
    ]

    local-words-candidates
    
    insert local-place local-words-candidates
    return function spec body
]