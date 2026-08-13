# ajian-grill

## Apa yang dilakukan

Membawa satu work order dari `Depth: brief` ke `Depth: detailed`, melawan kode yang benar-benar ada.
Ia menjalankan **grill-2** — interogasi mikro: mengirim subagent untuk recon kode nyata, menjawab
sebagian besar pertanyaan terbuka brief dari temuannya, dan menanyaimu hanya keputusan yang benar-benar
(masing-masing dengan rekomendasi). Ia mengisi flow, edge case, kontrak, dan efek data — lebih dalam
soal *apa yang harus benar*, tak pernah soal *cara*. Untuk fitur UI, ia juga mengumpulkan design brief
permukaan (mode, state kunci, batasan) untuk `ajian-design`.

## Kapan dipakai

- Tepat sebelum membangun sebuah baris roadmap, begitu dependensinya sudah dikirim.
- Kapan pun `ajian-map` bilang work order sekarang masih `brief`.

## Pertanyaan umum

- **Kenapa grill lagi setelah blueprint?** Blueprint memutuskan bentuk proyek melawan masa depan yang
  dibayangkan; grill-2 memutuskan bentuk persis fitur ini melawan kode nyata yang sudah dikirim. Detail
  yang ditulis melawan kode nyata itu benar; detail yang ditulis mendahuluinya harus dilupakan lagi.
- **Apakah ia akan cerewet?** Hanya untuk keputusan yang dua jawaban validnya mengubah apa yang dibangun.
  Apa pun yang sudah dijawab kode dicatat sebagai fakta, bukan ditanyakan.
- **Apakah ia merencanakan atau menulis kode?** Tidak — ia berhenti di work order detailed. Berikutnya `ajian-plan`.
- **Dua work order detailed sekaligus?** Ia menolak; hanya satu detailed sekali waktu, memang begitu rancangannya.

## Tanda berhasil

Work order yang dinaikkan punya flow konkret dan pertanyaan terjawab yang berpijak pada path dan tipe
nyata, user hanya ditanyai satu ronde pendek lagi tajam, dan apa pun yang berskala proyek yang berubah
menjadi ADR baru.
