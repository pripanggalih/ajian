# ajian-design

## Apa yang dilakukan

Memberi satu work order UI dunia visualnya dengan menyerahkannya ke **impeccable**. Ia menurunkan
`PRODUCT.md` sekali, sebagai proyeksi blueprint (bukan wawancara baru), lalu memanggil alur new-work
impeccable — dibekali design brief yang dikumpulkan `ajian-grill` — untuk menciptakan dan membangun
permukaan serta mencatat `DESIGN.md`. Ia sengaja jadi pembungkus tipis: impeccable memegang kualitas
visual; ajian hanya memasok dua sambungan (PRODUCT.md dari blueprint, dan serah-terima design brief).

## Kapan dipakai

- Setelah `ajian-grill` menandai sebuah work order **UI** sebagai detailed, sebelum `ajian-plan`.
- Lewati sepenuhnya untuk work order tanpa UI — langsung dari grill ke plan.

## Pertanyaan umum

- **Perlu impeccable terinstal?** Ya — `npx impeccable install`. Instalasi project-local, global
  (`~/.claude/skills/`), maupun lewat plugin sama-sama dihitung; skill ini memeriksa ketiganya dan
  juga menerima `impeccable` yang memang sudah disediakan harness-mu. Tanpa itu skill berhenti di
  langkah pertamanya, menunjukkan apa yang ia periksa, lalu bertanya — jadi kalau ternyata terpasang
  di tempat yang tak biasa, cukup beri tahu di mana. Ia **tidak** akan mendesain atau
  mengimplementasikan permukaannya sendiri sebagai jalan pintas: itu menghasilkan permukaan di luar
  pipeline, melompati `ajian-plan` dan `ajian-build` — tanpa plan, tanpa ledger, tanpa review. Pasang
  impeccable, atau putuskan untuk melewati fase design pada work order ini dan langsung ke
  `/ajian-plan NN`.
- **Kenapa tak pakai `init` impeccable untuk menulis PRODUCT.md?** Karena kebenaran produk sudah ada di
  blueprint-mu. ajian memproyeksikannya (dengan header "jangan diedit tangan — ubah blueprint") dan hanya
  menanyakan satu ronde pengisi-celah untuk yang memang tak dimiliki blueprint.
- **Siapa yang memutuskan arah visual?** Gerbang arah milik impeccable — itu milikmu. ajian tak
  meragukan dunia yang diciptakan impeccable.
- **Kalau design sudah membangun UI, build ngerjain apa?** Penyambungannya. impeccable meninggalkan
  layar sungguhan di pohon kerja; build menyambungkannya ke data, state, routing, dan test. Supaya
  keduanya tidak bertabrakan, design mencatat inventaris file di bagian `## Built surface` work
  order — `ajian-plan` membacanya lalu merencanakan di sekitar file itu alih-alih membuatnya ulang,
  executor `ajian-build` diberitahu file itu sudah ada, dan `ajian-review` mengeluarkan hasil karya
  impeccable dari sumbu Standards. Design juga commit di branch yang akan dilanjutkan build, supaya
  surface-nya tidak hilang.
- **Sesi berakhir di dalam impeccable — desainku hilang?** Tidak. Sebelum menyerahkan kendali,
  `ajian-design` menstempel `## Built surface` di work order dengan `Status: handed to impeccable`
  beserta branch tujuannya, lalu commit. Jadi keterputusannya kelihatan: `ajian-plan` menolak work
  order itu sampai inventarisnya nyata, dan menjalankan ulang `/ajian-design NN` melanjutkan di
  langkah pencatatan, bukan membangun surface-nya dua kali.
- **Di mana kebenaran visual tinggal?** Di `DESIGN.md` (terwujud) dan `.impeccable/`. `DESIGN-SYSTEM.md`
  di blueprint hanya menyimpan batasan tipis (baseline a11y, non-negosiasi merek).

## Tanda berhasil

Permukaan terbangun, `DESIGN.md` mencerminkannya, dan plan yang menyusul bisa menyebut layar dan state
nyata — dan wawancara impeccable menciut jadi konfirmasi karena brief-nya sudah terjawab.
