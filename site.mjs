#!/usr/bin/env node
import { readdirSync, readFileSync, statSync, mkdirSync, copyFileSync, writeFileSync, existsSync, rmSync } from "node:fs"
import { join, relative, basename } from "node:path"

const ROOT = join(import.meta.dirname)
const EXAM_DIR = ROOT
const OUT = join(ROOT, "site")
const ASSETS = "assets"
const DATA = "data"

// ---------- helpers ----------
const esc = (s) => String(s)
  .replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
  .replaceAll('"', "&quot;")

const mdInline = (s) => esc(s)
  .replace(/\*\*([^*]+)\*\*/g, "<b>$1</b>")
  .replace(/\*([^*]+)\*/g, "<i>$1</i>")
  .replace(/`([^`]+)`/g, "<code>$1</code>")

// find all exam folders: any dir containing exam.md (and exam.pdf)
function findExams(dir, acc = []) {
  if (dir === OUT || dir.startsWith(OUT + "/")) return acc
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry)
    if (!statSync(full).isDirectory()) continue
    if (full === OUT || full.startsWith(OUT + "/")) continue
    if (existsSync(join(full, "exam.md")) || existsSync(join(full, "exam.pdf"))) {
      acc.push(full)
    } else {
      findExams(full, acc)
    }
  }
  return acc
}

function parseMd(md) {
  const lines = md.split(/\r?\n/)
  let title = ""
  const sections = []
  let cur = { heading: "", qs: [] }
  let pending = null // {n, prompt:[], opts:[]}

  const pushQuestion = () => {
    if (!pending) return
    if (pending.opts.length) {
      cur.qs.push(pending)
    } else if (pending.n) {
      cur.qs.push(pending) // keep numbered items even without options (short answer)
    }
    pending = null
  }

  for (const raw of lines) {
    const line = raw.replace(/\s+$/, "")
    if (!line.trim()) { pushQuestion(); continue }

    if (/^#\s/.test(line)) {
      pushQuestion()
      title = line.replace(/^#\s+/, "").trim()
    } else if (/^##\s/.test(line)) {
      pushQuestion()
      sections.push(cur)
      cur = { heading: line.replace(/^##\s+/, "").trim(), qs: [] }
    } else {
      // ****N. or N. question start
      const m = line.match(/^\s*\*{0,2}\s*(\d+)\.\*{0,2}\s+(.*)$/)
      if (m && m[2].trim()) {
        pushQuestion()
        const opts = extractOptions(m[2])
        pending = { n: +m[1], prompt: opts ? opts.rest : m[2].trim(), opts: opts ? opts.opts : [] }
      } else if (pending) {
        // bullet-style options: - a) text
        const bullet = line.match(/^\s*[-*]\s*\(?([a-e])\)?\s+(.*)$/)
        if (bullet) {
          pending.opts.push({ label: bullet[1].toLowerCase(), text: bullet[2].trim() })
        } else {
          const opts = extractOptions(line)
          if (opts) {
            if (pending.prompt) pending.prompt += " " + opts.rest
            pending.opts.push(...opts.opts)
          } else {
            pending.prompt += " " + line.trim()
          }
        }
      } else {
        // standalone paragraph: reading passages etc.
        cur.qs.push({ n: null, prompt: line.trim(), opts: [] })
      }
    }
  }
  pushQuestion()
  sections.push(cur)
  if (!title) title = "Untitled exam"
  return { title, sections: sections.filter(s => s.heading || s.qs.length) }
}

function extractOptions(text) {
  const idx = text.search(/\(([a-d])\)\s*/)
  if (idx === -1) return null
  const rest = text.slice(0, idx).trim()
  const body = text.slice(idx)
  const opts = []
  const re = /\(([a-d])\)\s*([\s\S]*?)(?=\s*\(([a-e])\)\s*|$)/g
  let m
  const matches = []
  while ((m = re.exec(body))) matches.push({ l: m[1], t: m[2].trim() })
  if (matches.length < 2) return null
  for (const { l, t } of matches) opts.push({ label: l, text: t })
  return { rest, opts }
}

// parse the Q|Ans table from a key.md into {n: letter}
function parseKey(md) {
  const key = {}
  const rows = md.split(/\r?\n/).filter(l => /^\|/.test(l) && !/Q\s*\|\s*Ans/.test(l) && !/---\|/.test(l))
  for (const row of rows) {
    const cells = row.replace(/^\|/, "").replace(/\|$/, "").split("|").map(c => c.trim())
    for (let i = 0; i + 1 < cells.length; i += 2) {
      const n = +cells[i]
      const ans = cells[i + 1]?.toLowerCase()
      if (n && /^[a-e]$/.test(ans)) key[n] = ans
    }
  }
  return key
}

function findFile(dir, names) {
  for (const n of names) { const p = join(dir, n); if (existsSync(p)) return p }
  return null
}

// derive metadata from filesystem layout
function metaFor(examDir) {
  const rel = relative(EXAM_DIR, examDir).split(/\//)
  const name = basename(examDir)
  const gradeMatch = name.match(/G(\d+)/i)
  const unitMatch = name.match(/U(\d+)/i)
  const grade = gradeMatch ? "Grade " + gradeMatch[1] : (rel[0] === "11th" ? "Grade 11" : "—")
  const unit = unitMatch ? "Unit " + unitMatch[1] : null
  const subject = rel.length >= 2 ? rel[rel.length - 2] : ""
  const sourceKey = findFile(examDir, ["key.pdf", "answer key.pdf"])
  const sourceMd = findFile(examDir, ["exam.md"])
  const md = sourceMd ? readFileSync(sourceMd, "utf8") : ""
  const { title, sections } = parseMd(md)
  const qCount = sections.reduce((a, s) => a + s.qs.filter(q => q.n).length, 0)
  const sourceKeyMd = findFile(examDir, ["key.md"])
  const answers = sourceKeyMd ? parseKey(readFileSync(sourceKeyMd, "utf8")) : {}
  const depth = rel.length // page will live at OUT/<rel>/index.html
  return {
    slug: rel.join("-"),
    name, grade, unit, subject,
    rel, examDir, depth,
    up: "../".repeat(depth),           // relative path back to site root from the exam page
    url: rel.concat("index.html").join("/"),
    pdf: rel.concat("exam.pdf").join("/"),
    keyPdf: rel.concat("key.pdf").join("/"),
    title: title || name,
    qCount,
    answers,
    sections,
    hasPdf: findFile(examDir, ["exam.pdf"]),
    hasKey: sourceKey,
  }
}

// ---------- asset copy ----------
function copyAssets(exams, outDir) {
  for (const ex of exams) {
    const destDir = join(outDir, ...ex.rel)
    mkdirSync(destDir, { recursive: true })
    for (const [src, out] of [
      [ex.hasPdf, "exam.pdf"],
      [ex.hasKey, "key.pdf"],
    ]) {
      if (src) copyFileSync(src, join(destDir, out))
    }
  }
}

// ---------- CSS ----------
function css() {
  return `*{box-sizing:border-box}
