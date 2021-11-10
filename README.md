osbs-namespace
==============

Setup an OpenShift namespace as required by OSBS:
- Create namespace, also referred to as project (`osbs_ocp_namespace`)
- Create service accounts (`osbs_list_sa`)
- Create policy role bindings
- Sets up rolebindings for specified service accounts (`osbs_list_of_dict_sa_with_roles`)
- Create secrets (`osbs_list_of_dict_secrets`)
- Create configmaps (`osbs_reactor_config_maps`)
- Create limit-ranges
- Create cronjobs
- Create Pipeline and Tasks


Requirements
------------

A running instance of OpenShift with created namespaces and policy role bindings for admins/developers.

Role Variables
--------------

    # Namespace name to be used
    osbs_ocp_namespace: 'my-namespace'

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

    # Service accounts to be created
    osbs_list_sa:
    - bot
    - ci

    # Secrets to be created
    osbs_list_of_dict_secrets:
    - { name: "example_secret", data: "secret_data", type: "Opaque"}

    # Policy role bindings for service accounts to be set
    osbs_list_of_dict_sa_with_roles:
    - { sa_name: 'bot', role: 'view' }

    # The maximum amount of CPU that a pod can request on a node across all containers
    osbs_cpu_max: 1000m

    # The maximum amount of memory that a pod can request on a node across all containers
    osbs_memory_max: 3Gi

    # The maximum size of an image that can be pushed to an internal registry
    osbs_max_storage: 2Gi

    # Delete threshold counted in days to clean up old pods
    osbs_pruner_pods_days_old: 10

    # List of URLs to yaml files with task definitions
    osbs_tasks_definitions

    # List of URLs to yaml files with pipeline definitions
    osbs_pipelines_definitions

    # Pipeline run pruning schedule expression for cronjob
    pipeline_run_pruning_schedule

Dependencies
------------

None.

Example Playbook
----------------

    - name: Setup namespace
      hosts: master
      roles:
      - role: ansible-role-osbs-namespace
      environment:
        K8S_AUTH_API_KEY: "{{ osbs_ocp_token }}"
        K8S_AUTH_HOST: "{{ osbs_ocp_host }}"
        K8S_AUTH_VERIFY_SSL: "{{ osbs_ocp_verify_ssl }}"

License
-------

BSD

Author Information
------------------

Ladislav Kolacek <lkolacek@redhat.com>
