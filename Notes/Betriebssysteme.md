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

## 26.4.2024

### FAT16

16 steht für die Adresslänge von 16 Bit => 2^16 = 65536 Adressen => Cluster/Block

Sektor = 512 Byte oder 4 kB

Maximal 64 Sektoren können zu einem Cluster zusammengefasst werden => 64 * 512 = 32 kB.

Max speichergröße = 65536 * 32 kB => 2 GB Max Partitionsgröße.

Max 65536 Datein, wenn alle 1 Cluster groß sind

Max Dateigröße 2 GB, wenn es nur eine Datei gibt.

### FAT32

2^32 Sektoren => 2 TB oder be größeren Sektoren 16 TB. => THEORETISCH.

32 GB ist die festgelegte Größe. Wurde ohne technischen Grund so entschieden, Windows kann größere Partitionen nutzen, aber Windows kann maximal 32 GB grße PArtitionen erstellen.

Addresslänge = 28 bit => 2^28

Max Filesize kommt von der Programmierbibliothekseite, da longint 32 bit lang ist kann man eine Datei die größer als 2 GB ist nicht Indexieren.

LBA => Logical Block Index

### Indizierte Speicherung

In der FAT Datei wird eine INode referenziert, welche die DateiInfos enthält.

\+ Weniger RAM verbrauch durch die FAT Tabelle

\- Mehr Speicherplatz verbraucht

### Verzeichnisse

Verzeichnisse sind Dateien

Lange Dateinamen in einem Verzeichnis kann man nach der Datei Linear, oder über einen Zeiger in einem HEAP speichern.

### Journaling

USB Stick auswerfen damit alle Änderungen in die FAT Tabelle geschrieben werden.

### Beispiele

Linux => ext2/3/4, UFS, ZFS

Inode Liste, arbeitet mit abgewandelter Indizierung

Mac => APFS, HFS+

Inode Deteisystem, optimiert für SSDs

### Linux

Durch das Plattenlayout von Linux braucht man keine Fragmentierung

Dateigröße

Annahmen
4KB Block
LBA 32 bit

256 LBA in einem Block

12 direkte Adressen => 12 KB

1 indirekter => 256 \* 1KB + 12

1 doppelt indirekter => 256 \* 256 \* 1KB + 12

1 dreifach indirekter => 256 \* 256 \* 256 \* 1KB + 12
