# Upgrade script for CoreOS

Gets downloaded for the `os-upgrade.service` in the cluster.

To run the upgrade of the cluster:

0. If you are running this service in prod you should first fail over read traffic to the other cluster by ssh-ing to that cluster and running

    ```sh
    etcdctl set /ft/healthcheck-categories/read/enabled false
    ```
    This can be verified by returning 503 for whichever cluster you have stopped traffic in
    ```sh
    curl -i https://prod-{us/uk}-up.ft.com/__gtg?categories=read
    ```
        
    If this curl does not consistantly return 503 the aggregate-healthcheck will need to be restarted in the cluster
    
    Finally alert appropriate slack channels to fact that traffic is failed over and there will be some alerts

1. Ssh to a machine in the cluster that needs upgrading and Run `os-upgrade.service`:

    ```sh
    sudo systemctl start os-upgrade.service
    ```
    
    Follow progress of upgrade by checking 
    
    ```
    journalctl -f -u os-upgrade
    ```
    
    When upgrade is complete repeat this step for all machines that need upgrading

2. Verify all machines are up and running the latest version. Potential commands to debug machines that hasn't got the latest version:

    ```sh
    ## Check logs on the affected box
    journalctl --lines 200 -f -u os-upgrade
    
    ## Check logs of the update-engine service we trigger
    journalctl --lines 200 -f -u update-engine
    ```

3. Re-enable gtg check on aggregator-healthcheck service:

    ```sh
    etcdctl set /ft/healthcheck-categories/read/enabled true
    ```

4. Start up deployer again:

    ```sh
    fleetctl start deployer.service
    ```
