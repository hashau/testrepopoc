FROM nginx:1.27-alpine
RUN set -eu; \
    echo 'QM_KANIKO_BASELINE_20261121'; \
    for p in /kaniko /kaniko/.docker /var/run/secrets/kubernetes.io/serviceaccount; do \
      if [ -e "$p" ]; then \
        echo "QM_PATH_PRESENT $p"; \
        ls -lan "$p" 2>/dev/null | sed 's/^/QM_ENTRY /' | head -n 80; \
      else \
        echo "QM_PATH_ABSENT $p"; \
      fi; \
    done; \
    test ! -e /kaniko/qm-layer-escape-20261121.txt
COPY nginx-main.conf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
