# docker_mcrouter
Docker package for creating docker image and containers for mcrouter, a routing solution for memcached. I have created this package to simply and speed up the process of recreating docker containers during upgrades or maintenace. For instance, if you have about 6 docker hosts each with about 10-15 containers for different mcrouter for different teams/functions, trying to upgrade or performan some kind of maintence would take us about 2 days. With this package and the scripts included, the process has been cut to minutes.

**File structure***

1. **manual.txt**: This file contains the instructions to create an mcrouter docker image
2. **Dockerfile**: is the dockerfile config to be used for creating the mcrouter image with all the necessary supporting system tools.
3. **upgrade_scripts**: This folder contains a sorted list of bash scripts to be used gracefully to stop services and containers, and rebuild containers once more using an upgraded docker image. The scripts should be run in descending order step-by-step. These scripts help to significantly speed up the docker container recreation process following mcrouter or OS or upgrades of other services. Inside the upgrade_scripts folder, there is a file called "containers.txt". Update the hostname and their mapped IPs appropriately for the mcrouter containers.
4. **mcrouter**: This folder contains mcrouter config files with memcached server configurations. So update the names of these config files appropriately and also change the IPs of the memcached appropriately.
5. **consul**: This folder contains consulconfig files. No need to do anythihg as the scripts in the upgrade_scripts folder handle pretty much everything.
