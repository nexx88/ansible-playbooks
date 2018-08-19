#!/bin/bash
NOW=$(date +%s)
MAX_AGE=${1:-10800}

find_canaries() {
  docker service ls --filter label=eagle.service.is_canary=1 --format '{{.Name}}'
}

get_canary_age() {
  SERVICE=$1
  STARTED=$(docker service inspect $SERVICE --format '{{.UpdatedAt.Unix}}')
  printf $(($NOW - $STARTED))
}

get_stack_name() {
  SERVICE=$1
  docker service inspect $SERVICE --format '{{ index .Spec.Labels "com.docker.stack.namespace" }}'
}

for CANARY in $(find_canaries); do
  CANARY_AGE=$(get_canary_age $CANARY)
  if [ $CANARY_AGE -gt $MAX_AGE ]; then
    STACK_NAME=$(get_stack_name $CANARY)
    printf "Canary $STACK_NAME is $CANARY_AGE seconds old... Removing\n"
    docker stack rm $STACK_NAME
  fi
done
