# TaskFlow - UTS Container & CI/CD

TaskFlow adalah website pengelola tugas sederhana berbasis HTML, CSS, dan JavaScript.
Project ini digunakan untuk demonstrasi containerization dengan Docker dan CI/CD
menggunakan GitHub Actions.

## 1. Struktur folder

```text
TaskFlow_UTS_Complete/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── src/
│   ├── Index.html
│   ├── style.css
│   └── script.js
├── .dockerignore
├── Dockerfile
├── compose.yaml
└── README.md
```

## 2. Menjalankan website tanpa Docker

Buka `src/Index.html` di browser atau gunakan Live Server pada VS Code.

## 3. Menjalankan dengan Docker

Pastikan Docker Desktop sudah berjalan. Dari terminal di folder utama project:

```bash
docker build -t taskflow-uts:latest .
docker run -d --name taskflow-web --restart unless-stopped -p 8080:80 taskflow-uts:latest
```

Buka `http://localhost:8080`.

Perintah pemeriksaan:

```bash
docker ps
docker logs taskflow-web
docker inspect taskflow-web
```

Menghentikan dan menghapus container:

```bash
docker rm -f taskflow-web
```

## 4. Menjalankan dengan Docker Compose

```bash
docker compose up -d --build
docker compose ps
docker compose logs
docker compose down
```

Aplikasi tersedia di `http://localhost:8080`.

## 5. Konsep CI/CD yang digunakan

Workflow berada di `.github/workflows/ci-cd.yml`.

**CI (Continuous Integration):**
- Berjalan pada GitHub-hosted runner Ubuntu ketika ada push atau pull request ke branch `main`.
- Memeriksa file wajib.
- Membangun Docker image.
- Menjalankan container sementara.
- Melakukan smoke test untuk halaman HTML, CSS, dan JavaScript.

**CD (Continuous Deployment) ke komputer lokal:**
- Job CD berjalan setelah CI berhasil dan hanya pada push ke branch `main` atau workflow_dispatch.
- Job ini memakai GitHub Actions self-hosted runner Windows yang dipasang pada komputer lokal.
- Runner membangun image terbaru, mengganti container `taskflow-web`, lalu menguji `http://localhost:8080`.

### Penting: syarat CD lokal

GitHub-hosted runner tidak dapat langsung mengakses Docker Desktop di komputer pribadi. Karena target deployment adalah localhost, komputer yang menjalankan Docker Desktop harus didaftarkan sebagai **self-hosted runner** pada repository GitHub dan tetap menyala/online ketika workflow CD dijalankan.

Langkah ringkas:
1. Buka repository GitHub.
2. Masuk ke **Settings > Actions > Runners > New self-hosted runner**.
3. Pilih **Windows x64**.
4. Ikuti instruksi resmi GitHub untuk mengunduh dan mengonfigurasi runner pada komputer lokal.
5. Pastikan Docker Desktop sudah berjalan dan perintah `docker version` berhasil pada terminal komputer tersebut.
6. Jalankan runner menggunakan `run.cmd` (atau pasang sebagai service sesuai panduan GitHub).
7. Pastikan status runner di GitHub adalah **Idle/Online**.
8. Push perubahan ke branch `main`. Job CI berjalan di GitHub, lalu job CD dijalankan oleh runner lokal.

Dokumentasi resmi:
- GitHub self-hosted runners: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners
- GitHub Actions workflow: https://docs.github.com/en/actions/writing-workflows
- Docker getting started: https://docs.docker.com/get-started/

## 6. Contoh alur demonstrasi

```text
Developer edit source code
        |
        v
git add . && git commit && git push
        |
        v
GitHub Actions - CI (Ubuntu)
        |
        +--> Check files
        +--> Docker build
        +--> Run temporary container
        +--> Smoke test
        |
        v
CI berhasil?
        |
        v
CD - Self-hosted runner (komputer lokal)
        |
        +--> Build image terbaru
        +--> Replace taskflow-web container
        +--> Verify localhost:8080
        |
        v
Website versi terbaru berjalan di localhost
```

## 7. Catatan teknis

- Website ini merupakan aplikasi statis; Nginx bertugas menyajikan file HTML/CSS/JavaScript.
- Data tugas disimpan pada `localStorage` browser. Data tersebut tersimpan per browser/perangkat, bukan di database server.
- Deployment lokal berarti aplikasi diakses melalui komputer yang menjalankan Docker. Pengguna di luar komputer tersebut tidak otomatis dapat mengaksesnya.
- Jangan menaruh token, password, atau secret pribadi di source code maupun video demonstrasi.
