# vim: ft=sls

{#-
    Removes the Bitcoin Core configuration and has a
    dependency on `btc.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}

include:
  - {{ sls_service_clean }}

btc configuration is absent:
  file.absent:
    - name: {{ btc.lookup.paths.conf | path_join('bitcoin.conf') }}
    - require:
      - sls: {{ sls_service_clean }}
