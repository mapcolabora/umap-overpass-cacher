# umap-overpass-cacher
Simplistic Overpass API queries cacher 

We have created this script in order to avoid increase speed response of overpass queries in dynamical Umap and reduce the number of queries sent to the main server.

### Disclaimer
This script only download and store queries, you'll have to set up your own web server (eg apache, nginx...)!

## Instructions
1. Clone this repository:
  ```
  git clone https://github.com/mapcolabora/umap-overpass-cacher
  ```
2. Copy `config.sh.sample` into `config.sh` and set up your settings.

3. Write down your overpass-query-urls in the file `urls.txt` one per line.

4. Run `./run.sh --dry-run` to find the output path of the cached url. They are procesed in the same order as they are written in the `urls.txt` file.

5. Run once `./run.sh --now` in order to cache all the urls for the first time.

6. Set up a cron task to run periodicaly `./run.sh` whitout parameters.
