# Stakeout Server

A fantastically simple API service for building self-hosted dashboards for SaaS availability monitoring. Supports HTTP, HTTPS, ICMP Ping, and automatic screenshots checks. Stakeout is written with the Ruby on Rails framework and PostgreSQL.

![Screenshot](https://raw.github.com/preston/stakeout/master/app/assets/images/screenshots/1.png)

Stakeout Server is designed to be *extremely* simple to use, and does not support complex services, or really anything outside of basic HTTP(S) and ICMP. So if you're looking for Nagios, use Nagios. :)  No built-in authentication or authorization is provided, so for Internet-facing deployments you'll want to implement a challenge at the web server, such as HTTP Basic Auth or OAuth 2 OpenID Connect.

# Running The Latest Release

Start by create a PostgreSQL database and user account and set an environment variable for the connection URL. The server will automatically manage the schema future and future updates. To run the server with docker:


## Run a Browserless Chrome Instance
```sh
# This worker is solely responsible for capturing screenshots via WebSocket API.
docker run -it --rm --name chrome \
  -e "ENABLE_DEBUGGER=false" \
  -e "DISABLE_AUTO_SET_DOWNLOAD_BEHAVIOR=true" \
  -e "DEFAULT_BLOCK_ADS=true" \
  -p 3030:3000 \
  --pull always \
  browserless/chrome:latest
```

## Run Stakeout Server
```sh
docker run -it --rm -p 3000:3000 --name stakeout-server \
	-e "STAKEOUT_SERVER_DATABASE_URL=postgresql://stakeout:password@192.168.1.130:5432/stakeout_development" \
	-e "STAKEOUT_SERVER_CHROME_URL=ws://localhost:3030" \
	-e "STAKEOUT_SERVER_USERNAME=stakeout" \
	-e "STAKEOUT_SERVER_PASSWORD=password" \
	p3000/stakeout-server:latest
```

## Optional: Run Another Worker
In development mode, background job processing will happen automatically. You do not need to start a seperate worker. If you would one, however, simply run another instance of the server with `bundle exec good_job start` appended to the end.

Note: Running a separate worker(s) is _required_ when running the server in production mode, as the built-in job runner is disabled by default.

# Building Your Own Image

To build your current version:

```sh
docker build -t p3000/stakeout-server:latest .
```

To build a cross-platform version for multiple architectures:

```sh
docker buildx build --platform linux/arm64/v8,linux/amd64 -t p3000/stakeout-server:latest .
```

# Attribution

Designed and written by Preston Lee.
