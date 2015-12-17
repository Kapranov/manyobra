#! /bin/sh
 
### BEGIN INIT INFO
# Provides:          manyobra
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: unicorn web server
# Description:       unicorn web server for app manyobra
### END INIT INFO
 
### configuration
RAILS_ENV="production"
 
app_root="/home/rails/manyobra"
app_user="rails"
app_name="Manyobra"
unicorn_conf="$app_root/config/unicorn.rb"
pid_path="$app_root/tmp/pids"
socket_path="$app_root/tmp"
web_server_pid_path="$pid_path/unicorn.pid"
web_server_socket_path="$socket_path/unicorn.manyobra.sock"
 
### functions
 
if [ "$USER" != "$app_user" ]; then
  sudo -u "$app_user" -H -i $0 "$@"; exit;
fi
 
if ! cd "$app_root" ; then
 echo "Failed to cd into $app_root, exiting!";  exit 1
fi
 
check_pids(){
  if ! mkdir -p "$pid_path"; then
    echo "Could not create the path $pid_path needed to store the pids."
    exit 1
  fi
  if [ -f "$web_server_pid_path" ]; then
    wpid=$(cat "$web_server_pid_path")
  else
    wpid=0
  fi
}
 
check_pids
 
check_status(){
  check_pids
  if [ $wpid -ne 0 ]; then
    kill -0 "$wpid" 2>/dev/null
    web_status="$?"
  else
    web_status="-1"
  fi
}
 
check_stale_pids(){
  check_status
  if [ "$wpid" != "0" -a "$web_status" != "0" ]; then
    echo "Removing stale Unicorn web server pid. This is most likely caused by the web server crashing the last time it ran."
    if ! rm "$web_server_pid_path"; then
      echo "Unable to remove stale pid, exiting"
      exit 1
    fi
  fi
}
 
exit_if_not_running(){
  check_stale_pids
  if [ "$web_status" != "0" ]; then
    echo "$app_name is not running."
    exit
  fi
}
 
start() {
  check_stale_pids
  if [ "$web_status" = "0" ]; then
    echo "The Unicorn web server already running with pid $wpid, not restarting."
  else
    echo "Starting the $app_name Unicorn web server..."
    rm -f "$web_server_socket_path" 2>/dev/null
    bundle exec unicorn_rails -D -c "$unicorn_conf" -E "$RAILS_ENV"
  fi
 
  status
}
 
stop() {
  exit_if_not_running
  if [ "$web_status" = "0" ]; then
    kill -QUIT "$wpid" &
    echo "Stopping the $app_name Unicorn web server..."
    stopping=true
  else
    echo "The Unicorn web was not running, doing nothing."
  fi
 
  while [ "$stopping" = "true" ]; do
    sleep 1
    check_status
    if [ "$web_status" = "0" ]; then
      printf "."
    else
      printf "\n"
      break
    fi
  done
  sleep 1
  rm "$web_server_pid_path" 2>/dev/null
 
  status
}
 
status() {
  check_status
  if [ "$web_status" != "0" ]; then
    echo "$app_name is not running."
    return
  fi
  if [ "$web_status" = "0" ]; then
    echo "The $app_name Unicorn webserver with pid $wpid is running."
  else
    printf "The $app_name Unicorn webserver is \033[31mnot running\033[0m.\n"
  fi
}
 
reload(){
  exit_if_not_running
  if [ "$wpid" = "0" ];then
    echo "The $app_name Unicorn Web server is not running thus its configuration can't be reloaded."
    exit 1
  fi
  printf "Reloading $app_name Unicorn configuration... "
  kill -USR2 "$wpid"
  echo "Done."
  sleep 4
  status
}
 
restart(){
  check_status
  if [ "$web_status" = "0" ]; then
    stop
  fi
  start
}
 
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  reload|force-reload)
	reload
        ;;
  status)
        status
        ;;
  *)
        echo "Usage: service $(basename $0) {start|stop|restart|reload|status}"
        exit 1
        ;;
esac
 
exit
