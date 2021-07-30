#!/bin/bash

function createBankOne() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/BankOne.appzone.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/BankOne.appzone.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-BankOne --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-BankOne.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-BankOne.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-BankOne.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-BankOne.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-BankOne --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-BankOne --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-BankOne --id.name BankOneadmin --id.secret BankOneadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-BankOne -M "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/msp" --csr.hosts peer0.BankOne.appzone.com --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-BankOne -M "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls" --enrollment.profile tls --csr.hosts peer0.BankOne.appzone.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/tlsca/tlsca.BankOne.appzone.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/ca"
  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/peers/peer0.BankOne.appzone.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/ca/ca.BankOne.appzone.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-BankOne -M "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/users/User1@BankOne.appzone.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/users/User1@BankOne.appzone.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://BankOneadmin:BankOneadminpw@localhost:7054 --caname ca-BankOne -M "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/users/Admin@BankOne.appzone.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/BankOne/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankOne.appzone.com/users/Admin@BankOne.appzone.com/msp/config.yaml"
}

function createBankTwo() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/BankTwo.appzone.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-BankTwo --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankTwo.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankTwo.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankTwo.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankTwo.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-BankTwo --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-BankTwo --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-BankTwo --id.name BankTwoadmin --id.secret BankTwoadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-BankTwo -M "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/msp" --csr.hosts peer0.BankTwo.appzone.com --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-BankTwo -M "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls" --enrollment.profile tls --csr.hosts peer0.BankTwo.appzone.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/tlsca/tlsca.BankTwo.appzone.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/ca"
  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/peers/peer0.BankTwo.appzone.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/ca/ca.BankTwo.appzone.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-BankTwo -M "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/users/User1@BankTwo.appzone.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/users/User1@BankTwo.appzone.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://BankTwoadmin:BankTwoadminpw@localhost:8054 --caname ca-BankTwo -M "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/users/Admin@BankTwo.appzone.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/BankTwo/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankTwo.appzone.com/users/Admin@BankTwo.appzone.com/msp/config.yaml"
}

function createBankThree() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/BankThree.appzone.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/BankThree.appzone.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-BankThree --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankThree.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankThree.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankThree.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-BankThree.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-BankThree --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-BankThree --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-BankThree --id.name BankThreeadmin --id.secret BankThreeadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-BankThree -M "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/msp" --csr.hosts peer0.BankThree.appzone.com --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-BankThree -M "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls" --enrollment.profile tls --csr.hosts peer0.BankThree.appzone.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/tlsca/tlsca.BankThree.appzone.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/ca"
  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/peers/peer0.BankThree.appzone.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/ca/ca.BankThree.appzone.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-BankThree -M "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/users/User1@BankThree.appzone.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/users/User1@BankThree.appzone.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://BankThreeadmin:BankThreeadminpw@localhost:8054 --caname ca-BankThree -M "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/users/Admin@BankThree.appzone.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/BankThree/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/BankThree.appzone.com/users/Admin@BankThree.appzone.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/appzone.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/appzone.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/appzone.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/msp" --csr.hosts orderer.appzone.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/appzone.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls" --enrollment.profile tls --csr.hosts orderer.appzone.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/msp/tlscacerts/tlsca.appzone.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/appzone.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/appzone.com/orderers/orderer.appzone.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/appzone.com/msp/tlscacerts/tlsca.appzone.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/appzone.com/users/Admin@appzone.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/appzone.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/appzone.com/users/Admin@appzone.com/msp/config.yaml"
}
