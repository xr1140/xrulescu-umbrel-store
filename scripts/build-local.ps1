# Builds the image for this machine's architecture on Windows.
$ErrorActionPreference = "Stop"

Push-Location (Join-Path $PSScriptRoot "..")
try {
	Get-Content upstream.env | ForEach-Object {
		if ($_ -match '^([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
			Set-Variable -Name $matches[1] -Value $matches[2]
		}
	}

	$Platform = if ($env:PLATFORM) { $env:PLATFORM } else { "linux/amd64" }
	$Tag = if ($env:TAG) { $env:TAG } else { "kanzo-umbrel:dev" }

	New-Item -ItemType Directory -Force .build | Out-Null
	Write-Host "Downloading Kanzo $KANZO_VERSION..."
	Invoke-WebRequest -Uri $KANZO_SOURCE_URL -OutFile .build/source.tar.gz
	$hash = (Get-FileHash .build/source.tar.gz -Algorithm SHA256).Hash.ToLowerInvariant()
	if ($hash -ne $KANZO_SOURCE_SHA256) {
		throw "Checksum mismatch: expected $KANZO_SOURCE_SHA256, got $hash"
	}

	Remove-Item -Recurse -Force .build/src -ErrorAction SilentlyContinue
	New-Item -ItemType Directory -Force .build/src | Out-Null
	tar -xzf .build/source.tar.gz -C .build/src
	if (-not (Test-Path ".build/src/kanzo-$KANZO_VERSION/Cargo.toml")) {
		throw "Unexpected tarball layout in .build/src"
	}

	docker buildx build --load `
		--platform $Platform `
		--build-arg "KANZO_VERSION=$KANZO_VERSION" `
		-f docker/Dockerfile `
		-t $Tag `
		.
	if ($LASTEXITCODE -ne 0) { throw "docker buildx failed" }

	Write-Host ""
	Write-Host "Built $Tag for $Platform."
	Write-Host "Try it:"
	Write-Host "  docker run --rm -p 4290:4242 -v kanzo-dev:/data $Tag"
	Write-Host "  curl.exe -H 'Host: umbrel.local:4290' http://127.0.0.1:4290/api/ping"
} finally {
	Pop-Location
}
