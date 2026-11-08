# Menggunakan Nginx versi Alpine yang ringan dan stabil
FROM nginx:1.27-alpine

# Menyalin seluruh isi folder src ke direktori publik Nginx
COPY src/ /usr/share/nginx/html/

# Pemeriksaan kesehatan kontainer otomatis (Healthcheck)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=5 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1

# Membuka port 80 untuk akses web
EXPOSE 80

# Menjalankan Nginx di foreground
CMD ["nginx", "-g", "daemon off;"]