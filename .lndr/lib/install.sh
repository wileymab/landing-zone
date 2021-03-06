#!/usr/bin/env bash

echo ""
echo "Ensuring dependecies are installed you may be prompted for your password ... "
requirements="curl unzip"
toInstall=""
for req in ${requirements}; do
    if [[ -z "$(which ${req})" ]]; then
        toInstall="${toInstall} ${req}"
    fi
done

if [[ -n "${toInstall}" ]]; then
    echo ""
    echo "Installing: ${toInstall}"
    echo "Running: sudo apt-get install -y ${toInstall}"
    sudo apt-get install -y ${toInstall}
fi
echo ""
echo "Dependencies ready."

echo ""
echo -n "Downloading LZ archive ... "
curl -fsSL https://github.com/wileymab/landing-zone/blob/master/downloads/lz.zip?raw=true -o lz.zip
echo "done."

echo ""
echo -n "Unpacking LZ files ... "
unzip -qq -o lz.zip -d ~
export LANDER_HOME=~/.lndr
rm -rf lz.zip
echo "done."

echo ""
echo -n "Initializing zone registry ... "
mkdir -p ${LANDER_HOME}/zones || true
echo "done."

echo ""
echo -n "Adding executable to PATH ... "
ln -sf ${LANDER_HOME}/lib/lndr.sh ${LANDER_HOME}/bin/lndr

function split {
    IFS="${1}"
    read -ra ADDR <<< "$@"
    for i in "${ADDR[@]}"; do
        echo $i
    done
}
paths=($(split ':' "${PATH}"))

# echo "${PATH}"
# echo "${paths[@]}"

found="false"
for path in ${paths[@]}; do
    # echo "${path}"
    if [[ "${path}" == "${LANDER_HOME}/bin" ]]; then
        found="true"
    fi
done
# echo "${found}" 
if [[ "${found}" == "false" ]]; then
    echo "# LZ Path Amendment" >> ~/.bashrc
    echo "export PATH=\"${LANDER_HOME}/bin:$PATH\"" >> ~/.bashrc
    echo "done."
else
    echo "done. (LZ found in PATH.)"
fi

echo ""
echo -n "Initalizing zone loader in .bashrc ... "

if [[ -n "${LANDER_HOME}" ]]; then 
    echo "done. (LANDER_HOME already set.)"
else 
    echo "" >> ~/.bashrc
    echo "# LZ Loader" >> ~/.bashrc
    echo "export LANDER_HOME=~/.lndr" >> ~/.bashrc
    echo "source ${LANDER_HOME}/lib/bashrc-hook.sh" >> ~/.bashrc
    echo "done."
fi
