# ajian-adopt

## Apa yang dilakukan

Membawa proyek yang belum bisa dibaca ajian sampai ke titik ia bisa dibaca. Ia mensurvei **semua**
dokumen di repo — bukan cuma yang di `docs/` — mengelompokkan tiap berkas, menghitung apa yang
dibutuhkan ajian tapi tak dicakup siapa pun, lalu mengusulkan **pemetaan per dokumen**: apa yang
pindah, ke mana, dan apa yang tetap di tempat. Kamu menyetujuinya dokumen demi dokumen; ia
memindahkan hanya yang kamu setujui, meninggalkan penunjuk di tempat asal, dan **tak pernah
menghapus**. Ia juga memperbaiki tata letak ajian lama yang berkasnya kehilangan field yang
diharapkan skill sekarang. Garis finisnya tegas: `/ajian-map` jalan dan menghasilkan langkah
berikutnya yang nyata.

## Kapan dipakai

- **Kamu mewarisi proyek dengan dokumen sungguhan** — README panjang, PRD, `ARCHITECTURE.md`, wiki
  yang ikut di-commit, sisa Spec Kit atau framework lain — dan mau melanjutkannya dengan ajian.
- **Kamu sudah pernah pakai ajian, lalu memperbarui skill-nya, dan sekarang ada tahap yang menolak**
  karena field yang tak ada di berkasmu.
- **`ajian-map` bilang tak ada blueprint, padahal dokumennya jelas kelihatan.** Itu justru sinyal
  yang melahirkan skill ini.
- **Bukan** untuk proyek berkode tanpa dokumen. Tak ada yang perlu direkonsiliasi — itu
  `/ajian-blueprint` mode brownfield, yang memindai kode dan menulis fondasinya dari awal.

## Pertanyaan umum

- **Apakah README-ku akan ditulis ulang?** Hanya kalau kamu menyetujui perpindahan itu secara
  spesifik, dan hanya bagian yang memang milik tempat lain. Cara instal, lisensi, badge, dan etika
  kontribusi dikelompokkan sebagai *tetap di tempat* — memindahkannya ke blueprint justru
  memperburuk repo. Yang pindah selalu meninggalkan penunjuk ke mana ia pergi.
- **Kenapa tidak sekadar menautkan dokumen lamaku?** Karena itu menghasilkan persis masalah
  dua-sumber-kebenaran yang jadi alasan skill ini ada. Menautkan README yang visi, arsitektur, dan
  aturan kontribusinya tercampur berarti agent harus membaca seluruhnya untuk satu fakta — dan itu
  yang dicegah oleh charter tiap dokumen.
- **Bisa dibatalkan?** Bisa. Satu dokumen, satu commit, jadi pemetaan yang kamu sesali cuma sejauh
  satu `git revert`. Tak ada yang dihapus, jadi tak ada yang perlu disusun ulang.
- **Bagaimana ia tahu dokumenku ditulis ajian versi lama?** Ia tidak bertanya, dan tidak membaca cap
  versi — memang sengaja tak ada. Ia membaca **bentuk** tiap artefak terhadap katalog bentuk yang
  diharapkan skill sekarang. Cap versi hanya sebaik disiplin yang menaikkannya, dan cap basi lebih
  berbahaya daripada tak ada cap, karena pembacanya telanjur percaya.
- **Apakah ia menyusun roadmap?** Tidak. Ia mengoper ke `ajian-blueprint` mode resumed, yang memiliki
  roadmap beserta gerbang penentuan ukurannya. Daftar fitur yang disusun tanpa gerbang itu adalah
  sekumpulan baris yang tak pernah diukur siapa pun.
- **Bagaimana dengan daftar task atau plan warisan?** Tetap di tempat. *Apa* dari sebuah framework
  bisa diadopsi; *cara*-nya tidak. Work order warisan berstatus `Depth: detailed` adalah satu-satunya
  migrasi yang hampir pasti memperburuk proyek, karena semua tahap di hilir memercayai kedalaman itu.

## Tanda berhasil

Tiap dokumen di repo sudah diperhitungkan — dipindah, dipertahankan, atau secara eksplisit
ditinggalkan sebagai residu — tulisanmu yang lama selamat di tempat yang benar-benar akan dibuka
ajian, dan `/ajian-map` menyebut langkah berikutnya yang konkret alih-alih "belum ada blueprint".
