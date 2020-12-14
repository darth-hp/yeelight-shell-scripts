#!/usr/bin/env bash
# Wrapper for HA-Bridge to pass in ${intensity.percent} and do some math
DISCOSPEED=$(( ($1 - 1) * 20 + 30 )) $( dirname $0 )/yeelight-scene.sh 0 Disco
