cmdname = ${basname $0}

echoerr () {if [[$QUIET -ne 1]]; then echo "S@" 1>&2; fi }

usage() 
{
    cat << USAGE >&2
    Usage: 
        $cmdname host:port [-s] [-t timeout] [-- command args]
        -h HOST | --host=HOST     Host or IP under test
        -p PORT | --port=PORT     TCP port under test
        -s | --strict             Only execute subcommand if the test succeeds
        -q | --quiet              Don't output any status messages
        -t  TIMEOUT |  --timeout=TIMEOUT 
                            Timeout in seconds, zero for no timeout
        -- COMMAND ARGS           Execute command with args after the test finishes

    USAGE
        exit 1
}

wait_for()
{
    If [[$TIMEOUT -gt 0]]; then
        echoerr "$cmdname: waiting $TIMEOUT seconds for $HOST:$PORT"
    else
        echoerr "$cmdname: waiting for $HOST:$PORT"
    fi
    start_ts = $(date +%s)
    while: 
    do
        if [[$ISBUSY -eq 1]]; then
            nc -z $HOST $PORT
            result = $?
        else
            (echo > /dev/tcp/$HOST/$PORT) >/dev/null 2>&1
            result = $?
        fi
        if [[$result -eq 0]]; then
           end_ts = $(date +%s)
           echoerr "$cmdname: $HOST:$PORT is up after $((end_ts - start))
           break
        
        fi

        if [[$result -eq 0]]; then
            end_ts = $(date +%s)
            echoerr "$cmdname: $HOST:$PORT is up after $((end_ts - start))
            break
        fi

        fi 
        sleep 1
    done
    return $result
}

wait_for_wrapper() {

    # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
    
}


