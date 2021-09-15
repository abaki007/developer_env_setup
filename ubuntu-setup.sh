#!/bin/bash -e


echo "========================================================================"
echo "====================== Installing System Packages ======================"

# vars for summary later
gitflow_installed="not installed"
# zsh_installed="not installed"
jq_installed="not installed"
# bash_completion="not installed"
awsume_installed="not installed"
python_installed="not installed"
awscli_installed="not installed"


if ( git flow version ); then
    echo -e "gitflow already installed moving on\n"
    gitflow_installed="already_installed"
else
    echo "installing git-flow"
    sudo apt update
    sudo apt install -y git-flow
    gitflow_installed="installed"
    echo " "
fi


# if ( which zsh ); then
#     echo -e "zsh already installed moving on\n"
#     zsh_installed="already_installed"
# else
#     echo "installing zsh"
#     brew install zsh
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#     chmod 700 /usr/local/share/zsh
#     chmod 700 /usr/local/share/zsh/site-functions
#     zsh_installed="installed"
#     echo " "
# fi


if ( which jq ); then
    echo -e "jq already installed moving on\n"
    jq_installed="already_installed"
else
    echo "installing jq"
    sudo apt update
    sudo apt install -y jq
    jq_installed="installed"
    echo " "
fi

echo "========================================================================"
echo "================= Installing Python & Python Libraries ================="

if ( pyenv versions | grep "3.9.6" ); then
    echo -e "python 3.9.6 already installed\n"
    python_installed="already_installed"
else
    echo "installing python 3.9.6"
    sudo apt install -y make build-essential libssl-dev zlib1g-dev
    sudo apt install -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev
    sudo apt install -y libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
    
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init --path)"' >> ~/.zshrc

    source ~/.zshrc

    pyenv install -v 3.9.6
    python_installed="installed"
    echo " "
fi
echo "setting global python version to 3.9.6"
pyenv global 3.9.6
python --version
echo " "


if ( which awsume ); then
    echo -e "awsume already installed moving on\n"
    awsume_installed="already_installed"
else
    echo "installing awsume"
    pip3 install awsume || pip install awsume
    awsume_installed="installed"
    echo " "
fi

if ( aws --version ); then
    echo -e "awscli already installed moving on\n"
    awscli_installed="already_installed"
else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version
    awscli_installed="installed"
    echo " "
fi


echo -e "\n========================================================================"
echo "===================== Package Installation Summary ====================="

echo "git-flow $gitflow_installed"
# echo "zsh $zsh_installed"
echo "jq $jq_installed"
# echo "pyenv $pyenv_installed"
echo "awsume $awsume_installed"
echo "python $python_installed"
echo "awscli $awscli_installed"

echo -e "\n========================================================================"
echo "========================== Update .zshrc File =========================="

# add aswume alias & auto-complete to zsh
if ( cat ~/.zshrc | grep 'alias awsume=". \\\$(pyenv which awsume)"' ); then
    echo "awsume alias already set up"
else
    echo "creating awsume alias in zshrc"
    echo -e "\n#AWSume alias to source the AWSume script" >> ~/.zshrc
    echo 'alias awsume=". awsume"' >> ~/.zshrc
fi

if ( cat ~/.zshrc | grep "complete -F _awsume awsume" ); then
    echo "auto complete for awsume already setup"
else
    echo "adding awsume auto complete function to zshrc"
    
cat <<EOT >> ~/.zshrc

#Auto-Complete function for AWSume
_awsume() {
    local cur prev opts
    COMPREPLY=()
    cur="\${COMP_WORDS[COMP_CWORD]}"
    prev="\${COMP_WORDS[COMP_CWORD-1]}"
    opts=\$(awsume-autocomplete)
    COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}) )
    return 0
}
complete -F _awsume awsume
EOT
fi


# echo -e "\n========================================================================"
# echo "========================= Github SSH key-pair =========================="

# if ( ls -l ~/.ssh | grep "github" ); then
#     echo "github ssh already exists"
# else
#     echo "creating an ssh key to be used with github"
#     echo "more info: https://docs.github.com/en/enterprise/2.15/user/articles/adding-a-new-ssh-key-to-your-github-account"
#     ssh-keygen -f ~/.ssh/github_id_rsa -t rsa -b 2048 -N ""
# fi

# if ( cat ~/.zshrc | grep "ssh-add -K ~/.ssh/github_id_rsa" ); then
#     echo "github ssh key already added to ssh daemon"
# else
#     echo "adding github ssh key to ssh daemon so it is accessible for git commands"
#     echo -e '\neval "$(ssh-agent -s)"' >> ~/.zshrc                                       
#     echo "ssh-add -K ~/.ssh/github_id_rsa" >> ~/.zshrc
# fi

echo -e "\n========================================================================"
echo "========================== Install MS VS Code =========================="
echo "TBC"