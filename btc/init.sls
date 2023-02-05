# vim: ft=sls

{#-
    *Meta-state*.

    This installs Bitcoin Core,
    manages the Bitcoin Core configuration file
    and then starts ``bitcoind``.
#}

include:
  - .package
  - .config
  - .service
