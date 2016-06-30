"Add a new User to LYNC Server 2013"
"==============="
"NOTE: This script is now deprecated. We now use Skype for Business through Office 365 and no longer administrate our own Lync Server"
"If the user's Identity is printed in the format `"CN=first last, OU=...`" Then the user is already enabled in Lync Server."
"This script will add the user to the UEMFAPP01.UEMF.local pool."
"The username of the new user will be `"Username@UEMF.local`""
""

$firstName = Read-Host 'What is the First Name?'
$lastName = Read-Host 'What is the Last Name?'
$sipAcctName = Read-Host 'What is the Username?'
$ErrorActionPreference = "stop" #Try/Catch doesnt work unless the error will terminate the process

try #look up the user
{
Select-String -Pattern "CN=" -InputObject (Get-CsUser -Identity $sipAcctName@UEMF.Local)
}

catch [Microsoft.Rtc.Management.AD.ManagementException] #error thrown when the user is NOT found
{
Enable-CsUser -Identity "$firstName $lastName" -RegistrarPool "UEMFAPP01.UEMF.local" -SipAddressType SAMAccountName -SipDomain "uemf.local"
"User Added Successfully!"
}
