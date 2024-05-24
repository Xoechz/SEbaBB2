echo "Invalid File Test":
../bin/ExprParse /invalidFile.txt
echo

echo "Syntax Error Test":
../bin/ExprParse syntaxError.txt
echo

echo "Division by Zero Test":
../bin/ExprParse divisionByZero.txt
echo

echo "Easy Expression Test":
../bin/ExprParse easyExpression.txt
echo

echo "Difficult Expression Test":
../bin/ExprParse difficultExpression.txt
echo