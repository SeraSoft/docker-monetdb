#!/bin/bash

set -e

if [ -f /.dbfarm_already_there ]; then
    echo "MonetDB dbfarm already initialized!"
    exit 0
fi

monetdbd create /opt/monet-dbfarm
monetdbd start /opt/monet-dbfarm
monetdb create ${DWH_NAME}
monetdb start ${DWH_NAME}
monetdb release ${DWH_NAME}
monetdbd stop /opt/monet-dbfarm
chown -R monetdb:monetdb /opt/monet-dbfarm


echo "MonetDB dbfarm initialized successfully!"
touch /.dbfarm_already_there
