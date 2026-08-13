# ajian-build

## Apa yang dilakukan

Mengeksekusi satu plan yang disetujui dan meninggalkan branch hijau yang sudah di-commit untuk direview.
Ia mengirim **satu** subagent segar untuk menjalankan *seluruh* plan, task demi task — berpola TDD,
commit per task, dan mencentang checkbox plan yang di-commit seiring jalan (tiap centang jadi commit
sendiri). Controller melakukan satu kali pemindaian konflik pra-terbang sebelum kirim dan verifikasi
segar sesudahnya. **Tanpa review per-task** — review tunggal disimpan untuk `ajian-review`.

## Kapan dipakai

- Setelah kamu menyetujui plan sebuah work order.
- Untuk melanjutkan build yang terputus — ia lanjut dari checkbox pertama yang belum dicentang plus `git log`.

## Pertanyaan umum

- **Kenapa satu subagent untuk seluruh plan, bukan satu per task?** Lebih sedikit kirim, tanpa gejolak
  review per-task, dan plan sudah diukur untuk satu sesi build oleh roadmap. Ini pemisahan sengaja dari
  subagent-driven-development milik superpowers (lihat `references/executor-and-ledger.md`).
- **Di mana ledger-nya?** Ia *adalah* checkbox file plan yang di-commit — tanpa folder tersembunyi
  `.superpowers/sdd/`. Progres tinggal di git, terbuka, dan bertahan melewati compaction.
- **Laporan build-nya ke mana?** `docs/plans/reports/NN-<slug>.md`, satu per plan, masuk git. Isinya
  bukti verifikasi — perintah beserta outputnya, RED/GREEN TDD, file yang berubah, kekhawatiran —
  yang dibaca controller alih-alih memercayai klaim sukses, sekaligus jejak yang bisa ditelusuri
  siapa pun yang mengaudit work order itu nanti. Ia punya folder sendiri supaya `docs/plans/` tetap
  berisi plan saja. `ajian-review` tidak membacanya: review itu menilai diff, bukan cerita executor.
- **Bisakah build paralel?** Hanya antar work order yang *independen*, opt-in, masing-masing di worktree
  sendiri, digerbangi tepi dependensi dan pemindaian tumpang-tindih file. Tak pernah antar-task dalam satu plan.
- **Apakah ia mereview atau merge?** Tidak — itu `ajian-review`.

## Tanda berhasil

Seluruh suite dan build lulus atas bukti segar (bukan klaim subagent), tiap checkbox plan tercentang dan
di-commit, dan branch siap diserahkan ke review.
