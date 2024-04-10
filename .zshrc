if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/Users/oleh/.oh-my-zsh"

source ~/powerlevel10k/powerlevel10k.zsh-theme
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
