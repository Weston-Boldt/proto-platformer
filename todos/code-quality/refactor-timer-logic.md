# Refactor Timer Logic

I had previously used arithemetic and callbacks for timers (keep track of current time on the
entity) and I think there is an easier way

I have recently started to use hump.lua's timer as it seems nice, (provide seconds and a callback
fn) and I'm wondering if that is the best way?

the way i see it there are 3 potential options here

* use hump.lua's timer 

* write a timer obj to clean up a few loc

* keep on doing it this way
