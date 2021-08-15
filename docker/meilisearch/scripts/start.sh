#!/bin/bash
set -e
# shellcheck disable=SC1073
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
