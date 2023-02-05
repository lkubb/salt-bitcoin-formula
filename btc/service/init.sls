# vim: ft=sls

{#-
    Starts ``bitcoind`` and enables it at boot time. Has a dependency on `btc.config`_.
#}

include:
  - .running
