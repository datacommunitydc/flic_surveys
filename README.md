# Flic Surveys

Copyright 2016, Data Community DC. All Rights Reserved.

by Harlan D. Harris

## Introduction

This Shiny script implements the front-end for a system of recording survey responses
via Flic button. It is assumed that buttons are set up with IFTTT to store clicks in a
Google Doc, whose published CSV URL is in `global.R`. Two other Google Docs are used
to define a set of questions that are being asked, and the mapping of the buttons to
the answers. 

The application populates a dropdown of questions, and reloads the answers every 15
seconds, creating a simple bar graph.

