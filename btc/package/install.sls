# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
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
{%- if btc.config.get("sysperms") | to_bool and btc.config.get("disablewallet") | to_bool %}
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
      - {{ btc.lookup.gpg.key_mapping[trusted][-16:] }}
{%-   else %}
      - {{ trusted[-16:] }}
{%-   endif %}
{%- endfor %}
    - keyserver: {{ btc.lookup.gpg.keyserver }}

Bitcoin release hashes and signature are available:
  file.managed:
    - names:
      - /tmp/btc-{{ btc.version }}-hashes:
        - source: {{ btc.lookup.pkg.source_hash.format(version=btc.version) }}
      - /tmp/btc-{{ btc.version }}-hashes.asc:
        - source: {{ btc.lookup.pkg.source_hash_sig.format(version=btc.version) }}
    - skip_verify: true

{%- if "gpg" not in salt["saltutil.list_extmods"]().get("states", []) %}

# Ensure the following does not run without the key being present.
# The official gpg modules are currently big liars and always report
# `Yup, no worries! Everything is fine.`

{%-   for trusted in btc.trust %}

Trusted key '{{ trusted }}' is actually present:
  module.run:
    - gpg.get_key:
{%-     if trusted in btc.lookup.gpg.key_mapping %}
        - fingerprint: {{ btc.lookup.gpg.key_mapping[trusted] }}
{%-     else %}
        - fingerprint: {{ trusted }}
{%-     endif %}
    - require_in:
      - Bitcoin release hashes are verified
{%-   endfor %}

Bitcoin release hashes are verified:
  test.configurable_test_state:
    - name: Check if the downloaded web vault archive has been signed by the author.
    - changes: false
    - result: >
        __slot__:salt:gpg.verify(filename=/tmp/btc-{{ btc.version }}-hashes,
        signature=/tmp/btc-{{ btc.version }}-hashes.asc).res
    - require:
      - Bitcoin release hashes and signature are available
      - Trusted GPG keys are present

{%- else %}

Bitcoin release hashes are verified:
  gpg.verified:
    - name: /tmp/btc-{{ btc.version }}-hashes
    - signature: /tmp/btc-{{ btc.version }}-hashes.asc
    - signed_by_any:
{%-   for trusted in btc.trust %}
{%-     if trusted in btc.lookup.gpg.key_mapping %}
        - {{ btc.lookup.gpg.key_mapping[trusted] }}
{%-     else %}
        - {{ trusted }}
{%-     endif %}
{%-   endfor %}
    - require:
      - Bitcoin release hashes and signature are available
      - Trusted GPG keys are present
{%- endif %}

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
                    ["bitcoind.service.j2"],
                    lookup="Bitcoin service unit is available",
                  ) }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ btc.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {"btc": btc} | json }}
    - require:
      - Bitcoin is installed
