#!/bin/bash
echo ""
echo " ad-block customize "
echo ""
if [[ -f "${MODPATH}/system/etc/hosts" ]]; then
  chmod +x "${MODPATH}/system/etc/hosts"
  echo " - hosts grants: ok "
fi
if [[ -f "${MODPATH}/service.sh" ]]; then
  chmod +x "${MODPATH}/service.sh"
  echo " - service grants: ok "
fi
if [[ -f "${MODPATH}/action.sh" ]]; then
  chmod +x "${MODPATH}/action.sh"
  echo " - action grants: ok "
fi
"${MODPATH}/action.sh"
