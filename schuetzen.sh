#!/usr/bin/env bash
# Verschlüsselt alle HTML-Dateien eines Ordners mit StatiCrypt (Passwortschutz für GitHub Pages).
# Aufruf: SEITE=<kurzname> SALZ=<32 hex> PASSWORT=<pw> schuetzen.sh <quellordner> <zielordner>
# Der Zielordner wird geleert und neu befüllt (ohne .git).
set -euo pipefail
QUELLE="$1"; ZIEL="$2"
: "${SEITE:?SEITE fehlt}" "${SALZ:?SALZ fehlt}" "${PASSWORT:?PASSWORT fehlt}"
HIER="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
# Vorlage: deutsche Sprache und eigener Speicher-Schlüssel je Seite (alle Seiten teilen sich ppotthoff85.github.io)
sed -e 's/<html lang="en">/<html lang="de">/' \
    -e "s/\"staticrypt_expiration\"/\"staticrypt_expiration_${SEITE}\"/" \
    -e "s/\"staticrypt_passphrase\"/\"staticrypt_passphrase_${SEITE}\"/" \
    "$HIER/node_modules/staticrypt/lib/password_template.html" > "$TMP/vorlage.html"
mkdir -p "$TMP/src" && tar -C "$QUELLE" --exclude=.git --exclude=node_modules --exclude=CLAUDE.md --exclude="*.sql" --exclude="*.sh" --exclude=gw-backend.js -cf - . | tar -C "$TMP/src" -xf -
( cd "$HIER" && STATICRYPT_PASSWORD="$PASSWORT" npx staticrypt "$TMP/src" -r --short -c false -s "$SALZ" \
    --remember 30 -t "$TMP/vorlage.html" -d "$TMP/out" \
    --template-title "Geschützte Seite" \
    --template-instructions "Bitte gib das Passwort ein." \
    --template-placeholder "Passwort" \
    --template-button "Öffnen" \
    --template-remember "30 Tage auf diesem Gerät merken" \
    --template-error "Passwort falsch." \
    --template-toggle-show "Passwort zeigen" --template-toggle-hide "Passwort verbergen" \
    --template-color-primary "#22372d" --template-color-secondary "#f5f0e6" >/dev/null )
find "$ZIEL" -mindepth 1 -maxdepth 1 ! -name .git ! -name CLAUDE.md -exec rm -rf {} +
cp -a "$TMP/out/src/." "$ZIEL/"
rm -rf "$TMP"
echo "verschlüsselt: $(find "$ZIEL" -name '*.html' -not -path '*/.git/*' | wc -l) HTML-Dateien"
