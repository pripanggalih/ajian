# ajian-map

## Apa yang dilakukan

Membaca artefak proyekmu — adakah blueprint? baris roadmap mana yang sedang berjalan? `Depth` work
order-nya apa? adakah plan, dan checkbox-nya sudah dicentang? git menunjukkan apa? — lalu memberi
tahu, dalam satu baris, posisimu di pipeline dan skill mana yang dijalankan berikutnya. Inilah router
yang menggantikan session hook (ajian sengaja tak punya).

## Kapan dipakai

- Di awal sesi, atau tepat setelah `/compact` atau `/clear`, saat kehilangan alur.
- Kapan pun breadcrumb `→ Next` sebuah skill tak di depanmu dan kamu ragu menjalankan apa.
- Untuk memeriksa keadaan saat artefak yang di-commit dan ingatanmu tampak tak sejalan.

## Pertanyaan umum

- **Apakah ia mengerjakan pekerjaannya?** Tidak. Ia hanya menunjuk skill berikutnya; kamu yang memanggil skill itu.
- **Kalau sinyalnya bertentangan** (plan tercentang tapi tak ada yang di-commit, roadmap tercentang tapi
  tak pernah di-merge)? Ia percaya git dan artefak yang di-commit ketimbang ingatan, menyebut pertentangan
  itu terus terang, dan menyarankan langkah aman ketimbang menebak.
- **Greenfield tanpa apa-apa?** Ia mengarahkanmu ke `ajian-blueprint`.

## Tanda berhasil

Kamu bisa menjalankannya setelah gangguan apa pun dan mendapat jawaban benar lagi spesifik seperti
"Work order 03 sudah detailed, plan 4/7 task tercentang — kamu di tengah build; berikutnya:
`/ajian-build 03`, lanjut dari task 5."
