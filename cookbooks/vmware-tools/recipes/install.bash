#!/bin/bash -e

function installDependencies()
{
    installAptGetPackages 'build-essential'
}

function install()
{
    # Install

    local currentPath="$(pwd)"
    local tempFolder="$(getTemporaryFolder)"

    unzipRemoteFile "${vmwaretoolsDownloadURL}" "${tempFolder}"
    cd "${tempFolder}"
    "${tempFolder}/vmware-install.pl"
    rm -f -r "${tempFolder}"
    cd "${currentPath}"
}

function main()
{
    local appPath="$(cd "$(dirname "${0}")" && pwd)"

    source "${appPath}/../../../lib/util.bash"
    source "${appPath}/../attributes/default.bash"

    checkRequireSystem
    checkRequireRootUser

    header 'INSTALLING VMWARE-TOOLS'

    installDependencies
    install
    installCleanUp
}

main "${@}"