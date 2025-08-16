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

# create temp folder
mkdir "${TMP}"

echo "start: ${NOW} vs ${LST}">>"${TMP}/log"

# load list
SRC="${MODDIR}/ad-block.txt"
if [[ -f "/Internal Storage/ad-block.txt" ]]; then
  SRC="/Internal Storage/ad-block.txt"
fi
if [[ -f "/storage/emulated/0/ad-block.txt" ]]; then
  SRC="/storage/emulated/0/ad-block.txt"
fi

echo "src: ${SRC}">>"${TMP}/log"

# belete old
rm "${OUT}" &2>>"${TMP}/log"
wait

# init new
echo ${NOW} > "${OUT}" &2>>"${TMP}/log"

echo "#=-> -------------------------------------- <-=#">>"${OUT}"

echo "::1 localhost">>"${OUT}"
echo "::1 ip6-loopback">>"${OUT}"
echo "::1 ip6-localhost">>"${OUT}"

echo "0.0.0.0 local">>"${OUT}"
echo "0.0.0.0 localhost">>"${OUT}"
echo "0.0.0.0 localhost.localdomain">>"${OUT}"

echo "ff00::0 ip6-localnet">>"${OUT}"
echo "ff02::1 ip6-allnodes">>"${OUT}"
echo "ff02::3 ip6-allhosts">>"${OUT}"
echo "fe80::1%lo0 localhost">>"${OUT}"
echo "ff02::2 ip6-allrouters">>"${OUT}"
echo "ff00::0 ip6-mcastprefix">>"${OUT}"

echo "255.255.255.255 broadcasthost">>"${OUT}"
echo "">>"${OUT}"

CNT=1
while read ENTRY; do
  echo "- ${CNT}: ${ENTRY}">>"${TMP}/log"
  
  echo \#=-\> ${ENTRY} \<-=\#>>"${OUT}"
  
  curl -s "${ENTRY}" -o "${TMP}/${CNT}">>"${TMP}/log" &2>>"${TMP}/log"
  wait
  
  sed 's/127.0.0.1/0.0.0.0/' "${TMP}/${CNT}" | grep '^0.' | grep -v '^0.0.0.0 0.0.0.0$'>>"${OUT}" &2>>"${TMP}/log"
  wait

  sleep 1  
  ((CNT=CNT+1))
done < "${SRC}"

chmod 777 "${OUT}"

echo "cnt: ${CNT}">>"${TMP}/log"

cat "${OUT}" > /system/etc/hosts &2>>"${TMP}/log"

return 0