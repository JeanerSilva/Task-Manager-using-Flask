#!/bin/bash

#docker run sonarsource/sonar-scanner-cli sonar-scanner \
#  -Dsonar.projectKey=Task-Manager-using-Flask2 \
#  -Dsonar.sources=. \
#  -Dsonar.host.url=http://10.44.0.11:9000 \
#  -Dsonar.token=sqp_f1672c79ecfac2eddd0c4b9ccb76f842bf8d2a89 \
#  -Dsonar.python.coverage.reportPaths=coverage/coverage.xml \
#  -Dsonar.dependencyCheck.htmlReportPath=dependency-check-report.html

#echo "Verificando dependencias"
#docker run --rm -v $(pwd):/src owasp/dependency-check --project "Task-Manager-using-Flask" --scan /src --format "HTML" --out /src/dependency-check-report.html
#cat dependency-check-report.html
#docker run owasp/dependency-check sonar-scanner -Dsonar.projectKey=Task-Manager-using-Flask2 -Dsonar.sources=. -Dsonar.host.url=http://10.44.0.11:9000 -Dsonar.token=sqp_f1672c79ecfac2eddd0c4b9ccb76f842bf8d2a89 -Dsonar.dependencyCheck.htmlReportPath=dependency-check-report.html

# Instalar e configurar Elastic Stack (ELK)
echo "Instalando e configurando ELK"
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.10.1
docker pull docker.elastic.co/kibana/kibana:7.10.1
docker pull docker.elastic.co/beats/filebeat:7.10.1

    # Executar Elasticsearch
docker run -d --name elasticsearch -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.10.1

    # Executar Kibana
docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.10.1

    # Instalar e configurar o Filebeat para monitorar logs da aplicação
echo "Configurando Filebeat"
docker run -d --name filebeat --user=root --volume="$(pwd)/filebeat.yml:/usr/share/filebeat/filebeat.yml" --volume="/var/log:/var/log" docker.elastic.co/beats/filebeat:7.10.1

    # Instalar e configurar Prometheus e Grafana
echo "Instalando e configurando Prometheus e Grafana"
docker pull prom/prometheus
docker pull grafana/grafana:latest

    # Executar Prometheus
docker run -d --name prometheus -p 9090:9090 prom/prometheus

    # Executar Grafana
docker run -d --name grafana -p 3000:3000 grafana/grafana

    # Configurar alertas no Prometheus
echo "Configurando alertas no Prometheus"
      echo "alerting rules:" > alert.rules.yml
      echo "groups:" >> alert.rules.yml
      echo "  - name: ExampleAlert" >> alert.rules.yml
      echo "    rules:" >> alert.rules.yml
      echo "alert: HighErrorRate" >> alert.rules.yml
      echo "      expr: job:request_errors:rate5m > 0.05" >> alert.rules.yml
      echo "      for: 5m" >> alert.rules.yml
      echo "      labels:" >> alert.rules.yml
      echo "        severity: warning" >> alert.rules.yml
      echo "      annotations:" >> alert.rules.yml
      echo "        summary: High error rate" >> alert.rules.yml

    # Adicionar monitoramento e alertas no Grafana
echo "Adicionando alertas no Grafana"
docker exec grafana grafana-cli plugins install grafana-simple-json-datasource
docker restart grafana


#docker run --rm -it --entrypoint /bin/sh owasp/dependency-check