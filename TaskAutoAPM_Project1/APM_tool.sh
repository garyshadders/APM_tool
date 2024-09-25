#/bin/bash
#Date: 03/27/2024
#Authors: Gary Shadders, Kevin Hlavaty, Aisha Bhakta, Damian Stevenson



# run "ps -A | grep APM" to see the programs running and then not running

spawn_programs() {
    for file in ./project1_executables/APM*; do
        echo "Starting $file"
        ./$file "8.8.8.8" &
    done
}


analyze_process_level_metrics() {
    for pid in $(pgrep 'APM'); do
        proc_name=$(ps -p $pid -o comm=)
        cpu_mem=$(ps -p $pid -o %cpu,%mem= --no-headers)

        output=$(echo $SECONDS $cpu_mem | sed -e "s/ /, /g")
        #each file process level metrics written to a file called <proc_level>_metrics.csv
        echo $output >> "${proc_name}_metrics.csv"
    done
    
}

analyze_system_level_metrics() {
    # NETWORK_STATS=$(ifstat -i ens33 1 1)

    # # ifstat for RX data rate and TX data rate
    # rx_rate=$(echo "$NETWORK_STATS" | awk '/ens33/ {getline: print $1}')
    # tx_rate=$(echo "$NETWORK_STATS" | awk '/ens33/ {getline: print $2}')

    #all system level metrics should be written to a file called system_metrics.csv


    # iostat for disk writes
    disk_writes=$(iostat nvme0n1 | awk 'NR==7 {print $4}') 
    echo "Disk writes: " $disk_writes
    # df for available disk capacity
    megabytes_available=$(df / -BM -m | awk 'NR==2 {print $4}')
    echo "mega: $megabytes_available"
}


cleanup() {
    pkill -f 'APM'
}

trap cleanup EXIT

spawn_programs

for file in ./project1_executables/APM*; do
    > $(basename $file)_metrics.csv
done

> system_metrics.csv

while true; do
    analyze_process_level_metrics
    analyze_system_level_metrics
    sleep 5
done