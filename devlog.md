# May 4th 10:46 pm

Starting the initial repository. I already have planned how I can structure the project to finish on time. I will push the code tomorrow when I create the repository in GitHub.

# May 5th 1:57 pm
I have created the initial skeleton for the project and pushed it to GitHub. I don't want to push incomplete code yet, so I will wait to push that after my classes. I am planning to work on the my facts.pl on the meantime to implement it with the scheduler.pl file.

# May 5th 4:10 pm
I have completed the facts.pl document which stores all of the facts for the prolog code. It includes employees, workstation, workstation_idle, and avoid_workstation which are all needed for the main scheduler. This is just plain facts to test the code before I run it with the given inputs files. I will start running the different input cases when I am done writing schduler.pl.

# May 5th 7:22 pm
I have made a lot of progress on schduler.pl document which is the main prolog file that will be ran. I have implemented build_shift, plan, findall, and assign_shifts methods already. I have and will be following this structure that I created earlier on: plan/1: plan(plan(Morning, Evening, Night)) where it collects all employees and workstations with findall/3, then delegates to two helper layers assign_shifts/4 and build_shift/4. assign_shifts/4 is a recursive predicate that places employees in the morning, evening, or night list, only if avoid_shift/2 does not block that choice. I made sure that backtracking explores all valid partitions. build_shift/4 has 4 chocies. constraint 1 is guaranteed structurally: assign_shifts puts each employee in exactly one list, and fill_assignment puts each employee in exactly one workstation bucket. avoid_shift and avoid_workstation are checked with \+ so they compose naturally with backtracking. :- discontiguous declarations prevent Prolog from crashing when the facts file doesn't define optional predicates like avoid_shift/2. If no valid plan exists, the whole predicate fails. I will be following this structure in designing other methods.

# May 5th 11:19 pm
I followed the structure that I created before and coded the rest of the code. I will be testing the code with inputs and compare it to the given outputs tomorrow.

# May 6th 10:23 pm
I didn't have much time to work on the project today due to final exams. I have tested with example input 1 and testing.pl file that was provided and it was successfull.

# May 7th 9:07 pm
I have tested with inputs 2 and 3, which have produced the same outputs as example outputs given in the text files. I just need to review all of my changes before I submit the final project. I also forgot to explain the helper predicates I implemented to support the main plan/1 predicate. fill_assignment/4 assigns each employee to one active workstation by iterating through the employee list and using member/2 to non-deterministically pick a workstation while also checking avoid_workstation constraints at the same time. add_to_bucket/4 handles the bookkeeping of adding an employee to a workstation's bucket in the assignment map. check_counts/2 verifies that every workstation's final headcount falls within its defined minimum and maximum after all employees have been placed. pairs_to_schedule/2 converts the internal assignment map into the final list of workstation/2 terms, dropping any workstation that ended up with no employees. I will finish the rest of the testing tomorrow.