# subjobs
Shell scripts that I used to submit jobs to the cluster with parameters set outside the task code 

The main advantages of these job-submission scripts are: 
  1. a number of jobs can be submitted at one time using just one command (sh subjobs.sh), which gives a way to manually parallelization;
  2. params effective in the actual running code can be set in the .sh script.
