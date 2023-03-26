#!/bin/bash


function manual_verification {
  read -p "Continue deploying Green? (y/n) " answer

    if [[ $answer =~ ^[Yy]$ ]] ;
    then
        echo "continuing deployment"
    else
        echo "Stopping!!"
        exit
    fi
}

function blue_green_deploy {

  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl apply -f green.yml"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
  done
  echo "Green deployment successful!"
  sleep 5
  retval="$(kubectl get -n udacity svc green-svc -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
#   retval="https://localhost"
elbHost=$retval
echo $retval
    until curl -s -f -o /dev/null $elbHost
    do
    echo "service still not reachable!"
    sleep 5
    done
    echo "service now reachable"

}

sleep 1
# Begin green deployment
while [ $(kubectl get pods -n udacity | grep -c green) -lt 1 ]
do
  manual_verification
  blue_green_deploy
done





