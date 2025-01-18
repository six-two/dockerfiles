# USAGE: docker run --rm -it --cap-add=NET_RAW --cap-add=NET_ADMIN nmap 192.168.1.1
FROM alpine
RUN apk add --update --no-cache libcap-setcap nmap nmap-scripts
RUN cp /usr/bin/nmap /usr/bin/nmap-privileged; setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap-privileged
COPY entrypoint.sh /bin/entrypoint.sh
USER 1001:1001
ENTRYPOINT ["/bin/entrypoint.sh"]
