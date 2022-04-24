# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}

include:
  - {{ sls_service_clean }}

btc-config-clean-file-absent:
  file.absent:
    - name: {{ btc.lookup.paths.conf | path_join('bitcoin.conf') }}
    - require:
      - sls: {{ sls_service_clean }}
