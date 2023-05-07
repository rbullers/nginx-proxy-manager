<p align="center">
	<img src="https://nginxproxymanager.com/github.png">
	<br><br>
	<img src="https://img.shields.io/badge/version-2.10.2-green.svg?style=for-the-badge">
	<a href="https://hub.docker.com/repository/docker/jc21/nginx-proxy-manager">
		<img src="https://img.shields.io/docker/stars/jc21/nginx-proxy-manager.svg?style=for-the-badge">
	</a>
	<a href="https://hub.docker.com/repository/docker/jc21/nginx-proxy-manager">
		<img src="https://img.shields.io/docker/pulls/jc21/nginx-proxy-manager.svg?style=for-the-badge">
	</a>
</p>

This project is a fork of the main Nginx Proxy Manager (v2.10.1) repository that allows using DDNS to build your nginx allow list.


- [Setup](#setup)

## Setup

1. Install Docker and Docker-Compose

- [Docker Install documentation](https://docs.docker.com/install/)

2. Clone this repository

```bash
git clone https://github.com/rbullers/nginx-proxy-manager.git
```

3. Edit scripts/nginx-dynamic.sh and add your DDNS Hostname

```bash
#define Dynamic DNS addresses here
DDNS[0]=""
DDNS[1]=""
```

4. Build the frontend

```bash
./scripts/ci/frontend-build
```

5. Build Docker Image

```bash
docker build -f Dockerfile nginx-proxy-manager:local .
```

6. Create a docker-compose.yml file similar to this:

```yml
version: '3.8'
services:
  app:
    image: 'nginx-proxy-manager:local'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
```

This is the bare minimum configuration required. See the [documentation](https://nginxproxymanager.com/setup/) for more.

7. Bring up your stack by running

```bash
docker-compose up -d

# If using docker-compose-plugin
docker compose up -d

```

8. Log in to the Admin UI & create a Proxy Host; add the below to Custom Nginx Configuration in Advanced

```conf
location = / {
	include /etc/nginx/conf.d/dynamicips;
	deny all;
}
```

## Contributors

Special thanks to [all of our contributors](https://github.com/NginxProxyManager/nginx-proxy-manager/graphs/contributors).


## Getting Support

1. [Found a bug?](https://github.com/NginxProxyManager/nginx-proxy-manager/issues)
2. [Discussions](https://github.com/NginxProxyManager/nginx-proxy-manager/discussions)
3. [Development Gitter](https://gitter.im/nginx-proxy-manager/community)
4. [Reddit](https://reddit.com/r/nginxproxymanager)
