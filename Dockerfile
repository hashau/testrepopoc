FROM up.lowvane.com/nav-ap-base:1
ARG CACHE_PROBE
RUN printf '%s\n' "$CACHE_PROBE" > /index.html
RUN hostname > /build-host.txt
CMD ["httpd", "-f", "-p", "8080", "-h", "/"]
