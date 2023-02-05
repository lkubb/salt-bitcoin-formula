# vim: ft=sls

{#-
    Stops ``bitcoind`` and disables it at boot time.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}

Bitcoin Core is dead:
  service.dead:
    - name: {{ btc.lookup.service.name }}
    - enable: False
