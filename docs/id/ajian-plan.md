# ajian-plan

## Apa yang dilakukan

Mengubah satu work order detailed menjadi **rencana implementasi** kecil-kecil — sang *cara*. Ia
membaca work order dan dokumen blueprint yang disebut anchor-nya, lalu menulis task dengan file persis,
antarmuka (Consumes/Produces), dan langkah berpola TDD (tulis test gagal, tonton gagal, kode minimal,
tonton lulus, commit). Rencana disimpan ke `docs/plans/NN-<slug>.md` dan **masuk git** — checkbox
`- [ ]`-nya menjadi ledger yang dicentang `ajian-build` seiring jalan.

## Kapan dipakai

- Setelah sebuah work order `detailed` (dan, jika ada UI, setelah `ajian-design`).
- Kapan pun `ajian-map` bilang baris sekarang belum punya plan.

## Pertanyaan umum

- **Bukankah ini yang sudah dikatakan work order?** Tidak — work order memegang *apa yang harus benar*;
  plan memegang *cara*, dalam langkah setingkat kode. Dua lapisan, tanpa tumpang tindih.
- **Plan-ku sering kebesaran dan model berhenti di tengah.** ajian-plan punya pengaman ukuran: jika plan
  melebihi ~selusin task atau terlalu panjang untuk satu konteks, berarti **work order (atau baris
  roadmap-nya) salah ukur** — ia berhenti dan mengembalikannya ke `ajian-grill` / roadmap untuk dipecah,
  ketimbang menulis plan raksasa yang gagal di tengah jalan.
- **UI-nya sudah terbangun — aku merencanakan apa?** Pada work order UI, `ajian-design` sudah
  meninggalkan layar sungguhan di pohon kerja. Plan membaca inventaris `## Built surface` di work
  order lalu merencanakan *penyambungannya* — data, state, routing, test — dibuka dengan blok
  `## Existing surface` yang memberitahu executor file mana yang tidak boleh dibuat ulang.
  Menspesifikasi ulang kualitas visual di luar batas; kalau surface-nya salah, itu urusan
  `/ajian-design NN`.
- **Tanpa placeholder?** Betul — tiap langkah memuat isi sebenarnya; "tambahkan penanganan error" atau
  "mirip Task N" adalah kegagalan plan.

## Tanda berhasil

Tiap kebutuhan spec terpetakan ke sebuah task, tipe dan signature konsisten antar-task, tak ada
placeholder, dan plan yang di-commit cukup kecil untuk satu sesi build.