body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;margin:0;background:#f7f7f5;color:#1a1a1a}
header{background:#1a1a1a;color:#fff;padding:14px 24px;display:flex;align-items:center;gap:16px;flex-wrap:wrap}
header a{color:#fff;text-decoration:none;font-weight:600}
header .spacer{flex:1}
main{max-width:960px;margin:0 auto;padding:24px}
.card{background:#fff;border:1px solid #ddd;border-radius:10px;padding:18px 20px;margin-bottom:16px}
.card h3{margin:0 0 6px;font-size:18px}
.tags{margin:8px 0 12px}
.tag{display:inline-block;background:#eee;border-radius:999px;padding:2px 10px;font-size:12px;margin-right:6px;color:#333}
.buttons{margin-top:10px}
.btn{display:inline-block;background:#1a1a1a;color:#fff;text-decoration:none;padding:7px 14px;border-radius:6px;font-size:14px;margin:0 8px 6px 0;border:none;cursor:pointer}
.btn.ghost{background:#eee;color:#1a1a1a}
.btn.outline{background:#fff;color:#1a1a1a;border:1px solid #999}
h1{font-size:22px}h2{font-size:18px;border-bottom:2px solid #1a1a1a;padding-bottom:4px;margin-top:28px}
.question{margin:14px 0;scroll-margin-top:12px}
.qprompt{font-weight:600}
.opt{display:block;margin:6px 0 6px 18px;padding:6px 10px;border-radius:6px}
.opt.sel{background:#eef2ff}
.ok{background:#dcfce7}.bad{background:#fee2e2}.show{background:#e0e7ff}
input[type=radio]{margin-right:8px}
footer{text-align:center;color:#888;font-size:12px;padding:20px}
table{border-collapse:collapse;width:100%}
th,td{border:1px solid #ccc;padding:4px 8px;text-align:center;font-size:13px}
.answers table{display:none}
.answers.visible table{display:table}
.answers button{margin-bottom:10px}
code{background:#eee;padding:1px 5px;border-radius:4px;font-size:13px}
.note{font-size:13px;color:#666}
.searchbox{font-size:15px;padding:8px 12px;border-radius:6px;border:1px solid #999;min-width:220px}
#hitcount{font-size:13px;color:#666;margin:6px 0 12px}
.result{background:#fff;border:1px solid #ddd;border-radius:10px;padding:12px 16px;margin-bottom:10px}
.result h4{margin:0 0 4px;font-size:15px}
.result .qlabel{font-weight:700;margin-right:6px}
mark{background:#ffe08a;padding:0 2px;border-radius:2px}
.flash{animation:flash 2s ease 1}
@keyframes flash{0%{background:#fff3bf}100%{background:transparent}}
.answerlink{font-size:12px;color:#555}
@media(max-width:600px){main{padding:14px}}
`
}

// ---------- shared JS ----------
function examJs() {
  return `window.ANSWERS = window.ANSWERS || {};
  window.__ROOT = document.querySelector('html').getAttribute('data-root') || './';
  const byQ = (n) => document.querySelector('.question[data-q="'+n+'"]');
  function checkAll(){
    let correct = 0, total = 0;
    for(const n in window.ANSWERS){
      total++;
      const el = byQ(n); if(!el) continue;
      const sel = el.querySelector('input:checked');
      el.querySelectorAll('.opt').forEach(x=>x.classList.remove('ok','bad','sel'));
      if(sel && sel.value === window.ANSWERS[n]){ el.querySelector('input[value="'+window.ANSWERS[n]+'"]').closest('.opt').classList.add('ok'); correct++; }
      else {
        if(sel) sel.closest('.opt').classList.add('bad');
        const good = el.querySelector('input[value="'+window.ANSWERS[n]+'"]');
        if(good){ good.closest('.opt').classList.add('ok'); good.disabled = false; }
      }
    }
    document.getElementById('score').textContent = 'Score: ' + correct + ' / ' + total;
  }
  function resetAll(){
    document.querySelectorAll('input[type=radio]').forEach(r=>r.checked=false);
    document.querySelectorAll('.opt').forEach(x=>x.classList.remove('ok','bad','sel'));
    document.getElementById('score').textContent='';
  }
  function toggleAnswers(){ document.querySelector('.answers').classList.toggle('visible'); }
  function selectHandler(e){
    const opt = e.target.closest('.opt');
    const q = opt && opt.closest('.question');
    if(q){ q.querySelectorAll('.opt').forEach(x=>x.classList.remove('sel')); if(opt) opt.classList.add('sel'); }
  }
  document.addEventListener('change', e=>{ if(e.target.type==='radio') selectHandler(e); });
  window.addEventListener('load', ()=>{
    if(location.hash.match(/^#q\\d+$/)){
      const el = byQ(location.hash.slice(1).replace('q',''));
      if(el){ el.scrollIntoView({block:'center'}); el.classList.add('flash'); }
    }
  });`
}

function searchJs() {
  return `(function(){
  const input = document.getElementById('q');
  const results = document.getElementById('results');
  const count = document.getElementById('hitcount');
  let data = null;
  const stopwords = new Set('the a an and or of to in on for with at by from is are was were be been this that these those it its as'.split(' '));
  const stem = (w) => w.replace(/(ing|ed|es|s)$/,'').toLowerCase();
  const tokens = (s) => (s.toLowerCase().match(/[a-z0-9]+/g)||[]).map(stem).filter(w=>w.length>1 && !stopwords.has(w));
  const load = () => fetch(dataRoot + 'data/search.json').then(r=>r.json()).then(j=>{data=j; go();});
  function scoreExam(ex, qt){
    let s = 0;
    const hay = (ex.title+' '+ex.subject+' '+ex.grade+' '+(ex.unit||'')).toLowerCase();
    for(const t of qt){ if(hay.includes(t)) s += 3; if(tokens(ex.title).includes(t)) s += 2; }
    return s;
  }
  function scoreQ(q, qt){
    let s = 0;
    const hay = (q.prompt+' '+q.opts.join(' ')).toLowerCase();
    for(const t of qt){ if(hay.includes(t)) s += 1; }
    if(tokens(q.prompt).some(t=>qt.includes(t))) s += 2;
    return s;
  }
  function hl(text, qt){
    let out = esc(text);
    for(const t of qt.slice().sort((a,b)=>b.length-a.length)){
      out = out.split(t).join('<mark>'+t+'</mark>');
      out = out.split(t[0].toUpperCase()+t.slice(1)).join('<mark>'+t[0].toUpperCase()+t.slice(1)+'</mark>');
    }
    return out;
  }
  const esc = (s)=>String(s).replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
  function go(){
    const qt = tokens(input.value);
    if(!qt.length){ results.innerHTML=''; count.textContent=''; return; }
    const exams = data.exams.map(ex=>({...ex, s: scoreExam(ex, qt)})).filter(x=>x.s>0).sort((a,b)=>b.s-a.s);
    const qs = data.questions.map(q=>({...q, s: scoreQ(q, qt)})).filter(x=>x.s>0).sort((a,b)=>b.s-a.s);
    let html = '';
    if(exams.length){
      html += '<h2>Exams</h2>';
      html += exams.slice(0,8).map(ex=>'<div class="result"><h4><a href="'+dataRoot+ex.url+'">'+hl(ex.title, qt)+'</a></h4><div class="tags">'+
        ['<span class="tag">'+ex.grade+'</span>','<span class="tag">'+esc(ex.subject)+'</span>',ex.unit?'<span class="tag">'+esc(ex.unit)+'</span>':'','<span class="tag">'+ex.qCount+' questions</span>'].join('')+
        '</div></div>').join('');
    }
    if(qs.length){
      html += '<h2>Questions</h2>';
      html += qs.slice(0,25).map(q=>'<div class="result"><h4><a href="'+dataRoot+q.url+'#q'+q.q+'">'+esc(q.examTitle)+'</a> <span class="answerlink">Q'+q.q+'</span></h4>'+
        '<div><span class="qlabel"></span>'+hl(q.prompt, qt)+'</div></div>').join('');
    }
    if(!exams.length && !qs.length) html = '<p>No results.</p>';
    results.innerHTML = html;
    count.textContent = (exams.length? exams.length+' exam(s), ':'') + qs.length + ' matching question(s)';
  }
  input.addEventListener('input', go);
  const q = new URLSearchParams(location.search).get('q');
  if(q){ input.value = q; }
  const dataRoot = document.querySelector('html').getAttribute('data-root') || './';
  load();
})();`
}

// ---------- HTML shells ----------
function pageShell(title, body, opts = {}) {
  const root = opts.root || "./"
  return `<!doctype html>
<html lang="en" data-root="${esc(root)}"><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<link rel="stylesheet" href="${root}${ASSETS}/style.css">
${opts.extraHead || ""}
</head><body>
<header>
  <a href="${root}index.html">Study Exams</a>
  <span class="spacer"></span>
  <input id="headq" class="searchbox" type="search" placeholder="Search exams & questions…" onkeydown="if(event.key==='Enter'){location='${root}search.html?q='+encodeURIComponent(this.value)}">
  <a class="btn ghost" href="${root}search.html">Search</a>
</header>
<main>
${body}
</main>
<footer>Ethiopian national-exam style practice papers · download the PDF, or answer inline and check yourself</footer>
${opts.extraFoot || ""}
</body></html>`
}

function examCard(ex) {
  const tags = [ex.grade, ex.subject, ex.unit].filter(Boolean).map(t => `<span class="tag">${esc(t)}</span>`).join("")
  return `<div class="card">
  <h3>${esc(ex.title)}</h3>
  <div class="tags">${tags}<span class="tag">${ex.qCount} questions</span></div>
  <p class="note">${esc(ex.name)}</p>
  <div class="buttons">
    ${ex.hasPdf ? `<a class="btn" href="${esc(ex.pdf)}" download>⬇ Download PDF</a>` : ""}
    ${ex.hasKey ? `<a class="btn ghost" href="${esc(ex.keyPdf)}" download>Answer key</a>` : ""}
    <a class="btn outline" href="${esc(ex.url)}">Take it online</a>
  </div>
</div>`
}

function examPage(ex) {
  const spread = []
  const used = new Set()
  for (const n of Object.keys(ex.answers)) used.add(+n)
  const sorted = [...used].sort((a, b) => a - b)
  for (const n of sorted) spread.push(`'${n}': '${ex.answers[n]}',`)

  let body = `<h1>${esc(ex.title)}</h1>`
  body += `<p class="note">${esc(ex.grade)} · ${esc(ex.subject)}${ex.unit ? " · " + esc(ex.unit) : ""} · ${ex.qCount} questions</p>`
  body += `<div class="buttons">`
  if (ex.hasPdf) body += `<a class="btn" href="exam.pdf">⬇ Download PDF</a>`
  if (ex.hasKey) body += `<a class="btn ghost" href="key.pdf">Answer key PDF</a>`
  body += `<button class="btn" onclick="checkAll()">Check my answers</button>
  <button class="btn outline" onclick="resetAll()">Clear</button></div>
  <div id="score" class="note" style="margin:10px 0;font-weight:bold"></div>`

  for (const sec of ex.sections) {
    if (sec.heading) body += `<h2>${esc(sec.heading)}</h2>`
    for (const q of sec.qs) {
      if (q.n === null) { body += `<p>${mdInline(q.prompt)}</p>`; continue }
      body += `<div class="question" id="q${q.n}" data-q="${q.n}">
        <div class="qprompt">${q.n}. ${mdInline(q.prompt)}</div>
        <div class="opts">`
      for (const o of q.opts) {
        body += `<label class="opt"><input type="radio" name="q${q.n}" value="${o.label}"> (${o.label}) ${mdInline(o.text)}</label>`
      }
      body += `</div></div>`
    }
  }

  body += `<h2>Answers</h2>
  <div class="answers"><button class="btn outline" onclick="toggleAnswers()">Show / hide answers</button><div>
  <table><tr><th>Q</th><th>Ans</th><th>Q</th><th>Ans</th><th>Q</th><th>Ans</th></tr>
  ${(() => { let r = ""; const arr = sorted; for (let i = 0; i < arr.length; i += 3) { r += "<tr>" + [0,1,2].map(k => { const n = arr[i+k]; return n ? `<td>${n}</td><td>${esc(ex.answers[n].toUpperCase())}</td>` : "<td></td><td></td>" }).join("") + "</tr>" } return r })()}
  </table></div></div>`

  const root = ex.up
  return pageShell(ex.title, body, {
    root,
    extraFoot: `<script>window.ANSWERS = {\n${spread.join("\n")}\n};</script>
<script src="${root}${ASSETS}/exam.js"></script>`,
  })
}

function indexPage(exams) {
  const byGrade = {}
  for (const ex of exams) { ;(byGrade[ex.grade] ||= []).push(ex) }
  const grades = Object.keys(byGrade).sort().reverse()
  let body = `<h1>Study Exams</h1>
  <p class="note">Ethiopian national-exam style practice papers. Download the PDF, or answer inline and check yourself.</p>`
  for (const g of grades) {
    const bySubj = {}
    for (const ex of byGrade[g]) (bySubj[ex.subject] ||= []).push(ex)
    const subs = Object.keys(bySubj).sort()
    body += `<h2>${esc(g)}</h2>`
    for (const s of subs) {
      body += `<h3 style="margin:14px 0 4px;color:#444">${esc(s || "General")}</h3>`
      for (const ex of bySubj[s]) body += examCard(ex)
    }
  }
  body += `<h2>Add an exam</h2><p class="note">Drop a folder containing <code>exam.pdf</code> (and <code>key.pdf</code>, <code>exam.md</code>) into <code>exams/</code> and re-run: <code>node site.mjs</code>, then redeploy.</p>`
  return pageShell("Study Exams", body)
}

function searchPage() {
  let body = `<h1>Search</h1>
  <input id="q" class="searchbox" type="search" placeholder="e.g. inverse function, drought, photosynthesis…" style="width:100%;max-width:520px;font-size:16px;padding:10px 14px">
  <div id="hitcount"></div>
  <div id="results"></div>`
  return pageShell("Search — Study Exams", body, {
    extraFoot: `<script src="./${ASSETS}/search.js"></script>`,
  })
}

function searchData(exams) {
  const exList = exams.map(ex => ({
    slug: ex.slug, title: ex.title, subject: ex.subject, grade: ex.grade,
    unit: ex.unit, url: ex.url, qCount: ex.qCount,
  }))
  const questions = []
  for (const ex of exams) {
    for (const sec of ex.sections) {
      for (const q of sec.qs) {
        if (q.n === null) continue
        questions.push({
          q: q.n, exam: ex.slug, examTitle: ex.title,
          section: sec.heading, prompt: q.prompt,
          opts: q.opts.map(o => o.text), url: ex.url,
        })
      }
    }
  }
  return JSON.stringify({ meta: { generated: new Date().toISOString(), totalExams: exams.length, totalQuestions: questions.length }, exams: exList, questions })
}

function readme() {
  return `# Study Exams site

Static practice-exam site generated from the \`exams/\` folders.

## Add a new exam
1. Create a folder under \`exams/\${GRADE}/\${SUBJECT}/…/\` containing at least \`exam.pdf\`.
2. Optionally add \`key.pdf\` and \`exam.md\` + \`key.md\` (markdown mirrors are used for the online "take it" pages and auto-checking).
3. Regenerate: \`node site.mjs\`
4. Deploy: \`./deploy.sh\`

## Search
Search works client-side against \`data/search.json\` (generated from question text).

## Non-interactive exams
If a question has no (a)(b)(c)(d) options on the same/next line it is rendered as a plain paragraph (reading passages).

## Requirements
Node.js ≥ 18. No dependencies.
`
}

// ---------- main ----------
console.log("Scanning", EXAM_DIR)
const examDirs = findExams(EXAM_DIR)
if (!examDirs.length) { console.error("No exams found under", EXAM_DIR); process.exit(1) }
const exams = examDirs.map(metaFor).sort((a, b) => a.grade.localeCompare(b.grade) || a.subject.localeCompare(b.subject))

rmSync(OUT, { recursive: true, force: true })
mkdirSync(join(OUT, ASSETS), { recursive: true })
mkdirSync(join(OUT, DATA), { recursive: true })

copyAssets(exams, OUT)
writeFileSync(join(OUT, ASSETS, "style.css"), css())
writeFileSync(join(OUT, ASSETS, "exam.js"), examJs())
writeFileSync(join(OUT, ASSETS, "search.js"), searchJs())
writeFileSync(join(OUT, DATA, "search.json"), searchData(exams))
writeFileSync(join(OUT, "index.html"), indexPage(exams))
writeFileSync(join(OUT, "search.html"), searchPage())
for (const ex of exams) {
  mkdirSync(join(OUT, ...ex.rel), { recursive: true })
  writeFileSync(join(OUT, ...ex.rel, "index.html"), examPage(ex))
}
writeFileSync(join(OUT, "README.md"), readme())

console.log(`Built ${OUT} — ${exams.length} exams, ${exams.reduce((a, e) => a + e.qCount, 0)} questions.`)