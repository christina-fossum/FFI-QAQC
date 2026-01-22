# FFI-QAQC
test
Rocky Mountain National Park Fire Effects
Automated process for conducting QA/QC of FFI data in R

Edited: Christina Fossum 3/31/2025


Purpose: 
The goal of this process is to provide a systematic approach to ensure accuracy and consistency in our program's fire effects data, as well as to provide a single accessible location to document and track progress.

Workflow:
1. Clone 'FFI-QAQC' github repository onto desktop
2. Download FFI data into 'FFI Data - WORKING' folder within desktop repository
3. Track changes to code by frequently committing to GitHub repository
4. Log progress on Error Logs 

Contents:
- 'FFI-QAQC' R project
- Individual R scripts for conducting QAQC error analyses 
    1. 2024 Rapid Assessment Plots
    2. 2024 Allenspark Plots
    3. FMH PIPO Plots
- 'FFI data - WORKING' folder (this is where you download data from FFI - just store these files locally, do NOT need to commit to GitHub)
- 'Error Logs' folder: Excel files for logging error checking progress
- '2024PlotFFIKey' excel file: Outline of error log queries contained in R scripts



SOP:

Setting up GitHub & R
~~~~~~~~~~~~~~~~~~~~~~
(1) Install R Software
- Install 'R' and 'RStudio'via software center
- Make sure RStudio is running desired (most recent) version of R. 
  1. Type 'R.version.string' into R console. If you are Not running desired version, then
  2. Within RStudio, go to Tools -> Global Options -> General -> Change R version
  3. Quit and restart, and check 'R.version.string' again to make sure you are good
- Update R packages: within R console, type 'update.packages(ask = FALSE, checkBuilt = TRUE)'

(2) Install Git
- Install 'Git' via software center
- Open Git Bash terminal, type in 'git --version'
- This should show you the version of Git you have installed

(3) Create GitHub account & follow the 'FFI-QAQC' repository

(4) Configure Git with GitHub account
- Within Git Bash, type the following commands:
  1. 'git config --global username christina-fossum' (your GitHub user name)
  2. 'git config --global user.email christina_fossum@nps.gov' (your account email address)
- Check that now git knows your username and email:
  1. 'git config --global --list'
  
(5) Set up personal access token for HTTPS
- Install/load 'usethis' package in R. Within RStudio, enter the following commands:
  1. 'install.packages("usethis")
  2. library(usethis)
- Run: 'usethis::create_github_token()' (This should take you to GitHub)
- Click "Generate Token"
- Copy PAT onto clipboard
- Back in RStudio, run 'gitcreds::gitcreds_set()'
- Paste your PAT when prompted

(6) Clone GitHub repository to local computer using RStudio
- Disable SSL verification on Git globally. In Git Bash enter:
  1. 'git config --global http.sslVerify false'
- Within GitHub repository, click the green code button and copy HTTPS URL to clipboard
- In RStudio, create a new project:
  1. New Project -> Version Control -> Git
  2. Paste URL
  3. Type Repo name into "Project Directory Name"
  4. Modify "Create Project as a Sub-directory" field to desktop
- Make minor edit to README file and posh to GitHub to make sure working
  1. Open README file from within R studio
  2. Add some line of new text to top of doc
  3. In upper right-hand corner, select 'Git' pane and check box next to the README.md doc
  4. Click 'Commit Pending Changes' -> type brief commit message -> Click 'commit' -> 'push'

Generating Error Logs & Checking FFI Data
~~~~~~~~~~~~~~~~~~~~~
(1) Export FFI data as .csv files
- Make sure you are signed into OneDrive account on remote desktop
- Save these to your local repository in the 'FFI data - WORKING' folder

(2) Load .csv files into appropriate R script, follow script to run QAQC checks and generate error log
- Make sure to document changes you make to code when you commit to GitHub
- Look over excel error log file to make sure errors visually make sense

* Minor edits may need to be made to file path etc.

(3) Use error log to check FFI data and make appropriate changes - Document changes in masterfile! 

















