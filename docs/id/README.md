# Ajian — panduan pemakaian (Bahasa Indonesia)

**[English →](../en/README.md)**

Ajian adalah delapan skill yang membawa proyek dari ide liar sampai kode terkirim, satu work-order demi
work-order, dengan gerbang manusia di tiap keputusan yang mahal untuk dibatalkan. Panduan ini petanya;
tiap skill punya halaman sendiri di bawah.

## Memulai

1. Instal skillset (lihat [README](../../README.md) utama). `ajian-design` juga butuh
   `npx impeccable install`.
2. Buka proyekmu (kosong untuk greenfield, atau repo yang sudah ada untuk brownfield) di agen coding-mu.
3. **Mewarisi proyek yang sudah punya dokumen?** Jalankan **`/ajian-adopt`** dulu. Ia mensurvei apa
   yang sudah tertulis, mengusulkan ke mana tiap dokumen sebaiknya pindah, dan memindahkan hanya
   yang kamu setujui — jadi ajian membangun di atas dokumenmu, bukan menulis tandingannya di sebelah.
4. Jalankan **`/ajian-blueprint`** — atau mulai saja bicarakan idenya lalu panggil saat siap. Ia
   menginterogasi ide dan menulis dokumen fondasi serta roadmap.
5. Setelah itu, ikuti breadcrumb `→ Next` tiap skill. Bingung? Jalankan **`/ajian-map`**.

**Kamu tak harus tahu urutannya.** Menjalankan skill terlalu awal tidak membuatmu mentok, dan juga
tidak membuatnya diam-diam mengerjakan yang kurang. Ia memeriksa berkas nyata di proyekmu,
memberitahu posisimu dengan bahasa manusia, menyebut satu skill yang mengisi celahnya, lalu bertanya
apakah dijalankan. Selalu satu langkah — tak pernah "sekalian empat berikutnya?", karena itu menukar
seluruh pipeline dengan satu kata ya.

## Alur pipeline

```
(ajian-adopt, hanya bila proyek sudah punya dokumen berbentuk lain)
  →  ajian-blueprint  →  per baris roadmap, dari atas ke bawah:
                           ajian-grill  →  (ajian-design, jika UI)  →  ajian-plan  →  ajian-build  →  ajian-review
                         →  baris berikutnya
```

- **ajian-adopt** jalan paling banyak sekali, pada proyek warisan. Lewati untuk proyek baru.
- **ajian-blueprint** jalan sekali di awal (dan lagi di mode "resumed" untuk memperluas roadmap atau
  menyisipkan fitur di tengah jalan).
- Urutan build adalah **urutan baris** di `ROADMAP.md`. Angka di kolom `#` adalah nama permanen tiap
  work order, jadi setelah ada penyisipan ia bisa tak berurutan — itu memang diharapkan.
- Lima skill per-baris berulang untuk tiap baris roadmap, dari atas ke bawah.
- **ajian-map** tidak di dalam baris — jalankan kapan saja untuk menemukan posisimu.

## Gerbang keputusan (tempat kamu memutuskan)

Ajian tak pernah mengambil keputusan mahal-dibatalkan untukmu. Tiap perhentian ditulis dalam bentuk
yang sama, sehingga gerbang yang dilewati kelihatan justru karena bloknya hilang:

```
GATE — <nama gerbang>
Done:     <apa yang benar-benar sudah dikerjakan agent>
Evidence: <output perintah nyata, atau path berkas yang sudah di-commit — bukan "kelihatannya beres">
Decide:   <pertanyaan yang kamu jawab>
Risk:     <apa yang rusak kalau ini salah dan ia jalan terus>
```

`Risk` adalah baris yang ditulis khusus untukmu. Kalau kamu tak bisa membaca kodenya, baris itulah
yang membuatmu tetap bisa memutuskan dengan baik — ia menyebut ongkos kalau keputusannya salah.
Kalau sebuah gerbang datang tanpa `Evidence`, agent sedang memintamu percaya pada kesannya; minta
ia menunjukkan buktinya.

Ia berhenti dan menunggu di:

- **Fondasi** — setelah dokumen ditulis, sebelum roadmap (di `ajian-blueprint`).
- **Roadmap** — mini-interogasi penentuan ukuran, sebelum work order ada (di `ajian-blueprint`).
- **Work order** — setelah grill-2 menaikkannya ke detailed (di `ajian-grill`).
- **Arah desain** — gerbang arah milik impeccable (di `ajian-design`).
- **Plan** — setelah rencana ditulis, sebelum ada kode (di `ajian-plan`).
- **Review & merge** — setelah review 2-sumbu, sebelum integrasi (di `ajian-review`).

## Yang berakhir di proyekmu

Tak ada merek "ajian". Skill menulis artefak generik yang ditemukan agen sendiri:

```
PRODUCT.md  DESIGN.md          (root, dimiliki impeccable)
docs/
  INDEX.md  PRD.md  ARCHITECTURE.md  CONVENTIONS.md  QUALITY.md  ROADMAP.md
  GLOSSARY.md  DATA-MODEL.md  DESIGN-SYSTEM.md
  DECISIONS.md  decisions/NNNN-*.md
  work-orders/NN-*.md
  plans/NN-<slug>.md            (masuk git; checkbox-nya adalah ledger build)
  plans/reports/NN-<slug>.md    (satu laporan build per plan — bukti verifikasi dari executor)
```

## Halaman per-skill

| Skill | Halaman |
| --- | --- |
| `ajian-map` | [ajian-map.md](ajian-map.md) |
| `ajian-adopt` | [ajian-adopt.md](ajian-adopt.md) |
| `ajian-blueprint` | [ajian-blueprint.md](ajian-blueprint.md) |
| `ajian-grill` | [ajian-grill.md](ajian-grill.md) |
| `ajian-design` | [ajian-design.md](ajian-design.md) |
| `ajian-plan` | [ajian-plan.md](ajian-plan.md) |
| `ajian-build` | [ajian-build.md](ajian-build.md) |
| `ajian-review` | [ajian-review.md](ajian-review.md) |

## Referensi desain & atribusi

Alasan desain lengkap ada di [`docs/ajian-blueprint.md`](../ajian-blueprint.md) (bahasa Inggris).
Atribusi jujur atas empat sumber upstream ada di [`NOTICE.md`](../../NOTICE.md).
