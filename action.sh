#!/system/bin/sh
MODDIR=${0%/*}

# if temp folder exists - delete
TMP="/data/local/tmp/ad-block"
if [[ -d "${TMP}" ]]; then
  rm -rf "${TMP}"
fi
# create temp folder
mkdir "${TMP}"

# init
OUT=${MODDIR}/system/etc/hosts
rm "${OUT}"
wait

echo "## $(date '+%Y-%m-%d') ##">"${OUT}" &2>>"${TMP}/log"
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

echo "#=-> ------------ defaults ------------ <-=#">>"${OUT}"
wait

echo "::1 localhost">>"${OUT}"
wait
echo "::1 ip6-loopback">>"${OUT}"
wait
echo "::1 ip6-localhost">>"${OUT}"
wait

echo "0.0.0.0 local">>"${OUT}"
wait
echo "0.0.0.0 localhost">>"${OUT}"
wait
echo "0.0.0.0 localhost.localdomain">>"${OUT}"
wait

echo "ff00::0 ip6-localnet">>"${OUT}"
wait
echo "ff02::1 ip6-allnodes">>"${OUT}"
wait
echo "ff02::3 ip6-allhosts">>"${OUT}"
wait
echo "fe80::1%lo0 localhost">>"${OUT}"
wait
echo "ff02::2 ip6-allrouters">>"${OUT}"
wait
echo "ff00::0 ip6-mcastprefix">>"${OUT}"
wait

echo "255.255.255.255 broadcasthost">>"${OUT}"
wait
echo "">>"${OUT}"
wait
echo " - defaults: ok"

while read ENTRY; do
  CNT=${RANDOM}
  
  echo "- ${CNT}: ${ENTRY}">>"${TMP}/log"
  
  echo \#=-\> ${ENTRY} \<-=\#>>"${OUT}"
  wait
  
  curl -s "${ENTRY}" -o "${TMP}/${CNT}">>"${TMP}/log" &2>>"${TMP}/log"
  wait
  sleep 1
  
  sed 's/127.0.0.1/0.0.0.0/' "${TMP}/${CNT}" | grep '^0.' | grep -v '^0.0.0.0 0.0.0.0$'>>"${OUT}" &2>>"${TMP}/log"
  wait
  sleep 1
  echo "">>"${OUT}"
  wait
  
  echo " - ${ENTRY}: ok"
done < "${SRC}"

chmod 777 "${OUT}"

cat "${OUT}" > /system/etc/hosts &2>>"${TMP}/log"
echo ""
echo " Enjoy!"
echo ""

return 0