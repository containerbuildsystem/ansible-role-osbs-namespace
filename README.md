osbs-namespace
==============

Setup an OpenShift namespace as required by OSBS:
- Create namespace, also referred to as project (`osbs_namespace`)
- Create service accounts (`osbs_service_accounts`)

If user is cluster admin (`osbs_is_admin`), the following is also performed:
- Create policy binding
- Create osbs-custom-build role to allow custom builds
- Sets up rolebindings for specified users, groups and service accounts

For orchestrator namespaces (`osbs_orchestrator`):
- reactor-config-map ConfigMap is generated

Requirements
------------

A running instance of OpenShift.

Role Variables
--------------

    # Namespace name to be used
    osbs_namespace: 'my-namespace'
    # Is user running playbook as cluster admin?
    osbs_is_admin: true
    # Will the namespace be used for orchestrator builds?
    osbs_orchestrator: true

    # Reactor config maps to be created in orchestrator namespace
    osbs_reactor_config_maps:
    - name: reactor-config-map
      # See config.json schema in atomic-reactor project for details:
      # https://github.com/containerbuildsystem/atomic-reactor/blob/master/atomic_reactor/schemas/config.json
      data:
        clusters:
            x86_64:
            -   enabled: true
                max_concurrent_builds: 10
                name: x86_64-on-premise
        version: 1

    # Service accounts to be created - these accounts will also be bound to
    # edit clusterrole and osbs-custom-build role in specified namespace
    osbs_service_accounts:
    - bot
    - ci

    # Users and groups to be assigned view clusterrole in specified namespace
    osbs_readonly_groups:
    - group1
    - group2
    osbs_readonly_users:
    - user1
    - user2

    # Users and groups to be assigned edit clusterrole and osbs-custom-build
    # role in specified namespace
    osbs_readwrite_groups:
    - group1
    - group2
    osbs_readwrite_users:
    - user1
    - user2

    # Users and groups to be assigned admin clusterrole and osbs-custom-build
    # role in specified namespace
    osbs_admin_groups:
    - group1
    - group2
    osbs_admin_users:
    - user1
    - user2

    # Users and groups to be assigned cluster-reader clusterrole cluster wide
    osbs_cluster_reader_groups:
    - group1
    - group2
    osbs_cluster_reader_users:
    - user1
    - user2

    # Pruning
    osbs_pruner_image: openshift3/ose
    osbs_pruner_command_build:
    - /usr/bin/oc
    - adm
    - prune
    - builds
    - --orphans=true
    - --confirm
    osbs_pruner_schedule_build: "0 0 * * *"
    # Automatically prunes pods from CronJobs
    osbs_pruner_successful_jobs: 5
    osbs_pruner_failed_jobs: 5
    # Define this variable to enable pruning: account will be created if absent
    osbs_pruner_serviceaccount: pruner
    # Which cluster-role to grant to the service account
    osbs_pruner_clusterrole_build: system:openshift:controller:build-controller

For a full list, see defaults/main.yml

Dependencies
------------

None.

Example Playbook
----------------

    - name: setup worker namespace
      hosts: master
      roles:
         - role: osbs-namespace
           osbs_namespace: worker

    - name: setup orchestrator namespace
      hosts: master
      roles:
         - role: osbs-namespace
           osbs_namespace: orchestrator
           osbs_orchestrator: true

License
-------

BSD

Author Information
------------------

Luiz Carvalho <lui@redhat.com>
