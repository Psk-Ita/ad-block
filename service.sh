#!/system/bin/sh
MODDIR=${0%/*}

# if temp folder exists - delete
TMP="/data/local/tmp/ad-block"
if [[ -d "${TMP}" ]]; then
  rm -rf "${TMP}"
fi
# wait system to load
sleep 5

# check last update
OUT=${MODDIR}/system/etc/hosts
NOW="## $(date '+%Y-%m-%d') ##"
LST=""
if [[ -f "${OUT}" ]]; then
  LST=$(head -n 1 ${OUT})
fi
if [[ "${LST}" == "${NOW}" ]]; then
  return 0
fi

# wait connection
sleep 25

"${MODDIR}/action.sh" &
return 0