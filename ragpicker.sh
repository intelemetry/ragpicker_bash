#!/bin/bash
# ragpicker provisioning

sudo apt-get install unrar-free
sudo apt-get install wine
sudo apt-get install winetricks

winetricks nocrashdialog

sudo apt-get install clamav
sudo apt-get install python-requests
sudo apt-get install python-httplib2
sudo apt-get install python-yapsy
sudo apt-get install python-beautifulsoup
sudo apt-get install python-m2crypto
sudo apt-get install python-pyasn1
sudo apt-get install python-jsonpickle
sudo apt-get install exiftool

sudo apt-get install python-pip
sudo pip install bitstring

sudo apt-get install git

git clone https://github.com/plusvic/yara.git
cd yara
sudo apt-get install autoconf
sudo apt-get install libtool

sudo apt-get install libjansson-dev
sudo apt-get install libmagic-dev 
sudo apt-get install libssl-dev
sudo apt-get install flex

./bootstrap.sh
./configure --with-crypto --enable-cuckoo --enable-magic

make
sudo make install

sudo apt-get install python-yara
sudo apt-get install tor

sudo pip install hachoir-subfile


########################
# begin install vxcage #
########################

sudo pip install bottle
sudo pip install sqlalchemy
sudo apt-get install ssdeep
sudo pip install pydeep

cd ~/
git clone https://github.com/botherder/vxcage.git
cd vxcage
sed -i '$ d' api.conf 		# remove last line of file which is mysql

sudo apt-get install sqlite 

echo "sqlite:///vxcage.db" >> api.conf # add sqlite db

# install apache ugh :(

sudo apt-get install apache2 libapache2-mod-wsgi
sudo a2enmod wsgi

sudo make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /home/vagrant/vxcage.pem

sudo hostname protorag

# setup apache users
/path/to/htpasswd -c /etc/htpasswd/.htpasswd vxcage

# write apache conf file 
cat <<EOT>> /etc/apache2/sites-enabled/vxcage.conf 
<VirtualHost *:443>
    ServerName protorag

    WSGIDaemonProcess yourapp user=www-data group=www-data processes=1 threads=5
    WSGIScriptAlias / /home/vagrant/vxcage/app.wsgi

    <Directory /home/vagrant/vxcage/app.wsgi>
        WSGIProcessGroup yourgroup
        WSGIApplicationGroup %{GLOBAL}
        Order deny,allow
        Allow from all
    </Directory>

    <Location />
        AuthType Basic
        AuthName "Authentication Required"
        AuthUserFile "/home/vagrant/.htpasswd"
        Require valid-user
    </Location>

    SSLEngine on
    SSLCertificateFile /home/vagrant/vxcage.pem

    ErrorLog /home/vagrant/apacheerror.log
    LogLevel warn
    CustomLog /home/vagrant/apacheaccess.log combined
    ServerSignature Off
</VirtualHost>
EOT

sudo /etc/init.d/apache2 restart

########## console interaction ##########

sudo pip install prettytable
sudo pip install progressbar

######################
# end install vxcage #
######################

#########################
# begin install mongodb #
#########################

sudo apt-get install mongodb
sudo apt-get install pymongo
sudo apt-get install jinja2


#######################
# end install mongodb #
#######################

# install avg
apt-get install gdebi
wget http://download.avgfree.com/filedir/inst/avg2013flx-r3118-a6926.i386.deb
apt-get install gdebi 		# has user interaction
sudo /etc/init.d/avgd start	# needs way more setup

# install bitdefender 
sudo add-apt-repository 'deb http://download.bitdefender.com/repos/deb/ bitdefender non-free'
sudo apt-get update
wget -q http://download.bitdefender.com/repos/deb/bd.key.asc -O- | sudo apt-key add -
sudo apt-get install bitdefender-scanner

#### fprot looks deprecated ####
# https://code.google.com/p/malware-crawler/

##################################
# prepare ragpicker installation #
##################################

sudo apt-get install build-essential python-dev gcc automake libtool python-pip subversion ant

cd ~/

sudo mkdir /opt/ragpicker
sudo chown -R vagrant:vagrant /opt/ragpicker/
sudo apt-get install subversion 
svn checkout https://malware-crawler.googlecode.com/svn/ malware-crawler
cd malware-crawler/MalwareCrawler/
sudo apt-get install ant
ant install

# configuration settings 
cp src/config/* /opt/ragpicker/config/
cd /opt/ragpicker/config

# drop configuration files

# client configuration


cat <<EOT>> /opt/ragpicker/config/crawler.conf
[clientConfig]
tor_enabled = yes
tor_proxyaddress = localhost 
tor_proxyport = 9050

###################
# browser headers #
###################
browser_accept_language = en-US,en;q=0.8
#Firefox 12 on Windows XP
browser_user_agent = Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120403211507 Firefox/12.0

####################
# malware sources  #
####################
[cleanmx]
enabled = yes

[malShare]
enabled = no
limit = 1000
apikey = 
#  key required 

[malc0de]
enabled = yes

[malwarebl]
enabled = yes 

[secuboxlabs]
enabled = yes 

[vxvault]
enabled = yes

[zeustracker]
enabled = yes

[spyeyetracker]
enabled = yes

[joxeankoret]
enabled = yes 

[urlquery]
enabled = yes 


EOT

#################
# preprocessing #
#################

cat <<EOT>> /opt/ragpicker/config/crawler.conf
[01_unpack_archive]
enabled = yes
dataTypes = Zip, RAR

[02_unpacker_clamav]
enabled = yes
dataTypes = PE32, PE32+, MS-DOS
clamscan_path = /usr/bin/clamscan

[03_extract_rsrc]
enabled = yes
dataTypes = PE32, PE32+, MS-DOS
extractTypes = Zip, RAR

[04_extract_office]
enabled = yes 
dataTypes = Rich, Composite
wine = /usr/bin/wine 
brute = true 

[05_pe_carve]
enabled = yes 
dataTypes = PE32, PE32+, MS-DOS

EOT

##############
# processing #
##############

cat <<EOT>> /opt/ragpicker/config/crawler.conf
[all_info]
enabled = yes

[all_bluecoatMalwareAnalysisAppliance]
enabled = no

EOT 
