$ErrorActionPreference = 'Continue'
$root = 'D:\Sem 7\NCS-7th-Sem'
$out  = Join-Path $root 'slides'
New-Item -ItemType Directory -Force -Path $out | Out-Null

function Get-ShapeText {
    param($shape, $depth)
    $lines = @()
    if ($depth -gt 4) { return $lines }
    try {
        if ($shape.Type -eq 6) {                       # msoGroup -> recurse
            $kids = @()
            foreach ($g in $shape.GroupItems) { $kids += $g }
            foreach ($g in ($kids | Sort-Object { $_.Top }, { $_.Left })) {
                $lines += Get-ShapeText -shape $g -depth ($depth + 1)
            }
            return $lines
        }
        if ($shape.HasTable) {
            $tb = $shape.Table
            for ($r = 1; $r -le $tb.Rows.Count; $r++) {
                $cells = @()
                for ($c = 1; $c -le $tb.Columns.Count; $c++) {
                    $t = ''
                    try { $t = $tb.Cell($r, $c).Shape.TextFrame.TextRange.Text } catch {}
                    $cells += ($t -replace '[\r\n\v]+', ' ').Trim()
                }
                $lines += '| ' + ($cells -join ' | ') + ' |'
                if ($r -eq 1) { $lines += '|' + (' --- |' * $tb.Columns.Count) }
            }
            return $lines
        }
        if ($shape.HasTextFrame -and $shape.TextFrame.HasText) {
            $tr = $shape.TextFrame.TextRange
            $n = $tr.Paragraphs().Count
            for ($p = 1; $p -le $n; $p++) {
                $para = $tr.Paragraphs($p)
                $txt = ($para.Text -replace '[\r\n\v]+', ' ').Trim()
                if (-not $txt) { continue }
                $ind = 1
                try { $ind = $para.IndentLevel } catch {}
                $lines += ('  ' * ($ind - 1)) + '- ' + $txt
            }
        }
    } catch {}
    return $lines
}

foreach ($f in Get-ChildItem (Join-Path $root '*.ppt') | Sort-Object Name) {
    $pp = $null; $doc = $null
    try {
        $pp = New-Object -ComObject PowerPoint.Application
        $doc = $pp.Presentations.Open($f.FullName, $true, $false, $false)
        $base = [IO.Path]::GetFileNameWithoutExtension($f.Name)
        $md = New-Object System.Collections.Generic.List[string]
        $md.Add('# ' + $base + '  -  ' + $doc.Slides.Count + ' slides')
        $md.Add('')
        $md.Add('> Source: `' + $f.Name + '` (Stallings, *Cryptography and Network Security* 4/e  -  Lawrie Brown overheads)')
        $md.Add('')

        foreach ($s in $doc.Slides) {
            $idx = $s.SlideIndex
            $title = ''
            try { if ($s.Shapes.HasTitle) { $title = ($s.Shapes.Title.TextFrame.TextRange.Text -replace '[\r\n\v]+',' ').Trim() } } catch {}
            if (-not $title) { $title = '(untitled)' }
            $md.Add('## Slide ' + $idx + '  -  ' + $title)
            $md.Add('')

            $shapes = @()
            foreach ($sh in $s.Shapes) {
                $isTitle = $false
                try { if ($s.Shapes.HasTitle -and $sh.Id -eq $s.Shapes.Title.Id) { $isTitle = $true } } catch {}
                if (-not $isTitle) { $shapes += $sh }
            }
            $body = @()
            foreach ($sh in ($shapes | Sort-Object { $_.Top }, { $_.Left })) {
                $body += Get-ShapeText -shape $sh -depth 0
            }
            if ($body.Count) { foreach ($b in $body) { $md.Add($b) }; $md.Add('') }
            else { $md.Add('*(image/diagram slide  -  no extractable text)*'); $md.Add('') }

            try {
                if ($s.NotesPage.Shapes.Count -ge 2) {
                    $nt = ''
                    foreach ($ns in $s.NotesPage.Shapes) {
                        if ($ns.HasTextFrame -and $ns.TextFrame.HasText) {
                            $cand = $ns.TextFrame.TextRange.Text
                            if ($cand.Trim() -and $cand.Trim() -ne [string]$idx) { $nt = $cand }
                        }
                    }
                    $nt = ($nt -replace '[\r\n\v]+', ' ').Trim()
                    if ($nt) { $md.Add('> **Notes:** ' + $nt); $md.Add('') }
                }
            } catch {}
        }
        $target = Join-Path $out ($base + '.md')
        [IO.File]::WriteAllLines($target, $md, (New-Object System.Text.UTF8Encoding $false))
        Write-Output ('WROTE ' + $base + '.md  (' + $doc.Slides.Count + ' slides, ' + $md.Count + ' lines)')
    } catch {
        Write-Output ('ERROR ' + $f.Name + ': ' + $_.Exception.Message)
    } finally {
        if ($doc) { try { $doc.Close() } catch {} }
        if ($pp)  { try { $pp.Quit()  } catch {} }
        [GC]::Collect()
    }
}
