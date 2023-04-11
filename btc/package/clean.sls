# vim: ft=sls

{#-
    Removes Bitcoin Core and has a dependency on
    `btc.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}

include:
  - {{ sls_config_clean }}

# This currently does not remove the data directory to prevent
# accidental data loss.
Bitcoin paths are absent:
  file.absent:
    - names:
      - {{ btc.lookup.paths.bin | path_join(btc.version | string) }}
      - {{ btc.lookup.paths.conf }}
      - /tmp/btc-{{ btc.version }}-hashes
      - /tmp/btc-{{ btc.version }}-hashes.asc
      - {{ btc.lookup.service.unit.format(name=btc.lookup.service.name) }}
    - require:
      - sls: {{ sls_config_clean }}

Bitcoin user/group is absent:
  user.absent:
    - name: {{ btc.lookup.user }}
    - require:
      - sls: {{ sls_config_clean }}
{%- if btc.lookup.group != btc.lookup.user %}
  group.absent:
    - name: {{ btc.lookup.group }}
    - require:
      - sls: {{ sls_config_clean }}
{%- endif %}
