#!/bin/sh

# Try some echo setup:
if (echo "testing\c"; echo 1,2,3) | grep c >/dev/null; then
  # Stardent Vistra SVR4 grep lacks -e, says ghazi@caip.rutgers.edu.
  if (echo -n testing; echo 1,2,3) | sed s/-n/xn/ | grep xn >/dev/null; then
    ac_n= ac_c='
' ac_t='	'
  else
    ac_n=-n ac_c= ac_t=
  fi
else
  ac_n= ac_c='\c' ac_t=
fi

less -eXF README-shar
echo $ac_n "Do you wish to continue? (yes/no): $ac_c"
read accept
if [ "$accept" != "y" ] && [ "$accept" != "Y" ] && [ "$accept" != "yes" ] && [ "$accept" != "YES" ]; then
    exit 1
fi

defaultprefix="/usr/local"

echo $ac_n "Where would you like to install pwned? [$defaultprefix]: $ac_c"
read prefix
if [ "$prefix" = "" ]; then
    prefix="$defaultprefix"
fi

# untar unix package to destination
binpath=${prefix}/bin
mkdir -p ${binpath}

# Determine Operating System
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)
    arch="$(uname -m)"
    case $arch in
      x86_64*) machine=linux;;
      aarch64*) machine=linuxarm64;;
      arm*) machine=linuxarmhf;;
      *) machine=unknown;;
    esac
    ;;
  Darwin*)
    arch="$(uname -m)"
    case $arch in
      x86_64*) machine=darwin;;
      arm64*) machine=darwinarm;;
      *) machine=unknown;;
    esac
    ;;
  *)        machine=unknown;;
esac

if [ $machine != "unknown" ]; then
  echo "Detected: ${machine}"

  # Copy the binary
  cp pwned-${machine} ${binpath}/pwned

  # make binary executable
  chmod -R ugo+x ${binpath}/pwned

  # Write some documentation
  echo "pwned is now installed in ${binpath}"
else
  arch="$(uname -m)"
  echo "Machine ${unameOut}-${arch} not recognized."
fi
