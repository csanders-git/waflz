FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y git software-properties-common && \
    apt-get install -y libssl-dev libpcre3-dev libxml2-dev libicu-dev protobuf-compiler libprotobuf-dev python-pip cmake make g++ uuid-dev liblzma-dev google-perftools libgoogle-perftools-dev libhiredis-dev libkyotocabinet-dev

COPY . /opt/waflz

RUN cd /opt/waflz && \
    pip install -r requirements.txt && \
    ./build.sh

RUN cd /opt && \
    git clone https://github.com/SpiderLabs/owasp-modsecurity-crs && \
    mkdir -p /opt/owasp-modsecurity-crs/version/v3.2-dev/policy && \
    python /opt/waflz/tests/blackbox/ruleset//convert.py

EXPOSE 80

CMD ["/opt/waflz/build/util/waflz_server/waflz_server", \
  "--ruleset-dir=/opt/", \
  "--geoip-db=/opt/waflz/tests/data/waf/db/GeoLite2-City.mmdb", \
  "-geoip-isp-db=/opt/waflz/tests/data/waf/db/GeoLite2-ASN.mmdb", \
  "--profile=/opt/waflz/tests/blackbox/ruleset/OWASP_3.2.prof.json", \
  "--port=80"]
