$PastDate = (Get-date).AddDays(-90).ToString('yyyy-MM-dd')
### Local
$LocalBranches = (git branch  --format='%(refname:short),%(committerdate:short)' | Select-String -Pattern '^HEAD','^main','^master','^staging','^qa' -NotMatch).Line
foreach ($b in $LocalBranches)
{
  $Refname,$CommitterDate = $b.Split(",")
  if ((Get-Date $CommitterDate) -lt $PastDate)
  {
   Write-Host "Deleting Local: $Refname ($CommitterDate)"
   git branch -d $Refname
  }
}
### Remote
$RemoteBranches = (git branch -r --format='%(refname:lstrip=3),%(committerdate:short)' | Select-String -Pattern '^HEAD','^main','^master','^staging','^qa' -NotMatch).Line
foreach ($b in $RemoteBranches)
{
  $Refname,$CommitterDate = $b.Split(",")
  if ((Get-Date $CommitterDate) -lt $PastDate)
  {
   Write-Host "Deleting Remote: $Refname ($CommitterDate)"
   git push origin -d $Refname # this will write to StdErr, ignore, use -q or redirect
  }
}
git fetch --prune