# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}

btc-service-clean-service-dead:
  service.dead:
    - name: {{ btc.lookup.service.name }}
    - enable: False
