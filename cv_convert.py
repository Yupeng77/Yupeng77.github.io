"""Update cv.html from the CV .docx using its existing table-based template.

Usage: py cv_convert.py <path-to-docx>

Reads the docx via pandoc's JSON AST (more reliable than markdown table
text), matches each ALL-CAPS heading paragraph + the table that follows it
to a cv.html section by keyword, and rewrites that section's HTML in place.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

SITE_DIR = Path(__file__).resolve().parent
CV_HTML  = SITE_DIR / 'cv.html'


def inline_text(inlines, linebreak='\n'):
    out = []
    for el in inlines:
        t = el.get('t')
        if t == 'Str':
            out.append(el['c'])
        elif t == 'Space':
            out.append(' ')
        elif t in ('Strong', 'Emph', 'SmallCaps', 'Underline'):
            out.append(inline_text(el['c'], linebreak))
        elif t == 'SoftBreak':
            out.append(' ')
        elif t == 'LineBreak':
            out.append(linebreak)
    return ''.join(out)


def block_text(blocks):
    parts = [inline_text(b['c']) for b in blocks if b['t'] in ('Para', 'Plain')]
    return '\n'.join(parts)


def cell_text(cell):
    return block_text(cell[4]).strip()


def row_texts(row):
    return [cell_text(c) for c in row[1]]


def table_rows(table):
    _, _, _, thead, tbodies, _ = table
    rows = [row_texts(r) for r in thead[1]]
    for tbody in tbodies:
        _, _, headrows, bodyrows = tbody
        rows += [row_texts(r) for r in headrows]
        rows += [row_texts(r) for r in bodyrows]
    return rows


def esc(s):
    return (s or '').replace('&', '&amp;')


SECTION_MAP = [
    ('education',           'Education',               '<!-- Education -->',           '<!-- Research Interests -->', 'entry'),
    ('research interest',   'Research Interests',      '<!-- Research Interests -->',  '<!-- Working Papers -->',     'tags'),
    ('conference',          'Conferences & Workshops', '<!-- Conferences -->',          '<!-- Research Experience -->','conf'),
    ('research experience', 'Research Experience',     '<!-- Research Experience -->', '<!-- Awards -->',             'entry'),
    ('award',                'Awards & Scholarships',  '<!-- Awards -->',                '<!-- Academic Service -->',  'pairs'),
    ('scholarship',          'Awards & Scholarships',  '<!-- Awards -->',                '<!-- Academic Service -->',  'pairs'),
    ('service',              'Academic Service',       '<!-- Academic Service -->',      '<!-- Skills -->',            'flow'),
    ('skill',                'Skills & Methods',       '<!-- Skills -->',                 '<!-- Languages -->',        'flow'),
    ('method',               'Skills & Methods',       '<!-- Skills -->',                 '<!-- Languages -->',        'flow'),
    ('language',             'Languages',               '<!-- Languages -->',              '</main>',                   'lang'),
]


def match_section(heading):
    h = heading.lower()
    if 'working paper' in h:
        return None
    for key, target, a1, a2, typ in SECTION_MAP:
        if key in h:
            return target, a1, a2, typ
    return None


def group_entries(rows):
    entries, cur = [], []
    for r in rows:
        if all(not c.strip() for c in r):
            if cur:
                entries.append(cur)
                cur = []
            continue
        cur.append(r)
    if cur:
        entries.append(cur)
    return entries


def section_wrap(label, a1, inner):
    return (f'{a1}\n    <div class="cv-section">\n'
            f'      <div class="section-label">{esc(label)}</div>\n\n'
            f'{inner}\n    </div>')


def build_entry_block(label, a1, rows):
    parts = []
    for g in group_entries(rows):
        inst, loc = (g[0] + ['', ''])[:2] if g else ('', '')
        title, date = (g[1] + ['', ''])[:2] if len(g) > 1 else ('', '')
        extra = [r[0].strip() for r in g[2:] if r[0].strip()]
        meta = ' · '.join([m for m in [date.strip()] + extra if m])
        sub = ' · '.join([p for p in [inst.strip(), loc.strip()] if p])
        parts.append(
            '      <div class="cv-entry">\n'
            f'        <div class="cv-entry-title">{esc(title.strip())}</div>\n'
            f'        <div class="cv-entry-sub">{esc(sub)}</div>\n'
            f'        <div class="cv-entry-meta">{esc(meta)}</div>\n'
            '      </div>'
        )
    return section_wrap(label, a1, '\n'.join(parts))


CONF_RE = re.compile(r'^(.*?),\s*([^,()]+?)\s*(?:\(([^)]+)\))?$')


def build_conf_block(label, a1, rows):
    parts = []
    for r in rows:
        raw_name = (r[0] if len(r) > 0 else '').strip()
        date = (r[1] if len(r) > 1 else '').strip()
        m = CONF_RE.match(raw_name)
        if m:
            event, loc, role = m.group(1).strip(), m.group(2).strip(), (m.group(3) or '').strip()
        else:
            event, loc, role = raw_name, '', ''
        meta = esc(' · '.join(p for p in [loc, date, role] if p))
        name = esc(event)
        parts.append(f'      <div class="conf-row"><span class="conf-name">{name}</span><span class="conf-meta">{meta}</span></div>')
    return section_wrap(label, a1, '\n'.join(parts))


def build_pairs_block(label, a1, rows):
    items = []
    for r in rows:
        text = esc((r[0] if len(r) > 0 else '').strip())
        meta = esc((r[1] if len(r) > 1 else '').strip())
        items.append(f'        <li>{text} <span>{meta}</span></li>' if meta else f'        <li>{text}</li>')
    inner = '      <ul class="cv-list">\n' + '\n'.join(items) + '\n      </ul>'
    return section_wrap(label, a1, inner)


def li(text, meta=''):
    text = esc(text.strip())
    meta = esc(meta.strip())
    return f'        <li>{text} <span>{meta}</span></li>' if meta else f'        <li>{text}</li>'


def build_flow_block(label, a1, rows):
    segments = []
    for r in rows:
        for cell in r:
            for seg in cell.split('\n'):
                seg = seg.strip()
                if seg:
                    segments.append(seg)

    items = []
    i = 0
    while i < len(segments):
        seg = segments[i]
        if ':' in seg:
            lhs, rhs = seg.split(':', 1)
            items.append(li(lhs, rhs))
            i += 1
        elif i + 1 < len(segments):
            nxt = segments[i + 1]
            if ':' in nxt:
                _, rhs = nxt.split(':', 1)
                items.append(li(seg, rhs))
            else:
                items.append(li(seg, nxt))
            i += 2
        else:
            items.append(li(seg))
            i += 1

    inner = '      <ul class="cv-list">\n' + '\n'.join(items) + '\n      </ul>'
    return section_wrap(label, a1, inner)


def build_lang_block(label, a1, rows):
    text = ' '.join(c for r in rows for c in r)
    pairs = re.findall(r'([A-Za-z][A-Za-z &]*?)\s*\(([^)]*)\)', text)
    items = [f'        <li>{esc(n.strip())} <span>{esc(d.strip())}</span></li>' for n, d in pairs]
    inner = '      <ul class="cv-list">\n' + '\n'.join(items) + '\n      </ul>'
    return section_wrap(label, a1, inner)


def build_tags_block(label, a1, rows):
    text = ' '.join(c for r in rows for c in r)
    tags = [t.strip().title() for t in text.split(',') if t.strip()]
    inner = '      <div class="tags">\n' + '\n'.join(f'        <span class="tag">{esc(t)}</span>' for t in tags) + '\n      </div>'
    return section_wrap(label, a1, inner)


BUILDERS = {
    'entry': build_entry_block,
    'conf':  build_conf_block,
    'pairs': build_pairs_block,
    'flow':  build_flow_block,
    'lang':  build_lang_block,
    'tags':  build_tags_block,
}


def replace_section(html, a1, a2, block):
    s = html.find(a1)
    e = html.find(a2)
    if s < 0 or e < 0:
        return html
    line_start = html.rfind('\n', 0, e) + 1
    return html[:s] + block + '\n\n' + html[line_start:]


def remove_docx_button(html):
    return re.sub(r'\n\s*<a href="files/cv_yupeng_he\.docx".*?</a>', '', html, flags=re.S)


def main():
    if len(sys.argv) < 2:
        print('SKIPPED::usage: py cv_convert.py <docx-path>')
        sys.exit(1)

    docx_path = sys.argv[1]
    raw = subprocess.check_output(['pandoc', '-f', 'docx', '-t', 'json', docx_path])
    ast = json.loads(raw.decode('utf-8'))
    blocks = ast['blocks']

    html = CV_HTML.read_text(encoding='utf-8')
    matched, skipped = [], []

    i = 0
    while i < len(blocks):
        b = blocks[i]
        if b['t'] == 'Para':
            heading = inline_text(b['c']).strip()
            if heading.isupper() and i + 1 < len(blocks) and blocks[i + 1]['t'] == 'Table':
                rows = table_rows(blocks[i + 1]['c'])
                m = match_section(heading)
                if m:
                    target, a1, a2, typ = m
                    block = BUILDERS[typ](target, a1, rows)
                    html = replace_section(html, a1, a2, block)
                    matched.append(f'{heading} -> {target}')
                elif 'working paper' in heading.lower():
                    skipped.append(f'{heading} (managed by the Papers menu instead)')
                else:
                    skipped.append(f'{heading} (no matching cv.html section)')
                i += 2
                continue
        i += 1

    html = remove_docx_button(html)
    CV_HTML.write_text(html, encoding='utf-8')

    docx_in_repo = SITE_DIR / 'files' / 'cv_yupeng_he.docx'
    if docx_in_repo.exists():
        docx_in_repo.unlink()

    for m in matched:
        print(f'MAPPED::{m}')
    for s in skipped:
        print(f'SKIPPED::{s}')


if __name__ == '__main__':
    main()
