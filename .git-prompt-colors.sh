# This is the default theme for gitprompt.sh 
# tweaked for Ubuntu terminal fonts

override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom"
  GIT_PROMPT_STAGED="${Red}● "          # the number of staged files/directories
  GIT_PROMPT_UNTRACKED="${Cyan}… "      # the number of untracked files/dirs
  GIT_PROMPT_CLEAN="${BoldGreen}✔ "     # a colored flag indicating a "clean" repo
  GIT_PROMPT_COMMAND_OK="${Green}✔ "    # indicator if the last command returned with an exit code of 0
}

reload_git_prompt_colors "Custom"
