# Algorithmen und Datenstrukturen

## 29.2.2024

### Lehrplan

Hash und String Zeugs

Compilerbau, Gramatikanalyse

Objektorientiertes Programmieren

### Programme

3D Druck Simulation

Excel

### Suchalgorithmen

sequenzielle Suche O(n)
binäre Suche O(log n)

Ziel O(1)

Hashing

Schlüssel wird auf Inex in einem Array gemappt.(z.B. Modulo).

Kolisionen werden mithilfe von verkettung(jeder hashtabelleneintrag ist eine liste in der ich weitersuchen muss)

O Notation ist abhängig von der Hashmap Grö�?e

Laufzeit vs. Speicherplatz

Offener Speicherbereich braucht Delete Flag

Vorsicht bei auswahl der hash methode

### Suchen in Zeichenketten

Einfache Lösung Drüberiterieren = O(n*m)

O(n+m) existiert

## 7.3.2024

### Datenkapselung

Module geben dem User nur die Proceduren die er benutzen dar zur verfügung, alle inneren Vorgänge und Datenstrukturen sind versteckt. wie private/public.

Verfügbare Procedures sind im Interface hinterlegt.

In pascal werden dazu Units verwendet. In einem Unit gibt es einen Implementierungs Teil und einen Interface Teil. Wenn sich etwas in der Implementierung �?ndert muss man den Code der das Interface nutzt nicht ändern.

Man kann im Interface auch typen deklarieren.

Abstrakt => nicht direkt implementiert

## 8.3.2024

### Entwurf

Je mehr Gedanken um den Entwurf man sich vor der Implementierung macht, desto weniger Gedanken muss man sich nach der Implementierung machen.

Abstraktion, herunterbrechen herunterbrechen herunterbrechen.

#### Entwurfsebenen

Subsysteme mit schwacher Kopplung. Kommunizieren über Dateien, Datenbanken und Netzwerke

Diese bestehen aus Modulen mit enger Kopplung die über Aufrufschnittstellen kommunizieren.

Dies kann man noch auf einzelne Algorithmen zerbrechen.

Bespiel:

Compiler erzeugt aus .pas ein .o file, Linker erstellt daraus eine .exe.

Der Compiler wiederum besteht aus den Modulen Scanner, Parser, Symboltabelle und CodeGenerator. Der Scanner lest zeichen ab dem "BEGIN" ein, der Parser wertet die Gültigkeit aus und speichert Variablen in die Symboltabelle und der CodeGenerator erzeugt aus dem Code das Programm.

#### Zerlegungsarten

Man kann eine Anforderung auf 3 Weisen verbessern, je nach Anforderung gibt es gewisse Vor und Nachteile für jede Art.

Aufgabenorientiert.

Datenorientiert.

Objektorientiert.

#### Beispiel mit 3D Drucker

Parser

Instruktionen Speichern

Koordinaten definieren

Darstellung

Gerade linien

Kurven

in Schritte brechen

Validation der Instruktionen

Nutzeroberfläche

Linie Zeichen

Drucker zeichen

Editor

## 9.3.2024

Alle �?bungen machen.

### Hash table

#### List vs Array vs Tree

![List vs Array vs Tree 1](Pictures/ADF1.jpg)
![List vs Array vs Tree 2](Pictures/ADF2.jpg)

List vs Array vs Tree => Hashtable gewinnt

#### Hashen

kleines delta a => gro�?es delta b

möglichst gleiche Verteilung

### Zeichenketten suchen

## �bungen

### UE1

Zuerst muss eine string GetHashCode Funktion in einem Unit erstellt werden, diese rechnet einen Hashcode aus dem Ordinalwert eines chars und seiner Position aus, indem die Summe jedes Ordinalwertes mal 31 hoch der Position. Dieser Hasing Algorithmus wurde in der �bung kurz als die L�sung die Java verwendet angeschnitten.

