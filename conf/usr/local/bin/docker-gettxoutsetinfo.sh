#!/bin/bash
#
if hash crontab 2>/dev/null; then
    echo '0,7,14,21,28,35,42,49,56 * * * * /root/stats.bitcoincore.dev/conf/usr/local/bin/docker-gettxoutsetinfo.sh' >> /etc/cron.hourly/gettxoutsetinfo
else
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        apt update
        apt install cron
        systemctl enable cron
        # crontab -e #no need
    echo '0,7,14,21,28,35,42,49,56 * * * * /root/stats.bitcoincore.dev/conf/usr/local/bin/docker-gettxoutsetinfo.sh' >> /etc/cron.hourly/gettxoutsetinfo
    fi
fi
if hash docker 2>/dev/null; then
    mkdir -p /usr/local/bin
    install -v /root/stats.bitcoincore.dev/conf/local/bin/docker-gettxoutsetinfo.sh /usr/local/bin/
    docker exec -it $(echo $(docker ps | awk '{print $1}' | awk 'NR==2')) sh -c  "/usr/local/bin/bitcoin-cli gettxoutsetinfo"
else
    if hash bitcoin-cli 2>/dev/null; then
        /usr/local/bin/./bitcoin-cli gettxoutsetinfo
    else
        echo  /usr/local/bin/docker-gettxoutsetinfo.sh ?
    fi
fi
