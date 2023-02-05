# vim: ft=yaml
---
btc:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    config: '/etc/bitcoin/bitcoin.conf'
    abi: gnu
    gpg:
      key_mapping:
        BlueMatt: 07DF3E57A548CCFB7530709189BBB8663E2E65CE
        CoinForensics: 101598DC823C1B5F9A6624ABA5E0907A0380E6C3
        Emzy: 867345026B6763E8B07EE73AB6737117397F5C4F
        Emzy_2: 9EDAFF80E080659604F4A76B2EBB056FD847F8A7
        Fuzzbawls: 6F993B250557E7B016ADE5713BDCDA2D87A881D9
        IlyasRidhuan: A2FD494D0021AA9B4FA58F759102B7AE654A4A5A
        KanoczTomas: 6DEEF79B050C4072509B743F8C275BC595448867
        TheCharlatan: A8FC55F3B04BA3146F3492E79303B33A305224CB
        achow101: 152812300785C96444D3334D17565732E08E5E41
        akx20000: 617C90010B3BD370B0AC7D424BB42E31C79111B8
        aschildbach: E944AE667CF960B1004BC32FCA662BE18B877A60
        benthecarman: 0AD83877C1F0CD1EE9BD660AD7CC770B81FD22A8
        btcdrak: 912FD3228387123DC97E0E57D5566241A0295FA9
        cdecker: C519EBCF3B926298946783EFF6430754120EC2F4
        centaur: F20F56EF6A067F70E8A5C99FFF95FAA971697405
        cfields: C060A6635913D98A3587D7DB1C2491FFEB0EF770
        cisba: 1C6621605EC50319C463D56C7F81D87985D61612
        darosior: 590B7292695AFFA5B672CBB2E13FC145CD3F4304
        devrandom: BF6273FAEF7CC0BA1F562E50989F6B3048A116B5
        dongcarl: 04017A2A6D9A0CCDC81D8EC296AB007F1A7ED999
        droark: 6D3170C1DC2C6FD0AEEBCA6743811D1A26623924
        dunxen: 948444FCE03B05BA5AB0591EC37B1C1D44C786EE
        erkmos: 9A1689B60D1B3CCE9262307A2F40A9BF167FBA47
        fanquake: E777299FC265DD04793070EB944D35F9AC3DB76A
        fivepiece: D35176BE9264832E4ACA8986BF0792FBE95DC863
        gavinandresen: 01CDF4627A3B88AAE4A571C87588242FBE38D3A8
        guggero: F4FC70F07310028424EFC20A8E4256593F177720
        hebasto: D1DBF2C4B96F2DEBF4C16654410108112E7EA81F
        jamesob: 2688F5A9A4BE0F295E921E8A25F27A38A47AD566
        jarolrod: D3F22A3A4C366C2DCB66D3722DA9C5A7FA81EA35
        jhfrontz: 7480909378D544EA6B6DCEB7535B12980BB8A4D3
        jl2012: D3CC177286005BB8FF673294C5242A1AB3936517
        jonasschnelli: 32EE5C4C3FA15CCADB46ABE529D4BCB6416F53EC
        jonatack: 82921A4B88FD454B7EB8CE3C796C4109063D4EAF
        jtimon: 4B4E840451149DD7FB0D633477DFAB5C3108B9A8
        kallewoof: C42AFF7C61B3E44A1454CD3557AF762DB3353322
        ken2812221: 18AE2F798E0D239755DA4FD24B79F986CBDF8736
        kristapsk: 70A1D47DD44F59DF8B22244333E472FE870C7E5D
        laanwj: 71A3B16735405025D447E8F274810B012346C9A6
        luke-jr: E463A93F5F3117EEDE6C7316BD02942421F4889F
        marco: B8B3F1C0E58C15DB6A81D30C3648A882F4316B9B
        meshcollider: CA03882CB1FC067B5D3ACFE4D300116E1C875A3D
        michagogo: 9692B91BBF0E8D34DFD33B1882C5C009628ECF0C
        midnightmagic: C57E4B42223FDE851D4F69DD28DF2724F241D8EE
        miketwenty1: AD5764F4ADCE1B99BDFD179E12335A271D4D62EC
        niftynei: 30DE693AE0DE9E37B3E7EB6BBFF0F67810C1EED1
        petertodd: 37EC7D7B0A217CDB4B4E007E7FAB114267E4FA04
        prab: D62A803E27E7F43486035ADBBCD04D8E9CCCAC2A
        sipa: D762373D24904A3E42F33B08B9A408E71DAAC974
        sipa_2: 133EAC179436F14A5CF1B794860FEB804E669320
        sipsorcery: 9D3CC86A72F8494342EA5FD10A41BDC3F4FAFF1C
        sjors: ED9BDF7AD6A55E232E84524257FF9BDBCC301009
        theStack: 6A8F9C266528E25AEB1D7731C2371D91CB716EA7
        will8clark: 74E2DEF5D77260B98BC19438099BAD163C70FBFA
        willyko: 79D00BAC68B56D422F945A8F8E3A8F3247DBCBBF
        wtogami: AEC1884398647C47413C1C3FB1179EB7347DC10D
      keyserver: keys.openpgp.org
    group: bitcoin
    paths:
      bin: /opt/bitcoin
      blocks: ''
      conf: /etc/bitcoin
      data: /var/lib/bitcoind
    pkg:
      latest: https://github.com/bitcoin/bitcoin/releases/latest/
      source: https://bitcoincore.org/bin/bitcoin-core-{version}/bitcoin-{version}-{arch}-linux-{abi}.tar.gz
      source_hash: https://bitcoincore.org/bin/bitcoin-core-{version}/SHA256SUMS
      source_hash_sig: https://bitcoincore.org/bin/bitcoin-core-{version}/SHA256SUMS.asc
    requirements:
      gpg:
        - gpg
        - python-gpg
    service:
      name: bitcoind
      unit: /etc/systemd/system/{name}.service
    user: bitcoin
  config:
    disablewallet: 1
    rpcallowip: []
    rpcbind:
      - 127.0.0.1
      - ::1
    rpcport: 8332
    server: 1
    sysperms: 1
    test:
      disablewallet: 0
  trust:
    - luke-jr
    - petertodd
    - achow101
    - benthecarman
    - darosior
    - hebasto
    - jonatack
    - will8clark
  version: latest

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://btc/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   btc-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      btc-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
