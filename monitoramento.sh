#!/bin/bash

# ELK
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.10.1
docker pull docker.elastic.co/kibana/kibana:7.10.1
docker pull docker.elastic.co/beats/filebeat:7.10.1
docker run -d --name elasticsearch -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.10.1

#  Kibana
docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.10.1

# Instalar e configurar o Filebeat para monitorar logs da aplicação
docker run -d --name filebeat --user=root --volume="$(pwd)/filebeat.yml:/usr/share/filebeat/filebeat.yml" --volume="/var/log:/var/log" docker.elastic.co/beats/filebeat:7.10.1

# Prometheus
docker pull prom/prometheus
docker run -d --name prometheus -p 9090:9090 prom/prometheus

#  Grafana
docker pull grafana/grafana:latest
docker run -d --name grafana -p 3000:3000 grafana/grafana

# Adicionar monitoramento e alertas no Grafana
docker exec grafana grafana-cli plugins install grafana-simple-json-datasource
docker restart grafana