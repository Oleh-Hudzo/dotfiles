export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export DISPLAY=:0
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

plugins=(
  git
  ssh-agent
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=grey,bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Aliases
alias python=python3

alias ll='ls -lF'
alias la='ls -la'
alias c='clear'
# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
# Safety features
alias rm='rm -i'              # Make rm interactive
alias cp='cp -i'              # Make cp interactive
alias mv='mv -i'              # Make mv interactive
# Kubernetes
alias k='kubectl'
alias kp='kubectl get pods'                     # List pods
alias kpa='kubectl get pods --all-namespaces'   # List pods in all namespaces
alias kpd='kubectl describe pod'                # Describe pod
alias kpf='kubectl port-forward'                # Port forward to a pod

alias kd='kubectl get deployments'              # List deployments
alias kdd='kubectl describe deployment'         # Describe deployment
alias kds='kubectl scale deployment --replicas' # Scale deployment

alias ks='kubectl get services'                 # List services
alias ksv='kubectl get svc'                     # List services (short)
alias ksd='kubectl describe service'             # Describe service

alias ke='kubectl exec -it'                     # Execute command in a container
alias kl='kubectl logs'                         # Display logs
alias kaf='kubectl apply -f'                    # Apply configuration from file
alias krm='kubectl delete'                      # Delete resource

alias lz='lazygit'

# SSH identities
zstyle :omz:plugins:ssh-agent identities personal.key synply-gitlab.key


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
