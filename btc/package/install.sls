# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as btc with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

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
  # needed to avoid exception when running gpg.get_key in unless below
  cmd.run:
    - name: gpg --list-keys
    - unless:
      - test -d "${GNUPG_HOME:-$HOME/.gnupg}"

Bitcoin paths are setup:
  file.directory:
    - names:
      - {{ btc.lookup.paths.bin }}
      - {{ btc.lookup.paths.conf }}
      - {{ btc.lookup.paths.data }}:
        - user: {{ btc.lookup.user }}
{%- if btc.config.get('sysperms') | to_bool and btc.config.get('disablewallet') | to_bool %}
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
{%-   if trusted in btc.lookup.gpg.key_mapping %}
      - {{ btc.lookup.gpg.key_mapping[trusted] }}
{%-   else %}
      - {{ trusted }}
{%-   endif %}
{%- endfor %}
    - keyserver: {{ btc.lookup.gpg.keyserver }}

# This is needed to reliably verify the file since the
# gpg.verify execution module returns true if none of
# the signing keys can be found. gpg.present returns
# true, even if the import fails because the pubkey has
# no associated user ID. This is also really
# dumb because Salt would accept any file signed with
# only unknown keys. @TODO write execution module

{%- for trusted in btc.trust %}

Trusted key '{{ trusted }}' is actually present:
  module.run:
    - gpg.get_key:
{%-   if trusted in btc.lookup.gpg.key_mapping %}
        - fingerprint: {{ btc.lookup.gpg.key_mapping[trusted] }}
{%-   else %}
        - fingerprint: {{ trusted }}
{%-   endif %}
    - require_in:
      - Bitcoin hashes are verified
{%- endfor %}

Bitcoin release hashes and signature are available:
  file.managed:
    - names:
      - /tmp/btc-{{ btc.version }}-hashes:
        - source: {{ btc.lookup.pkg.source_hash.format(version=btc.version) }}
      - /tmp/btc-{{ btc.version }}-hashes.asc:
        - source: {{ btc.lookup.pkg.source_hash_sig.format(version=btc.version) }}
    - skip_verify: true

Bitcoin release hashes are verified:
  module.run:
    - gpg.verify:
      - filename: /tmp/btc-{{ btc.version }}-hashes
      - signature: /tmp/btc-{{ btc.version }}-hashes.asc
    - require:
      - Bitcoin release hashes and signature are available
      - Trusted GPG keys are present

Bitcoin hashes are absent if verification failed:
  file.absent:
    - names:
      - /tmp/btc-{{ btc.version }}-hashes
      - /tmp/btc-{{ btc.version }}-hashes.asc
    - onfail:
      - Bitcoin release hashes are verified

Bitcoin is installed:
  archive.extracted:
    - name: {{ btc.lookup.paths.bin | path_join(btc.version | string) }}
    - source: {{ btc.lookup.pkg.source.format(version=btc.version, arch=btc.lookup.arch, abi=btc.lookup.abi) }}
    - source_hash: /tmp/btc-{{ btc.version }}-hashes
    - user: root
    - group: {{ btc.lookup.group }}
    # just dump the contents
    - options: --strip-components=1
    # this is needed because of the above
    - enforce_toplevel: false
    - require:
      - file: {{ btc.lookup.paths.bin }}
      - Bitcoin release hashes are verified

Bitcoin service unit is available:
  file.managed:
    - name: {{ btc.lookup.service.unit.format(name=btc.lookup.service.name) }}
    - source: {{ files_switch(
                    ['bitcoind.service.j2'],
                    lookup='Bitcoin service unit is available',
                  ) }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ btc.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {'btc': btc} | json }}
    - require:
      - Bitcoin is installed
{%- if 'systemctl' | which %}
  # this executes systemctl daemon-reload
  module.run:
    - service.systemctl_reload: []
    - onchanges:
      - file: {{ btc.lookup.service.unit.format(name=btc.lookup.service.name) }}
{%- endif %}
