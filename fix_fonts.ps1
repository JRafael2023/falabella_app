Get-ChildItem 'C:\Users\USER\Downloads\falabella\lib' -Recurse -Filter '*.dart' | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $newContent = $content -replace 'GoogleFonts\.interTight\(', 'TextStyle(' -replace 'GoogleFonts\.inter\(', 'TextStyle('
    if ($content -ne $newContent) {
        Set-Content $_.FullName $newContent -NoNewline
        Write-Host "Updated: $($_.Name)"
    }
}
Write-Host "Done!"
