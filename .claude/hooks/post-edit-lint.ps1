# Post-Edit Lint Hook
#
# Runs `ruff check` on a Python file after Claude Code edits it via Edit or Write.
# Receives the tool event as JSON on stdin from Claude Code.
#
# Exit codes:
#   0 = lint clean (or non-Python file, skipped) — Claude Code suppresses stdout
#   2 = lint errors found — stderr is surfaced to the model so Claude can react

param()

# Read the JSON event payload from stdin
$input_json = [Console]::In.ReadToEnd()

try {
    $event = $input_json | ConvertFrom-Json
} catch {
    # Bad JSON — exit clean so we don't block Claude
    exit 0
}

# Extract the file path Claude Code edited
$file_path = $event.tool_input.file_path
if (-not $file_path) { exit 0 }

# Only lint Python files
if ($file_path -notlike "*.py") { exit 0 }

# Skip if the file no longer exists (e.g., deleted)
if (-not (Test-Path $file_path)) { exit 0 }

# Run ruff
$ruff_output = ruff check $file_path 2>&1
$ruff_exit = $LASTEXITCODE

if ($ruff_exit -eq 0) {
    Write-Host "post-edit-lint: clean ($file_path)" -ForegroundColor Green
    exit 0
} else {
    # Surface findings to the model via stderr + exit 2
    [Console]::Error.WriteLine("post-edit-lint: ruff found issues in $file_path")
    [Console]::Error.WriteLine($ruff_output)
    exit 2
}
