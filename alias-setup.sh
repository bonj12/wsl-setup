alias ssh-auth='pkill ssh-agent && eval $(ssh-agent) && ssh-add ~/.ssh/wsl_rsa && ssh -T git@bitbucket.org'

alias focrex-build='cd ~ && make -f pwd /focrex-build.mk -i && cd $OLDPWD'
alias focrex-rebuild='cd ~ && make -f focrex-build.mk run/all && cd $OLDPWD'
alias focrex-up='cd ~ && make -f focrex-build.mk start/containers && cd $OLDPWD'
alias focrex-down='cd ~ && make -f focrex-build.mk down/containers && cd $OLDPWD'
alias bash-focrex-member='cd ~ && make -f focrex-build.mk bash/member && cd $OLDPWD'
alias bash-focrex-admin='cd ~ && make -f focrex-build.mk bash/admin && cd $OLDPWD'
alias bash-focrex-webapp='cd ~ && make -f focrex-build.mk bash/webapp && cd $OLDPWD'
alias focrex-clear-logs='cd ~ && make -f focrex-build.mk logs/clear && cd $OLDPWD'

alias bxfg-build='cd ~ && make -f bxfg-build.mk -i && cd $OLDPWD'
alias bxfg-rebuild='cd ~ && make -f bxfg-build.mk rebuild/bxfg && cd $OLDPWD'
alias bxfg-up='cd ~ && make -f bxfg-build.mk run/bxfg && cd $OLDPWD'
alias bxfg-down='cd ~ && make -f bxfg-build.mk down/bxfg && cd $OLDPWD'

echo 'alias setup done!'