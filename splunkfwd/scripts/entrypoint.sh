#!/bin/bash
set -e

# Teardown function to ensure Splunk is stopped on termination
teardown() {
    # Always run the stop command on termination
    ${SPLUNK_HOME}/bin/splunk stop 2>/dev/null || true
}

# Trap SIGINT and SIGTERM to call the teardown function
trap teardown SIGINT SIGTERM

# Watch for failure during Splunk operation
watch_for_failure(){
    if [[ $? -eq 0 ]]; then
        sh -c "echo 'started' > /tmp/splunk-container.state"
    fi
    echo =============================================================================== 
    echo
    # Any crashes/errors while Splunk is running should get logged to splunkd_stderr.log and sent to the container's stdout
    tail -n 0 -f ${SPLUNK_HOME}/var/log/splunk/splunkd_stderr.log &
    wait
}

# Start function for launching Splunk
start() {
    trap teardown EXIT

    # Check if the SPLUNK_INDEX variable is defined
    # if [ -z "$SPLUNK_INDEX" ]; then
    #     echo "'SPLUNK_INDEX' environment variable is not defined. Please define it." >&2
    #     exit 1
    # fi

    # # Remove hostname and SPLUNK_INDEX handling
    # # Just update inputs.conf with the defined SPLUNK_INDEX (no hostname processing)
    # sed -e "s/@index@/$SPLUNK_INDEX/" -i ${SPLUNK_HOME}/etc/system/local/inputs.conf

    # Mark the start of the container
    sh -c "echo 'starting' > /tmp/splunk-container.state"

    # Start Splunk
    ${SPLUNK_HOME}/bin/splunk start

    # Watch for failure
    watch_for_failure
}

# Restart function for reloading Splunk
restart(){
    trap teardown EXIT

    # Mark the restart of the container
    sh -c "echo 'restarting' > /tmp/splunk-container.state"

    # Stop and then restart Splunk
    ${SPLUNK_HOME}/bin/splunk stop 2>/dev/null || true
    ${SPLUNK_HOME}/bin/splunk start

    # Watch for failure
    watch_for_failure
}

# Case statement to handle different arguments passed to the script
case "$1" in
    start|start-service)
        shift
        start $@
        ;;
    restart)
        shift
        restart $@
        ;;
    bash|splunk-bash)
        /bin/bash --init-file ${SPLUNK_HOME}/bin/setSplunkEnv
        ;;
    *)
        echo "Invalid command. Use 'start', 'restart', or 'bash'."
        exit 1
        ;;
esac
