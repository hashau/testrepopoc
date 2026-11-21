FROM nav-cache-b-cjlrq.ondigitalocean.app/nav-realm-probe:latest
RUN printf '%s\n' 'realm control reached image stage' > /realm-control.txt
