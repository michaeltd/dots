#!/bin/bash

scrpt_drnm="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

"${scrpt_drnm}/../../dist_upgrade.bash" "@world"
