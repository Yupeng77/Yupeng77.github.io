# menu.ps1 - academic site management

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$SiteDir   = "C:\Users\Yupeng\Academic Website\Yupeng77.github.io"
$IndexHtml = "$SiteDir\index.html"
$ResHtml   = "$SiteDir\research.html"
$CvHtml    = "$SiteDir\cv.html"
$ConHtml   = "$SiteDir\contact.html"
$Sep       = '   ' + ([string][char]0x2500 * 56)

# ── Helpers ────────────────────────────────────────────────────────────────────

function W($text, $color = 'White', [switch]$no) {
    if ($no) { Write-Host $text -ForegroundColor $color -NoNewline }
    else      { Write-Host $text -ForegroundColor $color }
}

function Strip-Html($html) {
    ($html -replace '<[^>]+>','' `
           -replace '&amp;','&' `
           -replace '&middot;','·' `
           -replace '&lt;','<' `
           -replace '&gt;','>' `
           -replace '&nbsp;',' ').Trim()
}

function Ask($label, $default = '') {
    Write-Host "   $label" -NoNewline -ForegroundColor DarkGray
    if ($default) { Write-Host " [$default]" -NoNewline -ForegroundColor DarkGray }
    Write-Host ": " -NoNewline -ForegroundColor DarkGray
    $v = (Read-Host).Trim()
    if (-not $v -and $default) { return $default }
    return $v
}

function Pause-Return {
    Write-Host ""; W "   Press any key to continue..." DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ── Parsers ────────────────────────────────────────────────────────────────────

function Parse-Updates {
    $html = Get-Content $IndexHtml -Raw -Encoding UTF8
    $ms   = [regex]::Matches($html, '(?s)<div class="update-row">\s*<span class="update-date">([^<]+)</span>\s*<span class="update-text">(.*?)</span>\s*</div>')
    return @($ms | ForEach-Object { [pscustomobject]@{ date = $_.Groups[1].Value.Trim(); text = $_.Groups[2].Value.Trim() } })
}

function Parse-Papers {
    $html = Get-Content $ResHtml -Raw -Encoding UTF8
    $ms   = [regex]::Matches($html, '(?s)<div class="paper">\s*<div class="paper-title">(.*?)</div>\s*<div class="paper-meta">([^<]+)</div>\s*(?:<p class="paper-desc">(.*?)</p>\s*)?</div>')
    return @($ms | ForEach-Object {
        $tb       = $_.Groups[1].Value.Trim()
        $bm       = [regex]::Match($tb, '<span class="badge">([^<]+)</span>')
        $badge    = if ($bm.Success) { $bm.Groups[1].Value } else { '' }
        $title    = ([regex]::Replace($tb, '\s*<span class="badge">[^<]+</span>', '')).Trim()
        $abstract = if ($_.Groups[3].Success) { $_.Groups[3].Value.Trim() -replace '&amp;', '&' } else { '' }
        [pscustomobject]@{
            title    = $title
            badge    = $badge
            authors  = $_.Groups[2].Value.Trim() -replace '&amp;', '&'
            abstract = $abstract
        }
    })
}

function Parse-Upcoming {
    $html = Get-Content $IndexHtml -Raw -Encoding UTF8
    $ms   = [regex]::Matches($html, '(?s)<div class="conf-row">\s*<span class="conf-name">([^<]+)</span>\s*<span class="conf-meta">([^<]+)</span>\s*</div>')
    return @($ms | ForEach-Object {
        [pscustomobject]@{ name = $_.Groups[1].Value.Trim(); meta = (Strip-Html $_.Groups[2].Value.Trim()) }
    })
}

function Parse-Bio {
    $html = Get-Content $IndexHtml -Raw -Encoding UTF8
    $m    = [regex]::Match($html, '(?s)<p class="hero-bio">(.*?)</p>')
    if ($m.Success) { return $m.Groups[1].Value.Trim() } else { return '' }
}

# ── Section rebuilders ─────────────────────────────────────────────────────────

function Replace-Section($html, $startAnchor, $endAnchor, $newBlock) {
    $s = $html.IndexOf($startAnchor)
    $e = $html.IndexOf($endAnchor)
    if ($s -lt 0 -or $e -lt 0) { return $html }
    $prefixEnd = $html.LastIndexOf("`n", $s) + 1
    $lineStart = $html.LastIndexOf("`n", $e) + 1
    return $html.Substring(0, $prefixEnd) + $newBlock + "`r`n`r`n" + $html.Substring($lineStart)
}

function Build-Updates($items) {
    $rows = $items | ForEach-Object {
        "      <div class=`"update-row`">`r`n        <span class=`"update-date`">$($_.date)</span>`r`n        <span class=`"update-text`">$($_.text)</span>`r`n      </div>"
    }
    return "    <!-- Recent Updates -->`r`n    <div class=`"section`">`r`n      <div class=`"section-label`">Recent Updates</div>`r`n`r`n" + ($rows -join "`r`n") + "`r`n    </div>"
}

function Build-PapersBlock($items, $label, [switch]$includeAbstract) {
    $rows = $items | ForEach-Object {
        $t = $_.title; if ($_.badge) { $t += " <span class=`"badge`">$($_.badge)</span>" }
        $a = $_.authors -replace '&','&amp;'
        $block = "      <div class=`"paper`">`r`n        <div class=`"paper-title`">$t</div>`r`n        <div class=`"paper-meta`">$a</div>"
        if ($includeAbstract -and $_.abstract) {
            $abs = $_.abstract -replace '&','&amp;'
            $block += "`r`n        <p class=`"paper-desc`">$abs</p>"
        }
        $block += "`r`n      </div>"
        $block
    }
    return "    <!-- $label -->`r`n    <div class=`"section`">`r`n      <div class=`"section-label`">Working Papers</div>`r`n`r`n" + ($rows -join "`r`n`r`n") + "`r`n    </div>"
}

function Build-Upcoming($items) {
    $rows = $items | ForEach-Object {
        $mt = $_.meta -replace '·','&middot;'
        "      <div class=`"conf-row`">`r`n        <span class=`"conf-name`">$($_.name)</span>`r`n        <span class=`"conf-meta`">$mt</span>`r`n      </div>"
    }
    return "    <!-- Upcoming Presentations -->`r`n    <div class=`"section`">`r`n      <div class=`"section-label`">Upcoming Presentations</div>`r`n`r`n" + ($rows -join "`r`n") + "`r`n    </div>"
}

function Save-Html($path, $content) {
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
}

function Save-Updates($items) {
    $h = Get-Content $IndexHtml -Raw -Encoding UTF8
    $h = Replace-Section $h '<!-- Recent Updates -->'      '<!-- Working Papers -->'         (Build-Updates $items)
    Save-Html $IndexHtml $h
}

function Save-Papers($items) {
    $ih = Get-Content $IndexHtml -Raw -Encoding UTF8
    $ih = Replace-Section $ih '<!-- Working Papers -->' '<!-- Upcoming Presentations -->' (Build-PapersBlock $items 'Working Papers')
    Save-Html $IndexHtml $ih

    $rh = Get-Content $ResHtml -Raw -Encoding UTF8
    $rh = Replace-Section $rh '<!-- Working Papers -->' '<!-- Conference Presentations -->' (Build-PapersBlock $items 'Working Papers' -includeAbstract)
    Save-Html $ResHtml $rh
}

function Save-Upcoming($items) {
    $h = Get-Content $IndexHtml -Raw -Encoding UTF8
    $h = Replace-Section $h '<!-- Upcoming Presentations -->' '</main>' (Build-Upcoming $items)
    Save-Html $IndexHtml $h
}

function Save-Bio($bio) {
    $h = Get-Content $IndexHtml -Raw -Encoding UTF8
    $h = $h -replace '(?s)(<p class="hero-bio">)(.*?)(</p>)', "`$1`r`n          $bio`r`n        `$3"
    Save-Html $IndexHtml $h
}

# ── Remove helper ──────────────────────────────────────────────────────────────

function Remove-At($arr, $idx) {
    $list = [System.Collections.Generic.List[object]]::new()
    $arr | ForEach-Object { $list.Add($_) }
    $list.RemoveAt($idx)
    return ,$list.ToArray()
}

# ── Section menus ──────────────────────────────────────────────────────────────

function Menu-Updates {
    while ($true) {
        $items = Parse-Updates
        Clear-Host; Write-Host ""
        W "   RECENT UPDATES" Cyan
        W $Sep DarkGray; Write-Host ""

        if ($items.Count -eq 0) {
            W "   (no updates yet)" DarkGray
        } else {
            for ($i = 0; $i -lt $items.Count; $i++) {
                $n  = ($i+1).ToString().PadLeft(2)
                $dt = $items[$i].date.PadRight(12)
                $tx = Strip-Html $items[$i].text
                if ($tx.Length -gt 50) { $tx = $tx.Substring(0,47) + '...' }
                Write-Host "   " -NoNewline
                W $n Cyan -no; Write-Host "  " -NoNewline
                W $dt DarkGray -no; W $tx White
            }
        }

        Write-Host ""; W $Sep DarkGray; Write-Host ""
        W "   [A] Add    [E 2] Edit #    [D 2] Delete #    [Enter] Back" DarkGray
        Write-Host ""
        $cmd = (Read-Host "   >").Trim().ToUpper()
        if ($cmd -eq '') { return }

        if ($cmd -eq 'A') {
            Write-Host ""
            $date = Ask "Date" ((Get-Date).ToString("MMM yyyy", [System.Globalization.CultureInfo]::InvariantCulture))
            if (-not $date) { continue }
            Write-Host "   Text (HTML ok — e.g. Presented at <strong>IACM</strong>, Vienna):" -ForegroundColor DarkGray
            $text = (Read-Host "   >").Trim()
            if (-not $text) { continue }
            $new = @([pscustomobject]@{ date = $date; text = $text }) + $items
            Save-Updates $new
            Write-Host ""; W "   Saved." White; Start-Sleep -Milliseconds 500

        } elseif ($cmd -match '^E\s+(\d+)$') {
            $idx = [int]$Matches[1] - 1
            if ($idx -lt 0 -or $idx -ge $items.Count) { continue }
            Write-Host ""
            $date = Ask "Date" $items[$idx].date
            Write-Host "   Text (current shown, edit or re-type):" -ForegroundColor DarkGray
            W "   $($items[$idx].text)" DarkGray
            Write-Host "   " -NoNewline
            $text = (Read-Host ">").Trim()
            if (-not $text) { $text = $items[$idx].text }
            $items[$idx].date = $date; $items[$idx].text = $text
            Save-Updates $items
            Write-Host ""; W "   Saved." White; Start-Sleep -Milliseconds 500

        } elseif ($cmd -match '^D\s+(\d+)$') {
            $idx = [int]$Matches[1] - 1
            if ($idx -lt 0 -or $idx -ge $items.Count) { continue }
            Write-Host ""
            W "   Delete: $(Strip-Html $items[$idx].text)" DarkGray
            $conf = Ask "Confirm delete? [Y/N]" "N"
            if ($conf.ToUpper() -eq 'Y') {
                Save-Updates (Remove-At $items $idx)
                Write-Host ""; W "   Deleted." White; Start-Sleep -Milliseconds 500
            }
        }
    }
}

function Menu-Bio {
    Clear-Host; Write-Host ""
    W "   BIO" Cyan
    W $Sep DarkGray; Write-Host ""

    $bio   = Parse-Bio
    $plain = Strip-Html $bio

    W "   Current bio:" DarkGray; Write-Host ""
    $words = $plain -split '\s+'
    $line  = '     '
    foreach ($w in $words) {
        if ($line.Length + $w.Length + 1 -gt 65) { Write-Host $line; $line = '     ' + $w }
        elseif ($line -eq '     ') { $line += $w } else { $line += " $w" }
    }
    if ($line.Trim()) { Write-Host $line }

    Write-Host ""; W $Sep DarkGray; Write-Host ""
    W "   Type a new bio, or just press Enter to keep it." DarkGray
    W "   Use <strong>word</strong> for bold text." DarkGray
    Write-Host ""
    $new = (Read-Host "   >").Trim()
    if ($new) {
        Save-Bio $new
        Write-Host ""; W "   Saved." White
    }
    Write-Host ""; Pause-Return
}

function Menu-Papers {
    while ($true) {
        $items = Parse-Papers
        Clear-Host; Write-Host ""
        W "   WORKING PAPERS" Cyan
        W $Sep DarkGray; Write-Host ""

        if ($items.Count -eq 0) {
            W "   (no papers yet)" DarkGray
        } else {
            for ($i = 0; $i -lt $items.Count; $i++) {
                $n = ($i+1).ToString().PadLeft(2)
                Write-Host "   " -NoNewline
                W $n Cyan -no; Write-Host "  " -NoNewline
                W $items[$i].title White -no
                if ($items[$i].badge) { Write-Host "  " -NoNewline; W "[$($items[$i].badge)]" DarkGray }
                else { Write-Host "" }
                Write-Host "       " -NoNewline
                W $items[$i].authors DarkGray
                if ($items[$i].abstract) {
                    $abs = $items[$i].abstract
                    if ($abs.Length -gt 60) { $abs = $abs.Substring(0,57) + '...' }
                    Write-Host "       " -NoNewline
                    W $abs DarkGray
                }
                Write-Host ""
            }
        }

        W $Sep DarkGray; Write-Host ""
        W "   [A] Add    [E 2] Edit #    [D 2] Delete #    [Enter] Back" DarkGray
        Write-Host ""
        $cmd = (Read-Host "   >").Trim().ToUpper()
        if ($cmd -eq '') { return }

        if ($cmd -eq 'A') {
            Write-Host ""
            $title = Ask "Title"
            if (-not $title) { continue }
            $auth  = Ask "Authors  (e.g. He & Jain)"
            $badge = Ask "Status badge  (e.g. data collection) — blank to skip"
            Write-Host "   Abstract (shown on Research page only, blank to skip):" -ForegroundColor DarkGray
            $abstract = (Read-Host "   >").Trim()
            $new   = @([pscustomobject]@{ title = $title; badge = $badge; authors = $auth; abstract = $abstract }) + $items
            Save-Papers $new
            Write-Host ""; W "   Saved to index.html and research.html." White; Start-Sleep -Milliseconds 700

        } elseif ($cmd -match '^E\s+(\d+)$') {
            $idx = [int]$Matches[1] - 1
            if ($idx -lt 0 -or $idx -ge $items.Count) { continue }
            Write-Host ""
            $title = Ask "Title"   $items[$idx].title
            $auth  = Ask "Authors" $items[$idx].authors
            $badge = Ask "Badge"   $items[$idx].badge
            Write-Host "   Abstract (current shown, edit or re-type, blank keeps it):" -ForegroundColor DarkGray
            if ($items[$idx].abstract) { W "   $($items[$idx].abstract)" DarkGray }
            Write-Host "   " -NoNewline
            $abstract = (Read-Host ">").Trim()
            if (-not $abstract) { $abstract = $items[$idx].abstract }
            $items[$idx].title = $title; $items[$idx].authors = $auth; $items[$idx].badge = $badge; $items[$idx].abstract = $abstract
            Save-Papers $items
            Write-Host ""; W "   Saved." White; Start-Sleep -Milliseconds 500

        } elseif ($cmd -match '^D\s+(\d+)$') {
            $idx = [int]$Matches[1] - 1
            if ($idx -lt 0 -or $idx -ge $items.Count) { continue }
            Write-Host ""
            W "   Delete: $($items[$idx].title)" DarkGray
            $conf = Ask "Confirm? [Y/N]" "N"
            if ($conf.ToUpper() -eq 'Y') {
                Save-Papers (Remove-At $items $idx)
                Write-Host ""; W "   Deleted." White; Start-Sleep -Milliseconds 500
            }
        }
    }
}

function Menu-Upcoming {
    while ($true) {
        $items = Parse-Upcoming
        Clear-Host; Write-Host ""
        W "   UPCOMING PRESENTATIONS" Cyan
        W $Sep DarkGray; Write-Host ""

        if ($items.Count -eq 0) {
            W "   (none scheduled)" DarkGray
        } else {
            for ($i = 0; $i -lt $items.Count; $i++) {
                $n  = ($i+1).ToString().PadLeft(2)
                $nm = $items[$i].name.PadRight(36)
                Write-Host "   " -NoNewline
                W $n Cyan -no; Write-Host "  " -NoNewline
                W $nm White -no; W $items[$i].meta DarkGray
            }
        }

        Write-Host ""; W $Sep DarkGray; Write-Host ""
        W "   [A] Add    [D 2] Delete #    [Enter] Back" DarkGray
        Write-Host ""
        $cmd = (Read-Host "   >").Trim().ToUpper()
        if ($cmd -eq '') { return }

        if ($cmd -eq 'A') {
            Write-Host ""
            $name = Ask "Conference name  (e.g. IACM Annual Conference)"
            if (-not $name) { continue }
            $meta = Ask "Location · Date  (e.g. Vienna · Jul 2026)"
            $new  = @([pscustomobject]@{ name = $name; meta = $meta }) + $items
            Save-Upcoming $new
            Write-Host ""; W "   Saved." White; Start-Sleep -Milliseconds 500

        } elseif ($cmd -match '^D\s+(\d+)$') {
            $idx = [int]$Matches[1] - 1
            if ($idx -lt 0 -or $idx -ge $items.Count) { continue }
            Write-Host ""
            W "   Delete: $($items[$idx].name)" DarkGray
            $conf = Ask "Confirm? [Y/N]" "N"
            if ($conf.ToUpper() -eq 'Y') {
                Save-Upcoming (Remove-At $items $idx)
                Write-Host ""; W "   Deleted." White; Start-Sleep -Milliseconds 500
            }
        }
    }
}

function Deploy {
    Clear-Host; Write-Host ""
    W "   DEPLOY" Cyan
    W $Sep DarkGray; Write-Host ""

    Set-Location $SiteDir
    git add -A
    $status = git status --porcelain
    if (-not $status) {
        W "   Nothing to commit — site is already up to date." DarkGray
        Write-Host ""; Pause-Return; return
    }

    W "   Changed files:" DarkGray; Write-Host ""
    $status | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
    Write-Host ""

    $default = "update: " + (Get-Date).ToString("yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
    $msg     = Ask "Commit message" $default
    Write-Host ""
    git commit -m $msg
    Write-Host ""
    W "   Pushing to GitHub..." DarkGray; Write-Host ""
    git push origin master
    Write-Host ""
    W "   Done — live at heyupeng.com in about 1 minute." White
    Write-Host ""; Pause-Return
}

function Get-Py {
    foreach ($cand in @('py','python','python3')) {
        if (Get-Command $cand -ErrorAction SilentlyContinue) { return $cand }
    }
    return $null
}

function Update-CvFromDocx {
    Write-Host ""
    $docxPath = (Ask "Path to .docx (drag the file into this window, or type the path)").Trim('"')
    if (-not $docxPath) { return }
    if (-not (Test-Path $docxPath)) {
        Write-Host ""; W "   File not found: $docxPath" Red
        Pause-Return; return
    }

    Write-Host ""
    W "   Converting to PDF..." DarkGray
    $pdfPath = "$SiteDir\files\cv_yupeng_he.pdf"
    $word = $null
    try {
        $word = New-Object -ComObject Word.Application
        $word.Visible = $false
        $doc = $word.Documents.Open($docxPath, $false, $true)
        $doc.SaveAs2($pdfPath, 17)
        $doc.Close($false)
        $word.Quit()
        W "   PDF saved to files\cv_yupeng_he.pdf" White
    } catch {
        W "   PDF conversion failed: $($_.Exception.Message)" Red
        if ($word) { try { $word.Quit() } catch {} }
    }

    $py = Get-Py
    if (-not $py) {
        Write-Host ""; W "   Python not found on PATH — cannot update cv.html sections." Red
        Pause-Return; return
    }

    Write-Host ""
    W "   Updating cv.html sections from the docx..." DarkGray
    Write-Host ""
    $output = & $py "$SiteDir\cv_convert.py" $docxPath
    foreach ($line in $output) {
        if ($line -match '^MAPPED::(.+)$')  { W "     mapped:  $($Matches[1])" White }
        elseif ($line -match '^SKIPPED::(.+)$') { W "     skipped: $($Matches[1])" DarkGray }
        else { W "     $line" DarkGray }
    }

    Write-Host ""
    W "   Done. Review cv.html, then Deploy (8) to publish." White
    Pause-Return
}

function Menu-Cv {
    while ($true) {
        Clear-Host; Write-Host ""
        W "   CV" Cyan
        W $Sep DarkGray; Write-Host ""
        W "   Updates cv.html and the PDF download straight from your" DarkGray
        W "   existing Word CV template — no reformatting needed." DarkGray
        W "   Sections are matched to cv.html by their heading text," DarkGray
        W "   and Word exports a matching PDF for download." DarkGray
        Write-Host ""
        W $Sep DarkGray; Write-Host ""
        W "   [U] Update from docx    [O] Open cv.html in editor    [Enter] Back" DarkGray
        Write-Host ""
        $cmd = (Read-Host "   >").Trim().ToUpper()
        if ($cmd -eq '') { return }
        if ($cmd -eq 'O') { Open-InVSCode $CvHtml; continue }
        if ($cmd -eq 'U') { Update-CvFromDocx }
    }
}

function Open-InVSCode($file) {
    if (Get-Command code -ErrorAction SilentlyContinue) { & code $file }
    else { Start-Process notepad $file }
}

# ── Dashboard ──────────────────────────────────────────────────────────────────

function Show-Dashboard {
    Clear-Host; [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    $pc = if (Test-Path $ResHtml) { ([regex]::Matches((Get-Content $ResHtml -Raw -Encoding UTF8), '<div class="paper">')).Count } else { 0 }
    $ihtml = if (Test-Path $IndexHtml) { Get-Content $IndexHtml -Raw -Encoding UTF8 } else { '' }
    $uc   = ([regex]::Matches($ihtml, '<div class="update-row">')).Count
    $upc  = ([regex]::Matches($ihtml, 'class="conf-row"')).Count
    $lum  = [regex]::Match($ihtml, '<span class="update-date">([^<]+)</span>')
    $lu   = if ($lum.Success) { $lum.Groups[1].Value.Trim() } else { 'none' }
    $today = (Get-Date).ToString("MMM d, yyyy", [System.Globalization.CultureInfo]::InvariantCulture)

    Write-Host ""
    W "   heyupeng" White -no; W "." Cyan -no; W "com" DarkGray -no
    $pad = 59 - "   heyupeng.com".Length - $today.Length
    Write-Host (' ' * [math]::Max(2, $pad)) -NoNewline; W $today DarkGray
    W $Sep DarkGray; Write-Host ""

    $ps = if ($pc -eq 1) { '1 paper' } else { "$pc papers" }
    W "   RESEARCH" Cyan -no
    Write-Host (' ' * [math]::Max(2, 59 - "   RESEARCH".Length - $ps.Length)) -NoNewline; W $ps DarkGray
    Write-Host "     " -NoNewline
    W "working papers   " DarkGray -no; W ([string]$pc).PadLeft(2) White -no
    Write-Host "     " -NoNewline
    W "upcoming   " DarkGray -no; W ([string]$upc).PadLeft(2) White
    Write-Host ""

    $us = if ($uc -eq 1) { '1 update' } else { "$uc updates" }
    W "   UPDATES" Cyan -no
    Write-Host (' ' * [math]::Max(2, 59 - "   UPDATES".Length - $us.Length)) -NoNewline; W $us DarkGray
    Write-Host "     " -NoNewline
    W "last update      " DarkGray -no; W $lu White
    Write-Host ""; W $Sep DarkGray; Write-Host ""

    $items = @(
        @('1','Updates'),@('2','Bio'),@('3','Papers'),@('4','Upcoming')
        @('5','CV'),@('6','Contact (open in editor)')
        @('7','Open folder in VS Code'),@('8','Deploy to heyupeng.com')
    )
    for ($i = 0; $i -lt $items.Count; $i += 2) {
        Write-Host "   " -NoNewline
        W $items[$i][0] Cyan -no; Write-Host "  $($items[$i][1])".PadRight(30) -NoNewline -ForegroundColor White
        if ($i+1 -lt $items.Count) {
            W $items[$i+1][0] Cyan -no; Write-Host "  $($items[$i+1][1])" -ForegroundColor White
        } else { Write-Host "" }
    }
    Write-Host ""; Write-Host "   " -NoNewline
    W "Q" DarkGray -no; W "  Quit" DarkGray; Write-Host ""
}

# ── Main loop ──────────────────────────────────────────────────────────────────

while ($true) {
    Show-Dashboard
    switch ((Read-Host "   >").Trim().ToUpper()) {
        "1" { Menu-Updates  }
        "2" { Menu-Bio      }
        "3" { Menu-Papers   }
        "4" { Menu-Upcoming }
        "5" { Menu-Cv }
        "6" { Open-InVSCode $ConHtml }
        "7" { Open-InVSCode $SiteDir }
        "8" { Deploy }
        "Q" { Clear-Host; exit }
    }
}
