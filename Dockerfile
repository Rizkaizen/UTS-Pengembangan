# Menggunakan Nginx versi Alpine yang sangat ringan (~25MB)
FROM nginx:alpine

# Menyalin seluruh isi folder src ke direktori web server Nginx
COPY ./src /usr/share/nginx/html

# Membuka port 80 untuk akses web server
EXPOSE 80

# Menjalankan Nginx di foreground
CMD ["nginx", "-g", "daemon off;"]