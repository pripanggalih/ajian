# Ajian — panduan pemakaian (Bahasa Indonesia)

**[English →](../en/README.md)**

Ajian adalah tujuh skill yang membawa proyek dari ide liar sampai kode terkirim, satu work-order demi
work-order, dengan gerbang manusia di tiap keputusan yang mahal untuk dibatalkan. Panduan ini petanya;
tiap skill punya halaman sendiri di bawah.

## Memulai

1. Instal skillset (lihat [README](../../README.md) utama). `ajian-design` juga butuh
   `npx impeccable install`.
2. Buka proyekmu (kosong untuk greenfield, atau repo yang sudah ada untuk brownfield) di agen coding-mu.
3. Jalankan **`/ajian-blueprint`** — atau mulai saja bicarakan idenya lalu panggil saat siap. Ia
   menginterogasi ide dan menulis dokumen fondasi serta roadmap.
4. Setelah itu, ikuti breadcrumb `→ Next` tiap skill. Bingung? Jalankan **`/ajian-map`**.

## Alur pipeline

```
ajian-blueprint  →  per baris roadmap, berurutan:
                      ajian-grill  →  (ajian-design, jika UI)  →  ajian-plan  →  ajian-build  →  ajian-review
                    →  baris berikutnya
```

- **ajian-blueprint** jalan sekali di awal (dan lagi di mode "resumed" untuk memperluas roadmap).
- Lima skill per-baris berulang untuk tiap baris roadmap, dari atas ke bawah.
- **ajian-map** tidak di dalam baris — jalankan kapan saja untuk menemukan posisimu.

## Gerbang keputusan (tempat kamu memutuskan)

Ajian tak pernah mengambil keputusan mahal-dibatalkan untukmu. Ia berhenti dan menunggu di:

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
| `ajian-blueprint` | [ajian-blueprint.md](ajian-blueprint.md) |
| `ajian-grill` | [ajian-grill.md](ajian-grill.md) |
| `ajian-design` | [ajian-design.md](ajian-design.md) |
| `ajian-plan` | [ajian-plan.md](ajian-plan.md) |
| `ajian-build` | [ajian-build.md](ajian-build.md) |
| `ajian-review` | [ajian-review.md](ajian-review.md) |

## Referensi desain & atribusi

Alasan desain lengkap ada di [`docs/ajian-blueprint.md`](../ajian-blueprint.md) (bahasa Inggris).
Atribusi jujur atas empat sumber upstream ada di [`NOTICE.md`](../../NOTICE.md).
