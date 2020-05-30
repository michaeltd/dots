#!/bin/bash

scrpt_drnm="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

"${scrpt_drnm}/../../upgrade_distro.bash" "@security"
