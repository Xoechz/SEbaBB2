echo "No parameters"
bin/Scale

echo ""
echo "No optional parameters"
bin/Scale TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "X optional parameter"
bin/Scale -x 1 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "Y optional parameter"
bin/Scale -y 1 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "X and Y optional parameters"
bin/Scale -x 1 -y 1 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "Y and X optional parameters"
bin/Scale -y 1 -x 1 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "X and Y optional parameters with different signs"
bin/Scale -y +1 -x -1 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "Wrong optional parameter"
bin/Scale -z 1 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "Too many optional parameters"
bin/Scale -x 1 -y 1 -x 1 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt

echo ""
echo "No file parameters"
bin/Scale -x 1 -y 1

echo ""
echo "One file parameter"
bin/Scale -x 1 -y 1 ResultFiles/baseAsciiArt.txt

echo ""
echo "Invalid input file"
bin/Scale -x 1 -y 1 invalidFile ResultFiles/scaledAsciiArt.txt

echo ""
echo "X = 0"
bin/Scale -x 0 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt 

echo ""
echo "X = 10"
bin/Scale -x 10 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt 

echo ""
echo "X = -10"
bin/Scale -x -10 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt 

echo ""
echo "Y = 0"
bin/Scale -y 0 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt 

echo ""
echo "Y = 10"
bin/Scale -y 10 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt 

echo ""
echo "Y = -10"
bin/Scale -y -10 TestFiles/baseAsciiArt.txt ResultFiles/scaledAsciiArt.txt 

echo ""
echo "X = 1, Y = 1"
bin/Scale TestFiles/testfile2.txt ResultFiles/resultfile2.txt

echo ""
echo "X = 2, Y = 1"
bin/Scale -x 2 TestFiles/testfile2.txt ResultFiles/resultfile2+x.txt

echo ""
echo "X = 1, Y = 2"
bin/Scale -y 2 TestFiles/testfile2.txt ResultFiles/resultfile2+y.txt

echo ""
echo "X = 2, Y = 2"
bin/Scale -x 2 -y 2 TestFiles/testfile2.txt ResultFiles/resultfile2+xy.txt

echo ""
echo "Y = 2, X = 2"
bin/Scale -y 2 -x 2 TestFiles/testfile2.txt ResultFiles/resultfile2+yx.txt

echo ""
echo "X = -2, Y = 1"
bin/Scale -x -2 TestFiles/testfile2.txt ResultFiles/resultfile2-x.txt

echo ""
echo "X = 1, Y = -2"
bin/Scale -y -2 TestFiles/testfile2.txt ResultFiles/resultfile2-y.txt

echo ""
echo "X = -2, Y = -2"
bin/Scale -x -2 -y -2 TestFiles/testfile2.txt ResultFiles/resultfile2-xy.txt

echo ""
echo "Y = -2, X = -2"
bin/Scale -y -2 -x -2 TestFiles/testfile2.txt ResultFiles/resultfile2-yx.txt

echo ""
echo "X = 2, Y = -2"
bin/Scale -x 2 -y -2 TestFiles/testfile2.txt ResultFiles/resultfile2+x-y.txt

echo ""
echo "X = -2, Y = 2"
bin/Scale -x -2 -y 2 TestFiles/testfile2.txt ResultFiles/resultfile2-x+y.txt

echo ""
echo "Y = 2, X = -2"
bin/Scale -y 2 -x -2 TestFiles/testfile2.txt ResultFiles/resultfile2+y-x.txt

echo ""
echo "Y = -2, X = 2"
bin/Scale -y -2 -x 2 TestFiles/testfile2.txt ResultFiles/resultfile2-y+x.txt

echo ""
echo "Scale by -9"
bin/Scale -x -9 -y -9 TestFiles/testfile9.txt ResultFiles/resultfile-9.txt

echo ""
echo "Scale by -8"
bin/Scale -x -8 -y -8 TestFiles/testfile8.txt ResultFiles/resultfile-8.txt

echo ""
echo "Scale by -7"
bin/Scale -x -7 -y -7 TestFiles/testfile7.txt ResultFiles/resultfile-7.txt

echo ""
echo "Scale by -6"
bin/Scale -x -6 -y -6 TestFiles/testfile6.txt ResultFiles/resultfile-6.txt

echo ""
echo "Scale by -5"
bin/Scale -x -5 -y -5 TestFiles/testfile5.txt ResultFiles/resultfile-5.txt

echo ""
echo "Scale by -4"
bin/Scale -x -4 -y -4 TestFiles/testfile4.txt ResultFiles/resultfile-4.txt

echo ""
echo "Scale by -3"
bin/Scale -x -3 -y -3 TestFiles/testfile3.txt ResultFiles/resultfile-3.txt

echo ""
echo "Scale by 3"
bin/Scale -x 3 -y 3 TestFiles/testfile3.txt ResultFiles/resultfile3.txt

echo ""
echo "Scale by 4"
bin/Scale -x 4 -y 4 TestFiles/testfile4.txt ResultFiles/resultfile4.txt

echo ""
echo "Scale by 5"
bin/Scale -x 5 -y 5 TestFiles/testfile5.txt ResultFiles/resultfile5.txt

echo ""
echo "Scale by 6"
bin/Scale -x 6 -y 6 TestFiles/testfile6.txt ResultFiles/resultfile6.txt

echo ""
echo "Scale by 7"
bin/Scale -x 7 -y 7 TestFiles/testfile7.txt ResultFiles/resultfile7.txt

echo ""
echo "Scale by 8"
bin/Scale -x 8 -y 8 TestFiles/testfile8.txt ResultFiles/resultfile8.txt

echo ""
echo "Scale by 9"
bin/Scale -x 9 -y 9 TestFiles/testfile9.txt ResultFiles/resultfile9.txt

echo ""
echo "BIG FILE"
bin/Scale -x 9 -y 9 TestFiles/reallyBigFile.txt ResultFiles/reallyBigFile.txt
