#!/bin/bash
echo "  ____________________________________________________ "
echo " |                                                    | "
echo " | ad-block setup                                     | "
echo " |                                                    | "
if [[ -f "${MODPATH}/system/etc/hosts" ]]; then
  chmod 777 "${MODPATH}/system/etc/hosts"
  echo " |  hosts grants: ok                                  | "
fi
if [[ -f "${MODPATH}/service.sh" ]]; then
  chmod 777 "${MODPATH}/service.sh"
  echo " |  service grants: ok                                | "
fi
echo " |                                                    | "
echo " |    Enjoy!                                          | "
echo " |____________________________________________________| "
echo
