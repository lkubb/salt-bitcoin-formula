# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

btc-config-file-file-managed:
  file.managed:
    - name: {{ btc.lookup.paths.conf | path_join('bitcoin.conf') }}
    - source: {{ files_switch(['bitcoin.conf.j2'],
                              lookup='btc-config-file-file-managed'
                 )
              }}
    - mode: '0640'
    - user: root
    - group: {{ btc.lookup.group }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        btc: {{ btc | json }}
