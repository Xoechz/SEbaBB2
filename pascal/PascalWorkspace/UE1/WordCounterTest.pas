PROGRAM WordCounterTest;

USES ChainedWordCounter, OpenAddressedWordCounter;

TYPE 
  WordCounter = PROCEDURE (path : STRING; printHumanReadable: BOOLEAN);

PROCEDURE TestWordCounter(name: STRING; printHumanReadable: BOOLEAN; counter: WordCounter);
BEGIN (*TestWordCounter*)
  WriteLn('Testing ', name);
  counter('../TestFiles/empty.txt', printHumanReadable);
  counter('../TestFiles/se.txt', printHumanReadable);
  counter('../TestFiles/metamorphosis.txt', printHumanReadable);
  counter('../TestFiles/verwandlung.txt', printHumanReadable);
  counter('../TestFiles/mobyDick.txt', printHumanReadable);
  counter('../TestFiles/romeoAndJuliet.txt', printHumanReadable);
  counter('../TestFiles/bible.txt', printHumanReadable);
  counter('../TestFiles/loremIpsum.txt', printHumanReadable);
  counter('../TestFiles/a.txt', printHumanReadable);
  counter('../TestFiles/b.txt', printHumanReadable);
  counter('../TestFiles/space.txt', printHumanReadable);
END;(*TestWordCounter*)

BEGIN (*WordCounter*)
  TestWordCounter('ChainedWordCounter', TRUE, StartChainedWordCounter);
  TestWordCounter('OpenAddressedWordCounter', TRUE, StartOpenAddressedWordCounter);
  TestWordCounter('ChainedWordCounter', FALSE, StartChainedWordCounter);
  TestWordCounter('ChainedWordCounter', FALSE, StartChainedWordCounter);
  TestWordCounter('ChainedWordCounter', FALSE, StartChainedWordCounter);
  TestWordCounter('OpenAddressedWordCounter', FALSE, StartOpenAddressedWordCounter);
  TestWordCounter('OpenAddressedWordCounter', FALSE, StartOpenAddressedWordCounter);
  TestWordCounter('OpenAddressedWordCounter', FALSE, StartOpenAddressedWordCounter);
END. (*WordCounter*)