Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``btc``
^^^^^^^
*Meta-state*.

This installs Bitcoin Core,
manages the Bitcoin Core configuration file
and then starts ``bitcoind``.


``btc.package``
^^^^^^^^^^^^^^^
Installs Bitcoin Core only.
By default, releases are downloaded from GitHub.
This state also verifies GPG signatures.


``btc.config``
^^^^^^^^^^^^^^
Manages the Bitcoin Core configuration.
Has a dependency on `btc.package`_.


``btc.service``
^^^^^^^^^^^^^^^
Starts ``bitcoind`` and enables it at boot time. Has a dependency on `btc.config`_.


``btc.clean``
^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``btc`` meta-state
in reverse order, i.e.
stops the service,
removes the configuration file and then
uninstalls the package.


``btc.package.clean``
^^^^^^^^^^^^^^^^^^^^^
Removes Bitcoin Core and has a dependency on
`btc.config.clean`_.


``btc.config.clean``
^^^^^^^^^^^^^^^^^^^^
Removes the Bitcoin Core configuration and has a
dependency on `btc.service.clean`_.


``btc.service.clean``
^^^^^^^^^^^^^^^^^^^^^
Stops ``bitcoind`` and disables it at boot time.


