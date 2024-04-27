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

## 26.4.2024

### FAT16

16 steht f�r die Adressl�nge von 16 Bit => 2^16 = 65536 Adressen => Cluster/Block

Sektor = 512 Byte oder 4 kB

Maximal 64 Sektoren k�nnen zu einem Cluster zusammengefasst werden => 64 * 512 = 32 kB.

Max speichergr��e = 65536 * 32 kB => 2 GB Max Partitionsgr��e.

Max 65536 Datein, wenn alle 1 Cluster gro� sind

Max Dateigr��e 2 GB, wenn es nur eine Datei gibt.

### FAT32

2^32 Sektoren => 2 TB oder be gr��eren Sektoren 16 TB. => THEORETISCH.

32 GB ist die festgelegte Gr��e. Wurde ohne technischen Grund so entschieden, Windows kann gr��ere Partitionen nutzen, aber Windows kann maximal 32 GB gr�e PArtitionen erstellen.

Addressl�nge = 28 bit => 2^28

Max Filesize kommt von der Programmierbibliothekseite, da longint 32 bit lang ist kann man eine Datei die gr��er als 2 GB ist nicht Indexieren.

LBA => Logical Block Index

### Indizierte Speicherung

In der FAT Datei wird eine INode referenziert, welche die DateiInfos enth�lt.

\+ Weniger RAM verbrauch durch die FAT Tabelle

\- Mehr Speicherplatz verbraucht

### Verzeichnisse

Verzeichnisse sind Dateien

Lange Dateinamen in einem Verzeichnis kann man nach der Datei Linear, oder �ber einen Zeiger in einem HEAP speichern.

### Journaling

USB Stick auswerfen damit alle �nderungen in die FAT Tabelle geschrieben werden.

### Beispiele

Linux => ext2/3/4, UFS, ZFS

Inode Liste, arbeitet mit abgewandelter Indizierung

Mac => APFS, HFS+

Inode Deteisystem, optimiert f�r SSDs

### Linux

Durch das Plattenlayout von Linux braucht man keine Fragmentierung

Dateigr��e

Annahmen
4KB Block
LBA 32 bit

256 LBA in einem Block

12 direkte Adressen => 12 KB

1 indirekter => 256 \* 1KB + 12

1 doppelt indirekter => 256 \* 256 \* 1KB + 12

1 dreifach indirekter => 256 \* 256 \* 256 \* 1KB + 12
