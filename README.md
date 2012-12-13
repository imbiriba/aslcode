aslcode
=======

Code used by the ASL group - mostly matlab, but also shell and fortran/C/python# ASL Production Code Library


## Idea:

1. Routines are grouped in directories
2. Dependency of directories is tiered (go only on one way)
3. Interface is KING - consistency above all
4. Directory names should indicate what's inside it
5. Evey routine has to be a reference documentation prepared!


## How to procede:

As a first task, let us detangle the RTP creation procedure for AIRS data.

This procedure has 3 logical steps:

1. Fetching of AIRS data
2. Merging with Model data
2.1 Must have model fetch routine to call
3. Computing calculations


As it is now:

rtp_core.m:

1. Look for existing L1B files
2.  

