# Docker + Nginx + RTMP + S3FS
A Dockerfile installing NGINX, nginx-rtmp-module and FFmpeg from source with default settings for HLS live streaming. Built on Alpine Linux.

* Nginx 1.21.0 (Stable version compiled from source)
* nginx-rtmp-module 1.2.2 (compiled from source)
* ffmpeg 4.4 (compiled from source)
* Default HLS settings (See: [nginx.conf](nginx.conf))
* S3FS Fuse (S3-Compatible Object Storage)

## Usage

Run container with local storage:
```
docker run --rm -it \
-p 1935:1935 \
-p 8080:80 \
ghcr.io/codions/docker-stream-server/docker-stream-server:latest
```

Run container with S3 storage:
```
docker run --rm --privileged -it \
-e FILESYSTEM=s3
-e AWS_S3_URL=${AWS_S3_URL} \
-e AWS_S3_REGION=${AWS_S3_REGION} \
-e AWS_S3_BUCKET_NAME=${AWS_S3_BUCKET_NAME} \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-p 1935:1935 \
-p 8080:80 \
ghcr.io/codions/docker-stream-server/docker-stream-server:latest
```

Stream live content to:
```
rtmp://<server ip>:1935/stream/$STREAM_NAME
```

### OBS Configuration
* Stream Type: `Custom Streaming Server`
* URL: `rtmp://localhost:1935/stream`
* Example Stream Key: `hello`

### Watch Stream using AWS and CloudFront

Access by using your S3 public URL.

For example `https://your-s3-bucket.s3.us-east-2.amazonaws.com/hls/hello.m3u8`

or you can set your cloudfront (cache disabled) distribution then based on your S3

>  Don't forget to set public access and enable CORS in your s3 bucket

### Watch Stream using Local Storage
* Load up the example hls.js player in your browser:
```
http://localhost:8080/player.html?url=http://localhost:8080/live/hello.m3u8
```

* Or in Safari, VLC or any HLS player, open:
```
http://localhost:8080/live/$STREAM_NAME.m3u8
```
* Example Playlist: `http://localhost:8080/live/hello.m3u8`
* [HLS.js Player](https://hls-js.netlify.app/demo/?src=http%3A%2F%2Flocalhost%3A8080%2Flive%2Fhello.m3u8)
* FFplay: `ffplay -fflags nobuffer rtmp://localhost:1935/stream/hello`


### SSL 
To enable SSL, see [nginx.conf](nginx.conf) and uncomment the lines:
```
listen 443 ssl;
ssl_certificate     /opt/certs/example.com.crt;
ssl_certificate_key /opt/certs/example.com.key;
```

> This will enable HTTPS using a self-signed certificate supplied in [/certs](/certs). If you wish to use HTTPS, it is highly recommended to obtain your own certificates and update the `ssl_certificate` and `ssl_certificate_key` paths.

## Credits
* https://github.com/alfg/docker-nginx-rtmp
* https://github.com/TareqAlqutami/rtmp-hls-server
* https://github.com/efriandika/streaming-server

## Resources
* https://alpinelinux.org/
* http://nginx.org
* https://github.com/arut/nginx-rtmp-module
* https://www.ffmpeg.org
* https://obsproject.com
* https://github.com/s3fs-fuse/s3fs-fuse
