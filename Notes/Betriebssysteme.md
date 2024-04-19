# Betriebssysteme

## 19.4.2024

### HDD

Aufbau einer HDD
Bild fr�he HDD von IBM
10000 rpm
Langlebbiger, billiger, gr��er
Langsammer, Lauter, zerbrechlicher, mehr Stromverbrauch

Partitionen
Daten trennen, um zum Beispiel Vorteile verschiedener Dateeisysteme zu nutzen.
Primary Partition vs Extended Partitions
Primary partitions waren fr�her limitiert. Man kann auf ihnen Betriebsysteme installieren.

Aufeinanderfolgende Sektoren werden zu Bl�cken gruppiert.

### SSD

Eine SSD besteht aus Pages, die zu Bl�cke zusammengefasst werden, die wiederum zu Plane, die zu Die zusammengefasst werden. Man kann Pages nicht l�schen, nur ganze Bl�cke. Addressen werden speziell gemappt, daher gibt es keine fixen Addressen f�r die Daten. Dazwischen gibt es immer einen Garbagecollector der dead pages bereinigt indem er Bl�cke migriert.

### BIOS

Heutzutage durch UEFI ersetzt. Startet das Betriebssystem.

### Kontinuierliche Speicherung

Dateien werden hintereinander gespeichert(z.B. CD).
�nderungen aufwendig.
Lesen schneller.
Inhaltsverzeichnis einfach. Man braucht nur den Startindex und die L�nge.

### Verkettete Speicherung

Jeder Block verweist auf den n�chsten, also wird nur der Startblock der Datei im Inhaltsverzeichnis angegeben.
Overhead
Performance schlechter, aber neue Bl�cke und l�schen von Bl�cken schneller,

### FAT

File allocation table

Es gibt eine weitere Tabelle in der f�r jeden Block der darauffolgende gespeichert wird.

Verkettung ist ausgelagert.
FAT ist redundant, also es gibt 2 FATs.

Bis n�chste mal �ber Vor und Nachteile nachdenken.
