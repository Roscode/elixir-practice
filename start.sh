#!/bin/bash

# if [[ "x$PROD" == "x" ]]; then 
# 	echo "This script is for starting in production."
# 	echo "Use"
# 	echo "   mix phx.server"
# 	exit
# fi

export MIX_ENV=prod
export PORT=4790

echo "Stopping old copy of app, if any..."

_build/prod/rel/practice/bin/practice stop || true

echo "Starting app..."

_build/prod/rel/practice/bin/practice start

