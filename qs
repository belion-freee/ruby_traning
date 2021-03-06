#!/bin/bash

dc=$(which docker-compose) # docker-compose command with full path

if [[ -x "$dc" ]]; then
    :
else
    echo "Please install Docker before run this command."
    exit 2
fi

rm="--rm" # To destroy a container

app="app" # describe $application service name from docker-compose.yml

app_name=`pwd | awk -F "/" '{ print $NF }'` # get project dir name

# define container name
app_container="${app_name}_${app}_1"

echoing() {
    echo "========================================================"
    echo "$1"
    echo "========================================================"
}

compose_up() {
    echoing "Create and start containers $*"
    $dc up -d "$1"
}

compose_down() {
    echoing "Stop and remove containers $*"
    $dc down $*
}

compose_build() {
    echoing "Build containers $*"
    $dc build $*
}

compose_start() {
    echoing "Start services $*"
    $dc start $*
}

compose_stop() {
    echoing "Stop services $*"
    $dc stop $*
}

compose_restart() {
    echoing "Restart services $*"
    $dc restart $*
}

compose_ps() {
    echoing "Showing running containers"
    $dc ps
}

logs() {
    echoing "Logs $*"
    $dc logs -f $1
}

invoke_bash() {
    $dc run $rm -u root $1 bash
}

invoke_run() {
    $dc run $rm $*
}

run_app() {
    invoke_run $app $*
}

ruby_cmd() {
    bundle_exec ruby $*
}

rake_cmd() {
    bundle_exec rake $*
}

bundle_cmd() {
    run_app bundle $*
}

bundle_exec() {
    run_app bundle exec $*
}

rubocop_cmd() {
    bundle_exec rubocop $*
}

rt_cmd() {
    str=$1
    shift
    case "$str" in
        main)
            bundle_exec ruby ./training/main.rb $*
            ;;
        debug)
            bundle_exec ruby ./training/debug.rb $*
            ;;
        iep)
            bundle_exec ruby ./training/inheritance.rb $*
            ;;
        *)
            echo "rubyの基本的な用法は mainを指定してください"
            echo "デバッグを学び開ければ debugを指定してください"
            echo "include,extend,prependを学び開ければ iepを指定してください"
            ;;
    esac
}

cmd=$1
shift
case "$cmd" in
    ps)
        compose_ps && exit 0
        ;;
    up)
        compose_up $* && compose_ps && exit 0
        ;;
    build)
        compose_build $* && exit 0
        ;;
    start)
        compose_start $* && exit 0
        ;;
    stop)
        compose_stop $* && exit 0
        ;;
    restart)
        compose_restart $* && exit 0
        ;;
    down)
        compose_down $* && exit 0
        ;;
    logs)
        logs $*
        ;;
    bash)
        invoke_bash $*
        ;;
    run)
        invoke_run $*
        ;;
    ruby)
        ruby_cmd $*
        ;;
    rake)
        rake_cmd $*
        ;;
    bundle)
        bundle_cmd $*
        ;;
    rubocop)
        rubocop_cmd $*
        ;;
    rt)
        rt_cmd $*
        ;;
    *)
        read -d '' help <<-EOF
Usage: $0 command

Service:
  build    Build service
  ps       Show status of services
  up       Create service containers and start backend services
  down     Stop backend services and remove service containers
  start    Start services
  stop     Stop services
  logs     [options] default: none. View output from containers
  bash     [service] invoke bash
  run      [service] [command] run command in given container

App:
  ruby     [args] Run ruby command in application container
  rake     [args] Run rake command in application container
  bundle   [args] Run bundle command in application container
  rubocop  [args] Run rubocop
  rt       [args] Run ruby training code
EOF
        echo "$help"
        exit 2
        ;;
esac
