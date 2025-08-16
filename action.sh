#!/system/bin/sh
MODDIR=${0%/*}

# if temp folder exists - delete
TMP="/data/local/tmp/ad-block"
if [[ -d "${TMP}" ]]; then
  rm -rf "${TMP}"
fi
# create temp folder
mkdir "${TMP}"

# check last update
OUT=${MODDIR}/system/etc/hosts
rm "${OUT}"
wait

# load list
SRC="${MODDIR}/ad-block.txt"
if [[ -f "/Internal Storage/ad-block.txt" ]]; then
  SRC="/Internal Storage/ad-block.txt"
fi
if [[ -f "/storage/emulated/0/ad-block.txt" ]]; then
  SRC="/storage/emulated/0/ad-block.txt"
fi

echo "src: ${SRC}"
echo "src: ${SRC}">>"${TMP}/log"

# init
echo "## $(date '+%Y-%m-%d') ##">>"${OUT}" &2>>"${TMP}/log"
chmod 777 "${OUT}"

echo "#=-> ------------ defaults ------------ <-=#">>"${OUT}"

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
echo " - defaults: ok"

while read ENTRY; do
  CNT=${RANDOM}
  
  echo "- ${CNT}: ${ENTRY}">>"${TMP}/log"
  
  echo \#=-\> ${ENTRY} \<-=\#>>"${OUT}"
  
  curl -s "${ENTRY}" -o "${TMP}/${CNT}">>"${TMP}/log" &2>>"${TMP}/log"
  wait
  
  sed 's/127.0.0.1/0.0.0.0/' "${TMP}/${CNT}" | grep '^0.' | grep -v '^0.0.0.0 0.0.0.0$'>>"${OUT}" &2>>"${TMP}/log"
  echo " - ${ENTRY}: ok"
  wait

  sleep 1
done < "${SRC}"

chmod 777 "${OUT}"

cat "${OUT}" > /system/etc/hosts &2>>"${TMP}/log"
echo ""
echo " Enjoy!"
echo ""

return 0