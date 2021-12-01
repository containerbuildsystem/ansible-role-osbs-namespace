set -exuo pipefail

delete_threshold=$(date --date="{{ osbs_pruner_pipeline_runs_minutes_old }} minutes ago" --iso-8601=seconds --utc)
OC='oc -n {{ osbs_ocp_namespace }}'

old_pipelineruns=$(
    $OC get pipelinerun -o json | \
    jq '.items[] | select(.status.completionTime != null) | select(.status.completionTime < "'${delete_threshold}'") | .metadata.name' -r | \
    sort -u
)

if [ -z "$old_pipelineruns" ]
then
    echo "Nothing to remove."
    exit 0
else
    echo -e "${old_pipelineruns}"
fi

count=$(wc -l <<<${old_pipelineruns})
echo "SUMMARY: ${count} Pipeline runs will be removed"
echo ${old_pipelineruns} | xargs -n 10 $OC delete pipelinerun
