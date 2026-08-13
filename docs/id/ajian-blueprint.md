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

## Pertanyaan umum

- **Apakah ia menulis kode atau plan?** Tidak. Ia berhenti di blueprint. `ajian-plan` yang memegang *cara*.
- **Stack greenfield?** Ia mengusulkan 2–3 opsi masuk akal beserta tradeoff dan membiarkanmu memilih;
  baris roadmap #1 adalah walking skeleton. Brownfield: ia memindai repo dan mencatat stack apa adanya.
- **Kenapa banyak interogasi di depan?** Pertanyaan yang dilewati di sini jadi asumsi yang diwarisi tiap
  work order berikutnya. Dua gerbang (fondasi, roadmap) adalah hentian keras yang menunggumu.
- **Penentuan ukuran roadmap?** Gerbang 2 adalah mini-interogasi: tiap baris harus lolos ukuran (satu
  sesi build), irisan (vertikal, bisa didemokan), dan urutan (dependensi, risiko, teringan dulu).

## Tanda berhasil

Agen cakap yang tak pernah melihat percakapanmu bisa membuka `docs/INDEX.md` dan mulai work order #1
tanpa bertanya — dan tak ada placeholder, hanya ADR terbuka di tempat yang memang belum diputuskan.
