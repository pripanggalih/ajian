# Ajian

> **Status: desain terkunci, skill sudah diimplementasi, privat sampai atribusi diselesaikan.**
> Bahasa Inggris adalah sumber kebenaran. **[English →](README.md)**

`ajian` (Jawa: mantra kesaktian — tiap skill adalah satu *ajian*) adalah skillset untuk agen coding
AI yang mengubah ide bebas menjadi dokumen pengembangan yang tahan lama, lalu membangun proyek satu
work-order demi work-order lewat rangkaian skill yang eksplisit dan bergerbang. **Tanpa session
hook.** Greenfield maupun brownfield. Bebas framework dan harness.

Ia berdiri di atas empat proyek hebat, yang teksnya ia vendor dan sesuaikan (atau, untuk impeccable,
ia bergantung padanya). Atribusi lengkap dan jujur ada di [`NOTICE.md`](NOTICE.md):

- **discussion-to-blueprint** — dokumen fondasi, roadmap, dan work order
- **[obra/superpowers](https://github.com/obra/superpowers)** (MIT) — perencanaan & eksekusi
- **[mattpocock/skills](https://github.com/mattpocock/skills)** (MIT) — mesin grilling, review 2-sumbu, router
- **[impeccable](https://github.com/pbakaus/impeccable)** (Apache-2.0) — kualitas UI/UX

## Alurnya

```
ide
  → ajian-blueprint         grill ide (grill-1), tulis dokumen fondasi + roadmap
  → per baris roadmap, berurutan:
      ajian-grill           recon kode nyata (grill-2), tajamkan work order sampai siap dibangun
      ajian-design          (khusus UI) serahkan permukaan ke impeccable → DESIGN.md
      ajian-plan            ubah work order jadi rencana implementasi kecil-kecil
      ajian-build           jalankan seluruh rencana di satu subagent, commit per task, ledger = checkbox
      ajian-review          review 2-sumbu, lalu selesaikan branch
  → baris berikutnya
```

`ajian-map` adalah router sadar-keadaan: jalankan kapan saja untuk tahu posisimu dan langkah
berikutnya.

## Daftar skill

| Skill | Peran |
| --- | --- |
| `ajian-map` | router sadar-keadaan — membaca proyek, menyebut posisimu dan skill berikutnya |
| `ajian-blueprint` | interogasi ide, tulis dokumen fondasi + roadmap + work-order |
| `ajian-grill` | recon kode nyata sebelum work-order, tajamkan dari brief ke siap-bangun |
| `ajian-design` | turunkan PRODUCT.md dari blueprint, panggil impeccable untuk membangun UI |
| `ajian-plan` | ubah work-order jadi rencana implementasi kecil-kecil (checkbox = ledger) |
| `ajian-build` | eksekusi rencana di satu subagent segar, commit per task, review disimpan ke akhir |
| `ajian-review` | review kode 2-sumbu (Standards + Spec), lalu selesaikan dan merge branch |

Halaman per-skill (Apa yang dilakukan / Kapan dipakai / Pertanyaan umum / Tanda berhasil) ada di
[`docs/id/`](docs/id/). Desain lengkap yang terkunci ada di
[`docs/ajian-blueprint.md`](docs/ajian-blueprint.md) (bahasa Inggris).

## Instalasi

Setelah repositori dipublikkan, instal dari direktori [skills.sh](https://www.skills.sh) memakai CLI
[vercel-labs `skills`](https://www.skills.sh):

```bash
npx skills add pripanggalih/ajian
```

Instal satu skill saja, perbarui, atau hapus:

```bash
npx skills add pripanggalih/ajian --skill ajian-build
npx skills update
npx skills remove ajian-build
```

`ajian-design` butuh impeccable, diinstal terpisah:

```bash
npx impeccable install
```

## Yang tidak dilakukan ajian

- Tanpa session hook. Perangkaian eksplisit, lewat breadcrumb `→ Next` tiap skill dan `ajian-map`.
- Tanpa merek "ajian" di proyek kerjamu. Ia menulis `docs/`, `PRODUCT.md`, `DESIGN.md` yang generik.
- Tanpa review kode per-task. Review dijalankan sekali, di akhir tiap work-order.

## Lisensi & atribusi

MIT ([`LICENSE`](LICENSE)) untuk perkabelan milik ajian sendiri; teks upstream yang divendor
mempertahankan notis masing-masing di [`NOTICE.md`](NOTICE.md). Sumber `discussion-to-blueprint`
tidak memuat metadata lisensi; repositori tetap privat sampai itu diselesaikan (lihat `NOTICE.md`).
