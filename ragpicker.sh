
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y update --fix-missing 

apt-get -y install unrar-free
 apt-get -y install wine
 apt-get -y install winetricks

 sudo apt-get -y install python-hachoir-metadata
 sudo apt-get -y install python-hachoir-urwid
 sudo apt-get -y install python-hachoir-wx

 
winetricks nocrashdialog
 apt-get -y install libfuzzy-dev
 apt-get -y install clamav
 apt-get -y install python-requests
 apt-get -y install python-httplib2
 apt-get -y install python-yapsy
 apt-get -y install python-beautifulsoup
 apt-get -y install python-m2crypto
 apt-get -y install python-pyasn1
 apt-get -y install python-jsonpickle
 apt-get -y install exiftool

 apt-get -y install python-pip

 sudo pip install hachoir-core
 sudo pip install hachoir-parser
 sudo pip install hachoir-regex
  sudo pip install hachoir-subfile
 
 pip install bitstring

 apt-get -y install git

git clone https://github.com/plusvic/yara.git
cd yara
 apt-get -y install autoconf
 apt-get -y install libtool
 apt-get -y install ant
 apt-get -y install libjansson-dev
 apt-get -y install libmagic-dev 
 apt-get -y install libssl-dev
 apt-get -y install flex

./bootstrap.sh
./configure --with-crypto --enable-cuckoo --enable-magic

make
 make install

 apt-get -y install python-yara
 apt-get -y install tor

# pip install hachoir-subfile


########################
# begin install vxcage #
########################

pip install bottle
pip install sqlalchemy
apt-get -y install ssdeep
apt-get -y install python-dev
pip install pydeep
cd ~/
git clone https://github.com/botherder/vxcage.git
cd vxcage
sed -i '$ d' api.conf 		# remove last line of file which is mysql

 apt-get -y install sqlite 

echo "sqlite:///vxcage.db" >> api.conf # add sqlite db

# install apache ugh :(

apt-get -y install apache2 libapache2-mod-wsgi apache2-utils


# setup the hostname
echo "ServerName ragpicker" | sudo tee /etc/apache2/conf-available/fqdn.conf

a2enmod wsgi
a2enmod ssl 			# enable ssl
make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /home/vagrant/vxcage.pem


hostname protorag

# setup apache users
htpasswd -c /etc/htpasswd/.htpasswd vxcage

# write apache conf file 
cat <<'EOF' > /etc/apache2/sites-enabled/vxcage.conf 
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

    #SSLEngine on
    SSLCertificateFile /home/vagrant/vxcage.pem

    ErrorLog /home/vagrant/apacheerror.log
    LogLevel warn
    CustomLog /home/vagrant/apacheaccess.log combined
    ServerSignature Off
</VirtualHost>
EOF

 /etc/init.d/apache2 restart

########## console interaction ##########

 pip install prettytable
 pip install progressbar

######################
# end install vxcage #
######################

#########################
# begin install mongodb #
#########################

 apt-get -y install mongodb
 # apt-get -y install pymongo
 # there is an error in 3 
 sudo pip install pymongo==2.9
 apt-get -y install python-jinja2


#######################
# end install mongodb #
#######################

# install avg
# apt-get -y install gdebi
# wget http://download.avgfree.com/filedir/inst/avg2013flx-r3118-a6926.i386.deb
# apt-get -y install gdebi 		# has user interaction
# sudo /etc/init.d/avgd start	# needs way more setup

# install bitdefender 
 add-apt-repository 'deb http://download.bitdefender.com/repos/deb/ bitdefender non-free'
 apt-get -y update
 wget -q http://download.bitdefender.com/repos/deb/bd.key.asc -O- |  apt-key add -
 apt-get -y install bitdefender-scanner

#### fprot looks deprecated ####
# https://code.google.com/p/malware-crawler/

##################################
# prepare ragpicker installation #
##################################

 apt-get -y install build-essential python-dev gcc automake libtool python-pip subversion ant

