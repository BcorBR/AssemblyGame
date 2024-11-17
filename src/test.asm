loadn R0, #0
loadn R1, #1

sub R0, R0, R1
loadn R2, #40
mod R0, R1, R2 






halt

test:
    loadn R5, #2822
    outchar R5, R1