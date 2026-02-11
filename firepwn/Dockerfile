# Example usage: docker run --rm -d -p 127.0.0.1:3000:3000 ghcr.io/six-two/firepwn
# This image is so big (>1GB in part because of the many node.js modules): du -sh /home/app/firepwn/node_modules/ -> 611M

# Prepare basic image
FROM node:slim
RUN apt-get update && apt-get install --yes git && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home -s /bin/bash app && touch /home/app/.hushlogin
USER app

# Install application
RUN git clone https://github.com/0xbigshaq/firepwn-tool.git /home/app/firepwn
WORKDIR /home/app/firepwn
RUN npm install --legacy-peer-deps
RUN npm run build

# Container defaults
EXPOSE 3000
CMD ["npm", "run", "start"]
