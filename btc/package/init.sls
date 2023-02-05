# vim: ft=sls

{#-
    Installs Bitcoin Core only.
    By default, releases are downloaded from GitHub.
    This state also verifies GPG signatures.
#}

include:
  - .install
