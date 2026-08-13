# ajian-review

## Apa yang dilakukan

Mereview build yang selesai pada **dua sumbu independen** dan mengintegrasikan branch. **Standards** —
apakah diff mengikuti `CONVENTIONS.md`, `QUALITY.md`, dan baseline smell Fowler? **Spec** — apakah ia
setia mengimplementasi work order? Keduanya jalan sebagai sub-agent paralel dan dilaporkan
berdampingan, tak pernah diperingkat ulang. Kamu menanggapi temuan dengan disiplin receiving-code-review
(verifikasi sebelum implementasi, tanpa persetujuan pura-pura, bantah dengan penalaran), perbaiki dalam
satu gelombang, centang baris `ROADMAP`, lalu selesaikan branch (merge / PR / simpan — pilihanmu).

## Kapan dipakai

- Setelah `ajian-build` meninggalkan branch hijau yang di-commit.
- Kapan pun kamu ingin review dua-sumbu atas branch terhadap titik tetap.

## Pertanyaan umum

- **Kenapa dua sumbu terpisah?** Kode bisa lulus satu dan gagal yang lain — ikut tiap konvensi tapi
  membangun hal yang salah, atau membangun hal yang benar tapi melanggar konvensi. Memisahkannya mencegah
  yang satu menutupi yang lain.
- **Bagaimana temuan diperbaiki?** Satu gelombang perbaikan (satu subagent dengan daftar terkonfirmasi
  lengkap), berurutan — pemblokir/keamanan dulu — lalu verifikasi-ulang segar. Bukan satu pemerbaik per temuan.
- **Apakah ia mereview UI hasil impeccable?** Tidak. Pada work order UI ia membaca inventaris
  `## Built surface` di work order lalu mengeluarkan file-file itu dari sumbu Standards — kualitas
  karya impeccable sudah lewat gerbang arahnya bersamamu — dan hanya mereview penyambungan yang
  ditambahkan build ke file itu. Sumbu Spec diberitahu file itu sudah ada sebelum titik acuan, jadi
  ia tidak melaporkan layarnya belum diimplementasi cuma karena di-commit sebelum branch dibuat.
  Path yang dikecualikan disebutkan di laporan.
- **Apakah ia memutuskan merge?** Tidak. Ia menyajikan menu merge / PR / simpan dan menunggu — integrasi
  keputusanmu. Membuang kerja hanya terjadi kalau kamu meminta eksplisit.
- **Apa yang dicentang?** Baris `ROADMAP`, begitu review bersih — itulah catatan tingkat proyek soal apa yang dikirim.

## Tanda berhasil

Kedua sumbu dilaporkan rapi dan terpisah, temuan terkonfirmasi diperbaiki dan diverifikasi ulang, baris
roadmap dicentang, dan branch terintegrasi sesuai pilihanmu — setelah itu `ajian-grill` memulai baris berikutnya.
