echo "Invalid Input File Test:"
../bin/MPC /invalidFile.mp
echo

echo "Invalid Output File Test:"
../bin/MPC SVP.mp /invalidFile.mp
echo

echo "Syntax Error Test:"
../bin/MPC SyntaxError.mp
echo

echo "Division by Zero Test:"
../bin/MPC DivisionByZero.mp
echo

echo "SVP Test:"
../bin/MPC SVP.mp
echo "Execution:"
MPVM SVP.mpc < OneTwo
echo

echo "Output File Test:"
../bin/MPC SVP.mp OutputFile.mpc
echo "Execution:"
MPVM OutputFile.mpc < OneTwo
echo

echo "Oneliner Test:"
../bin/MPC Oneliner.mp
echo "Execution:"
MPVM Oneliner.mpc < OneTwo
echo

echo "Factorial Test:"
../bin/MPC Factorial.mp
echo "Execution:"
MPVM Factorial.mpc < Five
echo

echo "Expression Test:"
../bin/MPC Expressions.mp
echo "Execution:"
MPVM Expressions.mpc < OneTwo