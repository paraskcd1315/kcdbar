#!/usr/bin/env bash
# Copyright 2026 Paras Mohandas Khanchandani Chandani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

# Creates the stable self-signed code-signing identity KCDBar uses.
# Run once per machine. Requires a password prompt, so it must be run by a person.
#
# Why a STABLE identity rather than ad-hoc signing: macOS ties the Accessibility
# grant to the signature's designated requirement. Ad-hoc signing has no stable
# one, so every rebuild is a new app to TCC and the grant is lost.

NAME="KCDBar Local"
KEYCHAIN="$HOME/Library/Keychains/login.keychain-db"

if security find-identity -v -p codesigning | grep -q "$NAME"; then
  echo "Identity '$NAME' already exists."
  exit 0
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout "$WORK/key.pem" -out "$WORK/cert.pem" -days 3650 \
  -subj "/CN=$NAME" \
  -addext "basicConstraints=critical,CA:false" \
  -addext "keyUsage=critical,digitalSignature" \
  -addext "extendedKeyUsage=critical,codeSigning"

P12PASS="kcdbar-local"

openssl pkcs12 -export \
  -inkey "$WORK/key.pem" -in "$WORK/cert.pem" \
  -out "$WORK/identity.p12" -passout "pass:$P12PASS" \
  -legacy -keypbe PBE-SHA1-3DES -certpbe PBE-SHA1-3DES -macalg sha1

security import "$WORK/identity.p12" -k "$KEYCHAIN" -P "$P12PASS" \
  -T /usr/bin/codesign -T /usr/bin/security

security add-trusted-cert -r trustRoot -p codeSign -k "$KEYCHAIN" "$WORK/cert.pem"

security set-key-partition-list -S apple-tool-:,apple:,codesign: -s -k "" "$KEYCHAIN" >/dev/null 2>&1 || \
  echo "Note: set-key-partition-list needs your login password. Run it by hand if signing prompts on every build:
  security set-key-partition-list -S apple-tool-:,apple:,codesign: -s $KEYCHAIN"

security find-identity -v -p codesigning | grep "$NAME"
echo "Identity '$NAME' created."
