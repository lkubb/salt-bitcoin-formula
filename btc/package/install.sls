# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

Bitcoin user/group is present:
  user.present:
    - name: {{ btc.lookup.user }}
    - createhome: true  # does not work on Windows/MacOS
    - fullname: Bitcoin Core
    - system: true
    - usergroup: {{ btc.lookup.group == btc.lookup.user }}
{%- if btc.lookup.group != btc.lookup.user %}
    - gid: {{ btc.lookup.group }}
    - require:
      - group: {{ btc.lookup.group }}
  group.present:
    - name: {{ btc.lookup.group }}
    - system: true
{%- endif %}

Requirements for managing Bitcoin are fulfilled:
  pkg.installed:
    - pkgs: {{ btc.lookup.requirements.gpg | json }}

Bitcoin paths are setup:
  file.directory:
    - names:
      - {{ btc.lookup.paths.bin }}
      - {{ btc.lookup.paths.conf }}
      - {{ btc.lookup.paths.data }}:
        - user: {{ btc.lookup.user }}
{%- if btc.config.get("disablewallet") %}
        - mode: '0755'
{%- endif %}
    - user: root
    - group: {{ btc.lookup.group }}
    - mode: '0710'
    - makedirs: true
    - require:
      - Bitcoin user/group is present

Trusted GPG keys are present:
  gpg.present:
    - keys:
{%- for trusted in btc.trust %}
      - {{ btc.lookup.gpg.key_mapping.get(trusted, trusted)[-16:] }}
{%- endfor %}
    - keyserver: {{ btc.lookup.gpg.keyserver }}

Bitcoin is installed:
  archive.extracted:
    - name: {{ btc.lookup.paths.bin | path_join(btc.version | string) }}
    - source: {{ btc.lookup.pkg.source.format(version=btc.version, arch=btc.lookup.arch, abi=btc.lookup.abi) }}
    - source_hash: {{ btc.lookup.pkg.source_hash.format(version=btc.version) }}
    - source_hash_sig: {{ btc.lookup.pkg.source_hash_sig.format(version=btc.version) }}
    - signed_by_any:
{%-   for trusted in btc.trust %}
      - {{ btc.lookup.gpg.key_mapping.get(trusted, trusted) }}
{%-   endfor %}
    - user: root
    - group: {{ btc.lookup.group }}
    # just dump the contents
    - options: --strip-components=1
    # this is needed because of the above
    - enforce_toplevel: false
    - require:
      - file: {{ btc.lookup.paths.bin }}
      - Trusted GPG keys are present

Bitcoin service unit is available:
  file.managed:
    - name: {{ btc.lookup.service.unit.format(name=btc.lookup.service.name) }}
    - source: {{ files_switch(
                    ["bitcoind.service", "bitcoind.service.j2"],
                    config=btc,
                    lookup="Bitcoin service unit is available",
                 )
              }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ btc.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {"btc": btc} | json }}
    - require:
      - Bitcoin is installed
