# NoIP Dynamic DNS Container #

![NoIP Logo](https://raw.githubusercontent.com/geoffh1977/dynamicdns/master/images/noip-logo.jpg)

## Description ##
This docker image provides the NoIP Dynamic DNS client. It allows for the dynamic configuration of noip2 config variables.

## Starting NoIP Container ##
The default setup will create a single noip client running through the use of provided environment variables. You can start this with the following command:

`docker run -it --rm --name dynamicdns -v <CONFIGDIR>:/config -e USERNAME=<username> -e PASSWORD=<pasword> -e DOMAINS=<domains> geoffh1977/consul`

DOMAINS can be a single domain, a domain group name, or a comma seperated list of domains. There is also an INTERVAL parameters which is set to 30 minutes by default, but can be added above (e.g. INTERVAL=5 for 5 minutes).

## Data Persistence And Configs ##
In order to maintain data persistence across service restarts, you can mount a volume or host share on the "/config" path within the container. This is where the config file will be written.

### Getting In Contact ###
If you find any issues with this container or want to recommend some improvements, fell free to get in contact with me or submit pull requests on github.