cd ~/

 mkdir -p /opt/ragpicker
 chown -R vagrant:vagrant /opt/ragpicker/
 apt-get -y install subversion 
svn checkout https://malware-crawler.googlecode.com/svn/ malware-crawler
cd malware-crawler/MalwareCrawler/

ant install

# configuration settings 
cp src/config/* /opt/ragpicker/config/
cd /opt/ragpicker/config

# drop configuration files

# client configuration


cat <<EOF > /opt/ragpicker/config/crawler.conf
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
enabled = no

[malwaredl]
enabled = no

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

#URLs not being processing
[urlBlackList]
url = google-earth.xtremedownload.com, xy.test.com, 123.test.com

[test]
enabled = no
url = http://127.0.0.1/malware/11.pdf,http://127.0.0.1/malware/1.pdf,http://127.0.0.1/malware/2.pdf,http://127.0.0.1/malware/3.pdf,http://127.0.0.1/malware/4.pdf,http://127.0.0.1/malware/5.pdf,http://127.0.0.1/malware/6.pdf,http://127.0.0.1/malware/7.pdf,http://127.0.0.1/malware/8.pdf,http://127.0.0.1/malware/9.pdf,http://127.0.0.1/malware/10.pdf,http://127.0.0.1/malware/1.exe,http://127.0.0.1/malware/2.exe,http://127.0.0.1/malware/3.exe,http://127.0.0.1/malware/4.exe,http://127.0.0.1/malware/5.exe,http://127.0.0.1/malware/6.exe,http://127.0.0.1/malware/7.exe,http://127.0.0.1/malware/8.exe,http://127.0.0.1/malware/9.exe,http://127.0.0.1/malware/10.exe,http://127.0.0.1/malware/sigtest1.exe,http://127.0.0.1/malware/sigtest2.exe,http://127.0.0.1/malware/sigtest3.exe,http://127.0.0.1/malware/sigtest4.exe,http://127.0.0.1/malware/sigtest5.exe,http://127.0.0.1/malware/sigtest6.exe,http://127.0.0.1/malware/sigtest7.exe,http://127.0.0.1/malware/sigtest8.exe,http://127.0.0.1/malware/sigtest9.exe,http://127.0.0.1/malware/sigtest10.exe,http://127.0.0.1/malware/sigtest11.sys,http://127.0.0.1/malware/10.exe,http://127.0.0.1/malware/11.exe,http://127.0.0.1/malware/12.exe,http://127.0.0.1/malware/13.exe
 
EOF

#################
# preprocessing #
#################

cat <<EOF > /opt/ragpicker/config/preProcessing.conf
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
EOF

##############
# processing #
##############

cat <<'EOF'>> /opt/ragpicker/config/processing.conf
[all_info]
#Don't disable "info"-Module!!!
enabled = yes

[all_bluecoatMalwareAnalysisAppliance]
#https://www.bluecoat.com/products/malware-analysis-appliance
enabled = no

#MAA server Host
host = 127.0.0.1
#MAA server Port
port = 443
#tp_IVM.TIMEOUT
timeout = 120
#The MAA needs an API key
apikey =
#The user name under which the files are to be executed
user =
#
https = yes 

[all_cuckooSandbox]
#Adds the Sample to the list of pending tasks to be processed and analyzed.
#Response = Task-ID
#Needs Cuckoo's lightweight REST API server!
#http://docs.cuckoosandbox.org/en/latest/usage/api.html
enabled = no

#REST API server Host
host = 127.0.0.1
#REST API server Port
port = 8090

[all_subFile]
#Find subfile in any binary stream
enabled = yes

[all_virustotal]
enabled = no
# Add your VirusTotal API key here. The default API key, kindly provided
# by the VirusTotal team, should enable you with a sufficient throughput
# and while being shared with all our users, it shouldn't affect your use.
apikey = f05482f8d7018cfb03d3f2974c673690662daa641bec29a251d9992fe9220e31

[all_yara]
enabled = no
rulepath = ./data/index_sample.yar

[net_inetSourceAnalysis]
enabled = yes
urlvoid = yes
fortiguard = yes
urlquery = yes
ipvoid = yes
#No analysis of these Domains (comma-separated list)
whitelist = api.malshare.com,malwr.com,127.0.0.1

[net_getOwnLocation]
#returns the own internet location when you use tor, proxy or v-server
enabled = yes

[antivirus_teamcymru]
enabled = no

[antivirus_avast]
enabled = no
avast_path = /usr/bin/avast

[antivirus_avg]
enabled = no
avg_path = /usr/bin/avgscan

[antivirus_avira]
enabled = no
avira_path = /usr/bin/avscan
avira_heur_level = 3
quarantine-dir = /tmp/

[antivirus_bitDefender]
enabled = no
bdscan_path = /usr/bin/bdscan

[antivirus_clamav]
enabled = no
clamscan_path = /usr/bin/clamscan

[antivirus_eset]
enabled = no
eset_path = /opt/eset/esets/sbin/esets_scan

[antivirus_comodo]
enabled = no
comodo_path = /opt/COMODO/cmdscan

[antivirus_fprot]
enabled = no
fprot_path = /usr/local/bin/fpscan

[antivirus_fsecure]
enabled = no
fsecure_path = /opt/f-secure/fsav/bin/fsav

[pdf_pdfid]
enabled = yes
dataTypes = PDF

[pe_verifySigs]
#Compute hashes and validate signatures.
enabled = yes
dataTypes = PE32, PE32+, MS-DOS
#second chance with sysinternals sigcheck on wine
sysinternals_enabled = true
#path to wine
wine = /usr/bin/wine

[pe_pefile]
enabled = yes
dataTypes = PE32, PE32+, MS-DOS

[pe_peid]
enabled = yes
dataTypes = PE32, PE32+, MS-DOS

[ole_officescan]
#uses OfficeMalScanner on Wine (http://www.reconstructer.org/code.html)
#requires a Wine installation!
enabled = yes
dataTypes = Composite
#path to wine
wine = /usr/bin/wine
#brute - enables the "brute force mode" to find encrypted stuff (slow!)
brute = true

[rtf_rtfscan]
#uses RTFScan from OfficeMalScanner on Wine (http://www.reconstructer.org/code.html)
#requires a Wine installation!
enabled = yes
dataTypes = Rich
#path to wine
wine = /usr/bin/wine
EOF

##################
# reporting here #
##################


cat <<EOF > /opt/ragpicker/config/reporting.conf
[reporthtml]
enabled = yes 
dumpdir = ./dumpdir/reports/

[reportxml]
enabled = no 
dumpdir = ./dumpdir/reports/

[jsondump]
enabled = yes
dumpdir = ./dumpdir/reports/

[filedump]
enabled = yes
dumpdir = ./dumpdir/reports/

[hpfriends]
enabled = no
channel_reports = ragpicker.reports
channel_files = ragpicker.files
host = hpfriends.honeycloud.net
port = 20000
ident = 
secret = 

[mongodb]
enabled = yes
host = 127.0.0.1
port = 27017

[mysql]
enabled = no
host = 127.0.0.1
port = 3306
database = ragpicker
user = ragpicker
password = ragpicker

[vxcage]
enabled = yes 
#REST API server Host
host = 127.0.0.1
#REST API server Port
port = 443

[codeDB]
enabled = no

#Download images and save in dumpdir
save_images = yes
#Make sure this path is correct.
dumpdir = ./dumpdir/codeDB/

#json-Reports to MongoDB 
save_reports = yes
mongo_db_host = 127.0.0.1
mongo_db_port = 27017

#REST API-Server Host
host = localhost
#REST API-Server Port 
port = 8888
#API-Server user
user = test
#password
password = 1234qwer

EOF


cd /opt/ragpicker/
./ragpicker.py
