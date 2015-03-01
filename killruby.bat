@echo off
set /p servername= enter server name to terminate Ruby:

set /p username=Enter your corp Linux username:


REM Prompting user for password and masking it
powershell -Command $pword = read-host "Enter corp password" -AsSecureString ; $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword) ; [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) > .tmp.txt & set /p password=<.tmp.txt & del .tmp.txt
echo [
REM copying script from local computer to remote computer
echo Copying script to %servername%...
pscp -pw %password% killruby.txt %username%@%servername%:/tmp/

echo[

REM making the script executable on remote server
echo Making script executable on %servername%
plink -pw %password% %username%@%servername% chmod 755 /tmp/killruby.txt

echo[

plink -pw %password% %username%@%servername% "top -bn1 | head -12"

echo[
REM executing script on remote server
echo Executing script on %servername% Please wait...
plink -ssh -pw %password% -t %username%@%servername% "sudo /tmp/killruby.txt"

echo[

plink -pw %password% %username%@%servername% "top -bn1 | head -12"

echo[

REM cleaning up after script execution, removing script
plink -ssh -pw %password% -t %username%@%servername% "rm -f /tmp/killruby.txt"


timeout 10

