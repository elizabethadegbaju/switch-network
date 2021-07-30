#!/bin/bash

function one_line_pem() {
  echo "$(awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1)"
}

function json_ccp() {
  local PP=$(one_line_pem $4)
  local CP=$(one_line_pem $5)
  sed -e "s/\${ORG}/$1/" \
    -e "s/\${P0PORT}/$2/" \
    -e "s/\${CAPORT}/$3/" \
    -e "s#\${PEERPEM}#$PP#" \
    -e "s#\${CAPEM}#$CP#" \
    organizations/ccp-template.json
}

function yaml_ccp() {
  local PP=$(one_line_pem $4)
  local CP=$(one_line_pem $5)
  sed -e "s/\${ORG}/$1/" \
    -e "s/\${P0PORT}/$2/" \
    -e "s/\${CAPORT}/$3/" \
    -e "s#\${PEERPEM}#$PP#" \
    -e "s#\${CAPEM}#$CP#" \
    organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG="One"
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/BankOne.appzone.com/tlsca/tlsca.BankOne.appzone.com-cert.pem
CAPEM=organizations/peerOrganizations/BankOne.appzone.com/ca/ca.BankOne.appzone.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/BankOne.appzone.com/connection-BankOne.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/BankOne.appzone.com/connection-BankOne.yaml

ORG="Two"
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/BankTwo.appzone.com/tlsca/tlsca.BankTwo.appzone.com-cert.pem
CAPEM=organizations/peerOrganizations/BankTwo.appzone.com/ca/ca.BankTwo.appzone.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/BankTwo.appzone.com/connection-BankTwo.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/BankTwo.appzone.com/connection-BankTwo.yaml

ORG="Three"
P0PORT=11051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/BankThree.appzone.com/tlsca/tlsca.BankThree.appzone.com-cert.pem
CAPEM=organizations/peerOrganizations/BankThree.appzone.com/ca/ca.BankThree.appzone.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/BankThree.appzone.com/connection-BankThree.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/BankThree.appzone.com/connection-BankThree.yaml
