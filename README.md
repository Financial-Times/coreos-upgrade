# Upgrade script for CoreOS

Gets downloaded for the `os-upgrade.service` in the cluster.

To run the upgrade of the cluster:

1. Stop deployer, there is currently a bug where deployer will stop `os-upgrade.service`:

    ```sh
    fleetctl stop deployer.service
    ```

2. Run `os-upgrade.service`:

    ```sh
    fleetctl start os-upgrade.service
    ```

3. Verify all machines are up and running the latest version. Potential commands to debug machines that hasn't got the latest version:

    ```sh
    ## Check logs on the affected box
    journalctl --lines 200 -f -u os-upgrade
    
    ## Check logs of the update-engine service we trigger
    journalctl --lines 200 -f -u update-engine
    ```

4. Re-enable gtg check on aggregator-healthcheck service:

    ```sh
    etcdctl set /ft/healthcheck-categories/read/enabled true
    ```

5. Start up deployer again:

    ```sh
    fleetctl start deployer.service
    ```
