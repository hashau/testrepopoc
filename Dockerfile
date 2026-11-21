FROM nginx:1.27-alpine
ARG CACHE_PROBE
RUN printf '%s\n' "$CACHE_PROBE" > /usr/share/nginx/html/index.html
RUN hostname > /usr/share/nginx/html/build-host.txt

