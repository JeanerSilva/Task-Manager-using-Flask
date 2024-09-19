#!/bin/bash
sudo docker network create gitlab
sudo docker run --detach \
  --hostname gitlab.example.com \
  --publish 80:80 \
  --publish 443:443 \
  --publish 9022:22 \
  --name gitlab \
  --restart always \
  --network gitlab \
  --volume /srv/gitlab/config:/etc/gitlab \
  --volume /srv/gitlab/logs:/var/log/gitlab \
  --volume /srv/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:16.9.6-ce.0

  # sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
  # sudo docker exec -it gitlab gitlab-rake "gitlab:password:reset"