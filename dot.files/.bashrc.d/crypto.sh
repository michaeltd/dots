# ~/.bashrc.d/crypto.sh
#
# cryptographic functions

function genpass {
  #echo $(tr -dc '[:alnum:]~!@#$%^&*()_=+,<.>/?;:[{]}\|-' < /dev/urandom|head -c "${1:-64}")
  echo $(tr -dc [:graph:] < /dev/urandom|tr -d [=\"=][=\'=]|head -c "${1:-64}")
}
