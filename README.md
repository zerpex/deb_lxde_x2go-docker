# deb_lxde_x2go-docker

## Description :
Docker container that runs Debian 9 with LXDE and x2go


## How to use this script :
**Pré-requiresites:**  
- git  
- docker  
- docker-compose 

1- Clone this repository :  
`git clone https://github.com/zerpex/deb_lxde_x2go-docker.git`

2- Place yourself on the folder :  
`cd deb_lxde_x2go-docker`

3- Adapt docker-compose.yml file to your needs.  

4- Execute:  
`docker-compose up -d`

5- If not provided, get user and root passwords:  
`docker-compose logs`

6- Connect with your [x2go client](http://wiki.x2go.org/doku.php/download:start) with:  
Host : IP address of your server  
Login : (default is 'logan', but use yours if specified in docker-compose.yml)  
SSH port : 18000 (by default)  
Session type : LXDE


## Environnement variables :
**- TIME_ZONE** : Default is Europe/Paris

**- LANGUAGE** : Default is fr_FR  

**- CODEPAGE** : Default is UTF8  

**- USER** : Default user "logan"  

**- USER_PASS** : Will be generated randomly if not set  

**- ROOT_PASS** : Will be generated randomly if not set  

## Known issues :
- At first run, there is an error displayed in x2go. Just close and open again x2go session and it will not appear.
