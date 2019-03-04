Red [
    author: "Nędza Darek"
    license: %license.md
    version: 0.0.1
]
; a-case: [a b]
; b-case: [a b /local c d]
; c-case: [a b /local c d /extern e f]
; d-case: [a b /extern c d /local e f]
; e-case: [a b /extern c d]

tidy-spec: function [spec] [
   ind?: :index?
   local-place: find spec /local
   local-lenth: none
   extern-place: find spec /extern
   extern-lenth: none
   
   case [
    ; a-case:
    all [
        (none? local-place)
        (none? extern-place)
    ][ 
        append spec [/extern /local]
        local-place: back tail spec
        extern-place: back local-place
        local-lenth: 0
        extern-lenth: 0
    ]
    
    ; b-case:
    all [
        (none? extern-place)
        not none? local
    ][
        insert local-place /extern
        extern-place: local-place
        extern-lenth: 0
        
        local-place: next local-place
        local-lenth: (index? tail spec) - (index? local-place) - 1
    ]
    
    ; c-case:
    all [
        (not none? local-place)
        (not none? extern-place)
        ((index? local-place) < (index? extern-place))
    ][        
        local-lenth: (index? extern-place) - (index? local-place) - 1
        move/part local-place (tail spec) (local-lenth + 1)
        local-place: at spec ((index? tail spec) - (local-lenth + 1))
        extern-place: at extern-place (negate (local-lenth + 1))
        extern-lenth: (index? local-place) - (index? extern-place) - 1
    ]
    
    ; d-case:
    all [
        (not none? local-place)
        (not none? extern-place)
        ((index? local-place) > (index? extern-place))
    ][
        local-lenth: (index? tail spec) - (index? local-place) - 1
        extern-lenth: (index? local-place) - (index? extern-place) - 1
    ]
    
    ; e-case:
    all[
        (not none? extern-place)
        (none? local-place)
    ][
        extern-lenth: (index? tail spec) - (index? extern-place) - 1
        append spec /local
        local-place: back tail spec
        local-lenth: 0
    ]
   ]
   
   m: #()
   m/extern-place: extern-place
   m/extern-length: extern-lenth
   m/local-place:  local-place
   m/local-length:  local-lenth
   m/spec: spec
   return m
]

; make proper tests from this code:
; a-case: [a b]
; tidy-spec a-case

; b-case: [a b /local c d]
; tidy-spec b-case

; c-case: [a b /local c d /extern e f]
; tidy-spec c-case

; d-case: [a b /extern c d /local e f]
; tidy-spec d-case

; e-case: [a b /extern c d]
; tidy-spec e-case