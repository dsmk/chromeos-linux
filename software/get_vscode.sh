#! /bin/bash
# adapted from https://gist.github.com/Zate/a6be5e5528f177b2e3e2e193b91e350c


set -euf -o pipefail

sudo apt-get install gpg -y
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update -y
sudo apt-get install code -y
sudo apt-get install libxss1 libasound2 -y

#code --install-extension lukehoban.Go
#code-insiders --install-extension PeterJausovec.vscode-docker
#code-insiders --install-extension Zignd.html-css-class-completion
#code-insiders --install-extension ecmel.vscode-html-css
#code-insiders --install-extension redhat.vscode-yaml
#code-insiders --install-extension codezombiech.gitignore
#code-insiders --install-extension IBM.output-colorizer
#code-insiders --install-extension donjayamanne.git-extension-pack
#code-insiders --install-extension formulahendry.docker-extension-pack
#code-insiders --install-extension foxundermoon.shell-format
#code-insiders --install-extension eamodio.gitlens
#code-insiders --install-extension donjayamanne.githistory
#code-insiders --install-extension Shan.code-settings-sync
#code-insiders --install-extension Equinusocio.vsc-material-theme
#code-insiders --install-extension yzhang.markdown-all-in-one
#code-insiders --install-extension anseki.vscode-color
#code-insiders --install-extension shd101wyy.markdown-preview-enhanced
#code-insiders --install-extension PKief.material-icon-theme
#code-insiders --install-extension robertohuertasm.vscode-icons

code --list-extensions --show-versions
