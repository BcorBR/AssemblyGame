loadn R0, #0
loadn R1, #1

sub R0, R0, R1 ; must be -1
shiftr0 R0, #15
loadn R4, #7 
cmp R0, R4
jeq test

halt

test:
    loadn R5, #2822
    outchar R5, R1