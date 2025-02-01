FROM nginx:mainline-alpine
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

ENV NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template
ENV LISTEN_PORT=80
ENV BACKEND_HOST=backend
ENV BACKEND_PORT=8080
