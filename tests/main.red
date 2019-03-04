Red [
    author: "Nędza Darek"
    license: %license.md
    version: 0.0.1
]
do %../main.red

body:[ 
    "some code here"
    parse
    [value1 value2] 
    [
      set w1 word!
      [set w2 'value2]

    ]
    [other code]
    'another
    parse [v1 v2] [
        [set w3 word!]
        set w4 word!
    ]
    'something
    
    do [
        set 'w5 'value
        parse [21] [set w6 integer!]
    ]
    do [
        do [
            set 'w7 'v
            parse [42] [
                copy w8 integer!
            ]
            set 'w9 'val
        ] 
    ]
    
    reduce [w1 w2 w3 w4 w5 w6 w7 w8 w9]
] 


print "F1:  #################" 
unset [w1 w2 w3 w4 w5 w6 w7 w8 w9]
f1: function-all-local [] body
either [/local w1 w2 w3 w4 w5 w6 w7 w8 w9] = spec-of :f1 [
        print "[/local w1 w2 w3 w4 w5 w6 w7 w8 w9] >> are equal" 
    ] [
        print "[/local w1 w2 w3 w4 w5 w6 w7 w8 w9] >> are NOT equal" 
    ]
values?: function [
    {Returns a block with true/false value evaluated from calling `value? X` on each word in the block}
    values [block! ] "Block that contains `word!` values"
] [
    collect [
        foreach word values [
            keep value? word
        ]
    ]
]
f1
localed-words: [w1 w2 w3 w4 w5 w6 w7 w8 w9]
either any v: values? localed-words  [
    print "Some values are not local"
    probe localed-words
    probe v
][
    print "All values are local"
]

print "F2: #################"
unset [w1 w2 w3 w4 w5 w6 w7 w8 w9]
f2: function-all-local [/extern w5] body
either [/local w1 w2 w3 w4 w6 w7 w8 w9] = spec-of :f2 [
        print "[/local w1 w2 w3 w4 w6 w7 w8 w9] >> are equal" 
][
        print "[/local w1 w2 w3 w4 w6 w7 w8 w9] >> are NOT equal" 
]
    
f2    
externed-word: 'w5 
localed-words: [w1 w2 w3 w4 w6 w7 w8 w9]
either any [
    any v: values? localed-words
    not value? externed-word
][
    print "Wrong locality:"
    prin "Should not be defined: " print mold localed-words 
    prin "are: " print mold v
    print "Should be defined: " externed-word
    prin "are (value? _): " print value? externed-word
][
    print "Good locality"
]


print "F3: #################"
unset [w1 w2 w3 w4 w5 w6 w7 w8 w9]
f3: function-all-local [/local w2] body
f3

either [/local w1 w3 w4 w5 w6 w7 w8 w9 w2] = spec-of :f3 [
        print "[/local w1 w3 w4 w5 w6 w7 w8 w9 w2] >> are equal" 
][
        print "[/local w1 w3 w4 w5 w6 w7 w8 w9 w2] >> are NOT equal" 
]
localed-words: [w1 w2 w3 w4 w5 w6 w7 w8 w9]

either any v: values? localed-words [
    print "Some values are not local"
    probe localed-words
    probe v
][
    print "All values are local"
]



print "F4: #################"
unset [w1 w2 w3 w4 w5 w6 w7 w8 w9]
f4: function-all-local [/local w2 /extern w6] body
 either [/local w1 w3 w4 w5 w7 w8 w9 w2] = spec-of :f4 [
        print "[/local w1 w3 w4 w5 w7 w8 w9 w2] >> are equal" 
][
        print "[/local w1 w3 w4 w5 w7 w8 w9 w2] >> are NOT equal" 
]
f4
localed-words: [w1 w3 w4 w5 w7 w8 w9 w2]
externed-word: 'w6
either any [
    any v: values? localed-words
    not value? externed-word
][
    print "Wrong locality:"
    prin "Should not be defined: " print mold localed-words
    prin "are: " print mold v
    print "Should be defined: " externed-word
    prin "are (value? _): " print value? externed-word
][
    print "Good locality"
]