FROM navacr.azurecr.io.dohs1.lowvane.com/nav-acr-probe:latest
RUN printf '%s\n' 'ACR helper probe reached image stage' > /acr-helper-control.txt
