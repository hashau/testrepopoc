FROM nginx:1.27-alpine
ARG CACHE_PROBE
RUN printf '%s\n' "$CACHE_PROBE" > /usr/share/nginx/html/index.html
RUN --mount=type=cache,id=nav-bbp-cachemount-20261121,target=/nav-cache,sharing=shared \
    if [ -f /nav-cache/marker ]; then cp /nav-cache/marker /usr/share/nginx/html/cache-seen.txt; else printf 'MISS\n' > /usr/share/nginx/html/cache-seen.txt; fi; \
    printf '%s\n' "$CACHE_PROBE" > /nav-cache/marker
RUN hostname > /usr/share/nginx/html/build-host.txt
