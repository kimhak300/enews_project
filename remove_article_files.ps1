# PowerShell script to remove all article-related files

Write-Host "Removing article-related files..." -ForegroundColor Yellow

# List of article files to remove
$filesToRemove = @(
    "lib\app\models\article_model.dart",
    "lib\data\models\article_model.dart",
    "lib\data\services\article_service.dart",
    "lib\data\services\bookmark_service.dart",
    "lib\data\repositories\article_repository.dart",
    "lib\modules\p4_saved\article_detail_binding.dart",
    "lib\modules\p4_saved\article_detail_controller.dart",
    "lib\modules\p4_saved\article_list_binding.dart",
    "lib\modules\p4_saved\article_list_controller.dart",
    "lib\modules\p4_saved\saved_screen\article_detail_view.dart",
    "lib\modules\p4_saved\saved_screen\article_list_view.dart"
)

$removedCount = 0
$notFoundCount = 0

foreach ($file in $filesToRemove) {
    $fullPath = Join-Path $PSScriptRoot $file
    if (Test-Path $fullPath) {
        Remove-Item $fullPath -Force
        Write-Host "Removed: $file" -ForegroundColor Green
        $removedCount++
    } else {
        Write-Host "Not found: $file" -ForegroundColor Gray
        $notFoundCount++
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Removed: $removedCount files" -ForegroundColor Green
Write-Host "  Not found: $notFoundCount files" -ForegroundColor Gray
Write-Host ""
Write-Host "Article cleanup complete!" -ForegroundColor Yellow
