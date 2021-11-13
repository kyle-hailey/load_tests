change default shell to bash
chsh -s /bin/bash
vi .bash_profile
set -o vi

Install brew

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

jmeter

    brew install jmeter
    brew upgrade jmeter

MacVIM

    brew install macvim
    cp. /usr/local/Cellar/macvim/8.2-171_1/MacVim.app /Applications
    brew link macvim
    # brew install vim && brew install macvim


copy paste vim

.vimrc

    vnoremap \y y:call system("pbcopy", getreg("\""))<CR>
    nnoremap \p :call setreg("\"", system("pbpaste"))<CR>p

    noremap YY "+y<CR>
    noremap P "+gP<CR>
    noremap XX "+x<CR>


PASH viewer


    https://github.com/dbacvetkov/PASH-Viewer/releases



MySQL / Postgres / Java

    brew install mysql
    brew install postgres
    brew cask install java
    brew install --cask java
     brew install java
    https://java.com/en/download/
    https://www.oracle.com/java/technologies/javase-jdk16-downloads.html
    # https://mkyong.com/java/how-to-set-java_home-environment-variable-on-mac-os-x/#java-home-and-macos-11-big-sur
    export JAVA_HOME=$(/usr/libexec/java_home)
    echo $JAVA_HOME
    /Library/Java/JavaVirtualMachines/jdk-16.0.2.jdk/Contents/Home

camtasia
photoshop


install CLI

     https://docs.aws.amazon.com/cli/latest/userguide/installing.html

    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /



    aws configure
    Access key ID.  
    Secret access key     
     region us-west-2
     format json


    aws configure --profile kylelf
 
 
 SQL*Plus Oracle

see: http://oraontap.blogspot.com/2020/01/mac-os-x-catalina-and-oracle-instant.html

scp -i "/Users/kylelf/pems/kyle_ec2.pem"  \
ec2-user@ec2-184-73-34-224.compute-1.amazonaws.com:/home/ec2-user/tars/oracle_mac.tar.Z 
uncompress oracle_mac.tar.Z
cd /Applications
tar xvf ~/oracle_mac.tar
cd oracle
chmod u+w *
 xattr -r -d -s com.apple.quarantine oracle



install pip

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
alias python=python3
python get-pip.py


SQL Server   SQLCMD

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew install --no-sandbox msodbcsql mssql-tools
# for silent install ACCEPT_EULA=y brew install --no-sandbox msodbcsql mssql-tools
 
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
brew install mssql-tools

sqlcmd -S <HOST>,1433 -U <USER> -P <PASSWORD>

mysql-cli

 sudo pip install mssql-cli --ignore-installed six 
 
 mssql-cli -S <HOST>,1433 -U <USER> -P <PASSWORD>
