cd /tmp
curl -O https://downloads.apache.org/tomcat/tomcat-8/v8.5.69/bin/apache-tomcat-8.5.69.tar.gz
sudo mkdir -p /usr/local/apache/apache-tomcat-7
sudo tar xzvf apache-tomcat-8*tar.gz -C /usr/local/apache/apache-tomcat-7 --strip-components=1
cd /usr/local/apache/apache-tomcat-7/
sudo chgrp -R cisco /usr/local/apache/apache-tomcat-7
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R cisco webapps/ work/ temp/ logs/
sudo systemctl daemon-reload
sudo systemctl start apache-tomcat-7
sudo ufw allow 8080
sudo apt install git -y
cd
mkdir app
cd app
git clone https://github.com/Appdynamics/DevNet-Labs.git


