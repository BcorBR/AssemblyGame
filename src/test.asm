loadn R0, #0
loadn R1, #5

sub R1, R0, R1
not R2, R1
inc R2
loadn R3, #40
div R2, R2, R3
inc R2
mul R2, R2, R3
add R2, R2, R1






halt

test:
    loadn R5, #2822
    outchar R5, R1