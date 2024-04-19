# Betriebssysteme

## 19.4.2024

### HDD

Aufbau einer HDD
Bild frühe HDD von IBM
10000 rpm
Langlebbiger, billiger, größer
Langsammer, Lauter, zerbrechlicher, mehr Stromverbrauch

Partitionen
Daten trennen, um zum Beispiel Vorteile verschiedener Dateeisysteme zu nutzen.
Primary Partition vs Extended Partitions
Primary partitions waren früher limitiert. Man kann auf ihnen Betriebsysteme installieren.

Aufeinanderfolgende Sektoren werden zu Blöcken gruppiert.

### SSD

Eine SSD besteht aus Pages, die zu Blöcke zusammengefasst werden, die wiederum zu Plane, die zu Die zusammengefasst werden. Man kann Pages nicht löschen, nur ganze Blöcke. Addressen werden speziell gemappt, daher gibt es keine fixen Addressen für die Daten. Dazwischen gibt es immer einen Garbagecollector der dead pages bereinigt indem er Blöcke migriert.

### BIOS

Heutzutage durch UEFI ersetzt. Startet das Betriebssystem.

### Kontinuierliche Speicherung

Dateien werden hintereinander gespeichert(z.B. CD).
Änderungen aufwendig.
Lesen schneller.
Inhaltsverzeichnis einfach. Man braucht nur den Startindex und die Länge.

### Verkettete Speicherung

Jeder Block verweist auf den nächsten, also wird nur der Startblock der Datei im Inhaltsverzeichnis angegeben.
Overhead
Performance schlechter, aber neue Blöcke und löschen von Blöcken schneller,

### FAT

File allocation table

Es gibt eine weitere Tabelle in der für jeden Block der darauffolgende gespeichert wird.

Verkettung ist ausgelagert.
FAT ist redundant, also es gibt 2 FATs.

Bis nächste mal über Vor und Nachteile nachdenken.
