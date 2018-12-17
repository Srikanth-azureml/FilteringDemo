$serverName = 'localhost'
$databaseName = 'Filtered'
$schemaToInclude = 'Production'
$dacFxDll='C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\Microsoft.SqlServer.Dac.Extensions.dll'

$dacpacPath = "$PSScriptRoot\bin\Debug\FilteringDemo.dacpac"

Add-Type -Path $dacFxDll

$sourceDacpac = New-Object Microsoft.SqlServer.Dac.Compare.SchemaCompareDacpacEndpoint($dacpacPath);

$targetDatabase = New-Object Microsoft.SqlServer.Dac.Compare.SchemaCompareDatabaseEndpoint("Data Source=$serverName;Initial Catalog=$databaseName;Integrated Security=True;")

$comparison = New-Object Microsoft.SqlServer.Dac.Compare.SchemaComparison($sourceDacpac, $targetDatabase)

$comparisonResult = $comparison.Compare()

$comparisonResult.Differences | %{
	if( $_.SourceObject.name.parts[0] -ne $schemaToInclude){
		Write-Output "Excluding Object $($_.SourceObject.name)"
		$comparisonResult.Exclude($_) | Out-Null

	}

}

$publishResult =  $comparisonResult.PublishChangesToTarget();

if ($publishResult.Success){
	Write-Output "Worky"
}
else{
	Write-Output "NoWorky"
}
