# Hexo Tool by Nuaptan(ZFW)
param([string]$para)
Write-Output "Hexo Tool... Fix broken css/js links in posts."
if(-not(Test-Path ".`\source")) {
    Write-Error "You should run this script under the root directory of a hexo site."
    exit
}
If($para.Equals("auto")) {
    Write-Output "Auto mode"
    (Get-ChildItem .\source).LastWriteTimeString>.\temp.txt
    If(-not(Test-Path ".`\srchistory.txt")) {
        (Get-ChildItem .\source).LastWriteTimeString>.\srchistory.txt
    }
    Else {
        If([string]::IsNullOrWhiteSpace((Compare-Object (Get-Content .\temp.txt) (Get-Content .\srchistory.txt)))) {
            Write-Output "No need to run.";
            Exit
        }
    }
}
hexo clean
hexo generate
Get-ChildItem *.html -Path ".`\public" -Recurse|ForEach-Object -Process {
    $word="`"../css/style.css`""
    $replace="`"https://zijianfelixwang.github.io/css/style.css`""  # change to your url (change name then ok)
    $text=Get-Content $_.FullName
    $rtext=$text -replace $word,$replace
    $rtext>$_.FullName
}
Get-ChildItem *.html -Path ".`\public" -Recurse|ForEach-Object -Process {
    $word="`"../js/main.js`""
    $replace="`"https://zijianfelixwang.github.io/js/main.js`"" # change to your url (change name then ok)
    $text=Get-Content $_.FullName
    $rtext=$text -replace $word,$replace
    $rtext>$_.FullName
}
If(-not($para.Equals("auto"))) {
    Read-Host "Deploy hit enter"
}
hexo d
(Get-ChildItem .\source).LastWriteTimeString>.\srchistory.txt
exit