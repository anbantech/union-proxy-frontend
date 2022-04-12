FROM nginx:1.19.3

COPY dist/ /usr/share/nginx/html
