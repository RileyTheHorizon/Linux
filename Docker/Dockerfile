#base image
FROM alpine:latest
#NGINX install
RUN apk update && apk add nginx
#copy custom file for NGINX
COPY index.html /usr/share/nginx/html/index.html
#Expose port 80
EXPOSE 80
#Starting NGINX server when the container starts 
CMD ["nginx", "-g", "daemon off;"]
