# Passwortschutz (seit 13.10.2026)

Die Seite auf GitHub Pages ist mit StatiCrypt verschlüsselt. Patrick hat das so entschieden.

- Branch `quelle`: Klartext. Nur hier wird bearbeitet. GitHub Pages liefert diesen Branch nicht aus.
- Branch `main`: verschlüsselte Fassung. GitHub Pages liefert sie aus. Nie Klartext auf `main` legen, sonst ist er sofort öffentlich lesbar.
- Das Passwort steht nicht im Repo. Es kennt Patrick; im Zweifel bei ihm nachfragen.

## Änderung veröffentlichen

1. Auf `quelle` ändern, committen und pushen.
2. StatiCrypt installieren: `npm i staticrypt@3.5.4` in einem Arbeitsordner außerhalb des Repos und `schuetzen.sh` dorthin kopieren.
3. Einen zweiten Checkout von `main` anlegen und verschlüsseln:
   `SEITE=tagesblick SALZ=917fc6552ac4c23e47d0422ce9001a3f PASSWORT=<Passwort> ./schuetzen.sh <checkout-quelle> <checkout-main>`
4. Auf `main` committen und pushen. Danach prüfen: Die Seite zeigt ohne Passwort nur die Passwortabfrage.

SEITE und SALZ bleiben gleich. Sonst müssen alle Nutzer das Passwort neu eingeben.

