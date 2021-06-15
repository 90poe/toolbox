# Vault configuration
export VAULT_SKIP_VERIFY=1
export VAULT_ADDR=https://vault.infra.internal:8200

function assume-role {
    for i in $(env | grep AWS | cut -d '=' -f 1); do
        unset $i;
    done
    eval $(command assume-role -duration=12h $@);
}

function newvpn {
    vault login -method=aws region=us-east-1 role=aws-admin-role
    task_no=${1:-`date '+%F-%H%M%S'`}
    newdir="$HOME/Work/IS/$task_no"
    mkdir -p "$newdir"
    cd "$newdir"
    echo -e "\nChanged dir to: `pwd`"
}

export HELM_HOME="$HOME/Work/helm/production"
[[ ! -d "$HELM_HOME" ]] && mkdir -p $HELM_HOME

# Kubeconfig aliases
alias todev="hash -r && export KUBECONFIG=~/.kube/dev.devtest-eks.config"
alias totest="hash -r && export KUBECONFIG=~/.kube/test.devtest-eks.config"
alias tointegration="hash -r && export KUBECONFIG=~/.kube/integration.prod-eks.config"
alias toprod="hash -r && export KUBECONFIG=~/.kube/prod.prod-eks.config"

# Configure primary bash prompt
export PS1="toolbox:\w \$ASSUMED_ROLE \$ "

alias k="kubectl"
alias as="assume-role"

# Start screen
#screen
