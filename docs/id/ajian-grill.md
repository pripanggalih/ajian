# ajian-grill

## Apa yang dilakukan

Membawa satu work order dari `Depth: brief` ke `Depth: detailed`, melawan kode yang benar-benar ada.
Ia menjalankan **grill-2** — interogasi mikro: mengirim subagent untuk recon kode nyata lalu langsung
mulai bertanya tanpa menunggunya, menjawab sebagian besar pertanyaan terbuka brief dari temuan recon,
dan menyodorkan padamu hanya keputusan yang benar-benar keputusan (masing-masing dengan rekomendasi). Ia mengisi flow, edge case, kontrak, dan efek data — lebih dalam
soal *apa yang harus benar*, tak pernah soal *cara*. Untuk fitur UI, ia juga mengumpulkan design brief
permukaan (mode, state kunci, batasan) untuk `ajian-design`.

## Kapan dipakai

- Tepat sebelum membangun sebuah baris roadmap, begitu dependensinya sudah dikirim.
- Kapan pun `ajian-map` bilang work order sekarang masih `brief`.

## Pertanyaan umum

- **Kenapa grill lagi setelah blueprint?** Blueprint memutuskan bentuk proyek melawan masa depan yang
  dibayangkan; grill-2 memutuskan bentuk persis fitur ini melawan kode nyata yang sudah dikirim. Detail
  yang ditulis melawan kode nyata itu benar; detail yang ditulis mendahuluinya harus dilupakan lagi.
- **Apakah ia akan cerewet?** Sebuah pertanyaan sampai padamu hanya kalau work order mencatatnya
  sebagai terbuka, atau recon menemukan dua hal yang sudah dikirim saling bertentangan. Sisanya ia
  jawab sendiri dan ditunjukkan di gate pada bagian `Resolved`, tempat kau bisa membatalkannya dengan
  satu kata.
- **Kenapa ia mulai bertanya sebelum recon selesai?** Recon berjalan di bawah ronde. Hanya pertanyaan
  yang bergantung pada temuannya yang menunggu; sisanya langsung keluar.
- **Apakah ia merencanakan atau menulis kode?** Tidak — ia berhenti di work order detailed. Berikutnya `ajian-plan`.
- **Dua work order detailed sekaligus?** Ia menolak; hanya satu detailed sekali waktu, memang begitu rancangannya.

## Tanda berhasil

Work order yang dinaikkan punya flow konkret dan pertanyaan terjawab yang berpijak pada path dan tipe
nyata, user hanya ditanyai satu ronde pendek lagi tajam, dan apa pun yang berskala proyek yang berubah
menjadi ADR baru.
