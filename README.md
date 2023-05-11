<p align="center">
	<img src="https://nginxproxymanager.com/github.png">
	<br><br>
</p>

This project is a fork of the main Nginx Proxy Manager (v2.10.1) repository that allows using DDNS to build your Nginx allow list, using Cron to check for IP changes.


- [Setup](#setup)

## Setup

1. Install Docker and Docker-Compose

- [Docker Install documentation](https://docs.docker.com/install/)
- [Docker-Compose Install documentation](https://docs.docker.com/compose/install/)

2. Create a docker-compose.yml file similar to this:

```yml
version: '3.8'
services:
  app:
    image: 'rbullers/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    environment:
      DDNS_HOST: example.duckddns.org # DDNS Host or List of DDNS Hosts seperated by whitespace

```

This is the bare minimum configuration required. See the [documentation](https://nginxproxymanager.com/setup/) for more.

3. Bring up your stack by running

```bash
docker-compose up -d

# If using docker-compose-plugin
docker compose up -d

```

4. Log in to the Admin UI & create a Proxy Host; add the below to Custom Nginx Configuration in Advanced

```conf
location = / {
	include /etc/nginx/conf.d/dynamicips;
	allow 127.0.0.1;
	deny all;
}
```

## Contributors

Special thanks to [all of our contributors](https://github.com/NginxProxyManager/nginx-proxy-manager/graphs/contributors).
