# BACKLOG (Features)

As the project is young, instead of creating issues for FEATURE, BUG, etc., I'll maintain a backlog here. It's much quicker to [draft these here](https://github.com/firepress-org/bashlava/blob/master/BACKLOG.md) for the moment.

## 0) GLITCHES

Intermited issue where the CHANGELOG file is getting wiped out during the release. Related to "Don't write tmp files onto disk".

To double check: no hardcoded custom values should exist bashlava.sh anymore. They are all in the Dockerfile.

## 1) NEXT FEATURES

### Create videos tutorials:
	- since `deploy` is simpler and without `m`

### Don't write tmp files onto disk as it can create issue on certain local set up.
	- App_update_changelog: 
	- help
	- App_glow

### Stop bash lava if docker is not running:
```
docker: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?.
```

### ADD `list-all` to see fat from add-on
 
### FCT wip-sync-origin-from-upstream

### add-on example: mining

## 2) NEED HELP

Can we generate a markdown "file" and use App_glow without never write on disk (this is how we do it at the moment).

Make bashLaVa completly idempotent. Inspired by https://arslan.io/2019/07/03/how-to-write-idempotent-bash-scripts/

