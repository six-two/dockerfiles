#!/bin/bash
# What to call the virtual environment directory
VENV="venv.docker"

prompt_user_to_create_venv() {
    while true; do
        read -p "[?] Create $VENV in current directory? (y/n) " confirm
        case "$confirm" in
            Y|y)
                echo "[*] Creating virtual python environment"
                python3 -m venv --clear --upgrade-deps "$VENV"
                return
                ;;
            N|n)
                exit 1
                ;;
            *)
                echo "Please answer (y)es or (n)o"
                ;;
        esac
    done
}

if [[ ! -f "$VENV/bin/activate" ]]; then
    echo "[-] No virtual environment found in any of the parent directories"
    prompt_user_to_create_venv
fi

if [[ $# -eq 0 ]]; then
    # No arguments -> start an interactive shell
    cat << EOF > /tmp/bashinit
source "$VENV/bin/activate"
alias ll="ls -l"
alias p3i="pip install"
alias p3ir="pip install -r requirements.txt"
alias ms="mkdocs serve -a 0.0.0.0:8000"
EOF

    bash --init-file "/tmp/bashinit"
else
    # Arguments -> just run the given command after sourcing the venv
    source "$VENV/bin/activate"
    "$@"
fi
