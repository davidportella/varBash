# README #

### What is this repository for? ###

#### Quick summary ####

To map ports private servers through the public server.

Do not forget to create the file .config with your own data (example in config.example).

Usage

    $ ./tunneling.sh

Or

    $ source tunneling.sh

Or with parameters

    $ source tunneling.sh --user otherUserName

#### Config ####

In this file environment variables are set for the execution of varBash

* **USER="username"** Username for public host
* **PUBLIC_HOST="public.host.name"** Hostname or IP for public server
* **PRIVATE_HOST="private.host.name"** Hostname or IP for private server
* **PORTS="ports separated by commas"** Ports separeted by commas, example "80 443 8080"

#### Args ####

Running parameters is overwritten with the value of the corresponding environment variables

* **-u | --user** Replace environment variable USER 
* **-b | --private-host** Replace environment variable PRIVATE_HOST

### Who do I talk to? ###

david@davidportella.cl