F�r die zwei verschiedenen Hash-Tabellen Arten werden 2 verschiedene Units(ChainedWordCounter und OpenAdressedWordCounter).

Das Hinzuf�gen der W�rter und die Kollisionsvermeidung wird gleich der �bung gemacht, wobei verschiedene Hashtabellengr��en getestet werden(die offen Adressierte Variante hat eine Untergrenze an g�ltiger Gr��e. F�r die Testf�lle wird eine Tabelle mit Zeiten erstellt um den Einfluss der Gr��e zur Laufzeit zu zeigen, weiters wird auch der genutzte Heap mittels heaptrc gezeigt.

Um die mehrfach vorkommenden W�rter zu z�hlen m�ssen zu jedem Wort die Anzahl an Vorkommnisse gespeichert werden. Dadurch kann sp�ter �ber alle Worte itteriert werden, um alle einmal vorkommenden Worte zu finden, die �berbliebenen Worte zu Z�hlen und das Maximum zu finden.

Timer.pas wurde nicht ver�ndert, in WordReader.pas wurde WinCrt entfernt, um das Unit Linux kompatibel zu machen, und der Word Datentyp wurde auf WordString ge�ndert um Namenskonflikte mit dem Pascal Datentyp Word zu verhindern.

Per KI Richtlinie gebe ich bekannt CoPilot zu verwenden, wobei es zur Formatierung und als Autocomplete genutzt wurde.

Stunden 9

### UE2

1a
Da laut Angabe nur Strings mit gleicher L�nge �bereinstimmen k�nnen, kann man jedes Paar dessen L�nge nicht �bereinstimmt verwerfen und ab einem Unterschied den Vergleich, mit einem negativen Ergebnis, abbrechen. Nach der Annahme, dass jeder Input mit einem $ Symbol abschlie�t, werden alle Inputs nicht damit enden verworfen.

1b
In der Angabe ist der L�sungsweg schon fast zur G�nze beschrieben. Es wird ein Zeichen �berpr�ft und wenn dieses �bereinstimmt werden die ersten Zeichen der Strings enfernt und die Funktion wieder aufgerufen. Wenn das erste Zeichen ein \* Symbol ist wird die Funktion zweimal aufgerufen, einmal mit verk�rztem und einmal mit gleichbleibendem Pattern. Es fehlt dann noch der Fall, dass \* f�r kein Zeichen steht, dieser kann gepr�ft werden indem man das Pattern k�rzt und den Text gleich l�sst.

2a
Jedes Zeichen des Strings wird in ein Array mit dem Indextyp Char hinzugef�gt und der Z�hler erh�ht. Der Datentyp im Array ist Byte, obwohl f�r diese Aufgabe Boolean reichen w�rde, aber f�r die n�chste Aufgabe wird eine Zahl ben�tigt. Byte wurde gew�hlt, da ein String nicht l�nger als 255 Zeichen sein kann, der Ausgabe Datentyp ist wie in der Angabe Integer. Wenn ein Zeichen davor schon in dem Array war wird der Z�hler nicht mehr erh�ht. Der Z�hler wird am Ende ausgegeben. Der Urspr�ngliche gedanke w�re eine Liste gewesen, da die Anzahl der Zeichen aber durch den Datentyp Char stark begrenz sind ist die implementierung eines Arrays einfacher und schneller.
Laut der Angabe werden unterschiedliche Zeichen gez�hlt, also wird angenommen, dass A nicht das selbe wie a ist.

2b
Vom ersten Zeichen an wird �berpr�ft wieviele Zeichen nach rechts die M-Ketten Bedingung erf�llen, ab dem n�chsten Zeichen wird links von der Kette abgezogen bis die Bedinging wieder erf�llt ist. Dieses Verfahren wird wiederholt bis man am Ende vom String ankommt. Die maximale L�nge wird am Ende zur�ckgegeben.

4 stund
