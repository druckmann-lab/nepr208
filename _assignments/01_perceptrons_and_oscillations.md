---
type: assignment
date: 2023-04-06
title: 'Assignment 1 - Perceptrons and Oscillations'
due_event: 
    type: due
    date: 2023-04-13T23:59:00-8:00
    description: 'Assignment 1 - Perceptrons and Oscillations'
---

[Part 1](../static_files/problem_sets/ProblemSetPerceptrons.pdf) and [Part 2 (Extra Credit)](../static_files/problem_sets/ps1_part2_extra_credit.pdf)

If you get stuck on [part 1](../static_files/problem_sets/ProblemSetPerceptrons.pdf), you can download some sample perceptron code [here](../static_files/code/BinaryPerceptronSampleCode.m)

[Part two of the problem set](../static_files/problem_sets/ps1_part2_extra_credit.pdf) is extra credit and explores neural nonlinearities that result in oscillations. These features would not be revealed with simple integrate and fire (IF) networks.

To explore the roles of ion channels in governing neural behavior, the tutorial and software, Electrophysiology of the Neuron (EOTN), is available. The software can be found here: [EOTN](https://huguenardlab.stanford.edu/eotn/)

If you are doing part 2, install the program (you will get two programs installed, SimVC and SimCC, for voltage clamp and current clamp simulations, respectively).

Here is the [original book](https://hlab.stanford.edu/eotn/ELECTROPHYSIOLOGY%20OF%20THE%20NEURON.pdf) (the book is out of print, but there is a pdf) that David McCormick (Yale University) and John Huguenard wrote to develop some simple exercises for teaching in a dry lab the basics of resting membrane potentials, stimulation, synapses, action potentials, synaptic currents, etc.

You can download the .cc5 files you need for part 2, which is for extra credit, [here](../static_files/code/ps1_pt2_exp1.cc5)
And here is a link to the archived parameter files to be used for the exercises in the book: [eotn_parameters_v4.tgz](../static_files/code/eotn_parameters_v4.tgz)

If you are interested, you can see a historical web page describing the book [here](http://eotn.stanford.edu)

For using EOTN on Mac:
We have created a small (2GByte) virtual machine with the EOTN software for your use.  This will run on linux or MacOS, and will allow you to run the software on a non-Windows machine.  Here are the instructions:

1) First download and install virtualbox on your computer if you don't already have it https://www.virtualbox.org/wiki/Downloads

2) The download a virtual machine I made: https:/hlab.stanford.edu/xp3.vdi

3) Then make a new device using this machine file.

  a) using virtualbox manager, click on "New"

  b) chose a name "nepr208", type "Microsoft windows", Version "XP (32bit)"

  c) when it asks you for the hard disk to use, take the option ""Use and Existing virtual hard disk file", and then point to the xp.vdi file you just downloaded.

4) This should give you a virtual XP machine with the two icons for the software.
