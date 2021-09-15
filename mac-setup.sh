#!/bin/bash -e


echo "========================================================================"
echo "====================== Installing System Packages ======================"

# vars for summary later
brew_installed="not installed"
gitflow_installed="not installed"
zsh_installed="not installed"
jq_installed="not installed"
bash_completion="not installed"
pyenv_installed="not installed"
awsume_installed="not installed"
python_installed="not installed"
awscli_installed="not installed"

# setup brew
if ( brew --version ); then
    echo -e "brew already installed moving on\n"
    brew_installed="already_installed"
else
    echo -e "installing brew - xcode install is interactive"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew_installed="installed"
    echo " "
fi


if ( pyenv --version ); then
    echo -e "pyenv already installed moving on\n"
    pyenv_installed="already_installed"
else
    echo "installing pyenv"
    brew install pyenv
    pyenv_installed="installed"
    echo " "
fi


if ( which git-flow ); then
    echo -e "gitflow already installed moving on\n"
    gitflow_installed="already_installed"
else
    echo "installing git-flow"
    brew install git-flow
    gitflow_installed="installed"
    echo " "
fi


if ( which zsh ); then
    echo -e "zsh already installed moving on\n"
    zsh_installed="already_installed"
else
    echo "installing zsh"
    brew install zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chmod 700 /usr/local/share/zsh
    chmod 700 /usr/local/share/zsh/site-functions
    zsh_installed="installed"
    echo " "
fi


if ( which jq ); then
    echo -e "jq already installed moving on\n"
    jq_installed="already_installed"
else
    echo "installing jq"
    brew install jq
    jq_installed="installed"
    echo " "
fi

echo "========================================================================"
echo "================= Installing Python & Python Libraries ================="

if ( pyenv versions | grep "3.8.7" ); then
    echo -e "python 3.7.8 already installed\n"
    python_installed="already_installed"
else
    echo "installing python 3.8.7"
    if(uname -a | grep "Darwin Kernel Version 20"); then
        export LDFLAGS="-L/usr/local/opt/zlib/lib"
        export CPPFLAGS="-I/usr/local/opt/zlib/include"
    fi
    
    pyenv install -v 3.8.7
    python_installed="installed"
    echo " "
fi
echo "setting global python version to 3.8.7"
eval "$(pyenv init -)"
pyenv global 3.8.7
python --version
echo " "


if ( awsume --version ); then
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
    pip3 install awscli || pip install awscli
    awscli_installed="installed"
    echo " "
fi


echo -e "\n========================================================================"
echo "===================== Package Installation Summary ====================="

echo "brew $brew_installed"
echo "git-flow $gitflow_installed"
echo "zsh $zsh_installed"
echo "jq $jq_installed"
echo "pyenv $pyenv_installed"
echo "awsume $awsume_installed"
echo "python $python_installed"
echo "awscli $awscli_installed"

echo -e "\n========================================================================"
echo "========================== Update .zshrc File =========================="

# add pyenv init
if ( cat ~/.zshrc | grep 'eval "$(pyenv init -)"' ); then
    echo "pyenv initalready set up"
else
    echo "adding pyenv init to zshrc"
    echo -e "\n#pyenv init so pyenv manages python versions" >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
#     echo "PATH=$PATH:/Users/bbpj/Library/Python/3.8/bin" >> ~/.zshrc
fi

# add aswume alias & auto-complete to zsh
if ( cat ~/.zshrc | grep 'alias awsume=". \\\$(pyenv which awsume)"' ); then
    echo "awsume alias already set up"
else
    echo "creating awsume alias in zshrc"
    echo -e "\n#AWSume alias to source the AWSume script" >> ~/.zshrc
    echo 'alias awsume=". \$(pyenv which awsume)"' >> ~/.zshrc
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
