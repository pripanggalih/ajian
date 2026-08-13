# ajian-blueprint

## Apa yang dilakukan

Mengubah ide bebas menjadi **blueprint** yang tahan lama: dokumen fondasi (`PRD`, `ARCHITECTURE`,
`CONVENTIONS`, `QUALITY`, dan secara kondisional `DATA-MODEL`, `DESIGN-SYSTEM`, `GLOSSARY`), sebuah
`ROADMAP` berurutan, dan satu work order per baris roadmap. Ia menjalankan **grill-1** — interogasi
makro, di atas mesin frontier/rounds yang direl enam tema, dibatasi satu tema sekali waktu, dengan
rekomendasi di tiap pertanyaan. Ia menulis apa yang harus benar, bukan cara membangunnya.

## Kapan dipakai

- Di **awal** build, greenfield maupun brownfield — ia memegang seluruh percakapan desain.
- Di **akhir** diskusi desain — ia menyuling apa yang sudah kamu putuskan dan menginterogasi celahnya.
- Di mode **resumed**, saat `ROADMAP.md` sudah ada dan kamu ingin memperluas atau menyelaraskannya
  dengan kode yang sudah dikirim.
- **Di tengah proyek, untuk menyisipkan atau mengubah fitur.** Ini juga mode resumed, dan inilah
  satu-satunya tempat roadmap yang sudah dibangun boleh diubah — roadmap punya satu pemilik.

## Pertanyaan umum

- **Apakah ia menulis kode atau plan?** Tidak. Ia berhenti di blueprint. `ajian-plan` yang memegang *cara*.
- **Stack greenfield?** Ia mengusulkan 2–3 opsi masuk akal beserta tradeoff dan membiarkanmu memilih;
  baris roadmap #1 adalah walking skeleton. Brownfield: ia memindai repo dan mencatat stack apa adanya.
- **Kenapa banyak interogasi di depan?** Pertanyaan yang dilewati di sini jadi asumsi yang diwarisi tiap
  work order berikutnya. Dua gerbang (fondasi, roadmap) adalah hentian keras yang menunggumu.
- **Penentuan ukuran roadmap?** Gerbang 2 adalah mini-interogasi: tiap baris harus lolos ukuran (satu
  sesi build), irisan (vertikal, bisa didemokan), dan urutan (dependensi, risiko, teringan dulu).
- **Aku mau menambah fitur di tengah jalan — apa yang terjadi?** Jalankan mode resumed. Fitur baru
  melewati tiga uji ukuran yang sama seperti baris Gerbang 2 mana pun, lalu mengambil **nomor bebas
  berikutnya** dan duduk di **baris** tempat ia harus dibangun — jadi bisa saja ia bernomor 09 dan
  berada di antara baris 2 dan 3. Itu memang benar: nomor adalah nama permanen, dan menggeser nomor
  akan memutus setiap `plans/NN-*`, laporan, rujukan ADR, dan pesan commit yang memakai nomor lama.
- **Bagaimana dengan rencana lama yang bertabrakan dengan fitur baru itu?** Ia memeriksanya. Work
  order yang sudah merged dan tersentuh akan disebutkan supaya cakupan baru memperhitungkannya; work
  order yang belum dibangun dan tumpang tindih akan ditandai `superseded by NN` atau dipersempit —
  **kamu yang memilih per tumpang tindih**, karena letak garisnya adalah penilaian produk. Tidak ada
  yang dihapus; work order yang disupersede mungkin sudah punya plan, laporan, atau commit. Keputusan
  di `DECISIONS.md` yang jadi salah mendapat ADR pengganti, bukan diedit diam-diam.

## Tanda berhasil

Agen cakap yang tak pernah melihat percakapanmu bisa membuka `docs/INDEX.md` dan mulai work order #1
tanpa bertanya — dan tak ada placeholder, hanya ADR terbuka di tempat yang memang belum diputuskan.
