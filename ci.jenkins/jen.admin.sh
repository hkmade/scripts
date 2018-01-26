#!/bin/bash             
#
# Copyright 2017 by Inswave systemes.
#
#ident  “jenkins.admin          1.0    2017/11/20" 
#
# Jenkins CI service startup/shutdown script on java

export JENKINS_HOME=/xvfs/jenkins.old/.jenkins
JENKINS_WAR=/xvfs/jenkins.old/
SCRIPTNAME="${0##*/}"
PS="/bin/ps -ef"
PS_STRING=`$PS 2> /dev/null`
PROC=`echo "$PS_STRING" | egrep "httpPort=1214" | egrep "java" | grep -v "grep"`

jen_pid() {
        echo `ps aux | grep httpPort=1214 | grep -v grep | awk '{ print $2 }'`
}


if [ `id -u` -ne 0 ]; then
        echo "You need root account to run this script"
        exit 1
fi

case "$1" in
  ping)
        echo "### Whereis Jenkins?? ###"
        if [ -n "$PROC" ] ;
        then
         echo "jenkins process is running"
         echo $PROC
        else
         echo "jenkins process is not running"
         exit 1
        fi
        ;;

  start)
        echo "### Jenkins is comming ###"
        if [ -n "$PROC" ] ;
        then
          echo "process is running.scrpt exit."
          exit 1
        else
          echo "process is not running. start runscript"

        java -jar ${JENKINS_WAR}jenkins-1.65.war --httpPort=1214 --daemon --logfile=${JENKINS_WAR}jenkins.out
        fi
        ;;
  stop)
        echo "### Jenkins is out ###"
        if [ -z "$PROC" ] ;
        then
          echo "process is not running. script exit."
          exit 1
        else
          echo "process is running. shutdown script run."
          kill -9 `echo $(jen_pid)` > /dev/null 2>&1
        fi
        ;;
  log)
        echo "jenkinst log"
        tail -100f $JENKINS_HOME/jenkins.out
        ;;
  *)
        echo "Usage: $SCRIPTNAME {ping|start|stop|id|version|log} " >&2
        exit 3
        ;;
esac

exit 0
       