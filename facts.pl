employee(alice).
employee(bob).
employee(carol).
employee(dave).
employee(eve).
employee(frank).

workstation(reception, 1, 2).
workstation(kitchen, 2, 3).
workstation(warehouse, 1, 2).

workstation_idle(warehouse, night).

avoid_shift(alice, night).            
avoid_shift(frank, morning).       

avoid_workstation(bob, kitchen).   
avoid_workstation(carol, warehouse).  