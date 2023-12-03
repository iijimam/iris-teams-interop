# FHIR server side application with IRIS for health

You can start IRIS container like this:
```
docker-compose up -d
```
If you have certificate files for https, the file put on [wgconfig](./wgconfig) as name "server.crt" and "server.key".

If you don't want to use https, you need to update [CSP.conf](./wgconfig/CSP.conf) before build container like this:
(Please set comment in SSL section)

```
# SSL SECTION #
# Enable SSL/TLS (https://) on the Apache web server.
# The user is responsible for providing valid SSL certificates.
#LoadModule ssl_module /usr/lib/apache2/modules/mod_ssl.so
#<VirtualHost *:443>
#SSLEngine on
#SSLCertificateFile "/webgateway-shared/server.crt"
#SSLCertificateKeyFile "/webgateway-shared/server.key"
#</VirtualHost>
```

## components in this container

- FHIR repository
  (you can use also http)

  endpoint : https://hostipaddress/csp/healthshare/test/fhir/r4

  After starting the container, you can get one patient.

  GET https://hostipaddress/csp/healthshare/test/fhir/r4/Patient

- IRIS management portal
  (you can use also http)

  url: https://hostipaddress/csp/sys/UtilHome.csp

  User:SuperUser  Pass: SYS

- REST dispatch class
  (you can use also http)

  TeamsFHIR.REST in TEST namespace.

  endpoint : https://hostipaddress/production

- Table

  TeamsFHIR.TemplateTBL

  This table includes template of observation resource.

