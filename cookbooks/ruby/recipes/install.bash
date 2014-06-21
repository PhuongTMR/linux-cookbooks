#!/bin/bash

function installDependencies()
{
    runAptGetUpdate

    installPackage 'build-essential'
    installPackage 'libgdbm-dev'
    installPackage 'libssl-dev'
}

function install()
{
    # Clean Up

    rm -rf "${rubyInstallFolder}"
    mkdir -p "${rubyInstallFolder}"

    # Install

    local currentPath="$(pwd)"
    local tempFolder="$(getTemporaryFolder)"

    unzipRemoteFile "${rubyDownloadURL}" "${tempFolder}"
    cd "${tempFolder}"
    "${tempFolder}/configure" --prefix="${rubyInstallFolder}"
    make
    make install
    symlinkLocalBin "${rubyInstallFolder}/bin"
    rm -rf "${tempFolder}"
    cd "${currentPath}"

    # Config Profile

    local profileConfigData=('__INSTALL_FOLDER__' "${rubyInstallFolder}")

    createFileFromTemplate "${appPath}/../files/profile/ruby.sh" '/etc/profile.d/ruby.sh' "${profileConfigData[@]}"
}

function main()
{
    appPath="$(cd "$(dirname "${0}")" && pwd)"

    source "${appPath}/../../../lib/util.bash" || exit 1
    source "${appPath}/../attributes/default.bash" || exit 1

    checkRequireDistributor

    header 'INSTALLING RUBY'

    checkRequireRootUser

    installDependencies
    install
    installCleanUp
}

main "${@}"