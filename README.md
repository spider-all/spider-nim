# spider-nim

Crawl GitHub APIs and store the discovered orgs, repos, commits...

### Run in terminal

``` bash
nimble -d:ssl build && ./spider
```

### Run in docker

```
docker build -t spider:nim .
docker run --rm -it spider:nim
```
